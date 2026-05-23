#!/usr/bin/env python3
"""Small GPT Image 2 compatible image-generation CLI.

This script intentionally uses only the Python standard library so it can run in
project environments that do not have the OpenAI SDK installed.
"""

from __future__ import annotations

import argparse
import base64
import json
import os
from pathlib import Path
import re
import sys
import time
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urlparse
from urllib.request import Request, urlopen


DEFAULT_BASE_URL = "https://api.openai.com/v1"
DEFAULT_MODEL = "gpt-image-2"
DEFAULT_SIZE = "2048x1152"
DEFAULT_QUALITY = "high"
DEFAULT_FORMAT = "png"
DEFAULT_OUT = "output/imagegen/output.png"
DEFAULT_ENV_FILES = (".envh", ".env.local", ".env")

ALLOWED_QUALITIES = {"low", "medium", "high", "auto"}
ALLOWED_FORMATS = {"png", "jpeg", "jpg", "webp"}


class ImageApiError(RuntimeError):
    def __init__(self, message: str, *, retryable: bool = False, retry_after: int | None = None) -> None:
        super().__init__(message)
        self.retryable = retryable
        self.retry_after = retry_after


def die(message: str, code: int = 1) -> None:
    print(f"Error: {message}", file=sys.stderr)
    raise SystemExit(code)


def warn(message: str) -> None:
    print(f"Warning: {message}", file=sys.stderr)


def read_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for line_no, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line[len("export ") :].strip()
        if "=" not in line:
            warn(f"Ignoring malformed env line {path}:{line_no}")
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip()
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", key):
            warn(f"Ignoring invalid env key {path}:{line_no}: {key}")
            continue
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            value = value[1:-1]
        values[key] = value
    return values


def load_env_files(extra_files: list[str] | None) -> None:
    for raw in (*DEFAULT_ENV_FILES, *(extra_files or [])):
        path = Path(raw)
        for key, value in read_env_file(path).items():
            os.environ[key] = value


def env_first(*names: str) -> str | None:
    for name in names:
        value = os.getenv(name)
        if value:
            return value
    return None


def normalize_base_url(base_url: str) -> str:
    base_url = base_url.strip().rstrip("/")
    parsed = urlparse(base_url)
    if not parsed.scheme or not parsed.netloc:
        die(f"Invalid base URL: {base_url}")
    return base_url


def generation_endpoint(base_url: str) -> str:
    base_url = normalize_base_url(base_url)
    if base_url.endswith("/images/generations"):
        return base_url
    if base_url.endswith("/v1"):
        return f"{base_url}/images/generations"
    return f"{base_url}/v1/images/generations"


def normalize_format(fmt: str | None) -> str:
    fmt = (fmt or DEFAULT_FORMAT).lower()
    if fmt not in ALLOWED_FORMATS:
        die(f"--output-format must be one of {', '.join(sorted(ALLOWED_FORMATS))}")
    return "jpeg" if fmt == "jpg" else fmt


def validate_args(args: argparse.Namespace) -> None:
    if args.n < 1 or args.n > 10:
        die("--n must be between 1 and 10")
    if args.quality not in ALLOWED_QUALITIES:
        die(f"--quality must be one of {', '.join(sorted(ALLOWED_QUALITIES))}")
    if args.output_compression is not None and not (0 <= args.output_compression <= 100):
        die("--output-compression must be between 0 and 100")
    if args.timeout < 1:
        die("--timeout must be >= 1")


def read_prompt(prompt: str | None, prompt_file: str | None) -> str:
    if prompt and prompt_file:
        die("Use --prompt or --prompt-file, not both")
    if prompt_file:
        path = Path(prompt_file)
        if not path.exists():
            die(f"Prompt file not found: {path}")
        return path.read_text(encoding="utf-8").strip()
    if prompt:
        return prompt.strip()
    die("Missing prompt. Use --prompt or --prompt-file")
    return ""


def augment_prompt(args: argparse.Namespace, prompt: str) -> str:
    if args.no_augment:
        return prompt
    fields = [
        ("Use case", args.use_case),
        ("Asset type", args.asset_type),
        ("Primary request", prompt),
        ("Composition", args.composition),
        ("Style", args.style),
        ("Palette", args.palette),
        ("Materials", args.materials),
        ("Motion and interaction", args.motion),
        ("Constraints", args.constraints),
        ("Avoid", args.negative),
    ]
    return "\n".join(f"{label}: {value}" for label, value in fields if value)


def build_payload(args: argparse.Namespace, prompt: str) -> dict[str, Any]:
    payload: dict[str, Any] = {
        "model": args.model,
        "prompt": prompt,
        "n": args.n,
        "size": args.size,
        "quality": args.quality,
        "output_format": normalize_format(args.output_format),
    }
    if args.background:
        payload["background"] = args.background
    if args.output_compression is not None:
        payload["output_compression"] = args.output_compression
    if args.moderation:
        payload["moderation"] = args.moderation
    return payload


def output_paths(out: str, out_dir: str | None, output_format: str, n: int) -> list[Path]:
    ext = "." + output_format
    if out_dir:
        directory = Path(out_dir)
        return [directory / f"image_{idx}{ext}" for idx in range(1, n + 1)]

    path = Path(out)
    if path.suffix == "":
        path = path.with_suffix(ext)
    if n == 1:
        return [path]
    return [path.with_name(f"{path.stem}-{idx}{path.suffix}") for idx in range(1, n + 1)]


def call_api(endpoint: str, api_key: str, payload: dict[str, Any], timeout: int) -> dict[str, Any]:
    data = json.dumps(payload).encode("utf-8")
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "Accept": "application/json",
    }
    request = Request(endpoint, data=data, headers=headers, method="POST")
    try:
        with urlopen(request, timeout=timeout) as response:
            body = response.read().decode("utf-8")
            return json.loads(body) if body else {}
    except HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        retry_after = parse_retry_after(body)
        retryable = exc.code in {408, 409, 425, 429, 500, 502, 503, 504, 524}
        raise ImageApiError(
            f"HTTP {exc.code} from image API: {body}",
            retryable=retryable,
            retry_after=retry_after,
        )
    except URLError as exc:
        raise ImageApiError(f"Could not reach image API: {exc}", retryable=True)
    except json.JSONDecodeError as exc:
        raise ImageApiError(f"Image API returned invalid JSON: {exc}", retryable=False)
    return {}


def parse_retry_after(body: str) -> int | None:
    try:
        parsed = json.loads(body)
    except Exception:
        parsed = None
    if isinstance(parsed, dict):
        value = parsed.get("retry_after")
        if isinstance(value, int) and value >= 0:
            return value
        if isinstance(value, str) and value.isdigit():
            return int(value)
    match = re.search(r"retry_after[\"':= ]+([0-9]+)", body)
    if match:
        return int(match.group(1))
    return None


def call_api_with_retries(
    endpoint: str,
    api_key: str,
    payload: dict[str, Any],
    *,
    timeout: int,
    max_attempts: int,
    retry_base_seconds: int,
) -> dict[str, Any]:
    last_error: ImageApiError | None = None
    for attempt in range(1, max_attempts + 1):
        try:
            return call_api(endpoint, api_key, payload, timeout)
        except ImageApiError as exc:
            last_error = exc
            if not exc.retryable or attempt >= max_attempts:
                die(str(exc))
            sleep_seconds = exc.retry_after or min(120, retry_base_seconds * attempt)
            print(
                f"Retryable image API error on attempt {attempt}/{max_attempts}: {exc}",
                file=sys.stderr,
            )
            print(f"Retrying in {sleep_seconds}s", file=sys.stderr)
            time.sleep(sleep_seconds)
    die(str(last_error or "Image API failed"))
    return {}


def download_url(url: str, timeout: int) -> bytes:
    with urlopen(url, timeout=timeout) as response:
        return response.read()


def write_images(response: dict[str, Any], paths: list[Path], force: bool, timeout: int) -> None:
    data = response.get("data")
    if not isinstance(data, list) or not data:
        die("Image API response did not include data[]")

    for idx, item in enumerate(data):
        if idx >= len(paths):
            break
        if not isinstance(item, dict):
            die(f"Unexpected image item at index {idx}")
        path = paths[idx]
        if path.exists() and not force:
            die(f"Output already exists: {path} (use --force to overwrite)")
        path.parent.mkdir(parents=True, exist_ok=True)
        if item.get("b64_json"):
            raw = base64.b64decode(item["b64_json"])
        elif item.get("url"):
            raw = download_url(str(item["url"]), timeout)
        else:
            die(f"Image item {idx} has neither b64_json nor url")
        path.write_bytes(raw)
        print(f"Wrote {path}")


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    value = re.sub(r"-{2,}", "-", value).strip("-")
    return value[:70] or "image"


def read_jobs_jsonl(path: str) -> list[dict[str, Any]]:
    p = Path(path)
    if not p.exists():
        die(f"Batch input not found: {p}")
    jobs: list[dict[str, Any]] = []
    for line_no, raw in enumerate(p.read_text(encoding="utf-8").splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        try:
            job = json.loads(line)
        except json.JSONDecodeError as exc:
            die(f"Invalid JSONL at {p}:{line_no}: {exc}")
        if not isinstance(job, dict) or not str(job.get("prompt", "")).strip():
            die(f"Batch job at {p}:{line_no} must be an object with a prompt")
        jobs.append(job)
    if not jobs:
        die(f"No jobs found in {p}")
    return jobs


def merge_job_args(args: argparse.Namespace, job: dict[str, Any]) -> argparse.Namespace:
    merged = argparse.Namespace(**vars(args))
    for key in (
        "model",
        "n",
        "size",
        "quality",
        "output_format",
        "background",
        "output_compression",
        "moderation",
        "use_case",
        "asset_type",
        "composition",
        "style",
        "palette",
        "materials",
        "motion",
        "constraints",
        "negative",
    ):
        if key in job and job[key] is not None:
            setattr(merged, key, job[key])
    merged.prompt = str(job["prompt"])
    merged.prompt_file = None
    return merged


def run_generate(args: argparse.Namespace) -> None:
    validate_args(args)
    prompt = augment_prompt(args, read_prompt(args.prompt, args.prompt_file))
    payload = build_payload(args, prompt)
    endpoint = generation_endpoint(args.base_url)
    paths = output_paths(args.out, args.out_dir, payload["output_format"], args.n)

    if args.dry_run:
        print(json.dumps({"endpoint": endpoint, "outputs": [str(p) for p in paths], **payload}, indent=2, ensure_ascii=False))
        return

    print(f"Calling {endpoint} with model={args.model}, quality={args.quality}, size={args.size}", file=sys.stderr)
    started = time.time()
    response = call_api_with_retries(
        endpoint,
        args.api_key,
        payload,
        timeout=args.timeout,
        max_attempts=args.max_attempts,
        retry_base_seconds=args.retry_base_seconds,
    )
    print(f"Generation completed in {time.time() - started:.1f}s", file=sys.stderr)
    write_images(response, paths, args.force, args.timeout)


def run_batch(args: argparse.Namespace) -> None:
    if not args.out_dir:
        die("generate-batch requires --out-dir")
    jobs = read_jobs_jsonl(args.input)
    base_out_dir = Path(args.out_dir)
    endpoint = generation_endpoint(args.base_url)
    any_failed = False

    for index, job in enumerate(jobs, start=1):
        merged = merge_job_args(args, job)
        validate_args(merged)
        prompt = augment_prompt(merged, read_prompt(merged.prompt, None))
        payload = build_payload(merged, prompt)
        explicit_out = job.get("out")
        if explicit_out:
            path = base_out_dir / str(explicit_out)
        else:
            path = base_out_dir / f"{index:02d}-{slugify(str(job['prompt'])[:90])}.{payload['output_format']}"
        paths = output_paths(str(path), None, payload["output_format"], int(payload["n"]))

        if args.dry_run:
            print(json.dumps({"job": index, "endpoint": endpoint, "outputs": [str(p) for p in paths], **payload}, indent=2, ensure_ascii=False))
            continue

        print(f"[{index}/{len(jobs)}] generating {paths[0]}", file=sys.stderr)
        try:
            response = call_api_with_retries(
                endpoint,
                args.api_key,
                payload,
                timeout=args.timeout,
                max_attempts=args.max_attempts,
                retry_base_seconds=args.retry_base_seconds,
            )
            write_images(response, paths, args.force, args.timeout)
        except SystemExit:
            if args.fail_fast:
                raise
            any_failed = True
    if any_failed:
        raise SystemExit(1)


def preparse_env_files(argv: list[str]) -> list[str]:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--env-file", action="append")
    known, _ = parser.parse_known_args(argv)
    return known.env_file or []


def add_common_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--env-file", action="append", help="Additional env file, loaded after .envh/.env.local/.env")
    parser.add_argument("--api-key")
    parser.add_argument("--base-url")
    parser.add_argument("--model")
    parser.add_argument("--prompt")
    parser.add_argument("--prompt-file")
    parser.add_argument("--n", type=int, default=1)
    parser.add_argument("--size")
    parser.add_argument("--quality")
    parser.add_argument("--output-format", default=DEFAULT_FORMAT)
    parser.add_argument("--background")
    parser.add_argument("--output-compression", type=int)
    parser.add_argument("--moderation")
    parser.add_argument("--out", default=DEFAULT_OUT)
    parser.add_argument("--out-dir")
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--max-attempts", type=int, default=3)
    parser.add_argument("--retry-base-seconds", type=int, default=20)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--no-augment", action="store_true")
    parser.add_argument("--use-case")
    parser.add_argument("--asset-type")
    parser.add_argument("--composition")
    parser.add_argument("--style")
    parser.add_argument("--palette")
    parser.add_argument("--materials")
    parser.add_argument("--motion")
    parser.add_argument("--constraints")
    parser.add_argument("--negative")


def resolve_config(args: argparse.Namespace) -> None:
    args.api_key = args.api_key or env_first("GPTIMAGE2_API_KEY", "IMAGE_API_KEY", "OPENAI_API_KEY")
    args.base_url = args.base_url or env_first("GPTIMAGE2_BASE_URL", "IMAGE_BASE_URL", "OPENAI_BASE_URL") or DEFAULT_BASE_URL
    args.model = args.model or env_first("GPTIMAGE2_MODEL", "IMAGE_MODEL", "OPENAI_IMAGE_MODEL") or DEFAULT_MODEL
    args.size = args.size or env_first("GPTIMAGE2_SIZE", "IMAGE_SIZE") or DEFAULT_SIZE
    args.quality = args.quality or env_first("GPTIMAGE2_QUALITY", "IMAGE_QUALITY") or DEFAULT_QUALITY
    if args.max_attempts < 1:
        die("--max-attempts must be >= 1")
    if args.retry_base_seconds < 1:
        die("--retry-base-seconds must be >= 1")
    if not args.api_key and not args.dry_run:
        die("Missing API key. Set GPTIMAGE2_API_KEY, IMAGE_API_KEY, OPENAI_API_KEY, or pass --api-key")


def main(argv: list[str] | None = None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    load_env_files(preparse_env_files(argv))

    parser = argparse.ArgumentParser(description="Generate images with GPT Image 2 compatible APIs")
    subparsers = parser.add_subparsers(dest="command", required=True)

    generate_parser = subparsers.add_parser("generate")
    add_common_args(generate_parser)
    generate_parser.set_defaults(func=run_generate)

    batch_parser = subparsers.add_parser("generate-batch")
    add_common_args(batch_parser)
    batch_parser.add_argument("--input", required=True)
    batch_parser.add_argument("--fail-fast", action="store_true")
    batch_parser.set_defaults(func=run_batch)

    args = parser.parse_args(argv)
    resolve_config(args)
    args.func(args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

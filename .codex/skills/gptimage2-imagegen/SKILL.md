---
name: gptimage2-imagegen
description: >
  Generate high-fidelity images with GPT Image 2 compatible APIs from Codex.
  Use this skill when the user wants image generation through a configurable
  base URL, model, API key, .env/.envh files, one-off prompts, or JSONL batches.
---

# GPT Image 2 Image Generation

Use the bundled script:

```bash
python3 .codex/skills/gptimage2-imagegen/scripts/gptimage2_imagegen.py generate --prompt "..." --out output/imagegen/example.png
```

For batches:

```bash
python3 .codex/skills/gptimage2-imagegen/scripts/gptimage2_imagegen.py generate-batch \
  --input output/imagegen/prompts.jsonl \
  --out-dir output/imagegen
```

## Configuration

The script reads `.envh`, `.env.local`, then `.env` from the current working
directory. Later environment files override earlier ones. Command-line flags
override environment variables.

Supported variables:

- `GPTIMAGE2_API_KEY`, `IMAGE_API_KEY`, or `OPENAI_API_KEY`
- `GPTIMAGE2_BASE_URL`, `IMAGE_BASE_URL`, or `OPENAI_BASE_URL`
- `GPTIMAGE2_MODEL`, `IMAGE_MODEL`, or `OPENAI_IMAGE_MODEL`
- `GPTIMAGE2_QUALITY`
- `GPTIMAGE2_SIZE`

Example `.envh`:

```bash
export GPTIMAGE2_API_KEY="sk-..."
export GPTIMAGE2_BASE_URL="https://api.openai.com/v1"
export GPTIMAGE2_MODEL="gpt-image-2"
export GPTIMAGE2_QUALITY="high"
export GPTIMAGE2_SIZE="2048x1152"
```

## Defaults

- Model: `gpt-image-2`
- Base URL: `https://api.openai.com/v1`
- Quality: `high`
- Size: `2048x1152`
- Format: `png`
- Output directory: `output/imagegen`

## Workflow

1. Put credentials and endpoint settings in `.envh` or pass them as flags.
2. Use `--dry-run` to inspect payloads without making API calls.
3. Generate with `generate` for one prompt or `generate-batch` for JSONL.
4. Save final project-bound images under `output/imagegen/`.

Never commit `.envh` or API keys.

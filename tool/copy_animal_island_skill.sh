#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SOURCE="$ROOT_DIR/skill/flutter-animal-island-ui"
SKILL_NAME="animal-island-ui-flutter"

TARGET_PROJECT=""
INSTALL_CLAUDE_PROJECT=false
INSTALL_CODEX_USER=false
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"

usage() {
  cat <<EOF
Usage:
  ./tool/copy_animal_island_skill.sh --project /path/to/project [--claude-project] [--codex-user] [--codex-home /path/to/.codex]

Options:
  --project PATH        Copy the skill bundle into a target project.
  --claude-project      Also install the skill into PATH/.claude/skills/$SKILL_NAME and update CLAUDE.md.
  --codex-user          Also install the skill into \$CODEX_HOME/skills or ~/.codex/skills.
  --codex-home PATH     Override Codex home directory. Default: \$CODEX_HOME or ~/.codex
  -h, --help            Show this help.
EOF
}

append_block_once() {
  local file="$1"
  local marker="$2"
  local block="$3"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  if grep -q "$marker" "$file"; then
    return 0
  fi

  printf "\n%s\n%s\n%s\n" "# BEGIN $marker" "$block" "# END $marker" >>"$file"
}

copy_skill_dir() {
  local destination="$1"
  rm -rf "$destination"
  mkdir -p "$(dirname "$destination")"
  cp -R "$SKILL_SOURCE" "$destination"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      TARGET_PROJECT="$2"
      shift 2
      ;;
    --claude-project)
      INSTALL_CLAUDE_PROJECT=true
      shift
      ;;
    --codex-user)
      INSTALL_CODEX_USER=true
      shift
      ;;
    --codex-home)
      CODEX_HOME_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$TARGET_PROJECT" ]]; then
  echo "--project is required" >&2
  usage
  exit 1
fi

TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

PROJECT_SKILL_DIR="$TARGET_PROJECT/skill/flutter-animal-island-ui"
copy_skill_dir "$PROJECT_SKILL_DIR"
echo "Copied skill bundle to $PROJECT_SKILL_DIR"

append_block_once \
  "$TARGET_PROJECT/AGENTS.md" \
  "ANIMAL_ISLAND_UI_FLUTTER" \
  "## Animal Island UI Flutter\n- When building Animal Crossing / Animal Island style Flutter UI, read \`skill/flutter-animal-island-ui/SKILL.md\` first.\n- Load the matching files in \`skill/flutter-animal-island-ui/references/\` for tokens, components, and demo layouts.\n- Preserve the day/night dual-theme design language when extending components."

if [[ "$INSTALL_CLAUDE_PROJECT" == true ]]; then
  CLAUDE_SKILL_DIR="$TARGET_PROJECT/.claude/skills/$SKILL_NAME"
  copy_skill_dir "$CLAUDE_SKILL_DIR"
  echo "Copied Claude Code project skill to $CLAUDE_SKILL_DIR"

  append_block_once \
    "$TARGET_PROJECT/CLAUDE.md" \
    "ANIMAL_ISLAND_UI_FLUTTER" \
    "## Animal Island UI Flutter\n- Use the project skill at \`.claude/skills/$SKILL_NAME/SKILL.md\` whenever the task involves Animal Crossing style Flutter UI.\n- Prefer the bundled references for tokens, components, and demo layout before inventing new styling."
fi

if [[ "$INSTALL_CODEX_USER" == true ]]; then
  CODEX_SKILL_DIR="$CODEX_HOME_DIR/skills/$SKILL_NAME"
  copy_skill_dir "$CODEX_SKILL_DIR"
  echo "Copied Codex user skill to $CODEX_SKILL_DIR"
fi

echo "Animal Island Flutter skill install complete."

#!/usr/bin/env bash
# ============================================================================
# ONBOARDING — uninstall the methodology skills from the USER level.
#
# SAFE: removes ONLY what install.sh created — a symlink pointing at this repo,
# or a copy tagged with .onboarding-installed. Any other skill (including a
# same-named one you created yourself) is left untouched. Never deletes the
# skills directory itself.
#
# Usage:
#   ./uninstall.sh            # remove this kit's skills from ~/.claude/skills
#   ./uninstall.sh --dest DIR # uninstall from DIR instead of ~/.claude/skills
# ============================================================================
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.claude/skills" && pwd)"
DEST="${HOME}/.claude/skills"

while [ $# -gt 0 ]; do
  case "$1" in
    --dest) shift; DEST="$1";;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    *) echo "unknown option: $1" >&2; exit 2;;
  esac
  shift
done

SKILLS=(new-project write-blog write-rfc write-drp write-architecture make-workplan milestone-review)

echo "Uninstalling ONBOARDING skills from $DEST"
[ -d "$DEST" ] || { echo "  nothing to do ($DEST does not exist)"; exit 0; }
echo

removed=0
for name in "${SKILLS[@]}"; do
  dst="$DEST/$name"
  if [ -L "$dst" ]; then
    # a symlink under one of our skill names — ours to remove
    rm -f "$dst"; echo "  removed symlink $name"; removed=$((removed+1))
  elif [ -d "$dst" ] && [ -f "$dst/.onboarding-installed" ]; then
    rm -rf "$dst"; echo "  removed copy    $name"; removed=$((removed+1))
  elif [ -e "$dst" ]; then
    echo "  KEEP $name (not installed by this kit — left untouched)"
  fi
done

echo
echo "Done. Removed $removed of ${#SKILLS[@]} kit skills. Any skills you created yourself were left in place."

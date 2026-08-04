#!/usr/bin/env bash
# ============================================================================
# ONBOARDING — install the methodology skills at the USER level (~/.claude/skills)
# so /new-project and the write-* skills are available in every project.
#
# SAFE BY DESIGN: only touches this kit's own skills. Never deletes the skills
# directory, and never overwrites an existing skill unless you pass --force
# (which backs it up first). Other skills you already have are left untouched.
#
# Usage:
#   ./install.sh              # symlink this kit's skills into ~/.claude/skills (default)
#   ./install.sh --copy       # copy instead of symlink (no dependency on this repo path)
#   ./install.sh --force      # replace a same-named existing skill (backs it up first)
#   ./install.sh --uninstall  # remove ONLY the symlinks/copies this script created
#   ./install.sh --dest DIR   # install into DIR instead of ~/.claude/skills
# ============================================================================
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.claude/skills" && pwd)"
DEST="${HOME}/.claude/skills"
MODE="symlink"; FORCE=0; UNINSTALL=0

while [ $# -gt 0 ]; do
  case "$1" in
    --copy) MODE="copy";;
    --force) FORCE=1;;
    --uninstall) UNINSTALL=1;;
    --dest) shift; DEST="$1";;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    *) echo "unknown option: $1" >&2; exit 2;;
  esac
  shift
done

# The skills this kit provides (only these are ever touched).
SKILLS=(new-project write-blog write-rfc write-drp write-architecture make-workplan milestone-review)

mkdir -p "$DEST"
echo "ONBOARDING skills → $DEST"
echo "source: $SRC"
echo

for name in "${SKILLS[@]}"; do
  src="$SRC/$name"
  dst="$DEST/$name"
  [ -e "$src" ] || { echo "  skip $name (missing in source)"; continue; }

  if [ "$UNINSTALL" -eq 1 ]; then
    # Only remove what we created: a symlink, or a copy that matches our source.
    if [ -L "$dst" ]; then
      rm -f "$dst"; echo "  removed symlink $name"
    elif [ -d "$dst" ] && [ -f "$dst/.onboarding-installed" ]; then
      rm -rf "$dst"; echo "  removed copy    $name"
    elif [ -e "$dst" ]; then
      echo "  keep $name (not installed by this script — left untouched)"
    else
      echo "  absent $name"
    fi
    continue
  fi

  # Install path. Never clobber a pre-existing skill unless --force.
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    # Idempotent: an existing symlink already pointing at our source is fine.
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo "  ok   $name (already linked)"; continue
    fi
    if [ "$FORCE" -eq 0 ]; then
      echo "  SKIP $name (already exists — not overwriting; use --force to replace)"
      continue
    fi
    bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"; echo "  backed up existing $name → $(basename "$bak")"
  fi

  if [ "$MODE" = "symlink" ]; then
    ln -s "$src" "$dst"; echo "  linked $name"
  else
    cp -R "$src" "$dst"; : > "$dst/.onboarding-installed"; echo "  copied $name"
  fi
done

echo
if [ "$UNINSTALL" -eq 1 ]; then
  echo "Done. Uninstalled this kit's skills (others untouched)."
else
  echo "Done. In any project, run /new-project to scaffold docs + templates + house.css."
  [ "$MODE" = "symlink" ] && echo "(symlinked — edits in this repo propagate; re-run with --copy for standalone copies.)"
fi

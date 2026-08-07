#!/usr/bin/env bash
# ============================================================================
# ONBOARDING — re-sync an already-onboarded project with the current methodology
#
# new-project COPIES templates + house.css into a project (so it's self-contained).
# That means methodology updates don't reach it. This script pushes them back in.
#
# SAFE BY DESIGN: only refreshes kit-owned files (templates/, assets/house.css,
# docs/METHODOLOGY.md). Never touches authored artifacts (your BLOG/RFC/DRP/
# ARCHITECTURE/WORK_PLAN/DECISIONS/DOCS_INDEX). CLAUDE.md and settings.json are
# only REPORTED on — they carry project-specific content, so you merge those.
#
# Usage:
#   ./sync-project.sh <project-dir>     # refresh kit files, report what needs a merge
#   ./sync-project.sh <dir> --dry-run   # show what would change, write nothing
# ============================================================================
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
PROJ=""; DRY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY=1;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    -*) echo "unknown option: $1" >&2; exit 2;;
    *) PROJ="$1";;
  esac
  shift
done

[ -n "$PROJ" ] || { echo "usage: $0 <project-dir> [--dry-run]" >&2; exit 2; }
PROJ="$(cd "$PROJ" && pwd)" || exit 2
[ -d "$PROJ/docs" ] || { echo "no docs/ in $PROJ — is it onboarded? run /new-project first" >&2; exit 2; }

say() { [ "$DRY" -eq 1 ] && echo "  would $*" || echo "  $*"; }
cp_if_changed() { # src dst label
  if [ -f "$2" ] && cmp -s "$1" "$2"; then return; fi
  say "update ${3}"
  [ "$DRY" -eq 1 ] || cp "$1" "$2"
}

echo "ONBOARDING sync → $PROJ"
echo "kit: $KIT"
[ "$DRY" -eq 1 ] && echo "(dry run — nothing will be written)"
echo

echo "templates (docs/templates/)"
[ "$DRY" -eq 1 ] || mkdir -p "$PROJ/docs/templates"
for f in "$KIT"/templates/*; do
  [ -f "$f" ] || continue
  cp_if_changed "$f" "$PROJ/docs/templates/$(basename "$f")" "$(basename "$f")"
done
if [ -d "$KIT/templates/hooks" ]; then
  [ "$DRY" -eq 1 ] || mkdir -p "$PROJ/docs/templates/hooks"
  for f in "$KIT"/templates/hooks/*; do
    [ -f "$f" ] || continue
    cp_if_changed "$f" "$PROJ/docs/templates/hooks/$(basename "$f")" "hooks/$(basename "$f")"
  done
fi

echo "design system + methodology"
[ "$DRY" -eq 1 ] || mkdir -p "$PROJ/docs/assets"
cp_if_changed "$KIT/assets/house.css" "$PROJ/docs/assets/house.css" "assets/house.css"
[ -f "$PROJ/docs/METHODOLOGY.md" ] && cp_if_changed "$KIT/METHODOLOGY.md" "$PROJ/docs/METHODOLOGY.md" "METHODOLOGY.md"

# ---- report-only: files that carry project-specific content ----
echo
echo "needs your merge (not touched):"

CM="$PROJ/CLAUDE.md"; [ -f "$CM" ] || CM="$PROJ/.claude/CLAUDE.md"
if [ -f "$CM" ]; then
  missing=""
  for r in $(grep -o '^- \*\*R[0-9]\+' "$KIT/templates/CLAUDE.template.md" | grep -o 'R[0-9]\+'); do
    grep -q "\*\*$r " "$CM" || missing="$missing $r"
  done
  if [ -n "$missing" ]; then
    echo "  CLAUDE.md — missing rules:$missing"
    echo "    → copy them from templates/CLAUDE.template.md (keep your project-specific notes)"
  else
    echo "  CLAUDE.md — rules current ✓"
  fi
  # R11's always-resident layer is the import line, not the rule text — check it separately.
  if grep -q '^@docs/CONSTRAINTS\.md' "$CM"; then
    echo "  CLAUDE.md — contract import present ✓"
  else
    echo "  CLAUDE.md — no '@docs/CONSTRAINTS.md' import (R11: the contract won't load each session)"
    echo "    → add the import line from templates/CLAUDE.template.md"
  fi
else
  echo "  CLAUDE.md — absent; create it from templates/CLAUDE.template.md"
fi

if [ -f "$PROJ/docs/CONSTRAINTS.md" ]; then
  echo "  docs/CONSTRAINTS.md — contract in force ✓ (authored; never synced)"
elif ls "$PROJ"/docs/*_RFC.html >/dev/null 2>&1 || ls "$PROJ"/docs/*_DRP.md >/dev/null 2>&1; then
  echo "  docs/CONSTRAINTS.md — absent though the RFC/DRP exist (R11)"
  echo "    → write it from templates/CONSTRAINTS.template.md and have it confirmed"
fi

SJ="$PROJ/.claude/settings.json"
if [ -f "$SJ" ]; then
  if grep -q '"Write(docs/\*\*)"' "$SJ"; then
    echo "  .claude/settings.json — docs permissions present ✓"
  else
    echo "  .claude/settings.json — no docs/** write permission"
    echo "    → merge the permissions.allow block from templates/settings.template.json"
  fi
else
  echo "  .claude/settings.json — absent; copy templates/settings.template.json"
fi

echo
echo "Done. Authored docs were not touched."
[ "$DRY" -eq 1 ] && echo "(dry run — re-run without --dry-run to apply)"
exit 0

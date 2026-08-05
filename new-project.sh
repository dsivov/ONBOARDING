#!/usr/bin/env bash
# ============================================================================
# ONBOARDING — bootstrap a project unattended by driving the /new-project skill
#
# Creates the directory if needed, then runs Claude Code non-interactively so
# the whole scaffold (docs/, templates, house.css, hooks, CLAUDE.md, settings)
# is produced without a human clicking through permission prompts.
#
# PERMISSIONS: by default this grants only what bootstrap needs — auto-accepted
# file edits plus the handful of shell commands used to copy the kit in. That is
# a scoped grant, not a bypass. --yolo swaps it for --dangerously-skip-permissions,
# which disables ALL permission checks for that run (machine-wide, not just this
# directory). Use it only if you know why you need it.
#
# Usage:
#   ./new-project.sh <dir> [--name NAME] [--description TEXT]
#   ./new-project.sh <dir> --dry-run     # print the claude command, run nothing
#   ./new-project.sh <dir> --yolo        # full permission bypass (see above)
#   ./new-project.sh <dir> --model opus  # pick the model (default: your default)
#
# --name defaults to the directory's basename.
# ============================================================================
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
DIR=""; NAME=""; DESC=""; DRY=0; YOLO=0; MODEL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --name) shift; NAME="${1:-}";;
    --description|--desc) shift; DESC="${1:-}";;
    --model) shift; MODEL="${1:-}";;
    --dry-run) DRY=1;;
    --yolo|--skip-permissions) YOLO=1;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    -*) echo "unknown option: $1" >&2; exit 2;;
    *) DIR="$1";;
  esac
  shift
done

[ -n "$DIR" ] || { echo "usage: $0 <dir> [--name NAME] [--description TEXT]" >&2; exit 2; }
command -v claude >/dev/null || { echo "claude CLI not found on PATH" >&2; exit 127; }

# Create the target dir, then resolve it to an absolute path.
[ -d "$DIR" ] || { [ "$DRY" -eq 1 ] && echo "would mkdir -p $DIR" || mkdir -p "$DIR"; }
# Resolve to absolute. Assign via a temp: `DIR="$(cd "$DIR"...)" || DIR=...`
# would blank DIR before the fallback could read it.
if _abs="$(cd "$DIR" 2>/dev/null && pwd)"; then DIR="$_abs"; else DIR="$(realpath -m "$DIR")"; fi
[ -n "$NAME" ] || NAME="$(basename "$DIR")"

# Refuse to scaffold over an existing project without a heads-up.
if [ -d "$DIR/docs/templates" ]; then
  echo "note: $DIR already looks onboarded — use ./sync-project.sh to refresh it instead." >&2
  exit 3
fi

# Install .claude/ ourselves. Writing hooks and settings.json is permission-gated
# in every mode short of a full bypass — reasonably, since hooks execute code and
# settings grant permissions. It's a deterministic copy needing no model judgment,
# so bash does it and Claude is told to leave it alone.
install_claude_dir() {
  local dst="$DIR/.claude" tpl="$KIT/templates/settings.template.json"
  mkdir -p "$dst/hooks"
  cp "$KIT"/templates/hooks/*.sh "$dst/hooks/" 2>/dev/null || true
  chmod +x "$dst"/hooks/*.sh 2>/dev/null || true

  if [ ! -f "$dst/settings.json" ]; then
    cp "$tpl" "$dst/settings.json"
  elif command -v jq >/dev/null 2>&1; then
    # Deep-merge, unioning permissions.allow so an existing grant is never dropped.
    local tmp; tmp="$(mktemp)"
    jq -s '.[0] as $cur | .[1] as $new | ($cur * $new)
           | .permissions.allow = (($cur.permissions.allow // []) + ($new.permissions.allow // []) | unique)' \
       "$dst/settings.json" "$tpl" > "$tmp" && mv "$tmp" "$dst/settings.json"
  else
    echo "  note: .claude/settings.json exists and jq is absent — merge $tpl by hand" >&2
  fi
  echo "  installed .claude/ (hooks + settings.json)"
}

PROMPT="Use the new-project skill to bootstrap the house methodology in ${DIR}.
Project name: ${NAME}.
Description: ${DESC:-(none given — ask nothing, leave the one-liner generic)}.
The ONBOARDING kit is at ${KIT} — copy templates, assets/house.css and the hooks from there.
SKIP the .claude/ part of step 6: hooks and settings.json are ALREADY installed. Leave
.claude/ untouched and don't report it as missing. Do everything else in the skill.
Run non-interactively: do not ask questions, do not commit anything (methodology R5).
Finish by printing a one-line summary of what was created."

# Scoped grant: the shell commands new-project actually uses to copy the kit in.
# Edits are auto-accepted via --permission-mode; --add-dir lets it READ the kit.
ALLOWED=(Write Edit Read "Bash(mkdir *)" "Bash(cp *)" "Bash(chmod *)" "Bash(ls *)")

cmd=(claude -p "$PROMPT" --add-dir "$KIT")
if [ "$YOLO" -eq 1 ]; then
  cmd+=(--dangerously-skip-permissions)
else
  cmd+=(--permission-mode acceptEdits --allowedTools "${ALLOWED[@]}")
fi
[ -n "$MODEL" ] && cmd+=(--model "$MODEL")

echo "ONBOARDING bootstrap → $DIR"
echo "  name:        $NAME"
echo "  description: ${DESC:-(none)}"
echo "  permissions: $([ "$YOLO" -eq 1 ] && echo 'BYPASS ALL (--yolo)' || echo 'scoped (acceptEdits + kit copy commands)')"
echo

if [ "$DRY" -eq 1 ]; then
  echo "would run, with cwd=$DIR:"
  printf '  %q' "${cmd[@]}"; echo
  exit 0
fi

install_claude_dir
echo

cd "$DIR"
set +e; "${cmd[@]}"; rc=$?; set -e

echo
if [ $rc -eq 0 ]; then
  echo "Done. Next: reopen the session in $DIR so the banner fires, then /write-blog."
  echo "      The docs/** permissions stay INACTIVE until this workspace is trusted —"
  echo "      that first interactive session's trust prompt is what switches them on."
  git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1 \
    || echo "note: $DIR is not a git repo — 'git init' so the progress trace has history."
else
  echo "claude exited $rc — scaffold may be incomplete; check $DIR/docs/." >&2
fi
exit $rc

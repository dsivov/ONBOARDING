#!/usr/bin/env bash
# ============================================================================
# ONBOARDING §8 — start the DEVELOPER session (sandbox side).
#
# The developer implements work-plan tasks with every permission check off, and
# reports to the manager rather than the human (R12). Run it FROM THE HOST: it
# starts the sandbox container and re-execs itself inside with --here.
#
# Usage:
#   .claude/roles/developer.sh               # host: launch the sandbox, then claude inside it
#   .claude/roles/developer.sh --here        # already in the sandbox — or you accept the risk
#   CLAUDE_DOCKER=/path/to/claude-docker .claude/roles/developer.sh
#   CC_PROJECT=other .claude/roles/developer.sh
#
# WHY A SANDBOX: this session runs --dangerously-skip-permissions, which turns off
# every confirmation. A container mounting your source and ~/.claude read-write
# bounds the damage to things git can restore. It is NOT a security boundary.
# ============================================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF="$HERE/$(basename "${BASH_SOURCE[0]}")"
PROJ_DIR="$(cd "$HERE/../.." && pwd)"
NAME="${CC_PROJECT:-$(basename "$PROJ_DIR")}"
BRIEF="$HERE/DEVELOPER.md"

IN_PLACE=0
passthru=()
for a in "$@"; do
  case "$a" in
    --here) IN_PLACE=1;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    *) passthru+=("$a");;
  esac
done

# Inside a container we're already sandboxed — nothing left to launch.
[ -f /.dockerenv ] && IN_PLACE=1

# ---------------------------------------------------------------- host side --
if [ "$IN_PLACE" -eq 0 ]; then
  SANDBOX="${CLAUDE_DOCKER:-$PROJ_DIR/../claude-docker}"
  if [ ! -x "$SANDBOX/run.sh" ]; then
    cat >&2 <<EOF
No sandbox found at: $SANDBOX

The developer role runs with ALL permission checks off, so it wants a container.
  · point at yours:  CLAUDE_DOCKER=/path/to/claude-docker $SELF
  · or get the reference one (see METHODOLOGY.md §8) and ./build.sh it
  · or run unsandboxed anyway, on your own judgement:  $SELF --here

Whatever you use must share with the host: the repo at the SAME path, ~/.claude,
and the PID namespace + \$XDG_RUNTIME_DIR/cc-socks — otherwise the two sessions
can't see each other and SendMessage has nothing to address.
EOF
    exit 2
  fi
  echo "developer · dev-${NAME} · sandbox: $SANDBOX"
  # Same repo path on both sides, so the script re-execs itself inside and all the
  # quoting stays in one place. Build the extra args separately — printf '%q ' with
  # an empty array would emit a literal '' and hand claude a blank prompt.
  extra=""
  [ ${#passthru[@]} -gt 0 ] && extra="$(printf '%q ' "${passthru[@]}")"
  exec "$SANDBOX/run.sh" bash -lc "exec $(printf '%q' "$SELF") --here ${extra}"
fi

# ------------------------------------------------------------- sandbox side --
command -v claude >/dev/null || { echo "claude CLI not found on PATH" >&2; exit 127; }

cd "$PROJ_DIR"

export CC_ROLE="developer"
export CC_PEER="mgr-${NAME}"

args=(-n "dev-${NAME}" --dangerously-skip-permissions)

# Role brief into the system prompt so it survives compaction — this session runs
# long and unattended, which is exactly when a banner scrolls out of context.
if [ -f "$BRIEF" ]; then
  args+=(--append-system-prompt "$(cat "$BRIEF")")
else
  echo "note: $BRIEF missing — session starts without the role brief" >&2
fi

[ -f /.dockerenv ] || echo "WARNING: no sandbox detected — skipping ALL permission checks on the host." >&2

echo "developer · dev-${NAME} · ${PROJ_DIR} · peer mgr-${NAME}"
exec claude "${args[@]}" ${passthru[@]+"${passthru[@]}"}

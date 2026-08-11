#!/usr/bin/env bash
# ============================================================================
# ONBOARDING §8 — start the MANAGER session (host side).
#
# The manager owns every doc in docs/, runs the milestone reviews, holds the
# contract, starts the servers, and is the ONLY session the human talks to (R12).
# Normal permissions on purpose: this side should stop and ask.
#
# Usage:
#   .claude/roles/manager.sh                 # start it
#   .claude/roles/manager.sh --resume        # any extra args pass through to claude
#   CC_PROJECT=other .claude/roles/manager.sh
# ============================================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ_DIR="$(cd "$HERE/../.." && pwd)"
NAME="${CC_PROJECT:-$(basename "$PROJ_DIR")}"
BRIEF="$HERE/MANAGER.md"

command -v claude >/dev/null || { echo "claude CLI not found on PATH" >&2; exit 127; }

cd "$PROJ_DIR"

# Read by .claude/hooks/session-banner.sh and statusline.sh so the session shows
# which role it is and whether its peer is up.
export CC_ROLE="manager"
export CC_PEER="dev-${NAME}"

args=(-n "mgr-${NAME}")

# The role brief goes into the SYSTEM prompt, not the banner: it then survives
# compaction and doesn't cost the human a screenful of text every session.
if [ -f "$BRIEF" ]; then
  args+=(--append-system-prompt "$(cat "$BRIEF")")
else
  echo "note: $BRIEF missing — session starts without the role brief" >&2
  echo "      (./sync-project.sh <this dir> from the ONBOARDING kit installs it)" >&2
fi

echo "manager · mgr-${NAME} · ${PROJ_DIR}"
echo "peer:     dev-${NAME} — start it with .claude/roles/developer.sh"
exec claude "${args[@]}" "$@"

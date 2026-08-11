#!/usr/bin/env bash
# ONBOARDING methodology — status line (optional). Claude Code pipes session JSON on
# stdin and renders this line in the bottom bar (user-visible; NOT model context).
# Shows: methodology marker · model · context% · git branch. Degrades gracefully if
# python3 is unavailable.
input="$(cat)"
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')"

# §8 role chip — set by the .claude/roles/ launchers; empty for a solo session.
role="${CC_ROLE:-}"
[ -z "$role" ] && [ -f /.dockerenv ] && role="developer"
case "$role" in
  manager)   chip="MGR · ";;
  developer) chip="DEV · ";;
  *)         chip="";;
esac

# Pass JSON via env (not stdin) so `python3 -c` isn't fighting the script source.
line="$(SL_JSON="$input" SL_BRANCH="$branch" SL_CHIP="$chip" python3 -c '
import os, json
try:
    d = json.loads(os.environ.get("SL_JSON") or "{}")
except Exception:
    d = {}
branch = os.environ.get("SL_BRANCH", "-")
chip = os.environ.get("SL_CHIP", "")
model = (d.get("model") or {}).get("display_name", "?")
cw = d.get("context_window") or {}
pct = cw.get("used_percentage")
pct = f"{int(pct)}%" if isinstance(pct, (int, float)) else "?"
print(f"⬢ {chip}methodology · {model} · ctx {pct} · {branch}")
' 2>/dev/null)"

if [ -n "$line" ]; then echo "$line"; else echo "⬢ ${chip}methodology · ${branch}"; fi

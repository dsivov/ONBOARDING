#!/usr/bin/env bash
# ONBOARDING methodology — session banner (SessionStart hook).
# Claude Code shows this hook's stdout to the USER and adds it to Claude's CONTEXT,
# so it both greets the human and reminds the model of the method. Dependency-free
# (bash + git). Always exits 0 — never block a session start.
set +e
proj="$(basename "$(pwd)")"
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

echo "──────────────────────────────────────────────────────────────"
echo "  ${proj} · house methodology"
echo "  Pipeline:  BLOG → RFC ↔ DRP → ARCHITECTURE → WORK PLAN → reviews"
echo "  Docs:      docs/  ·  index: docs/DOCS_INDEX.md  ·  log: docs/DECISIONS.md"
if [ -n "$branch" ]; then
  if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
    echo "  Branch:    ${branch}  ⚠ on ${branch} — cut a feature/ branch before building (R5)"
  else
    echo "  Branch:    ${branch}"
  fi
fi

# Next-step hint based on what already exists.
if ! ls docs/BLOG_*.html >/dev/null 2>&1; then
  echo "  Next:      /write-blog — start the vision"
elif ! ls docs/*_WORK_PLAN.md >/dev/null 2>&1; then
  echo "  Next:      /write-rfc + /write-drp  →  /write-architecture  →  /make-workplan"
else
  echo "  Next:      build the current milestone; /milestone-review before advancing"
fi

echo "  Rules:     docs-first · measure every claim · review each milestone · don't merge to main unverified"
echo "──────────────────────────────────────────────────────────────"
exit 0

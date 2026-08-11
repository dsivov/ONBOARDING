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

# ---- §8 two-session split (R12) -------------------------------------------
# Silent unless a role is actually in play: the launchers in .claude/roles/ export
# CC_ROLE + CC_PEER, and any session inside the sandbox is the developer by default.
# A solo session sees none of this and is the manager by definition.
role="${CC_ROLE:-}"
[ -z "$role" ] && [ -f /.dockerenv ] && role="developer"
if [ -n "$role" ]; then
  peer="${CC_PEER:-}"
  peer_state="unknown"
  if [ -n "$peer" ]; then
    peer_state="not running"
    # Sessions register in ~/.claude/sessions/<pid>.json; liveness is /proc/<pid>.
    for f in "$HOME"/.claude/sessions/*.json; do
      [ -f "$f" ] || continue
      grep -q "\"name\":\"${peer}\"" "$f" 2>/dev/null || continue
      p="$(basename "$f" .json)"
      [ -d "/proc/$p" ] && { peer_state="up"; break; }
    done
  fi
  if [ "$role" = "developer" ]; then
    echo "  Role:      DEVELOPER  ·  peer ${peer:-mgr-?}: ${peer_state}   (methodology R12 · §8)"
    echo "             Build the milestone flat out — no prompts are coming. Never edit docs/,"
    echo "             never start a long-lived server, never message the human."
    echo "             STOP and SendMessage the manager on:  M<n> READY · BLOCKED · DRIFT A<n> ·"
    echo "             PLAN GAP  — then wait for the reply. Brief: .claude/roles/DEVELOPER.md"
    [ "$peer_state" = "up" ] || echo "             ⚠ manager not running — wait for it; do not fall back to the human."
  else
    echo "  Role:      MANAGER  ·  peer ${peer:-dev-?}: ${peer_state}   (methodology R12 · §8)"
    echo "             You own docs/, the reviews, the contract, DECISIONS, and the servers"
    echo "             (host, bound 0.0.0.0). You are the only session the human talks to."
    echo "             Developer signals in → FINDINGS / PROCEED / ANSWER / AMENDED out. Findings"
    echo "             go back as findings: don't edit the tree mid-milestone. .claude/roles/MANAGER.md"
    [ "$peer_state" = "up" ] || echo "             Developer not running — start it: .claude/roles/developer.sh"
  fi
fi

# The architecture contract (R11) — in force, or owed once the RFC/DRP are agreed.
if [ -f docs/CONSTRAINTS.md ]; then
  n="$(grep -c '^| A[0-9]' docs/CONSTRAINTS.md 2>/dev/null)"
  v="$(grep -m1 -o 'v[0-9]\+' docs/CONSTRAINTS.md 2>/dev/null)"
  echo "  Contract:  docs/CONSTRAINTS.md · ${n:-?} constraints · ${v:-v1} — drift from it stops the build (R11)"
elif ls docs/*_RFC.html >/dev/null 2>&1 || ls docs/*_DRP.md >/dev/null 2>&1; then
  echo "  Contract:  ⚠ docs/CONSTRAINTS.md missing — agree it now that the RFC/DRP exist (R11)"
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
echo "             check CONSTRAINTS.md before any top-level change — drift ⇒ stop, report, ask"
echo "──────────────────────────────────────────────────────────────"
exit 0

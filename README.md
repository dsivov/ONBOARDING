# ONBOARDING — the project operating system

A reusable **methodology + templates + skills + UI kit** for starting and running a
project the way we run them: documentation-first, evidence-driven, reviewed at every
milestone, with a consistent house visual style.

Copy this into a new project (or point the `new-project` skill at it) and you get the
whole workflow — from the first BLOG to shipped, reviewed code — without reinventing it.

## The pipeline in one line

```
          ┌── RFC (approach) ──┐
BLOG ─▶   │   co-authored ↕    │ ─▶ ARCHITECTURE / CHANGE-REQUEST ─▶ WORK PLAN ─▶ ⟳ milestones
          └── DRP (detail) ────┘                                     (tasks + test gates)   │
                    └──────────────── DECISIONS log ────────────────────────────────────┐  │
                                                                                          ▼  ▼
                                                          CODE REVIEW + CHECKPOINT each milestone
                                                                                          │
                                                          progress trace + docs/ artifacts + memory
```

RFC & DRP are a **coupled pair** — co-author them (RFC leads on approach, DRP on detail);
sequential or merged-into-one are variants. See [METHODOLOGY.md](METHODOLOGY.md) §1.

- **BLOG** (`.html`) — the vision / narrative. Why this, why now, for whom.
- **RFC** (`.html`) — the proposal: what we assemble, build, avoid; decisions; phased plan.
- **DRP** (`.md`) — Detailed Requirements & Plan: scope, requirements, constraints, acceptance criteria.
- **ARCHITECTURE** (`.html`) / **CHANGE-REQUEST** (`.md`) — how it's built, or a scoped change on top.
- **WORK PLAN** (`.md`) — phases → milestones (M1, M2…) → checkbox tasks, each milestone with **test gates**.
- **CODE REVIEW** (`.md`) — per-milestone review, findings by severity (C/H/M/S).
- **CHECKPOINT REVIEW** (`.md`) — periodic project-level review; prioritized findings with `✅ FIXED` tracking.
- **DECISIONS** (`.md`) — running ADR-lite log so choices aren't re-litigated.
- **DOCS INDEX** (`.md`) — the map of `docs/`.

See **[METHODOLOGY.md](METHODOLOGY.md)** for the full lifecycle and the rules that make it work.

## What's in here

```
ONBOARDING/
  README.md                  ← you are here
  METHODOLOGY.md             ← the full lifecycle spec + conventions
  assets/house.css           ← the shared dark-theme design system (docs)
  templates/                 ← fill-in templates for every artifact
  frontend-kit/              ← standalone themed HTML UI kit (no build)
  .claude/skills/            ← installable skills that generate the artifacts
```

## Quick start

1. **Bootstrap a project:** `/new-project` — scaffolds `docs/`, copies templates + `house.css`,
   creates `DOCS_INDEX.md` and `DECISIONS.md`.
2. **Write the first artifact:** `/write-blog`, then `/write-rfc`, then `/write-drp`.
3. **Plan the build:** `/make-workplan` — phases, milestones, test gates.
4. **At each milestone:** `/milestone-review` — code review + checkpoint, update the progress trace.

Skills read the templates in `templates/` and the design system in `assets/house.css`, so
every project comes out consistent.

## The non-negotiables (why it works)

- **Docs before code.** Every build traces to an RFC/DRP; every doc traces to a BLOG.
- **Every claim is measured.** Performance/accuracy statements ship with a reproducible harness in `scripts/`.
- **Every milestone is reviewed** before the next one starts, and has explicit **test gates**.
- **Feature branches; never merge to main unverified.** Commit/push only when asked.
- **Docs are honest and current** — the final doc describes the destination, not the journey.

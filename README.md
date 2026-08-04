# ONBOARDING — the project operating system

A reusable **methodology + templates + skills + UI kit** for starting and running a
project the way we run them: documentation-first, evidence-driven, reviewed at every
milestone, with a consistent house visual style.

Install the skills once (see **Install** below) and you get the whole workflow — from the
first BLOG to shipped, reviewed code — in any project, without reinventing it.

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
  install.sh / uninstall.sh  ← install the skills at the user level (safe, non-destructive)
  assets/house.css           ← the shared dark-theme design system (docs)
  templates/                 ← fill-in templates for every artifact (+ CLAUDE.md, settings, hooks)
  frontend-kit/              ← standalone themed HTML UI kit (no build)
  docs/                      ← the illustrated methodology guide + LinkedIn poster
  .claude/skills/            ← installable skills that generate the artifacts
```

## Install (once)

Skills only resolve if they're discoverable *before* you invoke them. Claude Code loads
skills from two places:

- **User level** — `~/.claude/skills/<name>/SKILL.md` → available in **every** project.
- **Project level** — `<project>/.claude/skills/<name>/SKILL.md` → that project only.

So there's a bootstrap step. Pick one:

**A · Install at the user level (recommended)** — makes `/new-project` and the write-* skills
available in any directory, including an empty new project:

```bash
./install.sh              # symlink this kit's skills into ~/.claude/skills (updates propagate)
./install.sh --copy       # or copy them in (standalone, no dependency on this repo path)
./uninstall.sh            # remove them again (safe — see below)
```

`install.sh` is **non-destructive**: it only touches this kit's seven skills, never deletes
the skills directory, and **won't overwrite a same-named skill you already have** (use
`--force` to replace, which backs the old one up first). `uninstall.sh` removes **only** what
the installer created (its symlinks / tagged copies) — any skill you made yourself is left in
place.

Now, in a fresh project: **`/new-project`** → it **copies** the templates + `house.css` into
the project (so the project is self-contained), scaffolds `docs/`, and seeds `DOCS_INDEX.md` +
`DECISIONS.md`. By default it scaffolds into the **current directory**; `/new-project <path>`
targets another.

**B · Run from inside this repo** — open Claude Code in `ONBOARDING/` and ask it to scaffold a
sibling project; `new-project` targets the path you give. No install needed.

**C · Manual first copy** — copy `templates/` and `assets/house.css` into the new project by
hand; copy `.claude/skills/*` into the project's `.claude/skills/` to get the commands locally.

> The skills reference this repo for templates + `house.css` (default location `../ONBOARDING`,
> or tell the skill where it lives). Keep the repo somewhere stable.

## Then, in every project

1. **Bootstrap:** `/new-project` — scaffolds `docs/`, templates, `house.css`, index + decision log,
   **plus a `CLAUDE.md` and a `SessionStart` hook** so every session opens with a methodology
   banner (docs location · pipeline · branch · next step) that the user sees *and* Claude reads.
2. **Frame it:** `/write-blog` → `/write-rfc` + `/write-drp` (co-authored) — vision, proposal, requirements.
3. **Design & plan:** `/write-architecture`, then `/make-workplan` — phases, milestones, test gates.
4. **Each milestone:** `/milestone-review` — code review + checkpoint, update the progress trace.

Skills read the templates in `templates/` and the design system in `assets/house.css`, so
every project comes out consistent.

## The non-negotiables (why it works)

- **Docs before code.** Every build traces to an RFC/DRP; every doc traces to a BLOG.
- **Every claim is measured.** Performance/accuracy statements ship with a reproducible harness in `scripts/`.
- **Every milestone is reviewed** before the next one starts, and has explicit **test gates**.
- **Feature branches; never merge to main unverified.** Commit/push only when asked.
- **Docs are honest and current** — the final doc describes the destination, not the journey.

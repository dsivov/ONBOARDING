# ONBOARDING — the project operating system

[![License: MIT](https://img.shields.io/badge/License-MIT-8fd9c9.svg)](LICENSE)
[![Built for Claude Code](https://img.shields.io/badge/built%20for-Claude%20Code-a974f0.svg)](https://claude.com/claude-code)
[![Docs](https://img.shields.io/badge/docs-illustrated%20guide-5b8def.svg)](docs/METHODOLOGY.html)

A reusable **methodology + templates + skills + UI kit** for starting and running a
project the way we run them: documentation-first, evidence-driven, reviewed at every
milestone, with a consistent house visual style.

**The problem it solves:** agentic coding makes it cheap to produce code and expensive to
know whether that code was a good idea. This repo is the operating system that goes around
the agent — a fixed set of artifacts, thirteen rules, and eight skills that turn "ask an agent to
build it" into a traceable pipeline where every build points back to a written proposal,
every claim points to a measurement, and every milestone is reviewed before the next starts.

Install the skills once (see **Install** below) and you get the whole workflow — from the
first BLOG to shipped, reviewed code — in any project, without reinventing it.

## The pipeline in one line

```
          ┌── RFC (approach) ──┐
BLOG ─▶   │   co-authored ↕    │ ─▶ CONSTRAINTS ─▶ ARCHITECTURE / CHANGE-REQUEST ─▶ WORK PLAN ─▶ ⟳ milestones
          └── DRP (detail) ────┘    (the contract)                                  (tasks + gates)  │
                    └──────────────── DECISIONS log ─────────────────────────────────────────────┐  │
                                                                                                 ▼  ▼
                                                             CODE REVIEW + CHECKPOINT each milestone
                                                                                                 │
                                                             progress trace + docs/ artifacts + memory
```

Once the RFC + DRP are agreed, that agreement is frozen into **`CONSTRAINTS.md`** — one page the
agent carries in context every session and checks every top-level decision against.

RFC & DRP are a **coupled pair** — co-author them (RFC leads on approach, DRP on detail);
sequential or merged-into-one are variants. See [METHODOLOGY.md](METHODOLOGY.md) §1.

- **BLOG** (`.html`) — the vision / narrative. Why this, why now, for whom — plus the **product frame**
  (segments · jobs · success metric · launch criteria), which is the product tier of the pipeline and
  where an incoming PRD lands.
- **RFC** (`.html`) — the proposal: what we assemble, build, avoid; decisions; phased plan.
- **DRP** (`.md`) — Detailed Requirements & Plan: scope, requirements, constraints, acceptance criteria,
  layout, libraries, integrations. The **engineering** requirements spec — *not* a PRD. A PRD, if your
  org has one, is an upstream **input** to the RFC, never a co-author. See [METHODOLOGY.md](METHODOLOGY.md) §1.
- **CONSTRAINTS** (`.md`) — the architecture contract: the agreed top-level design in ~15
  falsifiable sentences. Loaded every session; drift from it stops the build and goes to a human.
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
  new-project.sh             ← bootstrap a project unattended (drives /new-project headless)
  sync-project.sh            ← push methodology updates into an already-onboarded project
  assets/house.css           ← the shared dark-theme design system (docs)
  templates/                 ← fill-in templates for every artifact (+ CLAUDE.md, settings, hooks)
  templates/DECK.template.html ← self-contained dual-mode HTML presentation (present + reference)
  templates/tools/           ← deck_to_pptx.py — export a deck to native 16:9 PowerPoint
  templates/roles/           ← manager/developer launchers for the two-session mode (R12 · §8)
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

`install.sh` is **non-destructive**: it only touches this kit's eight skills, never deletes
the skills directory, and **won't overwrite a same-named skill you already have** (use
`--force` to replace, which backs the old one up first). `uninstall.sh` removes **only** what
the installer created (its symlinks / tagged copies) — any skill you made yourself is left in
place.

Now, in a fresh project: **`/new-project`** → it **copies** the templates + `house.css` into
the project (so the project is self-contained), scaffolds `docs/`, and seeds `DOCS_INDEX.md` +
`DECISIONS.md`. By default it scaffolds into the **current directory**; `/new-project <path>`
targets another.

**B · One command, fully unattended** — install the skills *and* scaffold a new project without
touching a permission prompt:

```bash
./install.sh --new-project ~/work/budget-guard \
             --name "Budget Guard" \
             --description "Checks whether a grocery basket fits the family budget"

./new-project.sh ~/work/budget-guard --name "Budget Guard"   # same thing, skills already installed
./new-project.sh ~/work/budget-guard --dry-run               # print the command, run nothing
```

Creates the directory if it doesn't exist. **`--name` defaults to the directory's basename**, so
`./new-project.sh ~/work/budget-guard` names the project `budget-guard`. `--description` is
optional. `--model` picks the model.

*Permissions:* the run is scoped — `--permission-mode acceptEdits` plus the specific shell
commands the scaffold uses (`mkdir`/`cp`/`chmod`/`ls`). It is **not** a blanket bypass, so a
command outside that set still stops. `--yolo` swaps in `--dangerously-skip-permissions`, which
disables every check for that run **machine-wide, not just in the target directory** — reach for
it only if you know why. The script installs `.claude/hooks/` and `.claude/settings.json` itself
rather than asking the model to: writing hooks and settings is permission-gated in every mode
short of a bypass, and it's a plain copy needing no judgment.

> **Trust:** the `docs/**` permissions sit inactive until the workspace is trusted. The first
> interactive session there prompts for it — that's what switches them on.

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
5. **Need to present it?** `/write-deck` — one self-contained HTML file, present mode + reference
   mode, no build and no network; optional `.pptx` export.

Skills read the templates in `templates/` and the design system in `assets/house.css`, so
every project comes out consistent.

Bootstrapped projects also get `permissions.allow` for `Read`/`Edit`/`Write` on `docs/**`, so
the architect and manager skills author artifacts without a permission click. It's scoped to
`docs/` deliberately — code changes still ask.

## Two sessions: a manager and a developer

Optional mode, and the one that changes how a long build *feels*. Instead of one session that
alternates between writing docs and typing code — stopping for permission every few minutes —
run **two sessions against one repo**:

```bash
.claude/roles/manager.sh      # host · normal permissions · owns docs/, reviews, servers, you
.claude/roles/developer.sh    # sandbox · --dangerously-skip-permissions · owns the code
```

**You only ever talk to the manager** (that's rule R12). It holds every document, runs every
milestone review, amends the contract, and starts the servers — on the host, bound `0.0.0.0`,
because we work remotely. The developer holds nothing but the current milestone and runs flat out
inside a container where no prompt can interrupt it.

It stops for exactly four things, and reports each to the manager over Claude Code's
`SendMessage`, then waits:

| Signal | Fires when |
|---|---|
| `M<n> READY` | the milestone's test gate passes — requests the code review |
| `BLOCKED` | it genuinely can't proceed |
| `DRIFT A<n>` | a change would make a `CONSTRAINTS.md` sentence false (R11) |
| `PLAN GAP` | the work needs a task the plan doesn't have, or a library not in the DRP's table |

The manager reviews, and replies `FINDINGS M<n>` / `PROCEED` / `ANSWER` / `AMENDED A<n>`. So the
build runs at full speed between checkpoints, every question still reaches you in one place and
in order, and the code being reviewed isn't moving while it's reviewed.

The sandbox needs three things so the two sessions can see each other: the repo at the **same
path** on both sides, a shared **`~/.claude`**, and a shared **PID namespace + `cc-socks`**
directory. A sibling `claude-docker` repo (Ubuntu + the Claude Code CLI, `--pid=host`, the work
tree at its host path) is the reference implementation and does all three;
`CLAUDE_DOCKER=<path>` points the launcher at a different one. Be clear-eyed about what it buys:
a container mounting your source and `~/.claude` read-write bounds the blast radius, it is not a
security boundary.

`/new-project` installs the launchers and both role briefs into `.claude/roles/` — inert until you
use them. **A solo session is the manager**, R12 holds trivially, and nothing else about the
method changes. Full spec: [METHODOLOGY.md §8](METHODOLOGY.md#8--the-two-session-split-manager--developer).

## Keeping projects current

`/new-project` **copies** templates and `house.css` into each project so it's self-contained —
which means a later methodology change doesn't reach it. Push updates in with:

```bash
./sync-project.sh ~/work/budget-guard             # refresh the kit files
./sync-project.sh ~/work/budget-guard --dry-run   # see what would change first
```

It refreshes only kit-owned files (`docs/templates/`, `docs/assets/house.css`,
`docs/METHODOLOGY.md`) and **never touches your authored artifacts**. `CLAUDE.md` and
`.claude/settings.json` carry project-specific content, so those are *reported* — it names
which methodology rules are missing and whether the `docs/**` permission is absent — and you
merge them.

Install the skills with `./install.sh` (symlink, the default) and skill updates propagate on
their own; `--copy` freezes them and needs a re-run to update.

## The non-negotiables (why it works)

- **Docs before code.** Every build traces to an RFC/DRP; every doc traces to a BLOG.
- **Every claim is measured.** Performance/accuracy statements ship with a reproducible harness in `scripts/`.
- **Every milestone is reviewed** before the next one starts, and has explicit **test gates** —
  each naming the requirement IDs it proves, so coverage is checkable in both directions.
- **Feature branches; never merge to main unverified — and never merge what you can't undo.**
  Schema changes are expand-then-contract; the drop lands in a separate, later PR. Commit/push
  only when asked.
- **Docs are honest and current** — the final doc describes the destination, not the journey.
- **Ask in planning, don't guess** — ambiguity is cheapest to fix before the artifact is written.
- **Design docs name the layout, the libraries, the integrations, and what already exists** — and
  reuse it; never two libraries for one job. Every outbound call carries a timeout, a retry
  budget, a breaker and a terminal state, or it has silently chosen *hang, then cascade*.
- **Non-functional requirements are numbers, and every number has a gate.** "Fast", "reliable"
  and "it must scale" are not requirements — they are places where one is missing. Each quality
  attribute gets a target, a measurement method, and the milestone that proves it.
- **The architecture contract is checked, not remembered** — `CONSTRAINTS.md` holds the agreed
  design as ~15 falsifiable sentences, loaded into context every session. Would a change make one
  of them false? Stop, report the drift, ask. Approved changes amend the contract first.
- **One human interface** — you talk to exactly one session, the manager; it owns the docs, the
  reviews and every call that needs a person. A second, sandboxed session builds at full speed and
  reports to the manager, never to you. Solo? Then you're already talking to the manager.

The full set is [METHODOLOGY.md §2](METHODOLOGY.md#2--the-rules-that-make-it-work) (R1–R13),
or the illustrated version in [docs/METHODOLOGY.html](docs/METHODOLOGY.html).

## Built on, not instead of

The skills **delegate** to what Claude Code already does well and keep only what's house —
templates, design tokens, severity scheme, progress trace. The `Explore` agent runs the
existing-code inventory; the `Plan` agent weighs design alternatives; `artifact-diagramming`
and `dataviz` handle the SVGs; `/code-review`, `/security-review` and `simplify` find the
issues a milestone review then triages. One tool per job — the same rule the methodology
applies to your dependencies, applied to itself.

## License

[MIT](LICENSE) — use it, fork it, adapt it to your own house style. If it's useful, a link
back is appreciated but not required.

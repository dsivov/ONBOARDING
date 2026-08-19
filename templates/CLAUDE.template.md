<!-- TEMPLATE: CLAUDE.md — auto-loaded into Claude's context at every session start.
     new-project copies this to the project root (or .claude/CLAUDE.md). Keep it under
     ~200 lines. If the project already has a CLAUDE.md, MERGE this section in. -->

# {{PROJECT}} — working agreement

This project runs on the **house methodology** (docs-first, evidence-driven, reviewed at
every milestone). Full spec: `ONBOARDING/METHODOLOGY.md`.

## Pipeline
`BLOG → RFC ↔ DRP → CONSTRAINTS → ARCHITECTURE / CHANGE-REQUEST → WORK PLAN → milestone reviews`
Artifacts live in `docs/` (map: `docs/DOCS_INDEX.md`; decision log: `docs/DECISIONS.md`).
RFC & DRP are **co-authored** (RFC leads on approach, DRP on detail), agreed before the plan.

## The architecture contract — always in context

@docs/CONSTRAINTS.md

The import above loads the contract every session (it stays inert until the file exists — it's
created once the RFC + DRP are agreed). **Never build past it.** Re-read it before: adding or
swapping a **dependency / service / datastore** · creating or moving a **top-level directory or
deployable** · crossing a **stated boundary** · changing a **public contract** (API, schema, CLI,
event, file format) · introducing **state, concurrency, caching or background work** · changing
**auth / tenancy / trust** or the **deployment target** · adding a second tool for a job something
already does · anything on its **non-goals** list.

**The test:** would this change make a sentence in `CONSTRAINTS.md` false? Then **STOP** — don't
implement it and report afterwards. Report first: constraint **ID** · what the contract says ·
what the change needs · why · options (**comply / amend / defer**), and wait for a decision. If an
amendment is approved, edit `CONSTRAINTS.md` first (bump version + amendment row), log a `D-NN` in
`DECISIONS.md`, then build.

## Rules (do these — they're not optional)
- **R1 Docs before code** — no build without an RFC/DRP and a work-plan task.
- **R2 Measure every claim** — perf/accuracy/"better-than" ships with a reproducible harness in
  `scripts/`; otherwise call it a hypothesis. An honest "parity" beats an unverified win.
- **R3 Test gates** — a milestone is done when its listed gate passes, not when code exists.
  Every gate **names the requirement IDs it proves** (`— proves F3, NFR-latency`), so coverage
  is checkable both ways and an orphan requirement is findable before the last milestone.
- **R4 Review before advancing** — code review each milestone; fix Critical/High first.
- **R5 Branches & reversibility** — work on `feature/<name>`; never merge to `main` unverified;
  commit/push only when asked. Merge also needs **"how is this undone?"** answered in the PR:
  schema changes are **expand-then-contract** and the `drop` is a *separate later* PR — a
  migration never merges with the code that depends on it. Otherwise: "reversible: plain revert".
- **R6 Honest & current docs** — describe the destination, not the journey; fix docs when a measurement corrects a belief.
- **R7 Log decisions** in `docs/DECISIONS.md`; don't re-litigate them.
- **R8 Persist the non-obvious** — project memory the repo and git history don't already record.
- **R9 In planning, ask when unsure** — during discussion/RFC/DRP, don't guess at ambiguous scope
  or approach: ask, with suggested options (recommended first + trade-offs). Log the answer.
- **R10 Layout, libraries, integrations, reuse** — every RFC/DRP/architecture/CR carries four
  concrete sections: a **file-system layout**; an **external-library table** (name, version,
  purpose, why over the alternative); **integrations in and out** — inbound contracts we expose
  (style · consumers · version policy · auth · idempotency · limits) and every outbound call with
  its **timeout · retry · breaker · fallback · terminal state**; and **cross-cutting concerns**
  (authN/authZ · secrets · observability + SLO · config · tenancy · data classification ·
  retention & erasure · audit · flags · cost), one line each. "None" is an answer; silence isn't.
  Python? **Ask** the dependency manager (`conda` default; uv/poetry/pip+venv). Existing code?
  Inventory the current layout, used libs, DBs and integrations first and **reuse them** — never a
  second library for a job something already does; replacing an incumbent means planning its removal.
- **R11 Check the contract, don't remember it** — `docs/CONSTRAINTS.md` (imported above) holds the
  agreed top-level architecture as ~15 falsifiable sentences (`A1…`). Written contract-check at
  every milestone start and in every review; **tripwire** re-read before the edits listed above.
  Drift ⇒ stop and ask; approved change ⇒ amend the file **first**, then log `D-NN`. Never silent.
  Adding a **new** ID that contradicts nothing is an *extension* (`ext`) — log it, no drift report.
  Only making an **existing** sentence false is an *amendment*, and that stops the build first.
- **R12 One human interface** — the human talks to exactly one session, the **manager**: it owns
  every doc, every review, and every call that needs a person. A second **developer** session
  reports to the manager and waits — it never asks the human directly and never invents an answer
  to keep moving. Alone in a session? Then you are the manager and R12 is already satisfied.
- **R13 NFRs are numbers, and every number has a gate** — "fast", "reliable", "highly available",
  "real-time", "it must scale" are not requirements; they are places where one is missing. Every
  quality attribute gets **target · measured by · gate**, no blanks: latency (with the percentile)
  · throughput (peak) · availability · durability (RPO/RTO) · consistency · security & privacy ·
  observability · operability · cost. A target with no harness is a **hypothesis**; a number with
  no milestone gate is one nobody discovers was missed until production does. **Ask** for these
  numbers with options and their cost (R9) — never invent a default.

## GitHub cycle
Branch per feature · commit per task · push per milestone · merge only when the gate passes,
review is clean, **and the change is reversible**. `main` is always releasable. Prefer squash-merge.

## House style
Every doc is illustrated: **inline SVG** in HTML, **mermaid** in Markdown. Shared design
system: `docs/assets/house.css`. App UIs use the `frontend-kit` tokens.

## Skills
`/write-blog · /write-rfc · /write-drp · /write-architecture · /make-workplan · /milestone-review`
generate each artifact from `docs/templates/`.

## Roles — when two sessions are running (R12 · methodology §8)

Optional mode. Started with `.claude/roles/manager.sh` and `.claude/roles/developer.sh`, which
name the sessions `mgr-{{project}}` / `dev-{{project}}` and load the matching brief in
`.claude/roles/`. Find the peer with `ListAgents`, talk to it with `SendMessage`. The session
banner says which role you are; if it says nothing, you're solo and this section is inert.

| | **Manager** (host) | **Developer** (sandbox, no permission prompts) |
|---|---|---|
| Owns | all of `docs/` · reviews · contract · decisions · the servers (host, bound `0.0.0.0`) | the code and its tests |
| Talks to | the human | the manager only |
| Never | edits the working tree mid-milestone | edits `docs/` · starts a long-lived server · messages the human |

**Developer → manager**, first line is the tag, then stop and wait:
`M<n> READY` (gate passed, requests review) · `BLOCKED` · `DRIFT A<n>` (R11) · `PLAN GAP` (R1/R10).
**Manager → developer:** `FINDINGS M<n>` · `PROCEED` · `ANSWER` · `AMENDED A<n>`.

Messages are **signals, not payloads** — you share a working tree and a git history, so send a
branch, a commit, a `file:line` or a doc path. Never paste a diff.

## Project-specific notes
{{Add anything specific to THIS project: stack, run commands, gotchas, key paths.}}

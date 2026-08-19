---
name: write-architecture
description: Write an ARCHITECTURE doc (HTML) for a system, or a CHANGE_REQUEST (Markdown) for a scoped change on top of an existing one. Use when the user asks for "the architecture", "how it's built", or "a change request / CR".
---

# write-architecture — design (Stage 4)

Two modes. Pick by what the user needs.

## Reuse first
Reuse the capability, keep the house format (template, `house.css` tokens, section structure):
- **Inventory with the `Explore` agent** (below) instead of reading the tree inline.
- **Weighing design alternatives?** Run the **`Plan`** agent first — it returns step-by-step
  options and architectural trade-offs. Its output feeds the trade-offs table; it does not
  replace it, and the doc still names what was rejected and why.
- Before each section's SVG, load **`artifact-diagramming`**; load **`dataviz`** for charts.

## Before writing — read the contract (methodology R11)
`docs/CONSTRAINTS.md` holds the agreed top-level design (`A1…`). Both modes below are checked
against it **before** anything is written:
- **Mode A** designs *within* it, then **extends** it — an architecture commits to boundaries and
  stores the RFC/DRP only implied. Add those as new constraints (keep the one-page cap: merge or
  retire weaker ones rather than growing the list past ~15). **Extension is not drift**: a *new*
  ID that contradicts nothing is logged as `ext` and needs no drift report. Only a change that
  makes an existing sentence **false** is an `amend`, and that stops the build first (R11).
- **Mode B** must not silently contradict it. A CR that needs a constraint changed is a **drift**:
  stop, report (ID · what the contract says · what the CR needs · why · comply/amend/defer), and
  get approval. If approved, amend `CONSTRAINTS.md` first (bump version, amendment row) and log
  the `D-NN` — then write the CR against the amended contract.
- If the file doesn't exist yet (RFC/DRP predate R11), create it from
  `docs/templates/CONSTRAINTS.template.md` and have the human confirm it before continuing.

## Before writing — inventory (mandatory if any code already exists)
Run the **`Explore`** agent over the repo — read-only fan-out that returns the conclusion
rather than the file dumps, so a large codebase doesn't eat the context you need for the
design. Ask for "medium" breadth, or "very thorough" when the codebase is unfamiliar. Have it
report (methodology R10):
- The **current file-system layout** — what lives where, and the conventions it already follows.
- The **libraries already installed *and actually used*** (manifest *and* imports — a listed
  dep nobody imports is not a reason to keep it) plus their versions.
- The **databases, stores, and live integrations** it talks to.
Design *with* these. Never propose a second library, service, or module for a job something
in the repo already does. Replacing an incumbent is allowed but must be stated, justified,
and paired with a task to remove the old one.

## Mode A — ARCHITECTURE (new system)
Produce `docs/<NAME>_ARCHITECTURE.html` from `docs/templates/ARCHITECTURE.template.html`.
- Sections: **guiding principle** · **components** (map SVG + responsibility table) ·
  **data model** (SVG) · **key flows** (SVG) · **code layout & dependencies** ·
  **integrations in & out** (SVG + two tables) · **cross-cutting concerns** ·
  **boundaries/ownership** · **trade-offs**.
- **Key flows means three, not one**: the happy path, the most likely failure, and the nastiest
  one. The third is where the design is actually tested.
- Every section gets a colorful **SVG** using house tokens; link `assets/house.css`.
- State one guiding principle everything derives from; give each component an owner and
  its entry-point files.
- **Code layout & dependencies is not optional** (R10): the directory tree as it will exist
  with what each path owns, plus a table of every external library — name, version/pin,
  purpose, why it over the alternative. Mark each row **reused** (already in the repo) or
  **new**. A reader must be able to place a new file without asking.
- **Integrations are not optional either** (R10). Two tables, because they fail in opposite
  directions. *Inbound:* every contract we expose — style, consumers, version & compatibility
  policy, auth, idempotency semantics, limits, error shape. *Outbound:* every service we call,
  one row each, with **timeout · retry · breaker · fallback · the terminal state** a request
  ends in when all of it fails. Check the retry budget arithmetic: attempts × timeout + backoff
  must fit inside the caller's own deadline, or the retries are a self-inflicted outage.
  "None" is a valid answer; an absent table is not.
- **Cross-cutting concerns** (R10), one line each: authN/authZ · secrets & rotation ·
  observability (correlation id through HTTP *and* the broker, metrics, traces, the SLO) ·
  configuration · tenancy · data classification · retention & erasure · audit · feature flags ·
  cost. Plus the **reversibility** note: schema changes are expand-then-contract and the drop is
  a separate later deploy (§3, merge condition 5).
- **Python?** Ask which dependency manager before writing the layout — `conda` (house
  default), `uv`, `poetry`, or `pip` + `venv` — present them as options (R9), then show the
  real manifest file in the tree. Log the answer in `DECISIONS.md`.

## Mode B — CHANGE_REQUEST (change to an existing system)
Produce `docs/<NAME>_CHANGE_REQUEST.md` from `docs/templates/CHANGE_REQUEST.template.md`.
- Reference the architecture section(s) it touches.
- **Mermaid before→after** diagram; scope (changed vs explicitly-unchanged); impact/risk
  table; backward-compat + rollback; acceptance criteria (test gate); tasks.
- Show the **layout delta** (files/dirs added, moved, deleted) and **any new dependency**
  with its justification — including why nothing already installed covers it.
- Show the **integration delta** (any inbound contract changed, any new outbound call — with its
  timeout/retry/breaker/terminal state) and the **cross-cutting rows** this CR touches (R10).
- **Reversibility** is a required line (§3, condition 5), not a footnote: how is this undone?
  A schema change is expand-then-contract, and the `drop` is a separate later task in §7 —
  never in the same PR as the code that depends on it.
- Name any **NFR target** this moves, and re-measure it with its harness before merge (R13).

## Finish (both)
- **Update `docs/CONSTRAINTS.md`** — Mode A: add the constraints this design commits to (and the
  version/date). Mode B: only if an amendment was approved, with its amendment row. Re-confirm
  with the human that the contract still reads true.
- Log the design decisions in `docs/DECISIONS.md`.
- Add to `docs/DOCS_INDEX.md`. Suggest `/make-workplan` (new) or add tasks to the plan (CR).

## Rules
- Describe the **destination**, not the journey (methodology R6).
- Trade-offs section names what was rejected and why — and, for each, **the signal that would
  reverse the choice**. A choice with no reversal condition is a preference, not a decision.
- Ship no architecture without a **file-system layout**, an **external-library table**, an
  **integrations table (in and out)** and a **cross-cutting table** (R10).
- **Every box on the component map traces to a requirement.** If you can't name the `F#` or
  `NFR-*` that put it there, it comes off the map.
- **One tool per job** — no two libraries with overlapping functionality (R10).
- **Never contradict the contract in silence** (R11). Design inside it, extend it deliberately,
  or report the drift and ask — in that order of preference.

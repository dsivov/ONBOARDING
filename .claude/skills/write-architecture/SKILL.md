---
name: write-architecture
description: Write an ARCHITECTURE doc (HTML) for a system, or a CHANGE_REQUEST (Markdown) for a scoped change on top of an existing one. Use when the user asks for "the architecture", "how it's built", or "a change request / CR".
---

# write-architecture — design (Stage 4)

Two modes. Pick by what the user needs.

## Before writing — inventory (mandatory if any code already exists)
Read the repo before designing on top of it (methodology R10):
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
  **boundaries/ownership** · **trade-offs**.
- Every section gets a colorful **SVG** using house tokens; link `assets/house.css`.
- State one guiding principle everything derives from; give each component an owner and
  its entry-point files.
- **Code layout & dependencies is not optional** (R10): the directory tree as it will exist
  with what each path owns, plus a table of every external library — name, version/pin,
  purpose, why it over the alternative. Mark each row **reused** (already in the repo) or
  **new**. A reader must be able to place a new file without asking.
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

## Finish (both)
- Log the design decisions in `docs/DECISIONS.md`.
- Add to `docs/DOCS_INDEX.md`. Suggest `/make-workplan` (new) or add tasks to the plan (CR).

## Rules
- Describe the **destination**, not the journey (methodology R6).
- Trade-offs section names what was rejected and why.
- Ship no architecture without a **file-system layout** and an **external-library table** (R10).
- **One tool per job** — no two libraries with overlapping functionality (R10).

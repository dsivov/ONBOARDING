---
name: write-architecture
description: Write an ARCHITECTURE doc (HTML) for a system, or a CHANGE_REQUEST (Markdown) for a scoped change on top of an existing one. Use when the user asks for "the architecture", "how it's built", or "a change request / CR".
---

# write-architecture — design (Stage 4)

Two modes. Pick by what the user needs.

## Mode A — ARCHITECTURE (new system)
Produce `docs/<NAME>_ARCHITECTURE.html` from `templates/ARCHITECTURE.template.html`.
- Sections: **guiding principle** · **components** (map SVG + responsibility table) ·
  **data model** (SVG) · **key flows** (SVG) · **boundaries/ownership** · **trade-offs**.
- Every section gets a colorful **SVG** using house tokens; link `assets/house.css`.
- State one guiding principle everything derives from; give each component an owner and
  its entry-point files.

## Mode B — CHANGE_REQUEST (change to an existing system)
Produce `docs/<NAME>_CHANGE_REQUEST.md` from `templates/CHANGE_REQUEST.template.md`.
- Reference the architecture section(s) it touches.
- **Mermaid before→after** diagram; scope (changed vs explicitly-unchanged); impact/risk
  table; backward-compat + rollback; acceptance criteria (test gate); tasks.

## Finish (both)
- Log the design decisions in `docs/DECISIONS.md`.
- Add to `docs/DOCS_INDEX.md`. Suggest `/make-workplan` (new) or add tasks to the plan (CR).

## Rules
- Describe the **destination**, not the journey (methodology R6).
- Trade-offs section names what was rejected and why.

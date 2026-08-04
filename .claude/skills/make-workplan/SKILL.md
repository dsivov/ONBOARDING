---
name: make-workplan
description: Turn a DRP + architecture into a WORK PLAN (Markdown) — phases → milestones → checkbox tasks, each milestone with an explicit test gate. Use when the user asks to "plan the build", "make the work plan", or "break this into milestones".
---

# make-workplan — the build plan (Stage 5)

Produce `docs/<NAME>_WORK_PLAN.md` from `ONBOARDING/templates/WORK_PLAN.template.md`.

## Build it from the DRP
1. Read the DRP's requirements + acceptance criteria and the architecture's components.
2. Group work into **phases** (`P0` foundations/contracts first, then thin-vertical, then
   engine, then surface/UI). Assign **milestones** (`M1…`) to the phases that ship a
   demonstrable slice.
3. For each phase: concrete **checkbox tasks** naming real files/paths, including the
   **test files**. Lift the DRP's acceptance criteria into each milestone's **test gate**.
4. Add the phase-overview table and a **mermaid** phase→gate flowchart.
5. Include the Definition of Done block and the progress-trace note.

## Rules
- Every milestone has an explicit, testable **gate** (methodology R3) — written now, not later.
- Tasks name files, not vague activities.
- Nothing is planned that isn't traceable to a DRP requirement; if new work appears later,
  add a task here first (methodology R1).

## Finish
- Add to `docs/DOCS_INDEX.md`. The checkboxes are the progress trace — keep them current.
- Suggest starting `P0` on a `feature/<name>` branch.

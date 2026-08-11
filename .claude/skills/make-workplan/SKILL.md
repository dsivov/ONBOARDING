---
name: make-workplan
description: Turn a DRP + architecture into a WORK PLAN (Markdown) — phases → milestones → checkbox tasks, each milestone with an explicit test gate. Use when the user asks to "plan the build", "make the work plan", or "break this into milestones".
---

# make-workplan — the build plan (Stage 5)

Produce `docs/<NAME>_WORK_PLAN.md` from `docs/templates/WORK_PLAN.template.md` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Build it from the DRP
1. Read the DRP's requirements + acceptance criteria and the architecture's components.
2. Group work into **phases** (`P0` foundations/contracts first, then thin-vertical, then
   engine, then surface/UI). Assign **milestones** (`M1…`) to the phases that ship a
   demonstrable slice.
3. For each phase: concrete **checkbox tasks** naming real files/paths, including the
   **test files**. Paths must match the DRP/architecture **layout tree** (R10) — if a task
   needs a path the layout doesn't have, fix the layout, don't invent the path here.
   Lift the DRP's acceptance criteria into each milestone's **test gate**.
   `P0` includes the environment task: the dependency manifest (`environment.yml`,
   `pyproject.toml`, `requirements.txt`, `package.json`) pinned to the agreed libraries.
4. Add the phase-overview table and a **mermaid** phase→gate flowchart.
5. **Wire in the contract (R11):** link `CONSTRAINTS.md` in the header, and open every phase with
   a `- [ ] **Contract check (R11)**` task naming the constraint IDs (`A#`) that phase touches.
   That is the *written* trigger — the always-loaded file makes the contract available; this task
   is what makes checking it happen at a fixed point rather than when someone remembers.
   A phase whose tasks can't be traced to constraints without contradicting one is a drift: raise
   it now, while it's still a plan and costs nothing.
6. **Mark each milestone's handoff (R12 · §8):** every milestone ends with a
   `**Handoff (§8):**` line — the developer sends `M<n> READY` (branch · sha · gate result) and
   **stops**; the manager reviews and replies `FINDINGS M<n>` or `PROCEED`. Write it whether or not
   two sessions are running today: single-session, it's the same review with no message, and the
   plan shouldn't have to be rewritten to switch modes. The plan is also the developer's whole
   brief, so a task it can't act on without asking is a task that isn't finished — resolve the
   ambiguity here (R9), not over a `BLOCKED` signal later.
7. Include the Definition of Done block and the progress-trace note.

## Rules
- Every milestone has an explicit, testable **gate** (methodology R3) — written now, not later.
- Tasks name files, not vague activities.
- Nothing is planned that isn't traceable to a DRP requirement; if new work appears later,
  add a task here first (methodology R1).
- **No dependency arrives off-plan.** A library not in the DRP's table gets added there
  first, with its justification against what's already installed (methodology R10).
- **Nothing is planned that breaks `CONSTRAINTS.md`** (R11). If the plan needs it, the contract
  gets amended with the human's approval *before* the task is written — never after.

## Finish
- Add to `docs/DOCS_INDEX.md`. The checkboxes are the progress trace — keep them current.
- Suggest starting `P0` on a `feature/<name>` branch.

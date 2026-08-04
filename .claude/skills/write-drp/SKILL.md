---
name: write-drp
description: Write a DRP (Detailed Requirements & Plan, Markdown) — the detailed what/why that the RFC summarizes and the work plan builds from. Use when the user asks for "requirements", "the DRP", "the detailed plan", or "acceptance criteria".
---

# write-drp — detailed requirements & plan (Stage 3)

Produce `docs/<NAME>_DRP.md` from `docs/templates/DRP.template.md` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Gather
- The problem, the outcome that means "done", and explicit **non-goals**.
- Requirements (must/should/could) with rationale.
- Constraints & assumptions (flag unverified assumptions).
- **Acceptance criteria** — observable and testable (these become milestone gates).
- Data shapes and interfaces/endpoints.

## Write
1. Copy the template; fill every `{{PLACEHOLDER}}`; link the BLOG + RFC as sources.
2. **Illustrate with mermaid** (markdown house rule): a context `flowchart`, a data
   `classDiagram`, and the phase-summary `flowchart`.
3. Make acceptance criteria checkbox items — the work plan lifts them as test gates.
4. Any performance/accuracy criterion must name how it will be **measured** (methodology R2).

## Finish
- Add to `docs/DOCS_INDEX.md`. Suggest `/make-workplan` next.

## Rules
- Non-goals are mandatory — they prevent scope creep.
- Requirements are testable statements, not aspirations.

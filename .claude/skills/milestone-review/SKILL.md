---
name: milestone-review
description: Run a milestone code review and update the progress trace — produce a CODE_REVIEW (Markdown) and/or a CHECKPOINT review, verify the test gate, and advance the plan. Use at the end of a milestone, or when the user asks to "review this milestone", "code review", or "checkpoint".
---

# milestone-review — review & advance (Stage 6/7)

Run at the end of each milestone before starting the next.

## 1 · Verify the gate
- Run the milestone's **test gate** from the work plan. If it doesn't pass, the milestone
  isn't done — report what's failing; don't proceed.

## 2 · Code review → `docs/<NAME>_CODE_REVIEW.md`
From `ONBOARDING/templates/CODE_REVIEW.template.md`. Review the milestone's diff:
- Findings grouped by severity with stable IDs: **C**ritical / **H**igh / **M**edium / **S**ecurity.
- Each finding: where (`file:line`), the concrete failure, the fix.
- **Verify before reporting** — try to disprove each finding; drop plausible-but-wrong ones.
  Prefer confirmed issues over a long speculative list.
- List **non-issues confirmed** so they aren't re-flagged next time.
- Include the mermaid severity summary.

## 3 · Checkpoint (periodic) → `docs/PROJECT_REVIEW_<date>.md`
From `templates/CHECKPOINT_REVIEW.template.md`. Carry forward open findings, mark
`✅ FIXED`, give the recommended next sequence, and a phase-status mermaid.

## 4 · Advance the trace
- Check off completed tasks in the work plan; mark the milestone done.
- Log any decisions in `DECISIONS.md`; update `DOCS_INDEX.md`.
- Critical/High must be fixed (or explicitly deferred as a logged open finding) before the
  next milestone starts (methodology R4). Don't merge to main unverified (R5).

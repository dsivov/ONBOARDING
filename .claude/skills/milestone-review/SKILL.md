---
name: milestone-review
description: Run a milestone code review and update the progress trace — produce a CODE_REVIEW (Markdown) and/or a CHECKPOINT review, verify the test gate, and advance the plan. Use at the end of a milestone, or when the user asks to "review this milestone", "code review", or "checkpoint".
---

# milestone-review — review & advance (Stage 6/7)

Run at the end of each milestone before starting the next.

## Entry: the human, or an `M<n> READY` signal
Two ways in, same review either way:
- **Solo / the human asks** — the normal case.
- **A developer session signalled `M<n> READY`** (methodology R12 · §8). You are the manager; the
  developer is now **idle and waiting on you**, so don't leave it hanging. Its message names the
  branch, the commit and the gate result — verify those yourself rather than taking them on trust
  (§1), review that commit range, and finish by **replying over `SendMessage`**:
  - findings → `FINDINGS M<n>` · the Critical/High IDs and the order to fix them in · the path to
    the `CODE_REVIEW`. The developer fixes, re-runs the gate, and signals `M<n> READY` again.
  - clean → `PROCEED` · the next milestone and its first tasks.
  Fix the code yourself only if the developer is gone; while it's alive, **findings go back as
  findings** — two sessions editing one working tree loses more time than it saves.

Anything the developer surfaced mid-milestone (`BLOCKED`, `DRIFT A<n>`, `PLAN GAP`) is not a review
matter — those get answered when they arrive, not batched to here.

## Reuse first
Don't hand-roll a review Claude Code already does rigorously. Reuse the finding engine, keep
the house format (C/H/M/S IDs, the drift check, the checkpoint carry-forward):
- **`/code-review`** on the milestone's working diff — its findings become the C/H/M entries.
- **`/security-review`** — its output feeds the **Security (S)** section directly.
- **`simplify`** for the quality pass (reuse, dead code, altitude). It fixes rather than
  reports, so run it *after* the gate passes and review its diff like any other change.

These find issues; this skill decides severity, verifies before reporting, and advances the
trace. A finding you can't reproduce still gets dropped (§2), whoever surfaced it.

## 1 · Verify the gate
- Run the milestone's **test gate** from the work plan. If it doesn't pass, the milestone
  isn't done — report what's failing; don't proceed.

## 2 · Code review → `docs/<NAME>_CODE_REVIEW.md`
From `docs/templates/CODE_REVIEW.template.md` (copied into the project by new-project; fall back to the ONBOARDING repo if absent). Review the milestone's diff:
- Findings grouped by severity with stable IDs: **C**ritical / **H**igh / **M**edium / **S**ecurity.
- Each finding: where (`file:line`), the concrete failure, the fix.
- **Verify before reporting** — try to disprove each finding; drop plausible-but-wrong ones.
  Prefer confirmed issues over a long speculative list.
- List **non-issues confirmed** so they aren't re-flagged next time.
- Include the mermaid severity summary.
- **Check the contract** (methodology R11): walk `docs/CONSTRAINTS.md` against the milestone's
  diff and give **every** constraint a verdict — `held` / `drifted` / `n/a` — with evidence.
  This is the backstop for the tripwires: if one was missed mid-build, this is where it surfaces,
  at the last cheap moment. **Drift that shipped without being reported is a Critical finding**
  regardless of whether the code is good — the failure is the silence, not the design. Drift that
  *was* reported and approved must show its amendment row and `D-NN`. Also flag constraints that
  have gone **stale** (still enforced, no longer describe the design) — those get amended, not
  worked around.
- **Check layout, dependency & integration drift** (methodology R10): does the code sit where the
  architecture/DRP layout says it does, and does the manifest match the declared library
  table? Flag any dependency added off-plan, and any **new library that duplicates one
  already used** (two HTTP clients, two ORMs, two config loaders) — that's a High finding.
  Also flag any **new outbound call** that isn't in the design's outbound table, or is there
  without a timeout, retry budget, breaker and terminal state — an unbounded call is a High
  finding on its own. And any **public contract change** (endpoint, schema, event, file format):
  additive? versioned? deprecation window stated? Either the doc is updated to match reality, or
  the code moves; drift is never left silent.
- **Check requirement & NFR coverage** (R3 · R13): the gate is only meaningful if it proves
  something named. For each gate assertion, record what it proves (`F#` / `NFR-*`), whether it
  actually ran, and the result. Two questions that are easy to skip and expensive to skip:
  *did this milestone claim a requirement it didn't prove?* and *was an NFR target measured and
  missed?* A performance target with a number and no measurement this milestone is not "passing"
  — it is unverified, and it is a finding.
- **Check reversibility** (§3, merge condition 5): how is this undone? If the diff contains a
  schema change, is it expand-then-contract, and is the `drop` held back to a **separate later**
  PR? A migration merging alongside the code that depends on it is a High finding — code reverts
  in seconds and data does not.

## 3 · Checkpoint (periodic) → `docs/PROJECT_REVIEW_<date>.md`
From `docs/templates/CHECKPOINT_REVIEW.template.md`. Carry forward open findings, mark
`✅ FIXED`, give the recommended next sequence, and a phase-status mermaid. Include the
**contract standing** section (R11): amendments since the last checkpoint, constraints gone
stale, and where the contract keeps getting argued with — sustained pressure on one constraint
usually means the design is wrong, and that's a finding worth raising to the human.

## 4 · Advance the trace
- Check off completed tasks in the work plan; mark the milestone done. In §8 mode the
  `M<n> READY` signal carries `done:` / `not done:` **task ids** — tick from those rather than
  reconstructing what landed from the git log, and treat a `not done:` id as a finding to place
  (moved to a later phase, or dropped with a `D-NN`).
- **Update the requirement-coverage table** in the work plan: mark the requirements this
  milestone proved. At the last milestone, any row still unmapped is a shipped-unverified
  requirement — raise it to the human rather than closing the plan over it.
- Log any decisions in `DECISIONS.md`; update `DOCS_INDEX.md`.
- **Open the next milestone with its contract check** (R11) — re-read `CONSTRAINTS.md` and name
  the constraints the upcoming phase touches before its first task starts.
- Critical/High must be fixed (or explicitly deferred as a logged open finding) before the
  next milestone starts (methodology R4). Don't merge to main unverified (R5).
- **If a developer session is waiting, reply now** (R12 · §8) — `FINDINGS M<n>` or `PROCEED`. The
  trace is only updated on this side: the developer never edits `docs/`, so the checkboxes,
  `DECISIONS.md` and `DOCS_INDEX.md` are yours to move.

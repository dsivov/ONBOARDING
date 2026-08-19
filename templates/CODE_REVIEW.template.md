<!-- TEMPLATE: CODE REVIEW. Stage 6 — run at the end of each milestone against its diff.
     Findings grouped by severity with stable IDs (C#/H#/M#/S#). Markdown; a mermaid
     severity summary helps at a glance. Verify before reporting; kill plausible-but-wrong. -->

# {{NAME}} — Code Review ({{milestone e.g. M1}}, {{YYYY-MM-DD}})

- **Scope:** {{branch / commit range / files reviewed}}
- **Reviewer:** {{name / agent}}  ·  **Result:** {{blocked | changes-requested | approved}}

## Summary

```mermaid
pie showData
  title Findings by severity
  "Critical" : {{n}}
  "High" : {{n}}
  "Medium" : {{n}}
  "Security" : {{n}}
```

{{One paragraph: overall health, and the gating verdict — what must be fixed before the next milestone.}}

## Critical
> Ship-blockers: wrong results, crashes, data loss.

### C1 — {{one-line claim}}
- **Where:** `{{file}}:{{line}}`
- **Failure:** {{concrete inputs/state → wrong output/crash}}
- **Fix:** {{the change}}

## High
> Serious but not ship-blocking.

### H1 — {{one-line claim}}
- **Where:** `{{file}}:{{line}}`  ·  **Failure:** {{…}}  ·  **Fix:** {{…}}

## Medium
> Correctness/robustness worth fixing soon.

### M1 — {{one-line claim}}
- **Where:** `{{file}}:{{line}}`  ·  **Note:** {{…}}

## Security
> Isolation, secrets, injection, timing, disclosure.

### S1 — {{one-line claim}}
- **Where:** `{{file}}:{{line}}`  ·  **Risk:** {{…}}  ·  **Fix:** {{…}}

## Contract check (methodology R11)
> Walk `CONSTRAINTS.md` against this milestone's diff. Every constraint gets a verdict — a
> silent omission reads as "held". An unreported drift is a **Critical** finding on its own.

| ID | Verdict | Evidence |
|----|---------|----------|
| {{A1}} | {{held \| drifted \| n/a}} | {{`file:line` — what the diff does}} |
| {{A2}} | {{held}} | {{…}} |

- **Any drift reported to the human before it landed?** {{yes — D-NN \| no → C# finding}}
- **Contract amended this milestone?** {{no \| yes → v{{n}}, amendment row + `D-NN` logged}}
- **Non-goals still respected?** {{yes \| no — {{which}}}}

## Layout, dependency & integration drift (methodology R10)
- **Layout matches the doc?** {{yes | no — `{{path}}` isn't in the architecture layout}}
- **Manifest matches the declared library table?** {{yes | no — `{{lib}}` added off-plan}}
- **Any duplicate functionality introduced?** {{none | `{{lib_a}}` overlaps `{{lib_b}}` — one must go}}
- **New outbound call?** {{none | `{{dep}}` — timeout {{n}} ms, retry {{n}}×, breaker {{…}},
  terminal state {{…}} — and it's in the design's outbound table \| **it isn't → H# finding**}}
- **Public contract changed?** {{no | yes — additive? versioned? deprecation window stated?}}
- Resolution: {{update the doc, or move the code — never leave the drift silent}}

## Requirement & NFR coverage (methodology R3 · R13)
> The gate is only meaningful if it proves something named.

| Gate assertion | Proves | Ran? | Result |
|----------------|--------|------|--------|
| {{test / harness}} | {{F3}} | {{yes}} | {{34 passed}} |
| {{`scripts/bench_…/`}} | {{NFR-latency}} | {{yes}} | {{p99 = {{n}} ms vs target {{n}} ms}} |

- **Any requirement this milestone claimed and didn't prove?** {{none | {{F#}} → finding}}
- **Any NFR target measured and missed?** {{none | {{which, by how much}} → C#/H#}}
- **Any measured claim without a harness in `scripts/`?** {{none | {{which}} — R2}}

## Reversibility (methodology §3, merge condition 5)
- **How is this undone?** {{plain revert | flag off | {{…}}}}
- **Schema change in this diff?** {{none | yes — expand-then-contract? Is the `drop` in a
  *separate later* PR? Does a migration merge together with the code that depends on it?}}
- **Anything that can't be un-deployed** (published event shape, outbound webhook, API field)?
  {{none | {{which}} — additive-only or flagged off?}}

## Non-issues confirmed (checked, clean)
- {{thing that looked suspicious but is correct — say why, so it isn't re-flagged}}

## Progress trace (methodology §6 · §8)
- **Work-plan tasks completed this milestone:** {{P2.1, P2.2, P2.4}} — ticked in
  `{{NAME}}_WORK_PLAN.md` {{by the manager, from the `M<n> READY` signal}}.
- **Plan tasks not done:** {{P2.3 — why, and where it moved to}}.

## Verdict
- [ ] All **Critical** fixed → milestone gate can pass.
- [ ] **High** fixed or logged as open findings in the next checkpoint.
- [ ] Layout, dependencies & integrations match the design docs (or the docs were updated).
- [ ] **Every constraint in `CONSTRAINTS.md` still holds** (or was amended with approval).
- [ ] Every requirement this gate claims to prove was actually asserted (R3), and every NFR
      target it claims was actually **measured** (R13).
- [ ] The change is **reversible**, and the PR says how (§3, condition 5).
- [ ] Work-plan checkboxes updated — the trace matches reality.
- Decisions arising: log in `DECISIONS.md`.

<!-- TEMPLATE: CHECKPOINT / PROJECT REVIEW. Periodic project-level health check (not per-milestone).
     Tracks open findings across reviews with ✅ FIXED annotations. File: PROJECT_REVIEW_<date>.md. -->

# {{PROJECT}} — Checkpoint Review ({{YYYY-MM-DD}})

- **Since:** {{last checkpoint / milestone}}  ·  **Branch:** `feature/{{name}}`
- **Contract:** `CONSTRAINTS.md` {{v1}} — {{in force, unamended | amended {{n}}× since the last checkpoint}}

## Where the project is

```mermaid
flowchart LR
  P0[P0 ✅] --> P1[P1 ✅ · M1] --> P2[P2 ⧗ · M2] --> P3[P3 ▫ · M3]
  classDef done fill:#12302a,stroke:#3ecf8e,color:#e7ebf3;
  classDef wip fill:#2a2114,stroke:#f0a73c,color:#ffce86;
  classDef todo fill:#1b1f2a,stroke:#2c3346,color:#7b8499;
  class P0,P1 done; class P2 wip; class P3 todo;
```

{{One paragraph: momentum, what shipped, what's blocked.}}

## Contract standing (methodology R11)
> The project-level version of the milestone check: is the system we're building still the one
> that was agreed — and is the contract still describing the system honestly?

- **Constraints violated by shipped code:** {{none | {{A#}} — {{where}} → P0 finding}}
- **Amendments since the last checkpoint:** {{none | {{A#}} v{{n}} ({{D-NN}}) — {{one line}}}}
- **Constraints now stale** (true when written, no longer describes the design): {{none | {{A#}} — amend or retire}}
- **Drift pressure** — where the contract keeps getting argued with: {{…}}. {{Repeated pressure on
  one constraint is a signal the design is wrong, not that the team is careless — raise it.}}

## Requirement & NFR coverage (methodology R3 · R13)
> The question no other artifact asks: **which requirements still have no gate?** Walk the work
> plan's coverage table. An orphan found here is cheap; found at the last milestone it is a
> shipped-unverified requirement.

| | Count | Detail |
|---|:---:|---|
| Requirements proven by a passed gate | {{n}} | {{F1, F2, F3…}} |
| Requirements with a gate not yet run | {{n}} | {{F5 → M3}} |
| **Requirements with no gate at all** | {{n}} | {{F7 — deliberately deferred ({{D-NN}}) \| ⚠️ unplanned}} |
| **NFR targets measured** | {{n}} | {{NFR-latency: p99 {{n}} ms vs target {{n}} ms}} |
| **NFR targets still unmeasured** | {{n}} | {{NFR-throughput — no harness yet → P{{n}} finding}} |

## Reversibility & operability standing (methodology §3, condition 5)
- **Irreversible changes merged since the last checkpoint:** {{none | {{which, and whether the
  expand-then-contract `drop` step is still outstanding}}}}
- **Feature flags still open** (and the task that removes each): {{none | {{flag → task}}}}
- **Rollback rehearsed?** {{yes, {{date}} — took {{n}} min vs RTO target {{n}} | never — finding}}

## What was fixed in this pass
- {{finding → resolution}}  ✅

## Open findings — prioritized
> Carry forward from milestone code reviews + new observations. Annotate `✅ FIXED` as they close.

### P0 — {{must fix before {{gate/deploy}}}}
- {{finding}}  ·  owner: {{…}}  ·  {{status}}

### P1 — {{soon}}
- {{finding}}  ✅ FIXED ({{date}})

### P2 — {{nice to have}}
- {{finding}}

## Recommended sequence (next steps)
1. {{…}}
2. {{…}}

## Non-issues confirmed (checked, clean)
- {{…}}

## Metrics / evidence (if any)
| Metric | Before | Now | Harness |
|--------|:------:|:---:|---------|
| {{…}} | {{…}} | {{…}} | `scripts/{{…}}` |

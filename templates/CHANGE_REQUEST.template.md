<!-- TEMPLATE: CHANGE REQUEST. Stage 4b. A scoped change on top of an EXISTING architecture.
     Reference the architecture section(s) it touches. Markdown; illustrate with mermaid. -->

# {{NAME}} — Change Request (CR-{{NNN}})

- **Project:** {{PROJECT}}  ·  **Date:** {{YYYY-MM-DD}}  ·  **Status:** {{proposed | approved | done}}
- **Affects:** [{{SYSTEM}}_ARCHITECTURE.html]({{SYSTEM}}_ARCHITECTURE.html) §{{section}}
- **Requested by:** {{name}}

## 1 · What & why

{{One paragraph: the change and the reason. What breaks or is missing without it?}}

## 2 · Before → after

```mermaid
flowchart LR
  subgraph Before
    A1[{{current}}] --> A2[{{current}}]
  end
  subgraph After
    B1[{{new}}]:::new --> B2[{{current}}]
  end
  classDef new fill:#231b3a,stroke:#a974f0,color:#e7ebf3;
```

{{What specifically changes — components, data, contracts.}}

## 3 · Scope

**Changes**
- {{file / component}} — {{what changes}}

**Unchanged (explicitly)**
- {{what this CR does NOT touch}}

## 4 · Layout & dependency delta

<!-- Mandatory (methodology R10). "None" is a valid answer — say it explicitly. -->

**Files / directories**

| Path | Added / moved / deleted | Owns |
|------|-------------------------|------|
| `{{path}}` | {{added}} | {{…}} |

**Dependencies**

| Library | Version | New / reused | Why nothing already installed covers it |
|---------|---------|:------------:|------------------------------------------|
| {{lib}} | {{x.y}} | new | {{…}} |

{{Reuse first: existing modules, libraries, databases and integrations stay the one tool for
their job. If this CR replaces an incumbent, name it here and add the removal task in §7.}}

**Integrations touched** <!-- R10. "None" is a valid answer — say it. -->

| Direction | Contract / dependency | What changes | Timeout · retry · breaker · terminal state |
|-----------|----------------------|--------------|--------------------------------------------|
| {{inbound}} | `{{POST /v1/…}}` | {{additive field}} | {{n/a — version policy: additive-only}} |
| {{outbound}} | {{service}} | {{new call}} | {{800 ms · 3× jitter · 50%/20 · falls back to {{…}}}} |

**Cross-cutting touched** <!-- R10. Only the rows this CR changes. -->

| Concern | Change |
|---------|--------|
| {{authZ / secrets / observability / data classification / retention / cost}} | {{…}} |

## 5 · Impact & risk

| Area | Impact | Risk | Mitigation |
|------|--------|:----:|------------|
| {{data / API / perf / migration}} | {{…}} | {{low/med/high}} | {{…}} |

- **Backward compatibility:** {{yes / no — migration note}}
- **NFR impact:** {{none | {{which NFR-* target this moves, and by how much — remeasure with
  its harness before merge (R13)}}}}
- **Reversibility** (methodology §3, condition 5): {{plain revert | flag off | {{…}}}}
  - **Schema change?** {{none | expand-then-contract — this CR does {{add + backfill + switch
    reads}}; the `drop` is task §7.{{n}}, a **separate later PR**}}
  - **Anything that can't be un-deployed?** {{none | {{which}} — additive-only or flagged off}}

## 6 · Acceptance criteria (test gate)

Each cites the requirement it proves (R3):

- [ ] {{observable, testable}} — proves **{{F#}}**
- [ ] {{regression: existing behavior still holds}}
- [ ] {{measured claim + harness, if applicable}} — proves **{{NFR-*}}**

## 7 · Tasks

- [ ] `{{path}}` — {{…}}
- [ ] `test_{{…}}.py` — {{…}}

**Review:** on completion, code review of the CR diff; log the decision in `DECISIONS.md`.

<!-- TEMPLATE: DRP — Detailed Requirements & Plan. Stage 3. The "what/why" the RFC summarizes
     and the work plan builds from. Markdown; illustrate with mermaid. Replace {{PLACEHOLDERS}}.

     NOT A PRD. This is the *engineering* requirements spec — an SRS for the requirements half
     plus design detail for the rest: it carries the file-system layout, the pinned library
     table, the integrations with their timeout/retry/breaker policies, and the cross-cutting
     concerns (R10). Engineering owns it, and the same people write the RFC — which is why the
     two are co-authored. A PRD (problem, personas, user stories, success metrics, release
     criteria) is product-owned and sits UPSTREAM as an input; it is never co-authored with the
     RFC. Methodology §1. -->

# {{NAME}} — Detailed Requirements & Plan (DRP)

- **Project:** {{PROJECT}}
- **Status:** {{draft | review | accepted}}
- **Date:** {{YYYY-MM-DD}}
- **Owner:** {{name}}
- **Sources:** [BLOG_{{TOPIC}}.html](BLOG_{{TOPIC}}.html) · [{{NAME}}_RFC.html]({{NAME}}_RFC.html)

## 1 · Problem & goal

{{One paragraph: the problem this solves and the outcome that means "done".}}

**In scope**
- {{…}}

**Out of scope (non-goals)**
- {{…}}  ← be explicit; non-goals prevent scope creep.

## 2 · Context

```mermaid
flowchart LR
  U[{{actor}}] -->|{{action}}| S[{{system}}]
  S -->|{{reads/writes}}| D[({{data / external}})]
  S -->|{{output}}| R[{{result}}]
  classDef a fill:#1b2740,stroke:#5b8def,color:#e7ebf3;
  classDef b fill:#12302a,stroke:#19b89a,color:#e7ebf3;
  class U,R a; class S,D b;
```

{{What exists today, what it touches, and where this fits.}}

## 3 · Functional requirements

<!-- IDs are F1…Fn. Later artifacts cite them: acceptance criteria, work-plan gates, reviews
     (methodology R3). Keep each one testable — if no test could fail it, it isn't a requirement. -->

| # | Requirement | Priority | Rationale |
|---|-------------|:--------:|-----------|
| F1 | {{must do …}} | must | {{why}} |
| F2 | {{should do …}} | should | {{why}} |
| F3 | {{could do …}} | could | {{why}} |

## 4 · Non-functional requirements

<!-- Mandatory (methodology R13). A quality attribute with no number is not a requirement.
     No blanks: an attribute that doesn't apply is written "n/a — because …", not omitted.
     Every NFR with a number gets a milestone gate. Numbers are ASKED (R9), never invented. -->

| ID | Attribute | Target (a number + a percentile) | Measured by | Gate |
|----|-----------|----------------------------------|-------------|------|
| NFR-latency | Latency | {{p99 ≤ 800 ms at peak}} | {{`scripts/bench_{{…}}/` — p99 of {{op}} at {{n}}/s for 10 min}} | {{M4}} |
| NFR-throughput | Throughput | {{240 writes/s peak; 24k reads/s}} | {{same harness, sustained, no queue growth}} | {{M4}} |
| NFR-availability | Availability | {{99.9% monthly}} | {{synthetic probe, 1/min, on {{path}}}} | {{— ops, not a gate}} |
| NFR-durability | Durability | {{RPO 0 · RTO 5 min}} | {{rehearsed failover, timed}} | {{M3}} |
| NFR-consistency | Consistency | {{confirmation ≤ 10 s p95}} | {{timestamp delta, {{a}} → {{b}}}} | {{M2}} |
| NFR-security | Security & privacy | {{no {{regulated field}} at rest, ever}} | {{static scan + schema assertion in CI}} | {{M1}} |
| NFR-observability | Observability | {{100% of the hot path traced}} | {{trace sampling check on {{span}}}} | {{M2}} |
| NFR-operability | Operability | {{zero-downtime deploy; rollback ≤ {{n}} min}} | {{rehearsed in staging}} | {{M3}} |
| NFR-cost | Cost | {{≤ ${{n}}/mo at peak}} | {{monthly bill, tagged by service}} | {{— reviewed monthly}} |

**Unanswered numbers** — anything above still `{{…}}` is an open question, not a default.
List it in §8 and ask (R9) before this DRP is accepted.

## 5 · Constraints & assumptions

- **Constraint:** {{tech / compliance / deployment target / budget / team …}}
- **Assumption:** {{what we take as given — flag if unverified, and say what changes if it flips}}

Anything here that a **diff could make false** is promoted to `CONSTRAINTS.md` (R11); the rest
stays in this document.

## 6 · Acceptance criteria

The feature is accepted when **all** of these hold. Each cites the requirement it proves, and
each becomes a milestone test gate (R3):

- [ ] {{observable, testable criterion}} — proves **F1**
- [ ] {{observable, testable criterion}} — proves **F3**
- [ ] {{a measured claim + its harness, per R2}} — proves **NFR-latency**

**Coverage check:** every `F#` and every numbered `NFR-*` above appears in at least one line
here. An orphan requirement is a gap in the plan, not an oversight.

## 7 · Data & interfaces

```mermaid
classDiagram
  class {{Entity1}} {
    +{{field}}: {{type}}
    +{{field}}: {{type}}
  }
  class {{Entity2}} {
    +{{field}}: {{type}}
  }
  {{Entity1}} --> {{Entity2}} : {{relation}}
```

**Interfaces / endpoints**
- `{{METHOD}} {{/path}}` — {{purpose}} → {{shape}}

## 8 · Code layout & dependencies

<!-- Mandatory (methodology R10). Mark what already exists vs what this plan adds. -->

**Dependency manager:** {{conda (default) | uv | poetry | pip+venv | npm/pnpm | …}} — manifest
`{{environment.yml | pyproject.toml | requirements.txt | package.json}}`.
<!-- Python? This was ASKED, not assumed — record the answer in DECISIONS.md. -->

**File-system layout**

```
{{project}}/
├── {{src_or_pkg}}/
│   ├── {{module_a}}/        # {{what it owns}}            [new]
│   └── {{module_b}}.py      # {{what it owns}}            [exists]
├── tests/
│   └── test_{{…}}.py        # {{gate for M{{n}}}}          [new]
├── scripts/                 # measurement harnesses (R2)  [exists]
└── {{manifest}}             # {{pinned deps}}
```

**External libraries**

| Library | Version | Purpose | Reused / New | Why this over the alternative |
|---------|---------|---------|:------------:|-------------------------------|
| {{lib}} | {{x.y}} | {{…}} | reused | already in the repo — no second tool for this job |
| {{lib}} | {{x.y}} | {{…}} | new | {{alternative rejected because …}} |

**Existing code we build on** <!-- delete if greenfield -->

| What's already there | Where | How this plan reuses it |
|----------------------|-------|-------------------------|
| {{layout / module}} | `{{path}}` | {{extended, not replaced}} |
| {{library actually imported}} | `{{manifest}}` | {{kept as the one tool for {{job}}}} |
| {{database / integration}} | {{host / service}} | {{reused — no new store introduced}} |

{{If anything here is being **replaced**: say which incumbent, why, and the work-plan task
that removes it. Leaving both in place is not an option (R10).}}

## 9 · Integrations — inbound & outbound

<!-- Mandatory (methodology R10). "None" is a valid answer to either table — say it explicitly. -->

**Inbound — contracts we expose.** The most expensive thing in the system to change, because we
don't control who depends on it.

| Contract | Style | Consumed by | Version & compatibility | Auth | Idempotency | Limits & errors |
|----------|-------|-------------|-------------------------|------|-------------|-----------------|
| `{{POST /v1/…}}` | {{REST/JSON}} | {{who}} | {{`/v1`, additive-only, {{n}}-month deprecation}} | {{OIDC bearer}} | {{`Idempotency-Key`, unique per {{scope}}}} | {{429 + Retry-After · one error shape}} |

**Outbound — services we call.** One row per dependency; a global "we'll add retries" is not an
answer. The terminal state is where a request ends up when everything above it failed.

| Dependency | Their SLA / p99 | Timeout | Retry | Breaker | Fallback / terminal state |
|------------|-----------------|---------|-------|---------|---------------------------|
| {{provider}} | {{99.9% / 1.2 s}} | {{800 ms}} | {{3× exp+jitter}} | {{50% of 20}} | {{stays `PENDING`; poller retries; after {{n}} min → `CANCELLED` + notify}} |
| {{service}} | {{99.5%}} | {{300 ms}} | {{2×}} | {{50% of 20}} | {{degrade: {{what still works}}}} |

- **Retry budget:** {{attempts × timeout + backoff}} must fit inside {{the caller's own deadline}}
  — otherwise retries are a self-inflicted outage.
- **Non-idempotent calls** carry an idempotency key on the *provider's* side too, or they are not
  retried at all.
- **Sandbox / testability:** {{available → used in CI | none → contract-tested fake, and the real
  integration is its own milestone with its own gate}}.

## 10 · Cross-cutting concerns

<!-- Mandatory (methodology R10). One line each. Silence is not an answer; "n/a — because …" is. -->

| Concern | Decision |
|---------|----------|
| AuthN / AuthZ | {{where authentication happens; authorisation per resource or per route}} |
| Secrets | {{store, injection, rotation — never in the image or the repo}} |
| Observability | {{structured logs + correlation id propagated through {{HTTP and the broker}} · metrics · traces · the SLO and its error budget}} |
| Configuration | {{per-environment, validated at startup — fail fast, not at first use}} |
| Tenancy | {{single-tenant \| row-level \| schema-per-tenant — and where it's enforced}} |
| Data classification | {{which fields are personal/regulated → encryption, log redaction, residency}} |
| Retention & erasure | {{how long, and how a deletion request is satisfied}} |
| Audit trail | {{`updated_by` \| append-only audit table \| event sourcing — the cheapest that meets the obligation}} |
| Feature flags | {{what's behind one, and the task that removes it}} |
| Cost model | {{the monthly shape, and what dominates it}} |

## 11 · Risks & open questions

| Risk / question | Impact | Plan |
|-----------------|:------:|------|
| {{…}} | {{high/med}} | {{mitigation or who decides}} |
| {{an unanswered NFR number from §4}} | {{high}} | {{ask {{who}} — R9, with options}} |

## 12 · Plan summary

Phases and milestones live in [{{NAME}}_WORK_PLAN.md]({{NAME}}_WORK_PLAN.md). At a glance:

```mermaid
flowchart LR
  P0[P0 · foundations] --> P1[P1 · {{theme}} → M1] --> P2[P2 · {{theme}} → M2] --> P3[P3 · {{theme}} → M3]
  classDef p fill:#1b2740,stroke:#5b8def,color:#e7ebf3;
  class P0,P1,P2,P3 p;
```

<!-- TEMPLATE: CONSTRAINTS — the architecture contract. Created once, right after the RFC+DRP
     are agreed; extended by the ARCHITECTURE. This file is LOADED INTO CONTEXT EVERY SESSION
     (CLAUDE.md imports it), so it is hard-capped at ONE PAGE / ~15 constraints. It is a control
     file, not a doc artifact: no diagrams, no prose, no history — only sentences that a diff can
     make false. Everything else belongs in the RFC/DRP/ARCHITECTURE; the why-we-changed belongs
     in DECISIONS.md. Methodology R11. -->

# {{PROJECT}} — Architecture Contract

- **Version:** v1  ·  **Agreed:** {{YYYY-MM-DD}}  ·  **Status:** in force
- **Sources:** [{{NAME}}_RFC.html]({{NAME}}_RFC.html) · [{{NAME}}_DRP.md]({{NAME}}_DRP.md) · [{{NAME}}_ARCHITECTURE.html]({{NAME}}_ARCHITECTURE.html)

**Guiding principle:** {{one sentence — the thing every constraint below derives from}}

> **How to use this file (agent):** re-read it whenever a **tripwire** below fires. If a change
> would make any sentence here **false**, STOP — do not implement it. Report the drift to the
> human (constraint ID · what the contract says · what the change needs · why), offer
> *comply / amend / defer*, and wait. On approval, amend this file **first** (bump the version,
> add a row to the change log), then log a `D-NN` in `DECISIONS.md`, then build. Never drift
> silently. **Adding a new constraint that contradicts nothing is an extension, not a drift** —
> see the change log at the bottom for the difference.

## Constraints

> Each is one **falsifiable** sentence — you can point at a diff and say true or false.
> Max ~15. If it isn't worth stopping the build over, it isn't a constraint — it's a detail
> for the DRP.

| ID | Area | Constraint | Why |
|----|------|------------|-----|
| A1 | Shape | {{e.g. Exactly three deployables: `api`, `worker`, `web`. No fourth process.}} | {{…}} |
| A2 | Boundaries | {{e.g. `core/` imports nothing from `adapters/`; dependencies point inward only.}} | {{…}} |
| A3 | State | {{e.g. Postgres is the only durable store. No second database, no local disk state.}} | {{…}} |
| A4 | Data flow | {{e.g. All writes go through the service layer; no direct table access from handlers.}} | {{…}} |
| A5 | Interface | {{e.g. The public API is REST/JSON, versioned under `/v1`; contracts are additive-only.}} | {{…}} |
| A6 | Stack | {{e.g. Python 3.12 + conda; one HTTP client (`httpx`), one ORM (`SQLAlchemy`), one test runner (`pytest`).}} | {{…}} |
| A7 | Runtime | {{e.g. Stateless request handling; any cache is optional and the system is correct without it.}} | {{…}} |
| A8 | Trust | {{e.g. Single-tenant; auth happens at the edge; no service trusts another's identity claims.}} | {{…}} |
| A9 | Ops | {{e.g. Deploys to a single container host; no orchestrator, no cloud-managed queue.}} | {{…}} |

## Non-goals (deliberately not built)

- {{e.g. Multi-region. Real-time streaming. A plugin system. Mobile clients.}}
- Reaching for one of these is a drift, not a feature — same protocol as above.

## Tripwires — re-read this file when any of these is about to happen

- Adding, replacing, or removing an **external dependency**, service, or datastore.
- Creating a **top-level directory**, module, or deployable — or moving one.
- Crossing a **stated boundary** (a layer importing something the contract says it can't).
- Changing a **public contract**: API endpoint, schema, CLI, event, or file format.
- Introducing **state, concurrency, caching, or background work** where there was none.
- Changing the **auth / tenancy / trust** model, or the **deployment target**.
- Adding a second tool for a job something already does (methodology R10).
- Anything the **Non-goals** list names.
- {{project-specific tripwire}}

## Change log — extensions & amendments

> Two different acts, one table, told apart by the **kind** column. The test is mechanical:
> **did a sentence that was true become false?**
>
> - **`ext`** — a *new* constraint ID is added; nothing already in force changed. This is the
>   normal work of the ARCHITECTURE stage: the RFC/DRP agreed a shape, the design commits to
>   specifics it couldn't state yet. Just add it at the artifact's closing checkpoint and bump
>   the version. **No drift report — nothing became false.**
> - **`amend`** — an *existing* sentence's meaning changes, or a constraint is retired. This
>   requires the **full drift protocol**: stop, report (ID · what the contract says · what the
>   change needs · why), human decides *comply / amend / defer*. On approval: edit above
>   **first**, add the row here, log a `D-NN`, then build. Never as a side effect of a commit.
>
> The constraint text above is always edited in place and always present-tense; this table is
> the audit trail.

| Date | v | Kind | Constraint | What changed | Approved by | Decision |
|------|---|------|------------|--------------|-------------|----------|
| {{YYYY-MM-DD}} | v2 | `ext` | {{A11}} | {{added: the architecture commits to one HTTP client (`httpx`)}} | {{— architecture stage}} | {{—}} |
| {{YYYY-MM-DD}} | v3 | `amend` | {{A3}} | {{was: single Postgres → now: Postgres + Redis for ephemeral queue}} | {{human}} | {{D-014}} |

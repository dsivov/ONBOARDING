---
name: write-drp
description: Write a DRP (Detailed Requirements & Plan, Markdown) — the detailed what/why that the RFC summarizes and the work plan builds from. Use when the user asks for "requirements", "the DRP", "the detailed plan", or "acceptance criteria".
---

# write-drp — detailed requirements & plan (Stage 3)

Produce `docs/<NAME>_DRP.md` from `docs/templates/DRP.template.md` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

**A DRP is not a PRD.** It is the *engineering* requirements spec — an SRS for the requirements
half plus design detail for the rest, carrying the layout, the pinned libraries, the integrations
with their failure policies and the cross-cutting concerns (R10). Engineering owns it, and the
same people write the RFC — which is why the two are co-authored. If the user says "PRD" and means
personas, user stories, success metrics and release criteria, that is a **different, product-owned
document that sits upstream as an input** to the RFC, never beside it. Say so rather than writing
one document that tries to be both.

## Reuse first
Reuse the capability, keep the house format (template, section order, mermaid house rule):
- **Existing code?** Run the **`Explore`** agent for the R10 inventory below — read-only
  fan-out that returns the conclusion, so a large repo doesn't eat the context the
  requirements need. "medium" breadth, or "very thorough" on an unfamiliar codebase.
- If the RFC already inventoried the repo, **read its layout/dependency section instead of
  re-running Explore** — the DRP details that agreement, it doesn't re-litigate it (R7).
- No diagramming skill here: a DRP illustrates with **mermaid**, which renders natively.
  (`artifact-diagramming` and `dataviz` are for the HTML artifacts — BLOG, RFC, ARCHITECTURE.)

## Gather
- The problem, the outcome that means "done", and explicit **non-goals**.
- **Functional requirements** `F1…Fn` (must/should/could) with rationale — testable statements.
- **Non-functional requirements** (methodology R13) — the table is mandatory and has no blanks:
  latency (with the percentile) · throughput (peak, not average) · availability · durability
  (RPO/RTO) · consistency (how eventual, in seconds) · security & privacy · observability ·
  operability · cost. Each gets a **number**, a **measurement method**, and the **milestone
  gate** that will prove it. An attribute that doesn't apply is written `n/a — because …`.
  **Never invent these numbers** — ask, with options and their cost ("three nines or four? Four
  roughly triples the infrastructure and puts someone on call"), and log the answer (R9, R7).
  Anything still unanswered goes in §11 as an open question, not a quiet default.
- Constraints & assumptions (flag unverified assumptions; say what changes if one flips).
- **Acceptance criteria** — observable, testable, and each citing the `F#`/`NFR-*` it proves.
- Data shapes and interfaces/endpoints.
- The **code file-system layout** and the **external libraries** with versions and rationale
  (methodology R10) — agreed with the RFC, spelled out in detail here.
- **Integrations, in and out** (R10): inbound contracts we expose (style · consumers · version
  policy · auth · idempotency · limits) and outbound dependencies we call — one row each, with
  **timeout, retry, breaker, fallback and terminal state**. "None" is a valid answer; omitting
  the table is not.
- **Cross-cutting concerns** (R10): authN/authZ · secrets · observability + SLO · configuration ·
  tenancy · data classification · retention & erasure · audit · feature flags · cost. One line each.
- **Existing code?** Inventory it first: current layout, libraries actually imported,
  databases, integrations. Requirements build on those; duplicating them is out of scope.
- **Python?** Ask which dependency manager — `conda` (default), `uv`, `poetry`, `pip`+`venv`.

Ambiguous scope, requirements, or approach → **ask with options** before writing (R9).

## Write
1. Copy the template; fill every `{{PLACEHOLDER}}`; link the BLOG + RFC as sources.
2. **Illustrate with mermaid** (markdown house rule): a context `flowchart`, a data
   `classDiagram`, and the phase-summary `flowchart`.
3. Make acceptance criteria checkbox items, **each naming the `F#`/`NFR-*` it proves** (R3) —
   the work plan lifts them as test gates and carries the same IDs. Before finishing, run the
   coverage check: every requirement appears in at least one criterion. An orphan is a gap.
4. Any performance/accuracy criterion must name how it will be **measured** (methodology R2),
   and **every NFR carrying a number gets a milestone gate** (R13) — a target with no gate is
   one nobody will discover was missed until production does.
5. Include the **layout tree** (annotated: what each path owns, which entries already exist)
   and the **dependency table** — library · version · purpose · reused-or-new · why not the
   alternative. Name the dependency manager and its manifest file.

## Finish
- Add to `docs/DOCS_INDEX.md`. Suggest `/make-workplan` next.

### Seal the agreement into the contract (methodology R11)
The RFC + DRP agreement is the first point where a top-level design exists to hold anyone to.
Whichever of `/write-rfc` and `/write-drp` finishes second creates `docs/CONSTRAINTS.md` from
`docs/templates/CONSTRAINTS.template.md` (if it's already there, reconcile instead of overwrite).

- **Ask the human to confirm it before it's in force** (R9) — it's a contract, not a summary;
  it's only worth anything if they've agreed to be stopped by it.
- Distil, don't summarise: **~15 max**, each a **falsifiable sentence** (`A1…`) about *shape,
  boundaries, state, data flow, interfaces, stack, runtime, trust, ops*. The test for inclusion:
  *would I stop the build over this?* If not, it's a DRP detail, not a constraint.
- Copy the DRP's **non-goals** in, and add any **project-specific tripwire** the generic list
  misses (a fragile integration, a licence limit, a regulated data path).
- **One page, hard cap** — it's imported into every session's context by `CLAUDE.md`. No
  diagrams, no rationale essays, no history: link the RFC/DRP for the *why*.

## Rules
- Non-goals are mandatory — they prevent scope creep.
- Requirements are testable statements, not aspirations.
- **No adjectives where numbers belong.** "Fast", "reliable", "highly available", "real-time"
  and "it must scale" are not requirements — they are places where one is missing (R13).
- No design without a layout, a dependency table, an integrations table (in *and* out) and a
  cross-cutting table (R10). "None" is an answer; silence isn't.
- **One library per job.** A dependency that overlaps an installed one needs an explicit
  replace-and-remove plan, not a quiet coexistence (R10).
- The DRP doesn't ship without its **contract** (R11) — and the contract is confirmed by a
  human, not assumed.

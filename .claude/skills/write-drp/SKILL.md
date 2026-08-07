---
name: write-drp
description: Write a DRP (Detailed Requirements & Plan, Markdown) — the detailed what/why that the RFC summarizes and the work plan builds from. Use when the user asks for "requirements", "the DRP", "the detailed plan", or "acceptance criteria".
---

# write-drp — detailed requirements & plan (Stage 3)

Produce `docs/<NAME>_DRP.md` from `docs/templates/DRP.template.md` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

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
- Requirements (must/should/could) with rationale.
- Constraints & assumptions (flag unverified assumptions).
- **Acceptance criteria** — observable and testable (these become milestone gates).
- Data shapes and interfaces/endpoints.
- The **code file-system layout** and the **external libraries** with versions and rationale
  (methodology R10) — agreed with the RFC, spelled out in detail here.
- **Existing code?** Inventory it first: current layout, libraries actually imported,
  databases, integrations. Requirements build on those; duplicating them is out of scope.
- **Python?** Ask which dependency manager — `conda` (default), `uv`, `poetry`, `pip`+`venv`.

Ambiguous scope, requirements, or approach → **ask with options** before writing (R9).

## Write
1. Copy the template; fill every `{{PLACEHOLDER}}`; link the BLOG + RFC as sources.
2. **Illustrate with mermaid** (markdown house rule): a context `flowchart`, a data
   `classDiagram`, and the phase-summary `flowchart`.
3. Make acceptance criteria checkbox items — the work plan lifts them as test gates.
4. Any performance/accuracy criterion must name how it will be **measured** (methodology R2).
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
- No design without a layout and a dependency table (R10).
- **One library per job.** A dependency that overlaps an installed one needs an explicit
  replace-and-remove plan, not a quiet coexistence (R10).
- The DRP doesn't ship without its **contract** (R11) — and the contract is confirmed by a
  human, not assumed.

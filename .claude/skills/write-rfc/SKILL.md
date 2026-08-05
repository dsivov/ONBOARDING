---
name: write-rfc
description: Write a house-style RFC (HTML, slide sections) — the proposal & phased build plan. Use after a BLOG exists, or when the user asks to "write the RFC", "the proposal", or "the build plan".
---

# write-rfc — the proposal (Stage 2)

Produce `docs/<NAME>_RFC.html` from `docs/templates/RFC.template.html` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Gather
- The BLOG it builds on. The **decisions** the plan rests on (+ rejected alternatives).
- **Assemble / build / avoid**: what we reuse, what's genuinely new, what's out of scope.
- The **code file-system layout** the build will produce, and the **external libraries** it
  proposes — name, version, purpose, why over the alternative (methodology R10).
- If code already exists: its **current layout, used libraries, databases, integrations** —
  read the repo, don't assume. The proposal reuses these; it does not duplicate them.
- If the project is **Python**: which dependency manager — **ask** with options (R9),
  `conda` is the house default (alternatives: `uv`, `poetry`, `pip` + `venv`).
- The **phases** (P0…) and which end at **milestones** (M1…), each with a **test gate**.
- The top **risks** and mitigations.

Ask about anything ambiguous *before* writing (R9) — scope, requirements, approach, and the
dependency-manager question above — offering a recommended option first.

## Write
1. Copy the template; fill every `{{PLACEHOLDER}}`; link `assets/house.css`; cite the BLOG.
2. Sections: **summary** (assemble/build/avoid cards) · **decisions** · **architecture**
   (with a reuse map + SVG) · **code layout & dependencies** · **roadmap** (phase timeline
   SVG) · **phases** (deliverables + gates) · **risks** · one-line closer.
3. **Every section gets a colorful SVG diagram** using house tokens.
4. Record each decision also in `docs/DECISIONS.md` (methodology R7) — including the
   dependency-manager choice and any library chosen over an alternative.

## Finish
- Add to `docs/DOCS_INDEX.md`. Suggest `/write-drp` and `/make-workplan` next.

## Rules
- Decisions must state *why* + what was rejected.
- Gates are concrete, testable assertions — not "it works".
- The layout tree and library table are **required sections**, not appendices (R10).
- **Reuse beats adding.** Every new dependency must say why what's already installed can't
  do the job. Two libraries for one job is a defect (R10).

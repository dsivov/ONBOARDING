---
name: write-rfc
description: Write a house-style RFC (HTML, slide sections) — the proposal & phased build plan. Use after a BLOG exists, or when the user asks to "write the RFC", "the proposal", or "the build plan".
---

# write-rfc — the proposal (Stage 2)

Produce `docs/<NAME>_RFC.html` from `docs/templates/RFC.template.html` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Gather
- The BLOG it builds on. The **decisions** the plan rests on (+ rejected alternatives).
- **Assemble / build / avoid**: what we reuse, what's genuinely new, what's out of scope.
- The **phases** (P0…) and which end at **milestones** (M1…), each with a **test gate**.
- The top **risks** and mitigations.

## Write
1. Copy the template; fill every `{{PLACEHOLDER}}`; link `assets/house.css`; cite the BLOG.
2. Sections: **summary** (assemble/build/avoid cards) · **decisions** · **architecture**
   (with a reuse map + SVG) · **roadmap** (phase timeline SVG) · **phases** (deliverables +
   gates) · **risks** · one-line closer.
3. **Every section gets a colorful SVG diagram** using house tokens.
4. Record each decision also in `docs/DECISIONS.md` (methodology R7).

## Finish
- Add to `docs/DOCS_INDEX.md`. Suggest `/write-drp` and `/make-workplan` next.

## Rules
- Decisions must state *why* + what was rejected.
- Gates are concrete, testable assertions — not "it works".

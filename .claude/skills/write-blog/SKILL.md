---
name: write-blog
description: Write a house-style BLOG (HTML) — the vision/narrative piece that opens the pipeline. Use when starting a new initiative, or when the user asks to "write a blog", "the vision doc", or "the narrative".
---

# write-blog — the vision piece (Stage 1)

Produce `docs/BLOG_<TOPIC>.html` from `docs/templates/BLOG.template.html` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Reuse first
Don't re-derive what Claude Code already does well — reuse the capability, keep the house
format (template, `house.css` tokens, structure):
- Before drawing the SVG, load the **`artifact-diagramming`** skill for inline-SVG technique
  that stays legible in both themes. The house tokens and template structure still win.
- If a section carries a chart or metric, load **`dataviz`** first — then map its output onto
  the house palette below.

## Gather
- The **topic**, the **audience**, and the **one shift** the post argues for.
- The concrete pain today (a real scenario or number if available) and why now.
- The **product frame** — four things the narrative alone won't pin down, and which nothing later
  in the pipeline carries (the RFC/DRP pair is engineering-owned):
  - **Segments**, named and sized — not "users". An unsized segment is an assumption; say so.
  - **Jobs** — one line per segment, *when … I want to … so that …*, with no solution named.
    This is the altitude between the story and the DRP's `F1…Fn`; every requirement later traces
    up to one of these.
  - **Success metric** — one primary business number as *baseline → target → by when*, plus how
    it's measured, plus a **guardrail** that must not move. Business outcome, not latency: technical
    targets are NFRs and belong in the DRP (R13).
  - **Launch criteria** — what must be true to roll out, which is *not* the milestone gates.
    Gates prove the code is correct; these decide whether it's safe and worth switching people onto.

**Ask for these; don't invent them** (R9) — a fabricated baseline is worse than a stated gap.
Anything genuinely unknown is written as an open question and carried into the DRP.

## Write
1. Copy the template; replace every `{{PLACEHOLDER}}`. Link `assets/house.css`.
2. It's a **story**, not a spec: problem → idea → how it works → why now → **product frame** →
   where it goes. The narrative argues the case; the product frame pins it down.
3. **Illustrate** with at least one colorful inline **SVG** using the house tokens
   (`--a` blue, `--b` teal, `--c` amber, `--ctrl` violet). No external libraries, no raster.
4. Keep one memorable `.pull` sentence.
5. Put the "explicitly not solving" list in — it carries into the RFC's *avoid* column and the
   contract's non-goals, and deciding it here is what stops the argument recurring in month three.
6. End by naming the RFC this motivates.

## If the project already has a PRD
Don't write a second one, and don't duplicate it. A PRD is **product-owned and upstream**: map it
in — segments, jobs, metric and launch criteria fill the product frame; its detailed requirements
go to the DRP as `F1…Fn`. Cite the PRD as a source and keep it the authority for anything in the
frame, so there is one owner per fact (R6).

## Finish
- Add the BLOG to `docs/DOCS_INDEX.md` (Vision section).
- Offer to publish it as an artifact if the user wants a shareable link.
- Suggest `/write-rfc` next.

## Rules
- Honest and current (methodology R6). No cancelled ideas.
- Match the existing house look exactly — reuse tokens/classes, don't restyle.

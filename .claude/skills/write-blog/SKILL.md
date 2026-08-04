---
name: write-blog
description: Write a house-style BLOG (HTML) — the vision/narrative piece that opens the pipeline. Use when starting a new initiative, or when the user asks to "write a blog", "the vision doc", or "the narrative".
---

# write-blog — the vision piece (Stage 1)

Produce `docs/BLOG_<TOPIC>.html` from `docs/templates/BLOG.template.html` (copied into the project by new-project; fall back to the ONBOARDING repo if absent).

## Gather
- The **topic**, the **audience**, and the **one shift** the post argues for.
- The concrete pain today (a real scenario or number if available) and why now.

## Write
1. Copy the template; replace every `{{PLACEHOLDER}}`. Link `assets/house.css`.
2. It's a **story**, not a spec: problem → idea → how it works → why now → where it goes.
3. **Illustrate** with at least one colorful inline **SVG** using the house tokens
   (`--a` blue, `--b` teal, `--c` amber, `--ctrl` violet). No external libraries, no raster.
4. Keep one memorable `.pull` sentence.
5. End by naming the RFC this motivates.

## Finish
- Add the BLOG to `docs/DOCS_INDEX.md` (Vision section).
- Offer to publish it as an artifact if the user wants a shareable link.
- Suggest `/write-rfc` next.

## Rules
- Honest and current (methodology R6). No cancelled ideas.
- Match the existing house look exactly — reuse tokens/classes, don't restyle.

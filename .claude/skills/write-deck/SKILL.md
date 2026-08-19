---
name: write-deck
description: Write a self-contained, dual-mode HTML presentation (one file, no build, no network — present mode + reference mode, inline SVG diagrams), and optionally export it to PowerPoint. Use when the user asks for "a deck", "a presentation", "slides", "a talk", or wants an existing deck updated or converted to .pptx.
---

# write-deck — a self-contained HTML presentation

Produce a **single `.html` file** that needs nothing but a browser: inlined CSS and JS, inline
SVG diagrams, no CDN, no webfont link, no remote image. It opens from a USB stick, from a
laptop with no wifi, and from a hotel projector.

Template: `templates/DECK.template.html` (copied into the project by `/new-project`; fall back to
the ONBOARDING repo if absent). Its header comment is the full slide vocabulary — read it before
writing, and keep it in the file while drafting.

## The format, and why it's this one

**Two modes in one file**, toggled top-right or with `R`:

| Mode | For | Behaviour |
|------|-----|-----------|
| **Present** | walking an audience through it | one slide at a time · `←` `→` `space` `PageUp/Dn` `Home` `End` · `O` overview grid · `F` fullscreen |
| **Reference** | finding one thing fast, live | every slide stacked · sticky TOC with scrollspy · `Ctrl+F` works |

The mode persists in `localStorage`; `#s07` anchors deep-link; **Print → Save as PDF** exports
every slide one per page. The TOC and the overview grid are **built by the script** from the
sections — never hand-maintain a contents list.

## Write

1. Copy the template. Replace `{{TITLE}}`, `{{SUBTITLE}}`, `{{ONE_LINE_DESCRIPTION}}`, delete the
   three example slides.
2. Each slide is one section — that is the whole API:
   ```html
   <section class="slide" data-grp="Group shown in the TOC" data-t="Title in the TOC">
   ```
   `data-grp` opens a new TOC group when it changes; repeat it to stay inside one.
3. Open every slide with an `.eyebrow` (a `.chip` + a `.kicker`), then an `h2` that makes a
   **claim** rather than naming a topic, then a `p.lede` of one or two sentences.
4. Use the content blocks the stylesheet already defines — `.grid.g2/g3/g4 > .card.rail-*`,
   `.callout.key/.ok/.caveat/.danger`, `.tablewrap > table`, `pre.code`, `.tree`,
   `figure > .fig > svg`. Don't invent new classes; the PPTX exporter reads these.
5. **Diagram the mechanism, not the topic.** At least one per substantive slide.

## Diagrams — the house SVG vocabulary

Boxes `.bx` + a fill `.f-a .f-b .f-c .f-ctrl .f-d .f-n .f-g` · text `.dt`/`.ds` (centred),
`.dtl`/`.dsl` (left), `.hd` (uppercase label), `.lbl` (small caption) · lines `.ln`, `.ln-d` ·
markers `url(#arw)` `#arwA` `#arwB` `#arwD` `#arwS`.

Three rules that are not stylistic:

- **Never put a `<style>` block inside a diagram.** Inline SVG styles are *document*-scoped, so a
  second diagram's `.t` silently restyles the first one's. The shared classes exist for this.
- **Markers are declared once**, in the hidden `<svg>` at the top of the file. Referencing
  `url(#arw)` from anywhere resolves against it.
- **Route connectors orthogonally.** Lay boxes on a grid over a `0 0 1000 H` viewBox and elbow
  through a clear lane (`<path class="ln" d="M486 118 L508 118 L508 186 L528 186"/>`). Diagonals
  across boxes are what make a diagram look generated. One deliberate crossing is fine; several
  mean the layout is wrong.

**Check text fits before shipping.** SVG doesn't wrap and it doesn't warn — a long `<text>` runs
straight off the viewBox and is silently clipped. Estimate: monospace ≈ `0.60 × font-size` per
character, bold sans ≈ `0.56`. Anything wider than the viewBox gets split across two `<text>`
lines. Sweep the whole file for it rather than trusting each diagram.

Check against **the enclosing box, not just the viewBox** — a caption that fits the canvas but
overruns the rounded rect it sits inside looks like a bug and a viewBox-only sweep won't catch it.
For centred text the usable width is the box width minus ~2× the corner radius.

## Rules

- **Self-contained is the point** — verify it: `grep -oE 'https?://' deck.html` must return
  nothing, and so must any `src=`/`href=` that isn't a `#anchor`. Images go in as `data:` URIs.
- **Committed dark theme.** `body` paints its own background from a token, so the page holds on
  any host ground. Don't add a half-finished light theme.
- Accessible: every `<svg>` carries `role="img"` and an `aria-label`; keyboard focus stays visible;
  `prefers-reduced-motion` is already respected.
- A slide that is only bullets is a slide that wanted to be a paragraph. Cards, a table, or a
  diagram — pick one.

## Export to PowerPoint (optional)

```bash
pip install python-pptx cairosvg beautifulsoup4
python3 templates/tools/deck_to_pptx.py docs/<NAME>.html docs/<NAME>.pptx
```

Native 16:9 slides — real PowerPoint tables and text, with each inline SVG re-rendered to a
high-resolution image. One HTML slide becomes one or more PPTX slides; overflow continues on
"(cont.)" pages. The HTML stays the source of truth: **edit the HTML and re-run**, never the
`.pptx`.

Two things to know. The renderer resolves the CSS classes into presentation attributes itself
(cairosvg can't see the document stylesheet), so **a new diagram class must be added to `CLS` in
the script** or it renders unstyled. And SVG text is drawn with a local font — pick one with wide
glyph coverage (circled digits, arrows, check marks) via `SVG_SANS` / `SVG_MONO` at the top;
`fc-list` shows what's installed. Missing glyphs render as tofu boxes, in the image only.

## Finish

- Verify: no external URLs · every `<svg>` has an `aria-label` · no text overflows a viewBox ·
  it opens correctly straight from `file://`.
- If the project keeps a docs index, add it there.
- Offer the `.pptx` export, and mention that Print → Save as PDF already works.

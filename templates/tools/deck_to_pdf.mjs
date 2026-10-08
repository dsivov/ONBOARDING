/* Render a house deck to PDF — one slide per page, theme intact.
 *
 *   node templates/tools/deck_to_pdf.mjs docs/MY_DECK.html docs/MY_DECK.pdf
 *
 * Needs Playwright's Chromium. If the project already has it (most do — the
 * frontend kit uses @playwright/test), this finds it; otherwise:
 *
 *   npm i -D @playwright/test && npx playwright install chromium
 *
 * The deck's own `@page` rule decides the page size, so this script carries no
 * layout knowledge. Tune the height in the deck once it is written: at 297mm
 * wide a slide lays out around 900px, and a page that clears your tallest slide
 * keeps one slide per page.
 *
 * Print → Save as PDF from the browser produces the same thing; this is for
 * regenerating it without a human in the loop.
 */
import { createRequire } from "node:module";
import { pathToFileURL, fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";
import { existsSync } from "node:fs";

const here = dirname(fileURLToPath(import.meta.url));

/** Find @playwright/test wherever this project keeps it. */
function loadChromium() {
  const roots = [process.cwd(), resolve(here, "..", ".."), resolve(here, "..", "..", "..")];
  for (const dir of ["", "studio", "frontend", "web", "ui", "app"]) {
    for (const root of roots) {
      const pkg = resolve(root, dir, "package.json");
      if (!existsSync(pkg)) continue;
      try {
        return createRequire(pkg)("@playwright/test").chromium;
      } catch { /* not installed under this package.json */ }
    }
  }
  console.error(
    "Could not find @playwright/test.\n" +
    "  npm i -D @playwright/test && npx playwright install chromium");
  process.exit(2);
}

const [src, out] = process.argv.slice(2);
if (!src || !out) {
  console.error("usage: node deck_to_pdf.mjs <deck.html> <out.pdf>");
  process.exit(2);
}

const chromium = loadChromium();
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1122, height: 1360 } });
const errors = [];
page.on("pageerror", (e) => errors.push(e.message));

await page.goto(pathToFileURL(resolve(src)).href, { waitUntil: "networkidle" });

// Reference mode stacks every slide. The print CSS forces that anyway, but
// setting the mode means the DOM being printed is the one the author reviews.
await page.evaluate(() => {
  try { localStorage.setItem("deckMode", "ref"); } catch { /* file:// may block */ }
  document.getElementById("mRef")?.click();
});
await page.waitForTimeout(500);

const slides = await page.locator("section.slide").count();
await page.emulateMedia({ media: "print" });
await page.pdf({ path: resolve(out), printBackground: true, preferCSSPageSize: true });
await browser.close();

console.log(`${src} → ${out}  (${slides} slides)`);
if (errors.length) {
  console.error(`  page errors: ${errors.join(" | ")}`);
  process.exit(1);
}

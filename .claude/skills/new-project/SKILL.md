---
name: new-project
description: Bootstrap a project with the house methodology — copy templates + house.css into the project (self-contained), scaffold docs/, and seed DOCS_INDEX.md and DECISIONS.md. Use at the very start of a project, or when the user asks to "set up the project", "onboard", or "start the docs".
---

# new-project — scaffold the house methodology

Set the project up so the documentation-first pipeline (BLOG → RFC ↔ DRP → ARCHITECTURE/CR →
WORK PLAN → reviews) is ready — and **self-contained**: the project gets its own copy of the
templates and design system, so it no longer depends on the ONBOARDING repo's location.

## Target directory
- **Default: the current working directory** (the project). Scaffold there.
- If the user passes a path (`/new-project <path>`), scaffold into that path instead.
- Confirm the **project name** (default: the directory name) and a one-line description.

## Locate ONBOARDING (source of the kit)
Find the ONBOARDING repo to copy from — usually a sibling dir `../ONBOARDING`, or the repo
this skill was installed from; ask the user if it isn't obvious. You need
`ONBOARDING/templates/`, `ONBOARDING/assets/house.css`, and (for app UIs) `ONBOARDING/frontend-kit/`.

## Steps (copy in — don't symlink; the project must be standalone)
1. Create `docs/` and `docs/assets/`.
2. **Copy the design system:** `ONBOARDING/assets/house.css` → `docs/assets/house.css`.
3. **Copy the templates:** `ONBOARDING/templates/*` → `docs/templates/`. (So authoring works
   with no dependency on the ONBOARDING repo. A template links `../assets/house.css`, which
   from `docs/templates/` correctly resolves to `docs/assets/house.css`.)
4. **Seed the running docs** from the copied templates, filling project name/date:
   - `docs/DOCS_INDEX.md` ← `docs/templates/DOCS_INDEX.template.md`
   - `docs/DECISIONS.md`  ← `docs/templates/DECISIONS.template.md`
5. If the project has an app UI, copy `ONBOARDING/frontend-kit/` → the frontend (or copy
   `house-ui.css` into the app's styles) so UI work uses the house tokens.
6. Add/refresh a short `docs/README.md` pointing at the methodology and listing the pipeline.
7. Tell the user the next step: `/write-blog`.

## Path convention (so links resolve)
- Published artifacts live directly in `docs/` (e.g. `docs/PAYMENTS_RFC.html`) and link
  **`assets/house.css`**.
- Copied templates live in `docs/templates/` and link **`../assets/house.css`**.
- When a write-* skill turns a template into a real doc under `docs/`, it rewrites the
  stylesheet href from `../assets/house.css` → `assets/house.css`.

## Rules
- **Copy, don't symlink** — the project must be self-contained.
- Don't overwrite existing project files without asking; scaffold missing pieces only.
- Don't invent content — the write-* skills fill each artifact.
- Do not commit unless the user asks (methodology R5).

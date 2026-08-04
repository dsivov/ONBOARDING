---
name: new-project
description: Bootstrap a new project with the house methodology — scaffold docs/, copy templates + house.css, and seed DOCS_INDEX.md and DECISIONS.md. Use at the very start of a project, or when the user asks to "set up the project", "onboard", or "start the docs".
---

# new-project — scaffold the house methodology

Set up a project so the documentation-first pipeline (BLOG → RFC → DRP → ARCHITECTURE/CR →
WORK PLAN → reviews) is ready to use.

## Locate ONBOARDING
The templates + design system live in the ONBOARDING project. Find it (usually a sibling
dir `../ONBOARDING`, or ask the user for the path). You need `ONBOARDING/templates/`,
`ONBOARDING/assets/house.css`, and `ONBOARDING/frontend-kit/`.

## Steps
1. Confirm the **project name** and one-line description.
2. Create `docs/` and `docs/assets/`. Copy `ONBOARDING/assets/house.css` → `docs/assets/house.css`.
3. Seed the running docs from templates (fill the project name/date):
   - `docs/DOCS_INDEX.md` ← `templates/DOCS_INDEX.template.md`
   - `docs/DECISIONS.md` ← `templates/DECISIONS.template.md`
4. If the project has an app UI, copy `ONBOARDING/frontend-kit/` into the frontend
   (or copy `house-ui.css` into the app's styles) so UI work uses the house tokens.
5. Add a short `docs/README.md` (or update the project README) pointing at
   `ONBOARDING/METHODOLOGY.md` and listing the pipeline.
6. Tell the user the next step: `/write-blog` to start the vision.

## Rules
- Don't invent content — scaffold only. The write-* skills fill each artifact.
- Keep `<title>`/headers and dates accurate.
- Do not commit unless the user asks (methodology R5).

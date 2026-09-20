# Project: TutMe🔥 (D:\apps\TutMe2 🔥)

## JavaScript runtime — strictly Bun
- **Never use Deno, Node, npm, npx, pnpm, or yarn.**
- Run scripts/tests with `bun <file>` or `bun run <task>`.
- Parse/syntax-check JS with `bun` (e.g. `new Function(src)` shim).
- Install packages with `bun add`; executables with `bunx`.

## Site layout
- Static site lives in `public/` — all paths relative, no build step.
- Shared theme: `public/styles.css`. Praxis quiz + code-highlight logic: `public/praxis/praxis.js` (loaded by all 24 drills).
- Safety backup of the original site: `public.backup/` — do not edit.
- `public/site_manifest.json` lists every file (114 html + praxis.js + styles.css). Regenerate when files are added/removed.

## Conventions
- Hubs/landing pages: compact — `pagehead` (h1 + a few buttons) → sections → footer. No hero prose/stat strips.
- Drills: MCQ (`data-quiz`, `data-correct` on the `.opt` label) + `<details class="solution">` with `pre.code` (highlighted by praxis.js).
- Path contains an emoji (`TutMe2 🔥`) — console output may garble it; use `-LiteralPath` in PowerShell.
- Do not list content that doesn't exist (e.g. the deleted GIS Data Processing book).

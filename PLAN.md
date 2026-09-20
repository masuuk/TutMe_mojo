# TutMe🔥 — Reorganization Plan

## Overview
Reorganize loose HTML files from `all html files/` into the `public/` static site structure and rename the app from "Mojo 1.x Learning Hub" to **"TutMe🔥"**. The site is a learning hub for Mojo 1.x: a single-source syntax library (fundamentals), domain books (data science + applications), and a practice dojo (praxis).

## Folder Structure (live)
```
public/
├── index.html               (landing page — full site hub, links all 121 files)
├── styles.css
├── site_manifest.json       (regenerated — matches all HTML files on disk)
├── app.js                   (root SPA links updated)
├── fundamentals/            (single source of truth — the language)
│   ├── index.html           (hub: lessons + 2 books + reference library)
│   ├── lesson-01..04-values|control|functions|structures.html
│   ├── mojo_book_1.html     (+ mojo-01..15 chapters)
│   ├── mojo_book_2.html     (DS & ML library)
│   └── advisory, cli-tools, control-flow, functions, structs, types, mojo-101
├── data_science/            (books shelf)
│   ├── index.html           (hub: 3 book series + standalone topics)
│   ├── ds-textbook-00..14   (Mojo for Data Science & ML)
│   ├── ds-ml-textbook-00..09 (Data Science & ML Textbook)
│   ├── ds-advanced-00..17   (DS & ML with Mojo — advanced + MLIR appendix)
│   └── standalone: data-science, ds-tools, numerical-python-to-mojo,
│       linear-regression(-detailed), perceptrons-and-activation,
│       decision-aware-ml, fine-tuning-llms, time-series-analytics
├── praxis/                  (Exercises / practical tutorials)
│   ├── index.html           (dojo hub)
│   ├── drill-01..17         (one drill per Mojo textbook chapter)
│   ├── drill-18..24         (one drill per application book)
│   └── mini-project-01..03  (CSV utility, shape library, capital budget analyser)
└── applications
    ├── index.html           (hub: finance + geomatics + operations-research shelves)
    ├── geomatics/           (index links files + mother folder)
    │   └── karney-krueger-equations.html
    ├── operations_research/ (index links files + mother folder)
    │   └── operations_research.html
    └── finance/             (index links files + mother folder)
        ├── future_value_and_annuities.html
        ├── npv_amortisation.html
        └── the_annuity_codex.html
```

All topics are searchable from the landing page and from each section hub.

## Completed
- **Branding** — "Mojo 1.x Learning Hub" fully replaced with "TutMe🔥" across all pages.
- **Navigation** — standard pill nav (`Home | Fundamentals | Data Science | Applications | Praxis`) present on all 22 standard pages, prefix-correct per depth (`""`, `../`, `../../`).
- **Index hubs completed — every HTML file is linked from its section hub**:
  - `index.html` → links all 121 files, grouped by the four pills, with `#fundamentals` / `#data-science` / `#applications` / `#praxis` anchor sections.
  - `fundamentals/index.html` → links all 29 files (lessons, textbook chapters, reference library).
  - `data_science/index.html` → links all 52 files (three book series + standalone topics).
  - `applications/index.html` → links all 10 files (finance, geomatics, operations-research + related DS card).
  - `geomatics/index.html` and `operations_research/index.html` → link all files in shelf + "mother folder" `../index.html`.
  - `applications/finance/index.html` → redirects to `operations_research/` shelf for the moved textbook.
- **Praxis exercises created** — grounded in the books:
  - Drills 01–17 map 1:1 to the Mojo 1.x Textbook chapters (`drill-NN.html` links back to the source chapter).
  - Drills 18–24 map to application books (finance ×3, geomatics ×2, operations research ×2).
  - Mini-projects 01–03 (CSV summary utility, metaprogrammed shape library, capital budget analyser).
- **Moved file** — `operations_research.html` relocated `applications/finance/ → applications/operations_research/`.
- **Cleanup** — removed dead links (`/textbooks/*`, old `library/` references in `app.js`), updated `app.js` root links, regenerated `site_manifest.json` (121 html files, verified against disk).
- **Safety backup** — pre-restructure snapshot of `public/` kept at `public.backup` for rollback.

## Remaining / Next
- **Stale internal cross-links in saved books** — the big saved-webpage books (`mojo_book_1.html`, `mojo_book_2.html`, `ds-*` chapters, `data_science.html`, `operations_research.html`) still reference old paths:
  - root-absolute `/books/*.html` links, e.g. `/books/data_science.html`, `/books/decision_aware_ml.html` → should map to kebab-case files under `/fundamentals/`, `/data_science/`, `/applications/operations_research/`.
  - `<script src="/books/book-nav.js" defer></script>` tags → file no longer exists (remove or repoint).
  - `library/mojo_XX_*.html`, `library/ds_*`, `library/tb_*`, `library/m10_*`, `library/advisory.html` links in `mojo-book-1/2.html` → map to `fundamentals/mojo-*.html`, `data_science/ds-textbook-*.html`, `ds-ml-textbook-*.html`, `ds-advanced-*.html`, `fundamentals/advisory.html`.
  - snake_case chapter cross-links inside chapter files → kebab-case equivalents, preserving `#fragment`.
  - `assets/fonts-*.css` and `./lin2_files/...` references → no such folders/files exist; decide to strip or leave.
  - Relative `decision_aware_ml.html` inside `fine_tuning_llms.html` → repoint to same-folder kebab file.
- **Applications-based exercises** — extend Praxis with more drills grounded in application books as new books land.
- **Link-audit script** — run a final sweep for `(href|src)="[^"]*(/books/|library/|textbooks/)` and snake_case `.html` targets to confirm zero remaining stale links.

## Notes
- Files are self-contained or shared-stylesheet pages; saved book pages have inline CSS and their own anchor nav — they do not use the standard pill nav.
- PowerShell console may render `TutMe🔥` as `TutMe??`/`�` — display only; files are valid UTF-8.
- The emoji `🔥` in the project folder path is part of `D:\apps\TutMe2 🔥` and must be preserved in all paths.
- Internal cross-links within the big saved books were "preserved as-is" during the move; the remaining stale-link repoint pass is the active follow-up.
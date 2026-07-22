# Repository Agent Notes

> Full monorepo workflow (render portal, CI, scripts, layout) is documented in the root **`AGENTS.md`**.
> This file covers book-local Quarto generation rules only.

## Quarto Generation Rules (All Book Folders)

- Treat each book's `_quarto.yml` as generated output.
- Do not hand-edit `_quarto.yml`; edits will be overwritten.
- Regenerate with that book's script:
  - `./scripts/update-index.sh` (run from inside the specific book directory).

## Content Ordering Convention

For books using `scripts/update-index.sh` in this repo:

1. `index.qmd` is always the first chapter.
2. Book parts are discovered from first-level directories under `content/`.
3. Part order is controlled by numeric prefixes on directory names (`01-`, `02-`, ..., `99-`).
4. Chapter order inside a part is lexicographic filename order.
5. Use numeric filename prefixes (`01-*.qmd`, `02-*.qmd`, ... ) for deterministic order.
6. `index.qmd`/`index.md` inside a part is emitted first within that part.
7. Directories starting with `_` are ignored by part discovery.
8. Root-level files directly under `content/` are not included as chapters.

## myHomelab Specific

- Canonical manuscript content is split into prefixed files under:
  - `myHomelab/content/01-foundations/`
  - `myHomelab/content/02-platform-and-hybrid/`
  - `myHomelab/content/03-automation-and-operations/`
  - `myHomelab/content/04-reliability-and-growth/`
  - `myHomelab/content/99-appendices/`
- Planning/master source files are kept in `myHomelab/content/_planning/`.

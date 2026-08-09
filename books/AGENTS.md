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

## 90DaysOfX / 30DaysOfX (multi-volume series)

- Portal books: `books/90DaysOfX/`, `books/30DaysOfX/`
- **Volumes** = independent parts: `content/01-go/`, `content/02-nixos/`, `content/03-maths/`, future `content/04-…/`
- Readers take one volume at a time by default; no morning/evening dual-track in published prose
- Each volume: `00-sub-book-overview.qmd` + syllabus early; day chapters later
- Series-wide docs: `content/00-program/` where present
- Standalone `Go` / `NixOS` / `Maths` stay as deep libraries; do not auto-merge chapter bodies
- Prefer root **`AGENTS.md`** for full naming rules (`@lib` / `@90` / `30X`)

### Naming (same as root AGENTS.md — do not confuse with standalone books)

| Say / assume | Path |
|--------------|------|
| **standalone Go / Go book / Go@lib** | `books/Go/` |
| **standalone NixOS / NixOS book / NixOS@lib** | `books/NixOS/` |
| **standalone Maths / Maths book / Maths@lib** | `books/Maths/` |
| **Go volume / 90X Go / Volume 1 / Go@90** | `books/90DaysOfX/content/01-go/` |
| **NixOS volume / 90X NixOS / Volume 2 / NixOS@90** | `books/90DaysOfX/content/02-nixos/` |
| **Maths volume / 90X Maths / Volume 3 / Maths@90** | `books/90DaysOfX/content/03-maths/` |

**book** = standalone library · **volume / 90X / @90** = series day path. Ask if the user only says “Go” / “NixOS” / “Maths” without a qualifier.

## myHomelab Specific

- Canonical manuscript content is split into prefixed files under:
  - `myHomelab/content/01-foundations/`
  - `myHomelab/content/02-platform-and-hybrid/`
  - `myHomelab/content/03-automation-and-operations/`
  - `myHomelab/content/04-reliability-and-growth/`
  - `myHomelab/content/99-appendices/`
- Planning/master source files are kept in `myHomelab/content/_planning/`.

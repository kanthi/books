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

## Book naming

All titles under `books/` are **standalone libraries**. Paths: `books/Go/`, `books/NixOS/`, `books/Maths/`, `books/Linux/`, `books/Networking/`, `books/C/`, `books/Python/`, `books/VCS/` (Git content under `content/01-git/`). Prefer root **`AGENTS.md`** for inventory and workflow.

## Book independence

Each title is a complete book. Do not assume the reader has opened any other title. Do not cross-link into Linux, Maths, Networking, Go, C, NixOS, or VCS for a concept this page needs. If a host-OS or maths fact is required, give the minimum here.

## Illustrated diagrams (all books)

**Do not invent a per-book diagram style.** Use the monorepo standard:

| Item | Path |
|------|------|
| Standard | `includes/diagrams/STANDARD.md` (monorepo root) |
| Light reference | `includes/diagrams/reference/diagram-reference-topology.svg` |
| Dark reference | `includes/diagrams/reference/diagram-reference-topology-dark.svg` |
| Theme-swap fragment | `includes/diagrams/theme-swap.fragment.html` |

Rules (short):

1. **Topology / lab figures** → illustrated dual-theme cards: `images/diagram-<topic>.svg` + `images/diagram-<topic>-dark.svg` using reference CSS tokens.
2. **Conceptual models** → mono `#7a8fa6` on transparent; prefer `diagram-concept-*.svg`; no dark sibling.
3. Embed the **light** path only; HTML dark mode uses theme-swap in `styles/reader-mode-body.html`.
4. `scripts/update-index.sh` must list `project.resources: [images/*-dark.svg]`.
5. Open the light reference SVG before authoring a new figure.

Root **`AGENTS.md`** also links this standard for session defaults.

## `update-index.sh` (all books)

Every live book (and `Template/`) uses the same generator: **nested sections**, **`humanize_dir_title`** for sidebar labels (including special cases like File I/O, GitHub, NixOS, CLI, SRE), dual-theme `images/*-dark.svg` resources, and `date-modified` / “Updated”. Re-run after any content tree rename.

## Linux book (combined)

- Path: `Linux/`
- Merged from former `Linux-Commands`, `Linux-Editors`, `Linux-ShellScripting-Bash`
- **Sidebar tree** (nested sections allowed):
  - Part: `content/01-commands/`, `02-editors/`, `03-scripting/`
  - Section: e.g. `01-commands/01-files-and-paths/`, `03-scripting/01-bash/`
  - Nested section (optional): e.g. `03-scripting/01-bash/04-variables/`
  - Chapter: files inside the leaf section

## VCS book

- Path: `VCS/`; Git curriculum under `content/01-git/` (future parts may add `02-…`).

## Python book

- Path: `Python/`
- **Published sidebar (for now):** `01-language/` (nested, Internals inside Language), `98-stdlib/`, `99-projects/`
- Other domains parked in `content/_planning/later-parts.md`
- **Independent** of other titles. A Python reader never needs Maths, Linux, Networking, or any sibling book. Do not reteach those subjects; do not require them.
- Path A chapters assume **no prior Python**. Prefer beginner-friendly prose, named worked examples (input / output / why), and a term defined on first use. Deepen existing leaves before adding new parts.
- Getting started covers a self-contained **editor / font / CLI-only** setup (macOS + Linux first). Do not send the reader to the Linux book.

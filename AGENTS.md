# Agent Notes — Quarto Multi-Book Monorepo

Canonical workflow memory for this repository. Prefer this file over ad-hoc re-discovery.
Book-level ordering rules also live in `books/AGENTS.md`.

## What this repo is

A **multi-book Quarto monorepo**. Each book is a self-contained Quarto project under `books/`. A master script renders every book and assembles a single **library portal** (`books/published_books/index.html`) with cards for HTML / PDF / EPUB. GitHub Actions deploys that portal to the `gh-pages` branch.

- Remote: `https://github.com/kanthi/books.git`
- Author in generated configs: **K19G**

## Layout

| Path | Role |
|------|------|
| `books/<BookName>/` | One Quarto book |
| `books/<BookName>/content/` | Chapters (`.md` / `.qmd`), usually numbered parts |
| `books/<BookName>/scripts/update-index.sh` | **Generates** `_quarto.yml` from the filesystem |
| `books/<BookName>/_quarto.yml` | Generated config — **never hand-edit** |
| `books/<BookName>/styles/` | light/dark SCSS + epub CSS |
| `books/<BookName>/index.qmd` | Book landing page (always first chapter) |
| `books/<BookName>/_book/` | Local Quarto output (**gitignored**) |
| `books/published_books/` | Aggregated site artifact (**gitignored**; CI deploy source) |
| `Template-New-1/` | **Preferred** scaffold for a new book |
| `Template.backup/` | Legacy book scaffold (kept for reference only) |
| `.github/workflows/main.yml` | Build + deploy on push to `main` |

### Current books (as of last inventory)

`C`, `ContainerLabs`, `Git-Github`, `Go`, `Linux-Commands`, `Linux-Editors`, `Linux-ShellScripting-Bash`, `Maths`, `myHomelab`, `Rust`

## Critical rules

1. **Never hand-edit `_quarto.yml`** inside a book. It is overwritten by `scripts/update-index.sh`.
2. After adding/removing/renaming content files or folders, run that book's `update-index.sh` (or a full render script that calls it).
3. **CI path of record** is `books/renderpub-codex-v2.sh` (not the older `renderpub.sh`).
4. `published_books/` and `_book/` are build artifacts — do not commit them.
5. Older scripts (`renderpub.sh`, `renderpub-codex.sh`, `renderpub-indi-codex.sh`, `renderpub_backup*.sh`) may still be in the tree; treat them as legacy unless the user says otherwise.

## Content conventions

Documented in detail in `books/AGENTS.md`. Summary:

1. `index.qmd` is always the first chapter.
2. Book **parts** = first-level directories under `content/`.
3. Part order = numeric prefixes on directory names (`01-`, `02-`, …, `99-`).
4. Chapter order inside a part = lexicographic filename order (use `01-*.qmd`, `02-*.qmd`, …).
5. `index.qmd` / `index.md` inside a part is emitted first within that part.
6. Directories starting with `_` are ignored by part discovery (e.g. planning folders).
7. Root-level files directly under `content/` are **not** auto-included as chapters.
8. Titles for sidebar entries come from YAML frontmatter `title:`, else first `#` heading, else the path name.

## Build & publish pipeline

```
content/**  →  update-index.sh  →  _quarto.yml
                                    ↓
                              quarto render  →  _book/
                                    ↓
                         renderpub-codex-v2.sh
                                    ↓
              published_books/{html,pdf,epub,assets,index.html}
                                    ↓
                    GitHub Actions → gh-pages branch
```

### Master script (`books/renderpub-codex-v2.sh`)

Run from `books/`:

```bash
cd books
./renderpub-codex-v2.sh
```

For each subdirectory that contains `_quarto.yml`:

1. Run `scripts/update-index.sh` if present
2. `quarto render`
3. Generate SVG cover into `published_books/assets/<BookName>.svg`
4. Copy `_book/*` → `published_books/html/<BookName>/`
5. Copy PDF/EPUB if present → `published_books/pdf|epub/`
6. Append a card entry for the portal `index.html`

Portal features: search filter, light/dark theme toggle, format links (HTML/PDF/EPUB).

### Single-book local render

```bash
cd books
./indipub.sh <BookName>
```

Runs update-index + `quarto render` only (does **not** rebuild the portal).

### Per-book index refresh only

```bash
cd books/<BookName>
bash scripts/update-index.sh
```

## CI / deployment

File: `.github/workflows/main.yml`

- **Triggers:** push to `main`, `workflow_dispatch`
- **Quarto version:** `1.3.450`
- **Deps:** pandoc + texlive packages (for PDF)
- **Build:** `cd books && ./renderpub-codex-v2.sh`
- **Deploy:** `peaceiris/actions-gh-pages` publishes `./books/published_books` to `gh-pages` (`force_orphan: true`)

## Creating a new book

Prefer **`Template-New-1/`** (sample `content/`, accurate monorepo README, no per-book CI).
Legacy scaffold is kept as **`Template.backup/`** — do not use it for new books.

```bash
cp -r Template-New-1 books/My-New-Book
# Edit index.qmd; add/replace content under content/<NN-part>/...
cd books/My-New-Book && bash scripts/update-index.sh
cd ../ && ./indipub.sh My-New-Book   # optional local test
```

On the next full CI run (or local `renderpub-codex-v2.sh`), the new book appears on the portal automatically if it has `_quarto.yml`.

## Common agent tasks

| Task | Approach |
|------|----------|
| Add a chapter | Create file under the right `content/<part>/` with numeric prefix; run `update-index.sh` |
| Reorder chapters | Rename with numeric prefixes; run `update-index.sh` |
| Add a part | New `content/NN-name/` directory; run `update-index.sh` |
| Fix sidebar title | Edit chapter YAML `title:` or first `#` heading; re-run `update-index.sh` |
| Style changes | Edit `styles/light.scss` / `styles/dark.scss` (or shared patterns); not `_quarto.yml` by hand |
| Portal / cover / aggregate bugs | Edit `books/renderpub-codex-v2.sh` |
| CI changes | Edit `.github/workflows/main.yml` |

## Related docs

| File | Purpose |
|------|---------|
| `README.md` | Human project overview (may lag slightly vs CI script name) |
| `books/AGENTS.md` | Quarto generation + ordering rules; myHomelab notes |
| `Gemini.md` | Shorter legacy agent memory — prefer **this** file as canonical |

## Defaults for future sessions

- Prefer **`renderpub-codex-v2.sh`** for full library builds.
- Prefer **`indipub.sh <Book>`** for single-book iteration.
- Do not re-explain this pipeline unless the user asks; assume it is known.
- Do not invent hand-maintained chapter lists in `_quarto.yml`.
- When unsure whether `_quarto.yml` is stale after content moves, regenerate it.

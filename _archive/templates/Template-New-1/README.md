# Archived snapshot of Template-New-1 (pre-rename to Template)

# Book template (Template-New-1)

Scaffold for a **new book inside this monorepo**. Copy it into `books/`, add
chapters under `content/`, regenerate `_quarto.yml`, then render.

The older scaffold is kept under root **`_archive/templates/Template.backup/`** for reference only. Prefer this folder for all new books.

## Quick start

From the **repository root**:

```bash
# 1. Copy and name the book (folder name becomes the book title)
cp -r Template-New-1 books/My-New-Book

# 2. Generate _quarto.yml from content/
cd books/My-New-Book
bash scripts/update-index.sh

# 3. Optional: local single-book render
cd ..
./indipub.sh My-New-Book

# 4. Full library portal (HTML + PDF + EPUB + index cards)
# ./renderpub-codex-v2.sh
```

Preview while writing (from the book directory):

```bash
quarto preview
```

Pushing to `main` runs CI, which builds all books via `renderpub-codex-v2.sh`
and deploys `books/published_books` to GitHub Pages.

## Layout

```text
My-New-Book/
├── index.qmd                 # Book landing / preface
├── content/
│   ├── 00-intro/             # Part (numeric prefix = order)
│   │   └── 01-overview.qmd
│   ├── 01-foundations/
│   │   └── 01-getting-started.qmd
│   └── _planning/            # Ignored by update-index (notes only)
├── images/                   # Optional assets
├── scripts/
│   └── update-index.sh       # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
├── _quarto.yml               # GENERATED — do not hand-edit
└── README.md
```

## Content rules

1. **`index.qmd`** is always the first chapter.
2. **Parts** = first-level directories under `content/` (`01-name`, `02-name`, …).
3. **Chapter order** = lexicographic filename order (use `01-`, `02-`, …).
4. **`index.qmd` / `index.md`** inside a part is listed first in that part.
5. Directories starting with **`_`** are ignored (e.g. `_planning/`).
6. Files sitting **directly** under `content/` (not in a part folder) are not
   included as chapters.
7. Sidebar **titles** come from YAML `title:`, else the first `#` heading, else
   the path name.

Example chapter frontmatter:

```yaml
---
title: "Getting Started"
---
```

## Important

- **Do not hand-edit `_quarto.yml`.** It is overwritten by
  `scripts/update-index.sh`.
- After adding, removing, or renaming content, re-run:

  ```bash
  bash scripts/update-index.sh
  ```

- Optional env overrides when generating config:

  ```bash
  BOOK_AUTHOR="K19G" BOOK_REPO_URL="https://github.com/kanthi/books" \
    bash scripts/update-index.sh
  ```

## What this template does *not* include

- Per-book GitHub Actions (deployment is monorepo-wide under `.github/`)
- Multi-book render scripts (use `books/renderpub-codex-v2.sh` or `indipub.sh`)

See the repository root **`AGENTS.md`** for the full monorepo workflow.

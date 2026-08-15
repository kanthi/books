# Python

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Python/
├── index.qmd                 # Book landing page (paths + part map)
├── content/                  # Parts (numeric prefixes); Part 01 is nested
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):

```text
01-language          intro → syntax → mastery → internals (nested sections)
98-stdlib            standard library tour
99-projects          progressive labs
```

Other domains (CS, maths, data/AI, ops, apps) are parked in `content/_planning/later-parts.md` until we decide how to organize them.

Part **01 Language** is a Linux-style tree (section → optional nested section → chapter). Internals lives **inside** Language.

This book is **independent** of the other titles. A reader never needs Linux, Maths, Networking, or any sibling book. If a page needs a host fact (terminal, `PATH`, a file path), it explains the minimum here.

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Python      # update-index + quarto render (this book only)
# ./renderpub.sh         # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …). Order is the numeric prefix.
3. Nested sections are allowed (same generator as Linux).
4. Chapter order inside a leaf = lexicographic filename order.
5. Dirs starting with `_` are ignored by the index script.
6. Sidebar titles come from YAML `title:`, else the first `#` heading.
7. HTML title block shows **Published** (`book.date`) and **Updated** (`date-modified`).

New books should start from root **`Template/`**, not `_archive/templates/Template.backup/`.

# C

Modular **C17** library: foundations through systems topics, plus workbook and appendices. Prefer root **`AGENTS.md`** for the publish workflow.

## Layout

```text
C/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
00-intro … 15-advanced, 99-workbook (examples/exercises/projects), 100-appendices.

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh C      # update-index + quarto render (this book only)
# ./renderpub.sh      # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …). Order is the numeric prefix.
3. Chapter order inside a part = lexicographic filename order.
4. Dirs starting with `_` are ignored by the index script.
5. Sidebar titles come from YAML `title:`, else the first `#` heading.
6. HTML title block shows **Published** (`book.date`) and **Updated** (`date-modified`).

New books should start from root **`Template/`**, not `_archive/templates/Template.backup/`.

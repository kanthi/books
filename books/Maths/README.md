# Maths

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Maths/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
00-Intro,01-Arithmetic,02-Geometry,03-Pre-Algebra,04-Algebra,05-LinearAlgebra,06-DiscreteMathematics,07-Statistics,08-Calculus,09-Number-Theory,10-Information-Theory,11-Optimization,12-Machine-Learning-Math,13-Algorithms-Complexity,14-Graph-Theory,15-Numerical-Methods,16-Data-Science-Math,17-Probability-Advanced,18-Linear-Algebra-Advanced,19-Complexity-Theory,

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Maths      # update-index + quarto render (this book only)
# ./renderpub-codex-v2.sh      # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …). Order is the numeric prefix.
3. Chapter order inside a part = lexicographic filename order.
4. Dirs starting with `_` are ignored by the index script.
5. Sidebar titles come from YAML `title:`, else the first `#` heading.
6. HTML title block shows **Published** (`book.date`) and **Updated** (`date-modified`).

New books should start from root **`Template-New-1/`**, not `_archive/templates/Template.backup/`.

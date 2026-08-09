# Linux-ShellScripting-Bash

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Linux-ShellScripting-Bash/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
01-intro-to-shells,02-shell-scripting,03-bash-intro,04-variables,06-control,07-functions,98-Misc,99-Workbook,

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Linux-ShellScripting-Bash      # update-index + quarto render (this book only)
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

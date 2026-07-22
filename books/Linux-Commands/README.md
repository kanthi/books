# Linux-Commands

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Linux-Commands/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
00-help-documentation,01-file-directory-management,02-archiving-compression,03-system-information,04-process-management,05-system-monitoring,06-user-group-management,07-networking,08-filesystem-management,09-scheduling,10-logging,11-hardware-management,13-filesystem,14-archive,15-documentation,16-terminal,17-text-processing,18-network,19-process,20-performance,21-system-info,22-user-management,23-package-management,24-system-runtime,25-scheduling,26-logging,28-printing,99-miscellaneous,

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Linux-Commands      # update-index + quarto render (this book only)
# ./renderpub-codex-v2.sh      # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …). Order is the numeric prefix.
3. Chapter order inside a part = lexicographic filename order.
4. Dirs starting with `_` are ignored by the index script.
5. Sidebar titles come from YAML `title:`, else the first `#` heading.
6. HTML title block shows **Published** (`book.date`) and **Updated** (`date-modified`).

New books should start from root **`Template-New-1/`**, not `Template.backup/`.

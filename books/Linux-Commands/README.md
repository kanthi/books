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
00-help-and-docs, 01-files-and-paths, 02-archives-and-compression, 03-system-information, 04-processes-and-jobs, 05-system-monitoring, 06-users-and-groups, 07-networking, 08-scheduling, 09-logging, 10-hardware, 11-storage-and-filesystems, 12-terminals-and-mux, 13-text-and-pipes, 14-packages, 15-services-and-runtime, 16-printing, 17-shell-commands, 99-appendices



Phase 1 (2026-07) removed duplicate parallel parts (`08`, `14`, `15`, `18`, `19`, `20`, `21`, `22`, `25`, `26`) after merging the better page bodies into the primary parts. See `content/_planning/phase1-dedupe.log`.

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

New books should start from root **`Template-New-1/`**, not `_archive/templates/Template.backup/`.

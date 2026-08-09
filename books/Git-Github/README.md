# Git-Github

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Git-Github/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
00-Intro,01-Introduction,02-Git-Fundamentals,03-Core-Operations,04-Git-Internals,05-Branching,06-Merging,07-Advanced-Branching,08-Remotes,09-GitHub-Intro,10-Collaboration,11-Rewriting-History,12-Advanced-Commands,13-Hooks-Automation,14-Troubleshooting,15-GitHub-Actions,16-GitHub-Advanced,17-Open-Source,18-Team-Collaboration,19-Enterprise,20-Advanced-Topics,21-Misc,

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Git-Github      # update-index + quarto render (this book only)
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

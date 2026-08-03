# Go

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
Go/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Parts under `content/` (ignored dirs start with `_`):  
01-foundations,02-core,03-memory,04-generics,05-errors,06-testing,07-concurrency-parallelism,08-web,09-performance-tooling,10-infrastructure,11-security,12-specialized,13-network-systems,14-systems-programming,15-distributed-infra,16-observability-sre,17-security-hardening,18-performance-engineering,19-modern-go-book-synthesis,20-go-deep-dives,21-concurrency-ground-up,98-stdlib,99-projects,

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Go      # update-index + quarto render (this book only)
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

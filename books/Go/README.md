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

Parts under `content/` (numeric prefixes dictate order, ignored dirs start with `_`):  
`01-foundations` … `06-testing` (Language Basics)  
`07-stdlib` … `09-cli-tools-in-go` (Stdlib, DSA, CLI Tools)  
`10-concurrency-ground-up` … `11-concurrency-parallelism` (Concurrency Mastery)  
`12-socket-programming` … `14-network-performance` (Sockets & Network Performance)  
`15-web-development-in-go` … `16-web` (Web & API Architectures)  
`17-systems-programming` … `20-infrastructure` (Systems, Distributed Infra, SRE, Cloud)  
`21-security` … `24-performance-engineering` (Security & Performance Engineering)  
`25-go-deep-dives` … `28-specialized` (Runtime Internals, Longevity, Synthesis, Frontiers)  
`99-projects` (46 Hands-on Capstone Projects) & `100-appendices` (Glossary & Reference)

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh Go      # update-index + quarto render (this book only)
# ./renderpub.sh      # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …). Order is the numeric prefix.
3. Chapter order inside a part = lexicographic filename order.
4. Dirs starting with `_` are ignored by the index script.
5. Sidebar titles come from YAML `title:`, else the first `#` heading.
6. HTML title  block shows **Published** (`book.date`) and **Updated** (`date-modified`).

New books should start from root **`Template/`**, not `_archive/templates/Template.backup/`.

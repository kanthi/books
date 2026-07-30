# 30DaysOfX

Quarto book in the multi-book monorepo. An intensive 30-day condensation of 90DaysOfX — each day combines ~3 original chapters for accelerated learners.

Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
30DaysOfX/
├── index.qmd                 # Book landing page
├── content/                  # Chapters by part (numeric prefixes)
│   ├── 00-program/           # Series rules
│   ├── 01-go/                # Volume 1 — Go (30 days)
│   ├── 02-nixos/             # Volume 2 — NixOS (30 days)
│   └── 03-maths/             # Volume 3 — Maths (30 days)
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh 30DaysOfX         # update-index + quarto render (this book only)
```

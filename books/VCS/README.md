# VCS

Quarto book on **version control**. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
VCS/
├── index.qmd                 # Book landing page
├── content/
│   └── 01-git/               # Part: Git (+ GitHub, forge extras)
│       ├── 00-Intro/ …
│       ├── 01-Introduction/ …
│       └── 21-Misc/          # Gitea, GitLab, Jujutsu, …
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Sidebar: **Git** part → topic sections → chapter pages.

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh VCS      # update-index + quarto render (this book only)
# ./renderpub.sh      # full library portal (what CI runs)
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-git`, future `02-…`).
3. Sections under a part = second-level dirs (`00-Intro`, `05-Branching`, …).
4. Chapter order inside a section = lexicographic filename order.
5. Dirs starting with `_` are ignored by the index script.
6. Sidebar titles come from YAML `title:`, else the first `#` heading.

# VCS

Quarto book on **version control**. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
VCS/
├── index.qmd                 # Book landing page
├── content/
│   ├── 01-git/               # Part: Git (mental model → recovery)
│   ├── 02-github/            # Part: GitHub the product (seeds; expand later)
│   ├── 03-jj/                # Part: Jujutsu (seed; full part later)
│   ├── 04-forges/            # Part: GitLab, Gitea
│   └── _planning/SYLLABUS.md
├── scripts/update-index.sh   # Regenerates _quarto.yml
├── styles/                   # HTML + EPUB themes
└── _quarto.yml               # GENERATED — do not hand-edit
```

Sidebar: **part** → topic section → chapter pages.

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
2. Parts = first-level dirs under `content/` (`01-git`, `02-github`, `03-jj`, `04-forges`).
3. Sections under a part = second-level dirs.
4. Chapter order inside a section = lexicographic filename order.
5. Dirs starting with `_` are ignored by the index script.
6. Sidebar titles come from YAML `title:`, else the first `#` heading.
7. Do not send the reader to another library book for a concept this page needs.

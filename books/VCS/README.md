# VCS

Quarto book: **Architectures, Platforms, Operations, and GitOps**. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

## Layout

```text
VCS/
├── index.qmd                      # Book landing page (front matter)
├── content/
│   ├── 01-git-foundations/        # Part I chs 1–5 (prose + new stubs)
│   ├── 02-everyday-workflows/     # Part II chs 6–15 (prose + new stubs)
│   ├── 99-appendices/
│   └── _planning/SYLLABUS.md      # Full 63-chapter map
├── scripts/update-index.sh        # Regenerates _quarto.yml
├── styles/
└── _quarto.yml                    # GENERATED — do not hand-edit
```

Later parts (`02-everyday-workflows/` … `09-argo-rollouts/`) appear when a writing pass starts on them.

Sidebar: **part** → chapter section → pages.

## Local commands

From this directory:

```bash
bash scripts/update-index.sh   # after add/remove/rename under content/
quarto preview                 # live preview
```

From `books/`:

```bash
./indipub.sh VCS           # HTML only while content/_planning/html-only exists
./indipub.sh VCS --html    # same, explicit
```

PDF/EPUB return when `content/_planning/html-only` is deleted (core prose done). CI still builds all formats.

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/`.
3. Chapter = second-level dir; pages = files inside it.
4. Chapter order = lexicographic filename order.
5. Dirs starting with `_` are ignored by the index script.
6. Sidebar titles come from YAML `title:`, else the first `#` heading.
7. Do not send the reader to another library book for a concept this page needs.

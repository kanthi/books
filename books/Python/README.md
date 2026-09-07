# Python

Quarto book in the multi-book monorepo. Prefer the repository root **`AGENTS.md`** for the full publish workflow.

**Published sidebar today:** Basics only (`content/01-basics/`). Later parts are syllabus text on `index.qmd` and `content/_planning/syllabus.md` — do not add empty part directories for them.

This book is **independent** of the other titles. A reader never needs Linux, Maths, Networking, or any sibling book.

## Layout

```text
Python/
├── index.qmd                 # Landing: start here + later syllabus
├── content/01-basics/        # Only published part
├── content/_planning/        # Unpublished syllabus + chapter template
├── scripts/update-index.sh
├── styles/
└── _quarto.yml               # GENERATED — do not hand-edit
```

## Local commands

From this directory:

```bash
bash scripts/update-index.sh
quarto preview
```

From `books/`:

```bash
./indipub.sh Python
```

## Content rules

1. Do **not** hand-edit `_quarto.yml`; re-run `scripts/update-index.sh`.
2. Parts = first-level dirs under `content/` (`01-name`, …).
3. Dirs starting with `_` are ignored.
4. Sidebar titles come from YAML `title:` or the first `#` heading.
5. Python **3.14**, `uv`, original prose, full runnable `# name.py` files.
6. No type hints in Basics.

# Gemini Repository Memory & Instructions

**Canonical agent memory:** see root **`AGENTS.md`** (workflow, CI, scripts, conventions).
Book-local ordering rules: **`books/AGENTS.md`**.

This file is kept as a short pointer so older tooling that looks for `Gemini.md` still finds guidance.

## Quick rules

- Do **not** hand-edit `_quarto.yml`; regenerate with `scripts/update-index.sh`.
- Full library build / portal: `books/renderpub.sh` (what CI runs).
- Single book: `books/indipub.sh <BookName>`.
- Content lives under `books/<BookName>/content/` with numeric prefixes for order.
- `published_books/` and `_book/` are gitignored build artifacts.
- New books: copy **`Template/`** (not `Template.backup/`).

# Chapter page template (not published)

Use this shape for real chapters. Orientation indexes may be shorter (overview + planned table only).

```markdown
---
title: "Short sidebar title"
---

# Heading matching the title

One sentence: what the reader can do after this page.

## Mental model

ASCII first. Optional conceptual SVG (`images/diagram-concept-*.svg`).

## Minimal example

A **complete file** the reader can save and run (`# name.py` on line 1, then `uv run python name.py`). No leftover names from earlier blocks.

## Worked examples

Named cases. Each is a complete file. Show how to run it, the output, and *why*.

## Pitfalls

What breaks, and the usual fix.

## Python + CS / Python + maths

Optional. One short experiment or observation *in this book*. Never send the reader to another title.

## Exercises

3–8 items. Some with a one-line check.

## Further reading

Docs, PEPs, named books — never pasted third-party text.
```

Rules:

- Original prose only.
- Prefer Python 3.14.
- Type hints after the first syntax pass, not on day one of Part 01.
- This book is independent. Do not reteach other titles; do not require them; do not send the reader there.
- Path A assumes no prior Python. Define jargon on first use. Prefer short sentences.
- Prefer named worked examples (input, output, *why*) over one dense dump. Add a second or third example when the first only covers the happy path.
- Every `python` teaching block is a **full runnable file**: first line `# name.py`, self-contained, `print` (or `assert`) so running it shows something. Use `if __name__ == "__main__":` when the file defines functions. Keep `pycon` for REPL exploration only.
- After a runnable file, show the command and the expected output in a `text` block.

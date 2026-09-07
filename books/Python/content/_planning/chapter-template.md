# Chapter page template (not published)

Use this shape for Basics (and later parts when they exist).

```markdown
---
title: "Short sidebar title"
---

# Heading matching the title

One sentence: what the reader can do after this page.

## Mental model

ASCII first.

## Minimal example

A **complete file** (`# name.py` on line 1, then `uv run python name.py`).

## Worked examples

Named cases. Each is a complete file. Show the command, the output, and *why*.

## Pitfalls

What breaks, and the usual fix.

## Exercises

3–8 items. Some with a one-line check.

## Further reading

Docs, PEPs, named books — never pasted third-party text.
```

Rules:

- Original prose only. Python 3.14. Toolchain `uv`.
- No type hints in Basics.
- Independent of other titles. Define jargon on first use.
- Teaching blocks are full runnable files. Use `pycon` only for the REPL.

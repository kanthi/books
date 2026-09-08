# Chapter style (agents writing Boring-Python)

## Hard rules

1. Original prose. Do not copy `books/Python/` or `books/Boring-Go/` chapter text.
2. Standalone book: never “see the Python book / Linux book / Boring Go”.
3. **No `.py` files on disk.** Every program lives in the `.qmd` as a fenced block.
4. Every listing the reader is told to run is a **complete** program (or a complete test file). Include all imports.
5. First line of a Python fence is a filename comment: `# hello.py` or `# test_desk.py`.
6. After the fence, show the exact command and the exact output in their own fences.
7. Python **3.14**. Toolchain **`uv run python file.py`**. Tests: **`uv run pytest`**. Format/lint: **`ruff`**.
8. Four-space indent. `if __name__ == "__main__":` on scripts.
9. **No type annotations until part 09-typing.** After that, annotations are allowed and encouraged where they help.
10. Define terms on first use. Short sentences. No filler.

## Chapter skeleton

```yaml
---
title: "Human Title"
---

# Human Title

One-paragraph claim: the boring default and why it wins.

## Mental model
...

## Worked examples

### Case 1: …
Save as `name.py`:

```python
# name.py
def main():
    print("ok")


if __name__ == "__main__":
    main()
```

Run:

```bash
uv run python name.py
```

Output:

```
ok
```

## The trap
A complete program that demonstrates the bug, then the fix.

## The boring rule
Bullet list of what to do at work.

## Try this
2–4 exercises. Each names the file to start from and what to change.
```

## Size

- 3–6 complete programs per teaching chapter.
- ~150–400 lines of `.qmd`.
- Recurring domain: a small **desk** (orders, tickets, shifts, prices). Each listing still runs alone.

## YAML

Always set `title:` matching the `#` heading.

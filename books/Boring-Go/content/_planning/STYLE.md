# Chapter style (agents writing Boring-Go)

## Hard rules

1. Original prose. Do not copy `books/Go/` chapters or golang.college text.
2. Standalone book: never “see the Go book / Linux book / Maths book”.
3. **No `.go` files on disk.** Every program lives in the `.qmd` as a fenced block.
4. Every Go listing that the reader is told to run is a **complete** `package main` program or a complete `_test.go` file. Include all imports.
5. First line of a Go fence is a filename comment: `// hello.go` or `// desk_test.go`.
6. After the fence, show the exact command and the exact output in their own fences.
7. Go 1.27. Early chapters stay classic (no generics until part 09). From control-flow onward, `for i := range n` is fine. Use `log/slog` in the logging chapter, not `log` as the recommended default.
8. gofmt style: tabs in Go code, not spaces.
9. Define terms on first use. Short sentences. No filler.

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
Save as `name.go`:

```go
// name.go
package main
...
```

Run:

```bash
go run name.go
```

Output:

```
...
```

### Case 2: …
...

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

Always set `title:` matching the `#` heading (minus `{.unnumbered}`).

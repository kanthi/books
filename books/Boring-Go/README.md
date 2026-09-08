# Boring Go

Linear, example-heavy Go book: write clear, explicit, maintainable programs.

- **Baseline:** Go 1.27
- **Toolchain:** `go` (modules, `gofmt`, `go vet`, `go test`)
- **Examples:** complete runnable listings **inline in each chapter** — no separate `.go` tree

## Preview

From the monorepo `books/` directory:

```bash
cd /path/to/books
./indipub.sh Boring-Go
./indiprev.sh Boring-Go
```

Regenerate the sidebar after adding or renaming chapters:

```bash
cd Boring-Go
bash scripts/update-index.sh
```

Do not hand-edit `_quarto.yml`.

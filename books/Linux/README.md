# Linux

Combined monorepo book: **Commands + Editors + Bash**.

```text
Linux/
├── content/
│   ├── 01-commands/              # part → topic sections → command pages
│   │   ├── 00-help-and-docs …
│   │   ├── 16-shell-commands
│   │   ├── 17-security
│   │   └── 99-appendices
│   ├── 02-editors/               # part → editor sections → pages
│   └── 03-scripting/
│       └── 01-bash/              # section Bash → topic subsections → pages
├── scripts/update-index.sh
├── styles/
├── index.qmd                     # book intro (scope, template, parts map)
└── _quarto.yml                   # generated — do not hand-edit
```

## Scope (Commands)

Server CLI / Ubuntu-first. No desktop apps, GUI stores, or CUPS printing.

## Build

From `books/`:

```bash
./indipub.sh Linux
./indiprev.sh Linux
```

Regenerate sidebar only:

```bash
cd Linux && bash scripts/update-index.sh
```

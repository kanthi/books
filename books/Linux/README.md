# Linux

Combined monorepo book: **Commands + Editors + Bash**.

```text
Linux/
├── content/
│   ├── 01-commands/              # part → topic sections → command pages
│   ├── 02-editors/               # part → editor sections → pages
│   └── 03-scripting/
│       └── 01-bash/              # section Bash → topic subsections → pages
├── scripts/update-index.sh
├── styles/
├── index.qmd
└── _quarto.yml                   # generated — do not hand-edit
```


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

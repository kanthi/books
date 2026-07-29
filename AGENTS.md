# Agent Notes — Quarto Multi-Book Monorepo

Canonical workflow memory for this repository. Prefer this file over ad-hoc re-discovery.
Book-level ordering rules also live in `books/AGENTS.md`.

## What this repo is

A **multi-book Quarto monorepo**. Each book is a self-contained Quarto project under `books/`. A master script renders every book and assembles a single **library portal** (`books/published_books/index.html`) with cards for HTML / PDF / EPUB. GitHub Actions deploys that portal to the `gh-pages` branch.

- Remote: `https://github.com/kanthi/books.git`
- Author in generated configs: **K19G**

## Layout

| Path | Role |
|------|------|
| `books/<BookName>/` | One Quarto book |
| `books/<BookName>/content/` | Chapters (`.md` / `.qmd`), usually numbered parts |
| `books/<BookName>/scripts/update-index.sh` | **Generates** `_quarto.yml` from the filesystem |
| `books/<BookName>/_quarto.yml` | Generated config — **never hand-edit** |
| `books/<BookName>/styles/` | light/dark SCSS + epub CSS |
| `books/<BookName>/index.qmd` | Book landing page (always first chapter) |
| `books/<BookName>/_book/` | Local Quarto output (**gitignored**) |
| `books/published_books/` | Aggregated site artifact (**gitignored**; CI deploy source) |
| `Template-New-1/` | **Preferred** scaffold for a new book |
| `Template.backup/` | Legacy book scaffold (kept for reference only) |
| `.github/workflows/incremental.yml` | **Primary CI**: incremental build + deploy on push to `main` |
| `.github/workflows/main.yml` | Legacy full-rebuild workflow (manual `workflow_dispatch` only) |
| `books/scripts/gen-portal.sh` | Standalone portal regenerator (no book rendering) |

### Current books (as of last inventory)

`90DaysOfX`, `C`, `ContainerLabs`, `Git-Github`, `Go`, `Linux-Commands`, `Linux-Editors`, `Linux-ShellScripting-Bash`, `Maths`, `myHomelab`, `Networking`, `NixOS`, `Rust`

- **`90DaysOfX`**: multi-volume series container. Volumes are **independent** parts under `content/` (`01-go`, `02-nixos`, `03-maths`, …)—no required joint schedule. Standalone `Go` / `NixOS` / `Maths` books remain deeper libraries.

## Book vs volume naming (user language → path)

**Same topic names appear twice:** as a **standalone library book** and as a **volume inside `90DaysOfX`**. Agents **must** resolve the user’s wording to the correct path and **must ask** if ambiguous (e.g. bare “fix Go” / “NixOS chapter”).

### Rule of thumb

| User says… | Means… | Path |
|------------|--------|------|
| **`Go book`**, **`standalone Go`**, **`Go@lib`** | Standalone library | `books/Go/` |
| **`NixOS book`**, **`standalone NixOS`**, **`NixOS@lib`** | Standalone library | `books/NixOS/` |
| **`Maths book`**, **`standalone Maths`**, **`Maths@lib`** | Standalone library | `books/Maths/` |
| **`90DaysOfX`**, **`series`** | Series container only | `books/90DaysOfX/` |
| **`Go volume`**, **`90X Go`**, **`Volume 1`**, **`Go@90`** | Day-paced Go spine | `books/90DaysOfX/content/01-go/` |
| **`NixOS volume`**, **`90X NixOS`**, **`Volume 2`**, **`NixOS@90`** | Day-paced NixOS spine | `books/90DaysOfX/content/02-nixos/` |
| **`Maths volume`**, **`90X Maths`**, **`Volume 3`**, **`Maths@90`** | Day-paced Maths spine | `books/90DaysOfX/content/03-maths/` |

### Defaults when the user is ambiguous

1. Prefer **asking** which target (`@lib` vs `@90`) over guessing.
2. If they say **“Day N”**, **gate**, **Lab 0**, or **90-day path** → treat as a **volume** under `90DaysOfX`.
3. If they say **library**, **projects part**, **long-form**, or name advanced parts only in the standalone tree (e.g. Go `13-network-systems`, NixOS `99-projects`) → **standalone book**.
4. **Do not** silently edit both trees unless the user asks to sync or mirror.
5. **Do not** add cross-links between standalone `Go` / `NixOS` / `Maths` and `90DaysOfX` unless the user explicitly requests them (standalone books currently have **no** series links by policy).

### Roles (content shape)

| Kind | Role |
|------|------|
| **Standalone book** | Deep library / reference / large project set; **topic-organized** parts (not a day calendar). For **NixOS book** especially: normal chapters under `01-concepts/` … `08-capstone/` + `99-projects/` — **not** `day-01`…`day-90` filenames. |
| **Volume (`@90`)** | ~90-day-shaped curriculum: overview, syllabus, **day chapters**, gates, capstone under `90DaysOfX/content/0N-*/` |

## Critical rules

1. **Never hand-edit `_quarto.yml`** inside a book. It is overwritten by `scripts/update-index.sh`.
2. After adding/removing/renaming content files or folders, run that book's `update-index.sh` (or a full render script that calls it).
3. **Primary CI** is `incremental.yml` (push-triggered, per-book). Full-rebuild fallback is `main.yml` (manual only).
4. **Full-build script** is `books/renderpub-codex-v2.sh` (not the older `renderpub.sh`).
5. `published_books/` and `_book/` are build artifacts — do not commit them.
6. Older scripts (`renderpub.sh`, `renderpub-codex.sh`, `renderpub-indi-codex.sh`, `renderpub_backup*.sh`) may still be in the tree; treat them as legacy unless the user says otherwise.
7. Live books under `books/` share the **Template-New-1 shell**: `scripts/update-index.sh` (GitHub link, `date-modified` + “Updated” label, `epub.css`), monorepo README, no per-book `.github/`, no `render_all_books.sh`.

## Content conventions

Documented in detail in `books/AGENTS.md`. Summary:

1. `index.qmd` is always the first chapter.
2. Book **parts** = first-level directories under `content/`.
3. Part order = numeric prefixes on directory names (`01-`, `02-`, …, `99-`).
4. Chapter order inside a part = lexicographic filename order (use `01-*.qmd`, `02-*.qmd`, …).
5. `index.qmd` / `index.md` inside a part is emitted first within that part.
6. Directories starting with `_` are ignored by part discovery (e.g. planning folders).
7. Root-level files directly under `content/` are **not** auto-included as chapters.
8. Titles for sidebar entries come from YAML frontmatter `title:`, else first `#` heading, else the path name.

## Build & publish pipeline

### Incremental pipeline (CI default — `incremental.yml`)

```
push to main
    │
    ▼
┌─ detect ─────────────────────────┐
│  git diff → changed books/dirs   │  ~10 sec
└──────────────┬───────────────────┘
    ┌──────────┼──────────┐
    ▼          ▼          ▼
┌─ render ─┐┌─ render ─┐┌─ render ─┐
│  Book A  ││  Book B  ││  Book C  │  parallel matrix
│  only    ││  only    ││  only    │  ~3-5 min each
└────┬─────┘└────┬─────┘└────┬─────┘
     └───────────┼───────────┘
                 ▼
┌─ assemble ───────────────────────┐
│  prev gh-pages + overlay changed │
│  prune deleted → gen-portal.sh   │  ~30 sec
│  deploy to gh-pages              │
└──────────────────────────────────┘
```

Change detection: compares `github.event.before..HEAD` via `git diff`.
Infrastructure changes (workflow, `renderpub-codex-v2.sh`, `gen-portal.sh`, `Template-New-1/`) trigger a full rebuild of all books.
`workflow_dispatch` with `force_all` checkbox also triggers full rebuild.

### Full-rebuild pipeline (manual — `main.yml`)

```
content/**  →  update-index.sh  →  _quarto.yml
                                    ↓
                              quarto render  →  _book/
                                    ↓
                         renderpub-codex-v2.sh
                                    ↓
              published_books/{html,pdf,epub,assets,index.html}
                                    ↓
                    GitHub Actions → gh-pages branch
```

### Master script (`books/renderpub-codex-v2.sh`)

Run from `books/`:

```bash
cd books
./renderpub-codex-v2.sh
```

For each subdirectory that contains `_quarto.yml`:

1. Run `scripts/update-index.sh` if present
2. `quarto render`
3. Generate SVG cover into `published_books/assets/<BookName>.svg`
4. Copy `_book/*` → `published_books/html/<BookName>/`
5. Copy PDF/EPUB if present → `published_books/pdf|epub/`
6. Append a card entry for the portal `index.html`

Portal features: search filter, light/dark theme toggle, format links (HTML/PDF/EPUB).

### Single-book local render

```bash
cd books
./indipub.sh <BookName>
```

Runs update-index + `quarto render` only (does **not** rebuild the portal).

### Single- or multi-book local preview (Safari)

```bash
cd books
./indiprev.sh <BookName>              # static serve of _book/ (fast)
./indiprev.sh Go NixOS Maths          # several books; ports 4242+
./indiprev.sh Go --live               # quarto preview live reload
./indipub.sh Go && ./indiprev.sh Go   # rebuild then open Safari
```

Default is **static** (`python3 -m http.server` on `_book/`), waits for HTTP ready, opens Safari at `http://localhost:<port>/`. Use `--live` for Quarto live reload. See root `README.md` for flags.

### Per-book index refresh only

```bash
cd books/<BookName>
bash scripts/update-index.sh
```

## CI / deployment

### Primary: `.github/workflows/incremental.yml`

- **Triggers:** push to `main` (paths: `books/**`, workflow file), `workflow_dispatch` (with `force_all` option)
- **Quarto version:** `1.3.450`
- **Deps:** pandoc + texlive packages (for PDF) + librsvg2-bin
- **Jobs:** `detect` → `render` (parallel matrix per changed book) → `assemble` + deploy
- **Deploy:** `peaceiris/actions-gh-pages` to `gh-pages` (`force_orphan: false` — preserves history)
- **Portal:** `books/scripts/gen-portal.sh` regenerates `index.html` from `published_books/` contents
- **Concurrency:** cancels in-flight runs for the same branch

### Fallback: `.github/workflows/main.yml`

- **Triggers:** `workflow_dispatch` only (push trigger **disabled**)
- **Quarto version:** `1.3.450`
- **Deps:** pandoc + texlive packages (for PDF) + librsvg2-bin
- **Build:** `cd books && ./renderpub-codex-v2.sh` (all books sequentially)
- **Deploy:** `peaceiris/actions-gh-pages` to `gh-pages` (`force_orphan: true`)

## Creating a new book

Prefer **`Template-New-1/`** (sample `content/`, accurate monorepo README, no per-book CI).
Legacy scaffold is kept as **`Template.backup/`** — do not use it for new books.

```bash
cp -r Template-New-1 books/My-New-Book
# Edit index.qmd; add/replace content under content/<NN-part>/...
cd books/My-New-Book && bash scripts/update-index.sh
cd ../ && ./indipub.sh My-New-Book   # optional local test
```

On the next full CI run (or local `renderpub-codex-v2.sh`), the new book appears on the portal automatically if it has `_quarto.yml`.

## Common agent tasks

| Task | Approach |
|------|----------|
| Add a chapter | Create file under the right `content/<part>/` with numeric prefix; run `update-index.sh` |
| Reorder chapters | Rename with numeric prefixes; run `update-index.sh` |
| Add a part | New `content/NN-name/` directory; run `update-index.sh` |
| Fix sidebar title | Edit chapter YAML `title:` or first `#` heading; re-run `update-index.sh` |
| Style changes | Edit `styles/light.scss` / `styles/dark.scss` (or shared patterns); not `_quarto.yml` by hand |
| Portal / cover / aggregate bugs | Edit `books/scripts/gen-portal.sh` (incremental) or `books/renderpub-codex-v2.sh` (full) |
| CI changes (incremental) | Edit `.github/workflows/incremental.yml` |
| CI changes (full rebuild) | Edit `.github/workflows/main.yml` |
| Regenerate portal only (no render) | `cd books && bash scripts/gen-portal.sh` |

## Related docs

| File | Purpose |
|------|---------|
| `README.md` | Human project overview (may lag slightly vs CI script name) |
| `books/AGENTS.md` | Quarto generation + ordering rules; myHomelab notes |
| `Gemini.md` | Shorter legacy agent memory — prefer **this** file as canonical |

## Defaults for future sessions

- **CI** is handled by two workflows: `incremental.yml` (push-triggered, per-book) is the default; `main.yml` (manual full rebuild) is the fallback.
- Prefer **`renderpub-codex-v2.sh`** for local full library builds.
- Prefer **`indipub.sh <Book>`** for single-book one-shot render.
- Prefer **`indiprev.sh <Book>`** for local Safari preview (static `_book/`; use `--live` for Quarto reload).
- Prefer **`scripts/gen-portal.sh`** to regenerate just the portal `index.html` without rendering any books.
- Resolve **book vs volume** using **Book vs volume naming** above; ask if "Go" / "NixOS" / "Maths" is ambiguous.
- Do not re-explain this pipeline unless the user asks; assume it is known.
- Do not invent hand-maintained chapter lists in `_quarto.yml`.
- When unsure whether `_quarto.yml` is stale after content moves, regenerate it.

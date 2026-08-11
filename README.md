# Quarto Publishing Project Overview

Multi-book [Quarto](https://quarto.org/) monorepo. Each book under `books/` builds to HTML, PDF, and EPUB; a library portal is assembled under `books/published_books/` and deployed to GitHub Pages.

**Agent / maintainer notes:** root `AGENTS.md` (pipeline, naming). Illustrated SVG style: `includes/diagrams/STANDARD.md`.

## Prerequisites

Install these **before** rendering or previewing locally. CI installs its own toolchain on **Ubuntu** (see `.github/workflows/incremental.yml`).

**Primary authoring platforms:** macOS and Linux (bash scripts). **Windows:** use **WSL2 (Ubuntu)** for full parity, or Git Bash with limitations (below).

### What you need (all OSes)

| Tool | Why |
|------|-----|
| **Quarto** | Renders HTML / PDF / EPUB. **CI pins `1.3.450`**; local **1.4+ / 1.10.x** usually fine. |
| **Bash** | `books/indipub.sh`, `indiprev.sh`, `renderpub.sh`, each book’s `scripts/update-index.sh`. |
| **Python 3** | Preview server (`indiprev.sh`) and helpers (`python3` on `PATH`). |
| **Git** | Clone and CI change detection. |
| **TeX (TinyTeX or TeX Live)** | PDF via LuaLaTeX / related engines. Put `lualatex` + `tlmgr` on `PATH`. |
| **`rsvg-convert` (librsvg)** | Quarto converts SVG figures → PDF. Without it, topology diagrams fail or look wrong in PDF. |

HTML-only can skip TeX:

```bash
cd books/<BookName>
quarto render --to html
```

Pandoc is **bundled with Quarto** — no separate install. Node/Deno are managed by Quarto.

**TeX packages:** first PDF render may pull packages via `tlmgr` (network). Match `tlmgr`’s repository to your TeX Live **year** (frozen historic mirror if needed). CI package list: `ci/tinytex-packages.txt`; setup: `books/scripts/setup-ci-tinytex.sh`.

---

### macOS

**Recommended:** Homebrew + TinyTeX (or MacTeX if you already use it).

#### Install

```bash
# Package manager
# https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Quarto
brew install --cask quarto

# SVG → PDF (rsvg-convert)
brew install librsvg

# Python 3 (if missing)
brew install python

# Git (if missing)
brew install git

# TinyTeX — minimal TeX for PDF (pick one approach)
# A) Official TinyTeX: https://yihui.org/tinytex/
# B) Or full MacTeX: https://www.tug.org/mactex/  (large download)
```

#### PATH (required for TinyTeX)

After TinyTeX install, engines are often **not** on the default PATH:

```bash
# Apple Silicon / universal TinyTeX (common layout)
export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"

# Persist (zsh):
echo 'export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"' >> ~/.zshrc
# Also ensure Homebrew is on PATH (Apple Silicon):
# echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
```

Repo scripts prepend `/opt/homebrew/bin` automatically when present.

#### Verify & build

```bash
quarto --version
python3 --version
which rsvg-convert lualatex tlmgr
quarto check

cd books
./indipub.sh Networking          # HTML + PDF + EPUB
./indiprev.sh Networking         # HTTPS preview (Safari default)
./indiprev.sh Networking --browser "Google Chrome"
```

#### Preview notes (macOS)

- `indiprev.sh` defaults to **HTTPS** on localhost (Safari-friendly) and **Safari**.
- First visit may need to trust the local self-signed cert under `books/.preview-certs/`.
- OpenSSL/LibreSSL is usually already available.

---

### Linux

**Recommended:** same shape as CI (Ubuntu/Debian). Other distros: use equivalent packages.

#### Ubuntu / Debian

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  curl ca-certificates git python3 \
  librsvg2-bin unzip xz-utils

# Quarto: install the .deb from https://quarto.org/docs/get-started/
# Example (check site for current version/arch):
# curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.deb
# sudo dpkg -i quarto-1.3.450-linux-amd64.deb

# TinyTeX (user-local; matches CI idea) — https://yihui.org/tinytex/
# or system TeX Live:
# sudo apt-get install -y texlive-xetex texlive-luatex texlive-latex-recommended texlive-fonts-recommended
```

Fedora/RHEL-style (approximate):

```bash
sudo dnf install -y git python3 librsvg2 curl
# Quarto: .tar.gz or package from quarto.org
# TeX: sudo dnf install -y texlive-scheme-basic   # or TinyTeX
```

Arch-style (approximate):

```bash
sudo pacman -S git python librsvg
# yay/paru or manual: quarto-bin; texlive-basic or TinyTeX
```

#### PATH (TinyTeX on Linux)

```bash
# After TinyTeX install, bin is typically:
export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH"
# arm64:
# export PATH="$HOME/.TinyTeX/bin/aarch64-linux:$PATH"

# Persist:
echo 'export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH"' >> ~/.bashrc
```

#### Verify & build

```bash
quarto --version
python3 --version
which rsvg-convert lualatex tlmgr
quarto check

cd books
./indipub.sh Networking
./indiprev.sh Networking --browser "firefox"   # or chromium
# or plain HTTP if preferred:
./indiprev.sh Networking --http --browser "firefox"
```

#### Preview notes (Linux)

- `indiprev.sh` still works; pass `--browser` (no Safari).
- OpenSSL is usually present via `openssl` package if cert generation is needed.

#### CI parity

GitHub Actions (Ubuntu) roughly: Quarto **1.3.450**, TinyTeX + `ci/tinytex-packages.txt`, `librsvg2-bin`. Local Ubuntu with the same stack is the closest match to production builds.

---

### Windows

**Recommended path: WSL2 + Ubuntu.** The monorepo’s build/preview scripts are **bash**. Native PowerShell is not a first-class path for `indipub.sh` / `renderpub.sh`.

#### Option A — WSL2 (recommended)

1. Install **WSL2** and an Ubuntu distro (Microsoft Store or `wsl --install`).
2. Open the Ubuntu shell and follow the **Linux (Ubuntu / Debian)** section above.
3. Clone or open the repo **inside the Linux filesystem** (e.g. `~/src/books`) for best I/O performance — avoid building only from `/mnt/c/...` if possible.
4. Run builds from the WSL shell:

```bash
cd /path/to/repo/books
./indipub.sh Networking
./indiprev.sh Networking --http --browser ""   # open the printed URL from Windows browser if needed
# or: quarto preview books/Networking
```

Quarto and TeX should be installed **inside WSL**, not only on Windows, so `PATH` is consistent.

#### Option B — Native Windows (limited)

| Piece | How |
|-------|-----|
| **Git for Windows** | Provides **Git Bash** so you can run `./indipub.sh` / `update-index.sh`. |
| **Quarto** | [Windows installer](https://quarto.org/docs/get-started/) — ensure “Add to PATH”. |
| **Python 3** | [python.org](https://www.python.org/downloads/) or `winget install Python.Python.3.12` — enable “Add to PATH”; use `python` / `py` if `python3` is missing. |
| **TinyTeX / TeX Live** | [TinyTeX](https://yihui.org/tinytex/) or [TeX Live for Windows](https://tug.org/texlive/). Add the TinyTeX `bin/windows` directory to the **User PATH**. |
| **rsvg-convert** | Easiest via **MSYS2** (`pacman -S mingw-w64-x86_64-librsvg`) or a Scoop/Chocolatey package that ships `rsvg-convert`. Must be on PATH for PDF figures. |

Example Git Bash session:

```bash
# Git Bash
cd /c/Users/you/src/books/books
export PATH="/c/Program Files/Quarto/bin:$PATH"
# Add TinyTeX and rsvg bins as installed:
# export PATH="$HOME/AppData/Roaming/TinyTeX/bin/windows:$PATH"

quarto --version
./indipub.sh Networking
```

#### Windows preview caveats

- `indiprev.sh` is oriented toward macOS Safari/HTTPS; on Windows prefer:
  - `quarto preview` from the book directory, or
  - WSL + `--http` and open the URL in Edge/Chrome.
- Line endings: keep shell scripts as LF (`git config core.autocrlf input` recommended for this repo).

#### Not supported as a first-class path

- Running `indipub.sh` from **cmd.exe** / pure PowerShell without Bash.
- Expecting CI’s exact Ubuntu TinyTeX layout under native Windows without adjusting PATH.

---

### Environment variables (all platforms)

| Variable | Purpose |
|----------|---------|
| `PATH` | Must include Quarto, TeX (`lualatex`/`tlmgr`), and `rsvg-convert`. |
| `QUARTO_DENO_HEAP_MB` | Raise Deno heap for large books (e.g. `6144`); `indipub.sh` sets a high default. |
| `QUARTO_DENO_V8_OPTIONS` / `QUARTO_DENO_EXTRA_OPTIONS` | Advanced V8 flags; see comments in `books/indipub.sh` (differs Quarto 1.3 vs 1.4+). |

### What you do *not* need

- Per-book Node projects.
- Hand-edited `_quarto.yml` chapter lists — run each book’s `scripts/update-index.sh`.
- Committing `_book/` or `published_books/` (gitignored build artifacts).

### Sanity checklist (macOS / Linux / WSL)

```bash
cd books
quarto --version && python3 --version
which rsvg-convert
which lualatex && lualatex --version | head -1

./indipub.sh Networking    # single book: HTML + PDF + EPUB
./indiprev.sh Networking   # preview (adjust --browser on Linux/Windows)
```

### Troubleshooting (common)

| Symptom | Likely fix |
|---------|------------|
| PDF hangs on “updating existing packages” | `tlmgr` cannot reach its repo — fix network/mirror (historic TL year if frozen). |
| PDF figures solid black | SVG used CSS `var()` — use literal hex (`includes/diagrams/STANDARD.md`). |
| PDF figures blurry | SVG used filters (`feDropShadow`) — remove filters for pure vector PDF. |
| `lualatex: command not found` | TeX bin not on `PATH` (see OS section). |
| `rsvg-convert: command not found` | Install librsvg (`brew install librsvg` / `librsvg2-bin` / MSYS2). |
| Scripts fail on Windows | Use WSL2 or Git Bash; ensure LF line endings. |

---

## 1. Project Structure

The project is designed to host and publish multiple technical books (or documentation sets) using [Quarto](https://quarto.org/).

### Key Directories
- **`/books`**: Book projects only (e.g. `Networking`, `Go`). Each subdir with `_quarto.yml` is a book — not shared tooling.
- **`/ci`**: CI / PDF TeX assets (TinyTeX version, package list, Font Awesome zip). **Not a book.**
- **`/includes`**: Shared monorepo assets (diagram standard, analytics snippet, highlight themes). **Not a book.**
- **`/Template`**: Preferred scaffold for creating new books.
- **`/_archive`**: Legacy render scripts, old template, and retired docs (reference only).
- **`/.github`**: Contains GitHub Actions workflows for automated deployment.

### Book Structure (e.g., inside `/books/Linux`)
Each book generally follows this pattern:
- **`content/`**: (Expected) Contains the actual Markdown (`.md`) or Quarto (`.qmd`) source files, organized by folders (chapters/parts).
- **`scripts/`**:
    - `update-index.sh`: A helper script that scans the `content` directory and automatically generates the navigation structure in `_quarto.yml`.
- **`_quarto.yml`**: The Quarto configuration file (often generated/updated by scripts).
- **`styles/`**: Custom CSS/SCSS for styling the book.

## 2. Rendering Workflow

The rendering process is automated via shell scripts that handle indexing, building, and aggregating output.

### Main Scripts (in `/books`)

Run these from the **`books/`** directory.

0.  **`scripts/gen-portal.sh` (Portal Generator)**:
    - Regenerates `published_books/index.html` and SVG book covers by scanning the `published_books/` tree.
    - Does **not** render any books — only rebuilds the portal page.
    - Used by the incremental CI pipeline (`incremental.yml`) after overlaying changed books.
    - Can also be run locally: `bash scripts/gen-portal.sh` (from `books/`).

1.  **`renderpub.sh` (Master Build / CI path of record)**:
    - **Iterates** through all subdirectories in `books/` looking for `_quarto.yml`.
    - **Updates Index**: Calls `scripts/update-index.sh` for each book to ensure the navigation reflects the latest content.
    - **Renders**: Runs `quarto render` to build HTML, PDF, and EPUB formats.
    - **Publishes**:
        - Copies output to `books/published_books/`.
        - Generates a **custom SVG book cover** for each book dynamically.
        - Updates the main `index.html` portal to list all rendered books.
    - Older full-library scripts live under **`_archive/scripts/`**; do not use them for normal builds.

2.  **`indipub.sh` (Single Book Build)**:
    - Usage: `./indipub.sh <book_name>`
    - Runs that book’s `scripts/update-index.sh` (if present), then `quarto render`.
    - Target for testing or updating a **single** book without rebuilding the entire library.
    - Does **not** rebuild the portal under `published_books/`.

3.  **`indiprev.sh` (Local Preview + Safari)**:
    - Usage: `./indiprev.sh <book> [book2 ...] [options]`
    - **HTTPS by default** (`https://localhost:<port>/`) because Safari often blocks plain HTTP. Uses a local self-signed cert in `books/.preview-certs/` (auto-created; gitignored). First visit: Safari may ask you to **Visit Website** / trust the cert once.
    - **Default (static):** HTTPS serve of each book’s `_book/` (fast if already built).
    - **Live (`--live`):** Quarto on an internal HTTP port + HTTPS reverse proxy on the public port.
    - Multi-book: ports `4242`, `4243`, … Ctrl-C stops all.

    ```bash
    cd books

    # Recommended: HTTPS static preview in Safari
    ./indiprev.sh Go
    ./indiprev.sh Go NixOS Maths

    # After editing content: rebuild then preview
    ./indipub.sh Go && ./indiprev.sh Go

    # Live reload over HTTPS (slower first open)
    ./indiprev.sh Go --live

    # Options
    ./indiprev.sh Go --port 4500
    ./indiprev.sh Go --browser "Google Chrome"
    ./indiprev.sh Go --no-browser
    ./indiprev.sh Go --http                 # plain HTTP (not for Safari https-only)
    ./indiprev.sh Go --live --update-index
    ```

    | Flag | Meaning |
    |------|---------|
    | *(default)* | HTTPS static serve of `_book/` |
    | `--live` | Quarto live reload behind HTTPS proxy |
    | `--http` | Plain HTTP (skip TLS; Safari may refuse) |
    | `--port <n>` | Public base port (default `4242`) |
    | `--update-index` | Run `scripts/update-index.sh` first |
    | `--render <fmt>` | Only with `--live` (default `none`) |
    | `--browser <name>` | macOS app (default **Safari**) |
    | `--no-browser` | Serve only; print URL when ready |

    **Safari:** wait for `Ready: Book -> https://localhost:…/` — the script opens the tab then. On the certificate warning, continue once for localhost. Leave the terminal open.

### Automation Helper
-   **`update-index.sh`**:
    - This is a critical utility found in most book directories.
    - It reads the file system hierarchy of `content/` and writes a fresh `_quarto.yml`, automating the tedious process of mapping files to sidebar/toc menus.
    - Called automatically by `indipub.sh` and the master render scripts; optional for `indiprev.sh` via `--update-index`.

## 3. Deployment (GitHub Actions)

Two workflows live under `.github/workflows/`:

### Incremental Pipeline (`incremental.yml`) — **default, push-triggered**

The **primary** CI path. Triggers on push to `main` (only for changes under `books/` or the workflow itself).

**3-stage pipeline:**

| Stage | What it does | Time |
|-------|-------------|------|
| **detect** | `git diff` between previous and current commit to find which `books/<Name>/` dirs changed | ~10 sec |
| **render** | Parallel matrix jobs — one per changed book. Each runs `indipub.sh <Book>` | ~3-5 min |
| **assemble** | Downloads previous `gh-pages` as baseline, overlays changed books, prunes deleted books, regenerates portal via `gen-portal.sh`, deploys | ~30 sec |

**Key features:**
- **Incremental** — a single-page edit only renders the affected book (~3-5 min total), not all 13 (~45 min).
- **Parallel** — multiple changed books render simultaneously (up to 4 concurrent).
- **Baseline preservation** — previous `gh-pages` is kept as a starting point; unchanged books are untouched.
- **Concurrency control** — a new push cancels any in-flight run for the same branch.
- **Prunes deleted books** — if a book directory is removed from the repo, it's cleaned from the deployed site.
- **Force rebuild** — use `workflow_dispatch` with the `force_all` checkbox to rebuild everything.
- **Infrastructure changes** (workflow file, `renderpub.sh`, `gen-portal.sh`, `Template/`) trigger a full rebuild of all books automatically.

### Full Rebuild (`main.yml`) — **manual only**

Legacy workflow, retained for manual full rebuilds of all books via `workflow_dispatch`.

1.  **Trigger**: Manual (`workflow_dispatch`) only — push trigger is disabled.
2.  **Setup**: Installs Quarto 1.3.450 and LaTeX (texlive) for PDF generation.
3.  **Build**: Executes `books/renderpub.sh` (renders **all** books sequentially).
4.  **Deploy**: Pushes `books/published_books` to `gh-pages` (`force_orphan: true`).

## Summary of Logic
1.  **Author** writes content in `books/<Topic>/content`.
2.  **Script** (`update-index.sh`) scans content tags and updates config.
3.  **Quarto** builds the book from config.
4.  **Master Script** collects all builds, makes a portal page, and deployment publishes it.

## 4. How to Create a New Book

Use **`Template`** (preferred). The older scaffold is preserved under **`_archive/templates/Template.backup/`**.

1.  **Copy the template** into `books/` and name the folder for the book:
    ```bash
    cp -r Template books/My-New-Book
    ```
    The folder name becomes the Quarto book title when you regenerate `_quarto.yml`.

2.  **Edit content**:
    -   Prefill lives under `content/` (e.g. `00-intro/`, `01-foundations/`).
    -   Add `.md` / `.qmd` chapters; use numeric prefixes for order.
    -   Optional notes go in `content/_planning/` (ignored by the index script).

3.  **Update configuration** (do not hand-edit `_quarto.yml`):
    ```bash
    cd books/My-New-Book
    bash scripts/update-index.sh
    ```

4.  **Render / preview**:
    ```bash
    cd books
    ./indiprev.sh My-New-Book         # live preview + open browser
    ./indipub.sh My-New-Book          # one-shot render (no portal)
    # ./renderpub.sh         # full library portal (what CI runs)
    ```

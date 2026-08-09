# Quarto Publishing Project Overview

## 1. Project Structure

The project is designed to host and publish multiple technical books (or documentation sets) using [Quarto](https://quarto.org/).

### Key Directories
- **`/books`**: The core directory containing all book projects. Each subdirectory (e.g., `Git-Github`, `Linux-Commands`) represents a separate book.
- **`/Template-New-1`**: Preferred scaffold for creating new books.
- **`/_archive`**: Legacy render scripts, old template, and retired docs (reference only).
- **`/.github`**: Contains GitHub Actions workflows for automated deployment.

### Book Structure (e.g., inside `/books/Linux-Commands`)
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

1.  **`renderpub-codex-v2.sh` (Master Build / CI path of record)**:
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
- **Infrastructure changes** (workflow file, `renderpub-codex-v2.sh`, `gen-portal.sh`, `Template-New-1/`) trigger a full rebuild of all books automatically.

### Full Rebuild (`main.yml`) — **manual only**

Legacy workflow, retained for manual full rebuilds of all books via `workflow_dispatch`.

1.  **Trigger**: Manual (`workflow_dispatch`) only — push trigger is disabled.
2.  **Setup**: Installs Quarto 1.3.450 and LaTeX (texlive) for PDF generation.
3.  **Build**: Executes `books/renderpub-codex-v2.sh` (renders **all** books sequentially).
4.  **Deploy**: Pushes `books/published_books` to `gh-pages` (`force_orphan: true`).

## Summary of Logic
1.  **Author** writes content in `books/<Topic>/content`.
2.  **Script** (`update-index.sh`) scans content tags and updates config.
3.  **Quarto** builds the book from config.
4.  **Master Script** collects all builds, makes a portal page, and deployment publishes it.

## 4. How to Create a New Book

Use **`Template-New-1`** (preferred). The older scaffold is preserved under **`_archive/templates/Template.backup/`**.

1.  **Copy the template** into `books/` and name the folder for the book:
    ```bash
    cp -r Template-New-1 books/My-New-Book
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
    # ./renderpub-codex-v2.sh         # full library portal (what CI runs)
    ```

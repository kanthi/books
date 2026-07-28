# Quarto Publishing Project Overview

## 1. Project Structure

The project is designed to host and publish multiple technical books (or documentation sets) using [Quarto](https://quarto.org/).

### Key Directories
- **`/books`**: The core directory containing all book projects. Each subdirectory (e.g., `Git-Github`, `Linux-Commands`) represents a separate book.
- **`/Template-New-1`**: Preferred scaffold for creating new books.
- **`/Template.backup`**: Legacy scaffold (kept for reference only).
- **`/.github`**: Contains GitHub Actions workflows for automated deployment.

### Book Structure (e.g., inside `/books/Linux-Commands`)
Each book generally follows this pattern:
- **`content/`**: (Expected) Contains the actual Markdown (`.md`) or Quarto (`.qmd`) source files, organized by folders (chapters/parts).
- **`scripts/`**:
    - `update-index.sh`: A helper script that scans the `content` directory and automatically generates the navigation structure in `_quarto.yml`.
    - `render_all_books.sh`: Local rendering script.
- **`_quarto.yml`**: The Quarto configuration file (often generated/updated by scripts).
- **`styles/`**: Custom CSS/SCSS for styling the book.

## 2. Rendering Workflow

The rendering process is automated via shell scripts that handle indexing, building, and aggregating output.

### Main Scripts (in `/books`)

Run these from the **`books/`** directory.

1.  **`renderpub-codex-v2.sh` (Master Build / CI path of record)**:
    - **Iterates** through all subdirectories in `books/` looking for `_quarto.yml`.
    - **Updates Index**: Calls `scripts/update-index.sh` for each book to ensure the navigation reflects the latest content.
    - **Renders**: Runs `quarto render` to build HTML, PDF, and EPUB formats.
    - **Publishes**:
        - Copies output to `books/published_books/`.
        - Generates a **custom SVG book cover** for each book dynamically.
        - Updates the main `index.html` portal to list all rendered books.
    - Older scripts (`renderpub.sh`, `renderpub-codex.sh`, …) may still exist; prefer **`renderpub-codex-v2.sh`** unless you have a reason not to.

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

The file `.github/workflows/main.yml` defines the CI/CD pipeline:
1.  **Trigger**: Pushes to `main`.
2.  **Setup**: Installs Quarto matching version 1.3.450 and LaTeX (texlive) for PDF generation.
3.  **Build**: Executes `books/renderpub-codex-v2.sh` (path of record).
4.  **Deploy**: Pushes the resulting `books/published_books` directory to the `gh-pages` branch, making the library available online.

## Summary of Logic
1.  **Author** writes content in `books/<Topic>/content`.
2.  **Script** (`update-index.sh`) scans content tags and updates config.
3.  **Quarto** builds the book from config.
4.  **Master Script** collects all builds, makes a portal page, and deployment publishes it.

## 4. How to Create a New Book

Use **`Template-New-1`** (preferred). The older scaffold is preserved as **`Template.backup`**.

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

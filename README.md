# Quarto Publishing Project Overview

## 1. Project Structure

The project is designed to host and publish multiple technical books (or documentation sets) using [Quarto](https://quarto.org/).

### Key Directories
- **`/books`**: The core directory containing all book projects. Each subdirectory (e.g., `Git-Github`, `Linux-Commands`) represents a separate book.
- **`/Template`**: A reference structure for creating new books.
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
1.  **`renderpub.sh` (Master Build Script)**:
    - **Iterates** through all subdirectories in `books/` looking for `_quarto.yml`.
    - **Updates Index**: Calls `scripts/update-index.sh` for each book to ensure the navigation reflects the latest content.
    - **Renders**: Runs `quarto render` to build HTML, PDF, and EPUB formats.
    - **Publishes**:
        - Copies output to `books/published_books/`.
        - Generates a **custom SVG book cover** for each book dynamically.
        - Updates the main `index.html` portal to list all rendered books.

2.  **`indipub.sh` (Single Book Build)**:
    - Usage: `./indipub.sh <book_name>`
    - Target for testing or updating a single book without rebuilding the entire library.

### Automation Helper
-   **`update-index.sh`**:
    - This is a critical utility found in most book directories.
    - It reads the file system hierarchy of `content/` and writes a fresh `_quarto.yml`, automating the tedious process of mapping files to sidebar/toc menus.

## 3. Deployment (GitHub Actions)

The file `.github/workflows/main.yml` defines the CI/CD pipeline:
1.  **Trigger**: Pushes to `main`.
2.  **Setup**: Installs Quarto matching version 1.3.450 and LaTeX (texlive) for PDF generation.
3.  **Build**: Executes `books/renderpub.sh`.
4.  **Deploy**: Pushes the resulting `books/published_books` directory to the `gh-pages` branch, making the library available online.

## Summary of Logic
1.  **Author** writes content in `books/<Topic>/content`.
2.  **Script** (`update-index.sh`) scans content tags and updates config.
3.  **Quarto** builds the book from config.
4.  **Master Script** collects all builds, makes a portal page, and deployment publishes it.

## 4. How to Create a New Book

To start a new book project:

1.  **Copy the Template**:
    Copy the `Template` directory into the `books/` directory and rename it to your desired book name (e.g., `My-New-Book`).
    ```bash
    cp -r Template books/My-New-Book
    ```

2.  **Add Content**:
    -   Create a `content` folder inside your new book directory if it doesn't exist.
    -   Add your Markdown (`.md`) or Quarto (`.qmd`) files into `content/`.
    -   Organize chapters by creating subdirectories within `content/`.

3.  **Update Configuration**:
    -   Run the update script to generate your `_quarto.yml` configuration based on your folder structure:
        ```bash
        cd books/My-New-Book/scripts
        ./update-index.sh
        ```

4.  **Render**:
    -   You can render just this book to test:
        ```bash
        # From the project root
        ./books/indipub.sh My-New-Book
        ```

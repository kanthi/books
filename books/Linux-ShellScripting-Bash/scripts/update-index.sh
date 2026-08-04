#!/usr/bin/env bash
# Generate _quarto.yml from content/ directory layout.
# Do not hand-edit _quarto.yml; re-run this script after structural changes.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOK_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT_DIR="$BOOK_DIR/content"
QUARTO_YML="$BOOK_DIR/_quarto.yml"
BOOK_NAME="$(basename "$BOOK_DIR")"

# Repo homepage used in the book navbar (monorepo).
REPO_URL="${BOOK_REPO_URL:-https://github.com/kanthi/books}"
BOOK_AUTHOR="${BOOK_AUTHOR:-K19G}"

if [ ! -d "$CONTENT_DIR" ]; then
  echo "error: content/ not found at $CONTENT_DIR" >&2
  echo "Create content/<NN-part>/ chapters, then re-run this script." >&2
  exit 1
fi

extract_qmd_title() {
  local file="$1"
  local title=""

  if [ -f "$file" ]; then
    # YAML frontmatter title: (first --- block only)
    title="$(awk '
      BEGIN { in_fm=0 }
      /^---[[:space:]]*$/ {
        if (in_fm == 0) { in_fm=1; next }
        else { exit }
      }
      in_fm && /^title:[[:space:]]*/ {
        sub(/^title:[[:space:]]*/, "")
        gsub(/^["'\'']|["'\'']$/, "")
        print
        exit
      }
    ' "$file")"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi

    # First markdown H1; strip optional Pandoc attrs like {.unnumbered}
    title="$(head -n 20 "$file" | grep -E '^#[[:space:]]+' | head -n 1 | sed -E 's/^#[[:space:]]+//')"
    title="${title%% \{*}"
    title="$(printf '%s' "$title" | sed -E 's/[[:space:]]+$//')"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi
  fi

  local dirname
  dirname="$(basename "$(dirname "$file")")"
  printf '%s\n' "$dirname" | sed -E 's/^[0-9]+-?//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1'
}

get_metadata() {
  local dir="$1"
  local dirname
  dirname="$(basename "$dir")"
  local order title

  if [[ $dirname =~ ^[0-9]+ ]]; then
    order="${BASH_REMATCH[0]}"
    title="$(echo "$dirname" | sed -E 's/^[0-9]+-?//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')"
  else
    order="99"
    title="$(echo "$dirname" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')"
  fi

  printf '%s|%s\n' "$order" "$title"
}

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

cat > "$TMP_FILE" <<EOL
project:
  type: book
  output-dir: _book

book:
  title: "$BOOK_NAME"
  author: "$BOOK_AUTHOR"
  date: last-modified
  navbar:
    pinned: true
    right:
      - icon: github
        href: $REPO_URL

  sidebar:
    style: docked
    collapse-level: 1
  chapters:
    - index.qmd
EOL

process_directory() {
  local dir="$1"
  local metadata order title
  metadata="$(get_metadata "$dir")"
  order="$(echo "$metadata" | cut -d'|' -f1)"
  title="$(echo "$metadata" | cut -d'|' -f2)"

  {
    echo "    - part: \"$title\""
    echo "      contents:"
  } >> "$TMP_FILE"

  local ext doc doc_name file_title subdir subdir_name relative_path

  for ext in qmd md; do
    if [ -f "$dir/index.$ext" ]; then
      file_title="$(extract_qmd_title "$dir/index.$ext")"
      {
        echo "        - text: \"$file_title\""
        echo "          file: content/$(basename "$dir")/index.$ext"
      } >> "$TMP_FILE"
    fi

    # Lexicographic order via sorted null-safe listing
    while IFS= read -r -d '' doc; do
      doc_name="$(basename "$doc")"
      [ "$doc_name" = "index.$ext" ] && continue
      file_title="$(extract_qmd_title "$doc")"
      {
        echo "        - text: \"$file_title\""
        echo "          file: content/$(basename "$dir")/${doc_name}"
      } >> "$TMP_FILE"
    done < <(find "$dir" -maxdepth 1 -type f -name "*.$ext" -print0 2>/dev/null | sort -z)
  done

  for subdir in "$dir"/*; do
    if [ -d "$subdir" ] && [[ ! $(basename "$subdir") == _* ]]; then
      subdir_name="$(basename "$subdir")"
      {
        echo "        - section: \"$subdir_name\""
        echo "          contents:"
      } >> "$TMP_FILE"

      for ext in qmd md; do
        while IFS= read -r -d '' doc; do
          doc_name="$(basename "$doc")"
          file_title="$(extract_qmd_title "$doc")"
          relative_path="content/$(basename "$dir")/$(basename "$subdir")"
          {
            echo "            - text: \"$file_title\""
            echo "              file: ${relative_path}/${doc_name}"
          } >> "$TMP_FILE"
        done < <(find "$subdir" -maxdepth 1 -type f -name "*.$ext" -print0 2>/dev/null | sort -z)
      done
    fi
  done
}

categories=()
while IFS= read -r category; do
  if [ -d "$category" ] && [[ ! $(basename "$category") == _* ]]; then
    metadata="$(get_metadata "$category")"
    order="$(echo "$metadata" | cut -d'|' -f1)"
    categories+=("$order|$category")
  fi
done < <(find "$CONTENT_DIR" -maxdepth 1 -mindepth 1 -type d | sort)

while IFS= read -r category_info; do
  [ -z "$category_info" ] && continue
  category_path="$(echo "$category_info" | cut -d'|' -f2)"
  process_directory "$category_path"
done < <(printf "%s\n" "${categories[@]}" | sort -n)

cat >> "$TMP_FILE" <<'EOL'

# Document-level (not valid under book:). HTML title block: date → Published; date-modified → Updated.
date-modified: last-modified

language:
  title-block-modified: "Updated"

format:
  html:
    theme:
      dark: [darkly, styles/dark.scss]
      light: [cosmo, styles/light.scss]
    syntax-highlighting:
      light: styles/zed-light.theme
      dark: styles/zed-dark.theme
    code-fold: true
    toc: true
    number-sections: false
    page-navigation: true

  pdf:
    documentclass: scrreprt
    classoption: ["oneside"]
    number-sections: false
    colorlinks: true
    geometry:
      - top=25mm
      - left=25mm
      - right=25mm
      - bottom=25mm

  epub:
    toc: true
    number-sections: false
    css: styles/epub.css
EOL

mv "$TMP_FILE" "$QUARTO_YML"
trap - EXIT

echo "Updated _quarto.yml for book: $BOOK_NAME"
echo "  content: $CONTENT_DIR"
echo "  output:  $QUARTO_YML"

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
  reader-mode: true
  chapters:
    - index.qmd
EOL

# Title-case a directory basename: 01-files-and-paths → Files and Paths
# Small words stay lowercase (except first word). Special cases for awkward slugs.
humanize_dir_title() {
  local slug title
  slug="$(echo "$1" | sed -E 's/^[0-9]+-?//')"

  case "$slug" in
    terminals-and-mux)       printf '%s\n' "Terminals and Multiplexers"; return ;;
    help-and-docs)           printf '%s\n' "Help and Docs"; return ;;
    services-and-runtime)    printf '%s\n' "Services and Runtime"; return ;;
    text-and-pipes)          printf '%s\n' "Text and Pipes"; return ;;
    files-and-paths)         printf '%s\n' "Files and Paths"; return ;;
    archives-and-compression) printf '%s\n' "Archives and Compression"; return ;;
    processes-and-jobs)      printf '%s\n' "Processes and Jobs"; return ;;
    users-and-groups)        printf '%s\n' "Users and Groups"; return ;;
    storage-and-filesystems) printf '%s\n' "Storage and Filesystems"; return ;;
    system-information)     printf '%s\n' "System Information"; return ;;
    system-monitoring)      printf '%s\n' "System Monitoring"; return ;;
    shell-commands)          printf '%s\n' "Shell Commands"; return ;;
    intro-to-shells)         printf '%s\n' "Intro to Shells"; return ;;
    bash-features)           printf '%s\n' "Bash Features"; return ;;
    lazyvim)                 printf '%s\n' "LazyVim"; return ;;
    modern-tools)            printf '%s\n' "Modern Tools"; return ;;
  esac

  title="$(echo "$slug" | sed 's/-/ /g' | awk '{
    small["and"]=1; small["or"]=1; small["to"]=1; small["of"]=1;
    small["for"]=1; small["in"]=1; small["on"]=1; small["the"]=1; small["a"]=1;
    for (i=1;i<=NF;i++) {
      w=tolower($i)
      if (i>1 && (w in small)) $i=w
      else $i=toupper(substr(w,1,1)) substr(w,2)
    }
    print
  }')"
  printf '%s\n' "$title"
}

# Emit chapter entries for files directly in $1 (dir path).
# $2 = content-relative path (e.g. content/01-commands/01-files)
# $3 = indent spaces for YAML list items under contents:
emit_chapter_files() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local ext doc doc_name file_title

  for ext in qmd md; do
    if [ -f "$folder/index.$ext" ]; then
      file_title="$(extract_qmd_title "$folder/index.$ext")"
      {
        echo "${ind}- text: \"$file_title\""
        echo "${ind}  file: ${rel}/index.$ext"
      } >> "$TMP_FILE"
      break
    fi
  done

  while IFS= read -r -d '' doc; do
    doc_name="$(basename "$doc")"
    [[ "$doc_name" == index.* ]] && continue
    file_title="$(extract_qmd_title "$doc")"
    {
      echo "${ind}- text: \"$file_title\""
      echo "${ind}  file: ${rel}/${doc_name}"
    } >> "$TMP_FILE"
  done < <(find "$folder" -maxdepth 1 -type f \( -name "*.qmd" -o -name "*.md" \) -print0 2>/dev/null | sort -z)
}

# Emit a section (and nested sections if present).
# $1 = absolute/relative folder for this section
# $2 = content-relative path
# $3 = indent for "- section:" line (e.g. 8 spaces)
emit_section() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local nested_ind="${ind}  "
  local item_ind="${nested_ind}  "
  local name title sub sub_name sub_title sub_rel
  local has_nested=0

  name="$(basename "$folder")"
  title="$(humanize_dir_title "$name")"

  {
    echo "${ind}- section: \"$title\""
    echo "${ind}  contents:"
  } >> "$TMP_FILE"

  # Nested subsections (e.g. Scripting → Bash → Variables)
  for sub in "$folder"/*; do
    if [ -d "$sub" ] && [[ ! $(basename "$sub") == _* ]]; then
      has_nested=1
      sub_name="$(basename "$sub")"
      sub_rel="${rel}/${sub_name}"
      emit_section "$sub" "$sub_rel" "$item_ind"
    fi
  done

  # Files at this section level (Commands → Files → ls.md)
  emit_chapter_files "$folder" "$rel" "$item_ind"
}

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

  local ext doc doc_name file_title subdir

  # Prefer index.qmd over index.md when both exist
  for ext in qmd md; do
    if [ -f "$dir/index.$ext" ]; then
      file_title="$(extract_qmd_title "$dir/index.$ext")"
      {
        echo "        - text: \"$file_title\""
        echo "          file: content/$(basename "$dir")/index.$ext"
      } >> "$TMP_FILE"
      break
    fi
  done

  # Chapters directly under the part
  while IFS= read -r -d '' doc; do
    doc_name="$(basename "$doc")"
    [[ "$doc_name" == index.* ]] && continue
    file_title="$(extract_qmd_title "$doc")"
    {
      echo "        - text: \"$file_title\""
      echo "          file: content/$(basename "$dir")/${doc_name}"
    } >> "$TMP_FILE"
  done < <(find "$dir" -maxdepth 1 -type f \( -name "*.qmd" -o -name "*.md" \) -print0 2>/dev/null | sort -z)

  # Sections under the part (Commands topics, Editors, Scripting→Bash, …)
  for subdir in "$dir"/*; do
    if [ -d "$subdir" ] && [[ ! $(basename "$subdir") == _* ]]; then
      emit_section "$subdir" "content/$(basename "$dir")/$(basename "$subdir")" "        "
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
    include-after-body:
      - styles/reader-mode-body.html

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

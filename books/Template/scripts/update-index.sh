#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOOK_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT_DIR="$BOOK_DIR/content"
QUARTO_YML="$BOOK_DIR/_quarto.yml"

# Get the book name from the directory
BOOK_NAME=$(basename "$BOOK_DIR")

# Function to extract title from qmd file
extract_qmd_title() {
    local file="$1"
    if [ -f "$file" ]; then
        # First try YAML frontmatter
        title=$(sed -n '/^---$/,/^---$/p' "$file" | grep "^title:" | sed 's/^title:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/')
        if [ -n "$title" ]; then
            echo "$title"
            return
        fi

        # Then try first markdown header
        title=$(head -n 10 "$file" | grep "^#[[:space:]]\+" | head -n 1 | sed 's/^#[[:space:]]*\(.*\)$/\1/')
        if [ -n "$title" ]; then
            echo "$title"
            return
        fi
    fi

    # Fallback to directory name
    dirname=$(basename "$(dirname "$file")")
    echo "$dirname" | sed -E 's/^[0-9]+-?//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1'
}

# Function to get metadata from directory name
get_metadata() {
    local dir="$1"
    local dirname=$(basename "$dir")
    local order=""
    local title=""

    # Extract order if present (format: XX-)
    if [[ $dirname =~ ^[0-9]+ ]]; then
        order="${BASH_REMATCH[0]}"
        title=$(echo "$dirname" | sed -E 's/^[0-9]+-?//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    else
        order="99"
        title=$(echo "$dirname" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    fi

    echo "${order}|${title}"
}

# Create a temporary file
TMP_FILE=$(mktemp)

# Write the header
cat > "$TMP_FILE" << EOL
project:
  type: book
  output-dir: _book

book:
  title: "$BOOK_NAME"
  author: "K19G"
  date: last-modified
  navbar:
    pinned: true
    right:
      - icon: github
        href: https://github.com/yourusername
      - icon: twitter
        href: https://twitter.com/yourusername

  sidebar:
    style: docked
    collapse-level: 1
  chapters:
    - index.qmd
EOL

# Function to process directories
process_directory() {
    local dir="$1"
    local metadata=$(get_metadata "$dir")
    local order=$(echo "$metadata" | cut -d'|' -f1)
    local title=$(echo "$metadata" | cut -d'|' -f2)

    # Add the category with part
    echo "    - part: \"$title\"" >> "$TMP_FILE"
    echo "      contents:" >> "$TMP_FILE"

    # Process all files in the directory
    for ext in "qmd" "md"; do
        # First process index files
        if [ -f "$dir/index.$ext" ]; then
            local file_title=$(extract_qmd_title "$dir/index.$ext")
            echo "        - text: \"$file_title\"" >> "$TMP_FILE"
            echo "          file: content/$(basename "$dir")/index.$ext" >> "$TMP_FILE"
        fi

        # Then process non-index files
        for doc in "$dir"/*.$ext; do
            if [ -f "$doc" ] && [ "$(basename "$doc")" != "index.$ext" ]; then
                local doc_name=$(basename "$doc")
                local file_title=$(extract_qmd_title "$doc")
                echo "        - text: \"$file_title\"" >> "$TMP_FILE"
                echo "          file: content/$(basename "$dir")/${doc_name}" >> "$TMP_FILE"
            fi
        done
    done

    # Process subdirectories
    for subdir in "$dir"/*; do
        if [ -d "$subdir" ] && [[ ! $(basename "$subdir") == _* ]]; then
            local subdir_name=$(basename "$subdir")
            echo "        - section: \"$subdir_name\"" >> "$TMP_FILE"
            echo "          contents:" >> "$TMP_FILE"

            for ext in "qmd" "md"; do
                for doc in "$subdir"/*.$ext; do
                    if [ -f "$doc" ]; then
                        local doc_name=$(basename "$doc")
                        local file_title=$(extract_qmd_title "$doc")
                        local relative_path="content/$(basename "$dir")/$(basename "$subdir")"
                        echo "            - text: \"$file_title\"" >> "$TMP_FILE"
                        echo "              file: ${relative_path}/${doc_name}" >> "$TMP_FILE"
                    fi
                done
            done
        fi
    done
}

# Get all main categories and sort them by order
categories=()
while IFS= read -r category; do
    if [ -d "$category" ] && [[ ! $(basename "$category") == _* ]]; then
        metadata=$(get_metadata "$category")
        order=$(echo "$metadata" | cut -d'|' -f1)
        categories+=("$order|$category")
    fi
done < <(find "$CONTENT_DIR" -maxdepth 1 -mindepth 1 -type d)

# Sort categories by order and process them
while IFS= read -r category_info; do
    category_path=$(echo "$category_info" | cut -d'|' -f2)
    process_directory "$category_path"
done < <(printf "%s\n" "${categories[@]}" | sort -n)

# Add the format section
cat >> "$TMP_FILE" << EOL

format:
  html:
    theme:
      light: [cosmo, styles/light.scss]
      dark: [darkly, styles/dark.scss]
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
EOL

# Replace the original file with the new content
mv "$TMP_FILE" "$QUARTO_YML"

echo "Updated _quarto.yml with current directory structure"

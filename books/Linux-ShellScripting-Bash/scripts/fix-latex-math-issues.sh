#!/bin/bash

# Fix LaTeX Math Issues Script
# This script fixes bash array syntax that gets interpreted as LaTeX math

CONTENT_DIR="$(dirname "$0")/../content"

echo "Fixing LaTeX math interpretation issues in bash code blocks..."

# Function to fix a file
fix_file() {
    local file="$1"
    echo "Processing: $file"

    # Create a backup
    cp "$file" "$file.bak"

    # Fix common bash array patterns that cause LaTeX issues
    # Only fix them inside code blocks (between ``` markers)

    # Use a more sophisticated approach with awk to only fix inside code blocks
    awk '
    BEGIN { in_code_block = 0 }
    /^```/ {
        in_code_block = !in_code_block
        print
        next
    }
    in_code_block {
        # Fix bash array syntax only inside code blocks
        gsub(/\$\{([^}]*)\[@\]([^}]*)\}/, "\\${\\1[@]\\2}", $0)
        gsub(/\$\{#([^}]*)\[@\]([^}]*)\}/, "\\${#\\1[@]\\2}", $0)
        gsub(/\$\{!([^}]*)\[@\]([^}]*)\}/, "\\${!\\1[@]\\2}", $0)
    }
    { print }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

# Find all .qmd files and fix them
find "$CONTENT_DIR" -name "*.qmd" -type f | while read -r file; do
    # Check if file contains problematic patterns
    if grep -q '\${.*\[@\].*}' "$file"; then
        fix_file "$file"
    fi
done

echo "LaTeX math issues fixed!"
echo "Backup files created with .bak extension"
echo "You can remove them with: find $CONTENT_DIR -name '*.bak' -delete"
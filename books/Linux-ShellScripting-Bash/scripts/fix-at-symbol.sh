#!/bin/bash

# Simple fix for @ symbol in bash arrays that causes LaTeX math issues
# This script specifically targets the @ symbol in array syntax

CONTENT_DIR="$(dirname "$0")/../content"

echo "Fixing @ symbol in bash array syntax..."

# Function to fix @ symbols in bash array contexts
fix_at_symbols() {
    local file="$1"
    echo "Processing: $file"

    # Use sed to replace @ with \@ in specific bash array contexts
    # This is more targeted and safer
    sed -i.backup \
        -e 's/\${fruits\[@\]}/\${fruits[\\@]}/g' \
        -e 's/\${#fruits\[@\]}/\${#fruits[\\@]}/g' \
        -e 's/\${colors\[@\]}/\${colors[\\@]}/g' \
        -e 's/\${#colors\[@\]}/\${#colors[\\@]}/g' \
        -e 's/\${shopping_list\[@\]}/\${shopping_list[\\@]}/g' \
        -e 's/\${#shopping_list\[@\]}/\${#shopping_list[\\@]}/g' \
        "$file"
}

# Process key files that are most likely to cause issues
key_files=(
    "$CONTENT_DIR/04-variables/variable-basics.qmd"
    "$CONTENT_DIR/99-workbook/01-basic-examples.qmd"
    "$CONTENT_DIR/03-bash-intro/bash-features.qmd"
)

for file in "${key_files[@]}"; do
    if [ -f "$file" ]; then
        fix_at_symbols "$file"
    fi
done

echo "Fixed @ symbols in key files"
echo "Backup files created with .backup extension"
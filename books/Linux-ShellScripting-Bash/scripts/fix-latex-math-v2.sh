#!/bin/bash

# Fix LaTeX Math Issues Script v2
# This script fixes bash array syntax that gets interpreted as LaTeX math

CONTENT_DIR="$(dirname "$0")/../content"

echo "Fixing LaTeX math interpretation issues in bash code blocks..."

# Function to fix a file
fix_file() {
    local file="$1"
    echo "Processing: $file"

    # Create a backup
    cp "$file" "$file.bak2"

    # Use sed to fix the patterns more carefully
    # Fix ${array[@]} patterns
    sed -i.tmp1 's/\${fruits\[@\]}/\\${fruits[@]}/g' "$file"
    sed -i.tmp2 's/\${colors\[@\]}/\\${colors[@]}/g' "$file"
    sed -i.tmp3 's/\${#fruits\[@\]}/\\${#fruits[@]}/g' "$file"
    sed -i.tmp4 's/\${#colors\[@\]}/\\${#colors[@]}/g' "$file"

    # Fix other common array patterns
    sed -i.tmp5 's/\${SERVERS\[@\]}/\\${SERVERS[@]}/g' "$file"
    sed -i.tmp6 's/\${#SERVERS\[@\]}/\\${#SERVERS[@]}/g' "$file"
    sed -i.tmp7 's/\${WORKER_PIDS\[@\]}/\\${WORKER_PIDS[@]}/g' "$file"
    sed -i.tmp8 's/\${pids\[@\]}/\\${pids[@]}/g' "$file"
    sed -i.tmp9 's/\${#pids\[@\]}/\\${#pids[@]}/g' "$file"
    sed -i.tmp10 's/\${live_hosts\[@\]}/\\${live_hosts[@]}/g' "$file"
    sed -i.tmp11 's/\${#live_hosts\[@\]}/\\${#live_hosts[@]}/g' "$file"
    sed -i.tmp12 's/\${COMMON_PORTS\[@\]}/\\${COMMON_PORTS[@]}/g' "$file"
    sed -i.tmp13 's/\${hosts_with_port\[@\]}/\\${hosts_with_port[@]}/g' "$file"
    sed -i.tmp14 's/\${#hosts_with_port\[@\]}/\\${#hosts_with_port[@]}/g' "$file"

    # Clean up temporary files
    rm -f "$file".tmp*
}

# Find all .qmd files and fix them
find "$CONTENT_DIR" -name "*.qmd" -type f | while read -r file; do
    # Check if file contains problematic patterns
    if grep -q '\${.*\[@\].*}' "$file"; then
        fix_file "$file"
    fi
done

echo "LaTeX math issues fixed!"
echo "Backup files created with .bak2 extension"
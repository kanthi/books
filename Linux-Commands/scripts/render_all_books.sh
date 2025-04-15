#!/bin/bash

# Store the root directory path
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$ROOT_DIR")"

# Print start message
echo "Starting to render all books..."
echo "Root directory: $PARENT_DIR"

# Count for rendered books
count=0

# Find all directories that contain _quarto.yml
for book_dir in "$PARENT_DIR"/*; do
    if [ -d "$book_dir" ] && [ -f "$book_dir/_quarto.yml" ]; then
        echo "----------------------------------------"
        echo "Found book: $(basename "$book_dir")"
        
        # Change to the book directory
        cd "$book_dir" || continue
        
        # Run quarto render
        echo "Rendering book..."
        if quarto render; then
            echo "✅ Successfully rendered $(basename "$book_dir")"
            ((count++))
        else
            echo "❌ Failed to render $(basename "$book_dir")"
        fi
        
        # Return to parent directory
        cd "$PARENT_DIR" || exit
    fi
done

echo "----------------------------------------"
echo "Rendering complete! Successfully rendered $count books."

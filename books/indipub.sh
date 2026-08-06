#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

# Quarto runs on Deno (not Node). NODE_OPTIONS does NOT raise the heap.
# See https://quarto.org/docs/troubleshooting/ — Out-of-memory issues.
export QUARTO_DENO_V8_OPTIONS="${QUARTO_DENO_V8_OPTIONS:---max-old-space-size=8192}"

# Check if book name is provided
if [ $# -ne 1 ]; then
    echo "Usage: ./indipub.sh <bookname>"
    exit 1
fi

BOOK_NAME="$1"
BOOKS_DIR="$(pwd)"

# Check if the book directory exists
if [ ! -d "$BOOKS_DIR/$BOOK_NAME" ]; then
    echo "Error: Book directory '$BOOK_NAME' not found in $BOOKS_DIR"
    exit 1
fi

echo "📚 Processing book: $BOOK_NAME"
echo "   QUARTO_DENO_V8_OPTIONS=$QUARTO_DENO_V8_OPTIONS"

# Update book index
if [ -f "$BOOKS_DIR/$BOOK_NAME/scripts/update-index.sh" ]; then
    echo "🔄 Updating book index..."
    (cd "$BOOKS_DIR/$BOOK_NAME/scripts" && ./update-index.sh)
else
    echo "⚠️  No update-index.sh script found in $BOOK_NAME/scripts/"
fi

# Render formats one at a time so Deno heap is not held across HTML+PDF+EPUB
# in one process (large books like Go hit "Fatal javascript OOM" on EPUB).
BOOK_PATH="$BOOKS_DIR/$BOOK_NAME"
echo "🌐 Rendering book (sequential formats)..."
for fmt in html pdf epub; do
  echo "   → format: $fmt"
  quarto render "$BOOK_PATH" --to "$fmt"
done

echo "✅ Book rendering complete!"

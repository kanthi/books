#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

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

# Update book index
if [ -f "$BOOKS_DIR/$BOOK_NAME/scripts/update-index.sh" ]; then
    echo "🔄 Updating book index..."
    cd "$BOOKS_DIR/$BOOK_NAME/scripts" && ./update-index.sh
    cd "$BOOKS_DIR"
else
    echo "⚠️  No update-index.sh script found in $BOOK_NAME/scripts/"
fi

# Render book
echo "🌐 Rendering book..."
quarto render "$BOOKS_DIR/$BOOK_NAME"

echo "✅ Book rendering complete!"

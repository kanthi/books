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

BOOK_PATH="$BOOKS_DIR/$BOOK_NAME"
OUT_DIR="$BOOK_PATH/_book"

# Quarto often rebuilds _book per --to target and can drop earlier formats.
# Stage PDF/EPUB after each pass, then merge back so all three remain.
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/indipub-stage.XXXXXX")"
cleanup() { rm -rf "$STAGE"; }
trap cleanup EXIT

harvest_artifacts() {
  local f
  if [ -d "$OUT_DIR" ]; then
    while IFS= read -r f; do
      [ -n "$f" ] || continue
      cp -f "$f" "$STAGE/$(basename "$f")"
      echo "   harvested $(basename "$f")"
    done < <(find "$OUT_DIR" -maxdepth 1 -type f \( -iname '*.pdf' -o -iname '*.epub' \) 2>/dev/null || true)
  fi
}

restore_artifacts() {
  mkdir -p "$OUT_DIR"
  local f
  for f in "$STAGE"/*; do
    [ -f "$f" ] || continue
    cp -f "$f" "$OUT_DIR/$(basename "$f")"
    echo "   restored $(basename "$f") → _book/"
  done
}

# Sequential formats: lower peak Deno memory than one multi-format render
# (large books e.g. Go EPUB OOMed in a single multi-format pass).
echo "🌐 Rendering book (sequential formats)..."
for fmt in html pdf epub; do
  echo "   → format: $fmt"
  quarto render "$BOOK_PATH" --to "$fmt"
  harvest_artifacts
done

restore_artifacts

echo "✅ Book rendering complete!"

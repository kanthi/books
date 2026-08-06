#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

# ---------------------------------------------------------------------------
# Quarto 1.3.x (CI) runs on Deno and only forwards QUARTO_DENO_EXTRA_OPTIONS
# to the deno binary. QUARTO_DENO_V8_OPTIONS is ignored on 1.3.450 (no support
# in bin/quarto). Without --v8-flags, Deno sits at ~1.4GB and large books
# (Go EPUB) die with: Fatal javascript OOM / exit 133.
#
# Newer Quarto also honors QUARTO_DENO_V8_OPTIONS; set both for compatibility.
# Heap sizes are MB. GHA ubuntu-latest has ~7GB RAM — stay under that.
# ---------------------------------------------------------------------------
_V8_HEAP="${QUARTO_DENO_HEAP_MB:-6144}"
export QUARTO_DENO_V8_OPTIONS="${QUARTO_DENO_V8_OPTIONS:---max-old-space-size=${_V8_HEAP},--max-heap-size=${_V8_HEAP}}"
# Critical for Quarto 1.3.450:
if [[ "${QUARTO_DENO_EXTRA_OPTIONS:-}" != *v8-flags* ]]; then
  export QUARTO_DENO_EXTRA_OPTIONS="--v8-flags=--max-old-space-size=${_V8_HEAP},--max-heap-size=${_V8_HEAP}${QUARTO_DENO_EXTRA_OPTIONS:+ ${QUARTO_DENO_EXTRA_OPTIONS}}"
fi

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
echo "   quarto: $(quarto --version 2>/dev/null || echo unknown)"
echo "   QUARTO_DENO_EXTRA_OPTIONS=$QUARTO_DENO_EXTRA_OPTIONS"

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

# Pandoc EPUB fallback when Quarto/Deno still OOMs (uses Quarto-bundled pandoc).
build_epub_pandoc() {
  local list css_args resource
  local -a sources
  list="$(mktemp)"
  if [ -f "$BOOK_PATH/index.qmd" ]; then
    echo "$BOOK_PATH/index.qmd" >> "$list"
  elif [ -f "$BOOK_PATH/index.md" ]; then
    echo "$BOOK_PATH/index.md" >> "$list"
  fi
  if [ -d "$BOOK_PATH/content" ]; then
    find "$BOOK_PATH/content" -type f \( -name '*.qmd' -o -name '*.md' \) | LC_ALL=C sort >> "$list"
  fi
  if [ ! -s "$list" ]; then
    echo "   pandoc epub: no source files" >&2
    rm -f "$list"
    return 1
  fi
  mapfile -t sources < "$list"
  rm -f "$list"
  mkdir -p "$OUT_DIR"
  css_args=()
  if [ -f "$BOOK_PATH/styles/epub.css" ]; then
    css_args=(--css="$BOOK_PATH/styles/epub.css")
  fi
  resource="$BOOK_PATH"
  if [ -d "$BOOK_PATH/images" ]; then
    resource="$BOOK_PATH:$BOOK_PATH/images"
  fi
  echo "   pandoc epub: ${#sources[@]} source files → _book/${BOOK_NAME}.epub"
  quarto pandoc "${sources[@]}" \
    -o "$OUT_DIR/${BOOK_NAME}.epub" \
    --toc \
    --resource-path="$resource" \
    "${css_args[@]+"${css_args[@]}"}"
}

# Sequential formats: lower peak Deno memory than one multi-format render.
echo "🌐 Rendering book (sequential formats)..."
for fmt in html pdf epub; do
  echo "   → format: $fmt"
  if [ "$fmt" = epub ]; then
    if ! quarto render "$BOOK_PATH" --to epub; then
      echo "   ⚠️  quarto epub failed (often Deno OOM on huge books) — trying pandoc fallback..."
      build_epub_pandoc
    fi
  else
    quarto render "$BOOK_PATH" --to "$fmt"
  fi
  harvest_artifacts
done

restore_artifacts

echo "✅ Book rendering complete!"

#!/bin/bash
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

# ---------------------------------------------------------------------------
# Deno heap for large books (Go EPUB OOM without a higher V8 limit).
#
# Quarto 1.3.x (CI 1.3.450): bin/quarto does NOT wire QUARTO_DENO_V8_OPTIONS.
#   Only QUARTO_DENO_EXTRA_OPTIONS reaches deno → put --v8-flags there.
#
# Quarto 1.4+ / 1.10+ (local): bin/quarto always prepends
#   --v8-flags=${QUARTO_DENO_V8_OPTIONS} onto QUARTO_DENO_EXTRA_OPTIONS.
#   If EXTRA already contains --v8-flags, Deno errors:
#     "the argument '--v8-flags[=...]' cannot be used multiple times"
#   So on modern Quarto: set V8 options only; strip any --v8-flags from EXTRA.
#
# Heap sizes are MB. GHA ubuntu-latest has ~7GB RAM — stay under that.
# Override: QUARTO_DENO_HEAP_MB=4096 ./indipub.sh Book
# ---------------------------------------------------------------------------
_V8_HEAP="${QUARTO_DENO_HEAP_MB:-6144}"
export QUARTO_DENO_V8_OPTIONS="${QUARTO_DENO_V8_OPTIONS:---max-old-space-size=${_V8_HEAP},--max-heap-size=${_V8_HEAP}}"

_strip_v8_flags_from_extra() {
  # Remove --v8-flags=... tokens (Deno allows only one --v8-flags).
  local e="${QUARTO_DENO_EXTRA_OPTIONS:-}"
  [[ -z "$e" ]] && return 0
  # shellcheck disable=SC2001
  e="$(printf '%s' "$e" | sed -E 's/(^|[[:space:]])--v8-flags=[^[:space:]]*//g')"
  e="$(printf '%s' "$e" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/[[:space:]]+/ /g')"
  if [[ -n "$e" ]]; then
    export QUARTO_DENO_EXTRA_OPTIONS="$e"
  else
    unset QUARTO_DENO_EXTRA_OPTIONS
  fi
}

_QUARTO_BIN="$(command -v quarto 2>/dev/null || true)"
_QUARTO_WRAP=""
if [[ -n "$_QUARTO_BIN" ]]; then
  # Prefer realpath resolution (macOS/BSD readlink often lacks -f).
  if command -v python3 >/dev/null 2>&1; then
    _QUARTO_WRAP="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$_QUARTO_BIN" 2>/dev/null || true)"
  fi
  if [[ -z "$_QUARTO_WRAP" ]]; then
    _QUARTO_WRAP="$(readlink -f "$_QUARTO_BIN" 2>/dev/null || true)"
  fi
  if [[ -z "$_QUARTO_WRAP" ]]; then
    _QUARTO_WRAP="$_QUARTO_BIN"
  fi
fi

if [[ -n "$_QUARTO_BIN" ]]; then
  # Modern Quarto injects --v8-flags from QUARTO_DENO_V8_OPTIONS.
  _strip_v8_flags_from_extra
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
echo "   QUARTO_DENO_V8_OPTIONS=${QUARTO_DENO_V8_OPTIONS-}"
echo "   QUARTO_DENO_EXTRA_OPTIONS=${QUARTO_DENO_EXTRA_OPTIONS-}"

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
#
# Order matters: each `quarto render --to X` often rebuilds _book/ and drops
# other formats. Do **html last** so the site (index.html + chapters) remains.
# PDF/EPUB are harvested after their passes and restored onto the final HTML tree.
echo "🌐 Rendering book (sequential: pdf → epub → html)..."
for fmt in pdf epub html; do
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

if [ ! -f "$OUT_DIR/index.html" ]; then
  echo "ERROR: _book/index.html missing after render (HTML site not produced)" >&2
  ls -la "$OUT_DIR" 2>/dev/null || true
  exit 1
fi

echo "✅ Book rendering complete!"

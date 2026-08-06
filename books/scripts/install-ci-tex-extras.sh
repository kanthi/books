#!/usr/bin/env bash
# Install lightweight TeX extras needed by Quarto PDF on GHA runners.
#
# Avoids apt's texlive-fonts-extra (~629 MB, often stalls). Installs only:
#   - fontawesome5 (Quarto callout icons) into ~/texmf
#
# Source: vendored zip at books/ci/fontawesome5.zip (no CTAN/network at CI time).
#
# Prerequisite: unzip on PATH; TinyTeX (or TeX Live) with kpsewhich available.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_ZIP="${SCRIPT_DIR}/../ci/fontawesome5.zip"
TINYTEX_HOME="${TINYTEX_HOME:-$HOME/.TinyTeX}"

# Nested `bash this-script` does not inherit PATH exports from siblings.
# Re-attach TinyTeX bin if kpsewhich is missing.
if ! command -v kpsewhich >/dev/null 2>&1; then
  for d in "$TINYTEX_HOME"/bin/*; do
    if [ -d "$d" ] && [ -x "$d/kpsewhich" ]; then
      export PATH="$d:$PATH"
      break
    fi
  done
fi

if [ ! -f "$VENDOR_ZIP" ]; then
  echo "ERROR: vendored fontawesome5 zip not found: $VENDOR_ZIP" >&2
  echo "Expected books/ci/fontawesome5.zip in the repo (do not download from CTAN in CI)." >&2
  exit 1
fi

FA_TMP="$(mktemp -d)"
trap 'rm -rf "$FA_TMP"' EXIT

echo "Installing fontawesome5 into \$HOME/texmf from vendored zip..."
echo "  source: $VENDOR_ZIP"

unzip -qo "$VENDOR_ZIP" -d "$FA_TMP"
SRC="$FA_TMP/fontawesome5"
if [ ! -d "$SRC" ]; then
  echo "ERROR: zip did not contain fontawesome5/ directory" >&2
  exit 1
fi

TEXMF="${HOME}/texmf"

mkdir -p \
  "$TEXMF/tex/latex/fontawesome5" \
  "$TEXMF/fonts/opentype/public/fontawesome5" \
  "$TEXMF/fonts/tfm/public/fontawesome5" \
  "$TEXMF/fonts/type1/public/fontawesome5" \
  "$TEXMF/fonts/enc/dvips/fontawesome5" \
  "$TEXMF/fonts/map/dvips/fontawesome5"

cp -R "$SRC"/tex/*        "$TEXMF/tex/latex/fontawesome5/"
cp -R "$SRC"/opentype/*   "$TEXMF/fonts/opentype/public/fontawesome5/"
cp -R "$SRC"/tfm/*        "$TEXMF/fonts/tfm/public/fontawesome5/"
cp -R "$SRC"/type1/*      "$TEXMF/fonts/type1/public/fontawesome5/"
cp -R "$SRC"/enc/*        "$TEXMF/fonts/enc/dvips/fontawesome5/"
cp -R "$SRC"/map/*        "$TEXMF/fonts/map/dvips/fontawesome5/"

if command -v mktexlsr >/dev/null 2>&1; then
  mktexlsr "$TEXMF" 2>/dev/null || true
elif command -v texhash >/dev/null 2>&1; then
  texhash "$TEXMF" 2>/dev/null || true
fi

if ! command -v kpsewhich >/dev/null 2>&1; then
  echo "ERROR: kpsewhich not on PATH (is TinyTeX installed and PATH set?)" >&2
  echo "  PATH=$PATH" >&2
  echo "  TINYTEX_HOME=$TINYTEX_HOME" >&2
  ls -la "$TINYTEX_HOME/bin" 2>/dev/null || true
  exit 1
fi

if ! kpsewhich fontawesome5.sty >/dev/null 2>&1; then
  # Force kpathsea to see TEXMFHOME
  export TEXMFHOME="${TEXMFHOME:-$HOME/texmf}"
  if ! kpsewhich fontawesome5.sty >/dev/null 2>&1; then
    echo "ERROR: fontawesome5.sty not found after install" >&2
    echo "  TEXMFHOME=$TEXMFHOME" >&2
    find "$TEXMF" -name 'fontawesome5.sty' 2>/dev/null || true
    exit 1
  fi
fi
echo "fontawesome5.sty -> $(kpsewhich fontawesome5.sty)"

#!/usr/bin/env bash
# Install lightweight TeX extras needed by Quarto PDF on GHA runners.
#
# Avoids apt's texlive-fonts-extra (~629 MB, often stalls). Installs only:
#   - fontawesome5 (Quarto callout icons) into $TEXMFHOME (default ~/texmf)
#
# Source: vendored zip at ci/fontawesome5.zip (no CTAN/network at CI time).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_ZIP="${SCRIPT_DIR}/../../ci/fontawesome5.zip"
TINYTEX_HOME="${TINYTEX_HOME:-$HOME/.TinyTeX}"
export TEXMFHOME="${TEXMFHOME:-$HOME/texmf}"

# Nested bash may not inherit PATH; re-attach TinyTeX bin if needed.
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
  exit 1
fi

FA_TMP="$(mktemp -d)"
trap 'rm -rf "$FA_TMP"' EXIT

echo "Installing fontawesome5 into TEXMFHOME=$TEXMFHOME from vendored zip..."
echo "  source: $VENDOR_ZIP"

unzip -qo "$VENDOR_ZIP" -d "$FA_TMP"
SRC="$FA_TMP/fontawesome5"
if [ ! -d "$SRC" ]; then
  echo "ERROR: zip did not contain fontawesome5/ directory" >&2
  exit 1
fi

mkdir -p \
  "$TEXMFHOME/tex/latex/fontawesome5" \
  "$TEXMFHOME/fonts/opentype/public/fontawesome5" \
  "$TEXMFHOME/fonts/tfm/public/fontawesome5" \
  "$TEXMFHOME/fonts/type1/public/fontawesome5" \
  "$TEXMFHOME/fonts/enc/dvips/fontawesome5" \
  "$TEXMFHOME/fonts/map/dvips/fontawesome5"

cp -R "$SRC"/tex/*        "$TEXMFHOME/tex/latex/fontawesome5/"
cp -R "$SRC"/opentype/*   "$TEXMFHOME/fonts/opentype/public/fontawesome5/"
cp -R "$SRC"/tfm/*        "$TEXMFHOME/fonts/tfm/public/fontawesome5/"
cp -R "$SRC"/type1/*      "$TEXMFHOME/fonts/type1/public/fontawesome5/"
cp -R "$SRC"/enc/*        "$TEXMFHOME/fonts/enc/dvips/fontawesome5/"
cp -R "$SRC"/map/*        "$TEXMFHOME/fonts/map/dvips/fontawesome5/"

if command -v mktexlsr >/dev/null 2>&1; then
  mktexlsr "$TEXMFHOME" 2>/dev/null || true
elif command -v texhash >/dev/null 2>&1; then
  texhash "$TEXMFHOME" 2>/dev/null || true
fi

if ! command -v kpsewhich >/dev/null 2>&1; then
  echo "ERROR: kpsewhich not on PATH" >&2
  exit 1
fi

if ! kpsewhich fontawesome5.sty >/dev/null 2>&1; then
  echo "ERROR: fontawesome5.sty not found after install" >&2
  echo "  TEXMFHOME=$TEXMFHOME" >&2
  echo "  kpsewhich TEXMFHOME => $(kpsewhich -var-value=TEXMFHOME 2>/dev/null || true)" >&2
  find "$TEXMFHOME" -name 'fontawesome5.sty' 2>/dev/null || true
  exit 1
fi
echo "fontawesome5.sty -> $(kpsewhich fontawesome5.sty)"

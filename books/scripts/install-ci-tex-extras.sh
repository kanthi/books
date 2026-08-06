#!/usr/bin/env bash
# Install lightweight TeX extras needed by Quarto PDF on GHA runners.
#
# Avoids apt's texlive-fonts-extra (~629 MB, often stalls). Installs only:
#   - fontawesome5 (Quarto callout icons) from CTAN into ~/texmf
# Prerequisite: unzip + curl already on PATH; TeX Live already installed.
set -euo pipefail

FA_TMP="$(mktemp -d)"
trap 'rm -rf "$FA_TMP"' EXIT

echo "Installing fontawesome5 into \$HOME/texmf (Quarto PDF callouts)..."
curl -fsSL -o "$FA_TMP/fontawesome5.zip" \
  "https://mirrors.ctan.org/fonts/fontawesome5.zip"

unzip -qo "$FA_TMP/fontawesome5.zip" -d "$FA_TMP"
SRC="$FA_TMP/fontawesome5"
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

mktexlsr "$TEXMF" 2>/dev/null || texhash "$TEXMF" 2>/dev/null || true

if ! kpsewhich fontawesome5.sty >/dev/null; then
  echo "ERROR: fontawesome5.sty not found after install" >&2
  exit 1
fi
echo "fontawesome5.sty -> $(kpsewhich fontawesome5.sty)"

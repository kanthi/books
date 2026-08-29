#!/usr/bin/env bash
# Install or restore TinyTeX for GitHub Actions (user-local, cacheable).
#
# Env:
#   TINYTEX_FORCE_INSTALL=1  — ignore existing ~/.TinyTeX and reinstall
#   SKIP_TLMGR_PACKAGES=1    — only ensure PATH (packages already in cache tree)
#
# After this script:
#   - xelatex / tlmgr on PATH
#   - packages from ci/tinytex-packages.txt installed (unless skipped)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Monorepo root is two levels up from books/scripts (…/books/scripts → …/ci)
CI_DIR="$(cd "$SCRIPT_DIR/../../ci" && pwd)"
VERSION_FILE="$CI_DIR/tinytex-version.txt"
PKG_FILE="$CI_DIR/tinytex-packages.txt"

TINYTEX_HOME="${TINYTEX_HOME:-$HOME/.TinyTeX}"
VERSION="$(tr -d '[:space:]' < "$VERSION_FILE")"
if [ -z "$VERSION" ]; then
  echo "ERROR: empty $VERSION_FILE" >&2
  exit 1
fi

arch="$(uname -m)"
case "$arch" in
  x86_64|amd64)  asset_arch="x86_64" ;;
  aarch64|arm64) asset_arch="arm64" ;;
  *)
    echo "ERROR: unsupported arch: $arch" >&2
    exit 1
    ;;
esac

# TinyTeX-1 = larger preset (fewer mid-render package downloads).
ASSET="TinyTeX-1-linux-${asset_arch}-${VERSION}.tar.xz"
URL="https://github.com/rstudio/tinytex-releases/releases/download/${VERSION}/${ASSET}"

find_bindir() {
  local d
  for d in "$TINYTEX_HOME"/bin/*; do
    if [ -d "$d" ] && [ -x "$d/tlmgr" ]; then
      printf '%s\n' "$d"
      return 0
    fi
  done
  return 1
}

add_tinytex_path() {
  local bindir
  bindir="$(find_bindir)" || {
    echo "ERROR: TinyTeX bin dir not found under $TINYTEX_HOME/bin" >&2
    ls -la "$TINYTEX_HOME" 2>/dev/null || true
    exit 1
  }
  echo "TinyTeX bin: $bindir"
  if [ -n "${GITHUB_PATH:-}" ]; then
    echo "$bindir" >> "$GITHUB_PATH"
  fi
  export PATH="$bindir:$PATH"
}

install_tinytex() {
  echo "Installing TinyTeX $VERSION ($ASSET)..."
  echo "  URL: $URL"
  local tmp tarball top
  tmp="$(mktemp -d)"
  tarball="$tmp/$ASSET"
  curl -fsSL --retry 3 --retry-delay 2 -o "$tarball" "$URL"

  rm -rf "$TINYTEX_HOME"
  tar -xJf "$tarball" -C "$tmp"

  if [ -d "$tmp/.TinyTeX" ]; then
    mv "$tmp/.TinyTeX" "$TINYTEX_HOME"
  elif [ -d "$tmp/TinyTeX" ]; then
    mv "$tmp/TinyTeX" "$TINYTEX_HOME"
  else
    # Single top-level dir containing bin/
    top="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d ! -name "$(basename "$tarball")" | head -1)"
    if [ -n "$top" ] && [ -d "$top/bin" ]; then
      mv "$top" "$TINYTEX_HOME"
    else
      echo "ERROR: unexpected archive layout:" >&2
      find "$tmp" -maxdepth 2 -type d >&2
      exit 1
    fi
  fi
  rm -rf "$tmp"
  echo "TinyTeX installed at $TINYTEX_HOME"
}

install_packages() {
  if [ "${SKIP_TLMGR_PACKAGES:-}" = "1" ]; then
    echo "SKIP_TLMGR_PACKAGES=1 — not running tlmgr install"
    return 0
  fi
  if [ ! -f "$PKG_FILE" ]; then
    echo "ERROR: missing $PKG_FILE" >&2
    exit 1
  fi

  local pkgs=()
  local line
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="${line// /}"
    [ -z "$line" ] && continue
    pkgs+=("$line")
  done < "$PKG_FILE"

  if [ "${#pkgs[@]}" -eq 0 ]; then
    echo "No packages listed in $PKG_FILE"
    return 0
  fi

  echo "tlmgr install (${#pkgs[@]} packages from tinytex-packages.txt)..."
  tlmgr update --self || true
  if ! tlmgr install "${pkgs[@]}"; then
    echo "WARN: batch tlmgr install reported errors; installing one-by-one..."
    local p
    for p in "${pkgs[@]}"; do
      tlmgr install "$p" || echo "WARN: could not install $p"
    done
  fi
  tlmgr path add 2>/dev/null || true
}

NEED_INSTALL=0
if [ "${TINYTEX_FORCE_INSTALL:-}" = "1" ]; then
  NEED_INSTALL=1
elif ! find_bindir >/dev/null 2>&1; then
  NEED_INSTALL=1
fi

if [ "$NEED_INSTALL" = "1" ]; then
  install_tinytex
  add_tinytex_path
  install_packages
else
  echo "Using existing TinyTeX at $TINYTEX_HOME"
  add_tinytex_path
fi

command -v xelatex >/dev/null
command -v tlmgr >/dev/null
xelatex --version | head -n 1
echo "setup-ci-tinytex: OK"

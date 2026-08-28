#!/usr/bin/env bash
# One entrypoint for GHA: TinyTeX PATH + fontawesome extras + sanity checks.
#
# Important: do not run setup/install as nested `bash script.sh` without
# re-exporting PATH — child shells do not keep the parent's PATH exports,
# and GITHUB_PATH only applies to *later* workflow steps.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TINYTEX_HOME="${TINYTEX_HOME:-$HOME/.TinyTeX}"
# Vendored fontawesome and any personal sty files live here (not only TinyTeX tree).
export TEXMFHOME="${TEXMFHOME:-$HOME/.texmf}"

ensure_tinytex_path() {
  if command -v kpsewhich >/dev/null 2>&1 && command -v tlmgr >/dev/null 2>&1; then
    return 0
  fi
  local d
  for d in "$TINYTEX_HOME"/bin/*; do
    if [ -d "$d" ] && [ -x "$d/tlmgr" ]; then
      export PATH="$d:$PATH"
      if [ -n "${GITHUB_PATH:-}" ]; then
        echo "$d" >> "$GITHUB_PATH"
      fi
      echo "ci-tex-setup: PATH += $d"
      return 0
    fi
  done
  return 1
}

persist_env_for_later_steps() {
  # GITHUB_ENV / GITHUB_PATH apply to subsequent workflow steps (Render, etc.).
  if [ -n "${GITHUB_ENV:-}" ]; then
    echo "TEXMFHOME=$TEXMFHOME" >> "$GITHUB_ENV"
    echo "TINYTEX_HOME=$TINYTEX_HOME" >> "$GITHUB_ENV"
  fi
}

# Install / verify TinyTeX
bash "$SCRIPT_DIR/setup-ci-tinytex.sh"
ensure_tinytex_path || {
  echo "ERROR: TinyTeX not on PATH after setup-ci-tinytex.sh" >&2
  ls -la "$TINYTEX_HOME/bin" 2>/dev/null || true
  exit 1
}

# Child bash process — pass TEXMFHOME explicitly via environment (exported above)
bash "$SCRIPT_DIR/install-ci-tex-extras.sh"

persist_env_for_later_steps

# Sanity checks in *this* process (must use same TEXMFHOME)
if ! kpsewhich soul.sty >/dev/null 2>&1; then
  echo "soul.sty missing — trying tlmgr install soul..."
  tlmgr install soul || true
fi
if ! kpsewhich soul.sty >/dev/null 2>&1; then
  echo "ERROR: soul.sty still not found" >&2
  exit 1
fi
if ! kpsewhich fontawesome5.sty >/dev/null 2>&1; then
  echo "ERROR: fontawesome5.sty not found (TEXMFHOME=$TEXMFHOME)" >&2
  echo "  kpsewhich -var-value=TEXMFHOME => $(kpsewhich -var-value=TEXMFHOME 2>/dev/null || true)" >&2
  find "$TEXMFHOME" -name 'fontawesome5.sty' 2>/dev/null || true
  exit 1
fi

echo "ci-tex-setup: soul -> $(kpsewhich soul.sty)"
echo "ci-tex-setup: fontawesome5 -> $(kpsewhich fontawesome5.sty)"
echo "ci-tex-setup: TEXMFHOME=$TEXMFHOME"

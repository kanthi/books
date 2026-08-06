#!/usr/bin/env bash
# One entrypoint for GHA: TinyTeX PATH + fontawesome extras + sanity checks.
#
# Important: do not run setup/install as nested `bash script.sh` without
# re-exporting PATH — child shells do not keep the parent's PATH exports,
# and GITHUB_PATH only applies to *later* workflow steps.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TINYTEX_HOME="${TINYTEX_HOME:-$HOME/.TinyTeX}"

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

# Install / verify TinyTeX (writes GITHUB_PATH; also needs PATH in *this* process)
bash "$SCRIPT_DIR/setup-ci-tinytex.sh"
ensure_tinytex_path || {
  echo "ERROR: TinyTeX not on PATH after setup-ci-tinytex.sh" >&2
  ls -la "$TINYTEX_HOME/bin" 2>/dev/null || true
  exit 1
}

bash "$SCRIPT_DIR/install-ci-tex-extras.sh"

# Required for Networking-style ~~strikethrough~~ and callout icons
if ! kpsewhich soul.sty >/dev/null 2>&1; then
  echo "soul.sty missing — trying tlmgr install soul..."
  tlmgr install soul || true
fi
if ! kpsewhich soul.sty >/dev/null 2>&1; then
  echo "ERROR: soul.sty still not found" >&2
  exit 1
fi
if ! kpsewhich fontawesome5.sty >/dev/null 2>&1; then
  echo "ERROR: fontawesome5.sty not found" >&2
  exit 1
fi

echo "ci-tex-setup: soul -> $(kpsewhich soul.sty)"
echo "ci-tex-setup: fontawesome5 -> $(kpsewhich fontawesome5.sty)"

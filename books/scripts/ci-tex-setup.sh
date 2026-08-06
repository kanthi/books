#!/usr/bin/env bash
# One entrypoint for GHA: TinyTeX PATH + fontawesome extras + sanity checks.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/setup-ci-tinytex.sh"
bash "$SCRIPT_DIR/install-ci-tex-extras.sh"

# Required for Networking-style ~~strikethrough~~ and callout icons
if ! kpsewhich soul.sty >/dev/null; then
  echo "soul.sty missing — trying tlmgr install soul..."
  tlmgr install soul || true
fi
if ! kpsewhich soul.sty >/dev/null; then
  echo "ERROR: soul.sty still not found" >&2
  exit 1
fi
if ! kpsewhich fontawesome5.sty >/dev/null; then
  echo "ERROR: fontawesome5.sty not found" >&2
  exit 1
fi

echo "ci-tex-setup: soul -> $(kpsewhich soul.sty)"
echo "ci-tex-setup: fontawesome5 -> $(kpsewhich fontawesome5.sty)"

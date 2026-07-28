#!/usr/bin/env bash
# indiprev.sh — local HTML preview for one or more books; opens Safari when ready.
#
# Safari note: many Safari setups allow only HTTPS. This script defaults to
# HTTPS on https://localhost:<port>/ using a local self-signed certificate.
# On first visit Safari will warn once — choose "Visit Website" / trust localhost.
#
# Usage:
#   ./indiprev.sh <book> [book2 ...] [options]
#
# Modes:
#   (default)  Static HTTPS preview of each book's _book/ (fast).
#   --live     Quarto live-reload on an internal HTTP port, fronted by HTTPS proxy.
#
# Options:
#   -h, --help          Show help
#   --live              Quarto live reload (HTTPS front-door + HTTP upstream)
#   --http              Force plain HTTP (not recommended for Safari)
#   --no-browser        Do not open a browser
#   --port <n>          Public base port (default: 4242). Multi-book uses n, n+1, …
#   --update-index      Run scripts/update-index.sh first
#   --render <fmt>      Only with --live (default: none)
#   --browser <name>    macOS browser app (default: Safari)
#   --                  Extra args for `quarto preview` (--live only)
#
# Examples:
#   ./indiprev.sh Go
#   ./indiprev.sh Go NixOS Maths
#   ./indiprev.sh Go --live
#   ./indiprev.sh Go --http            # plain HTTP if you really need it
#   ./indiprev.sh Go --browser "Google Chrome"
#
# Notes:
#   - Run from monorepo books/ directory.
#   - Certs live in books/.preview-certs/ (auto-generated; gitignored).
#   - Ctrl-C stops all servers.

set -euo pipefail

usage() {
  sed -n '2,36p' "$0" | sed 's/^# \{0,1\}//'
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

BOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BOOKS_DIR"

HTTPS_SERVER_PY="$BOOKS_DIR/scripts/preview-https-server.py"
CERT_DIR="$BOOKS_DIR/.preview-certs"
CERT_FILE="$CERT_DIR/localhost.pem"
KEY_FILE="$CERT_DIR/localhost-key.pem"

BOOKS=()
QUARTO_EXTRA=()
NO_BROWSER=0
LIVE=0
USE_HTTP=0
PORT_BASE=4242
RENDER_FMT="none"
UPDATE_INDEX=0
BROWSER_APP="Safari"
PARSE_EXTRA=0
READY_TIMEOUT=900

while [[ $# -gt 0 ]]; do
  if [[ $PARSE_EXTRA -eq 1 ]]; then
    QUARTO_EXTRA+=("$1")
    shift
    continue
  fi
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --no-browser) NO_BROWSER=1; shift ;;
    --live) LIVE=1; shift ;;
    --http) USE_HTTP=1; shift ;;
    --port)
      PORT_BASE="${2:?--port requires a number}"
      shift 2
      ;;
    --render)
      RENDER_FMT="${2:?--render requires a format}"
      shift 2
      ;;
    --update-index) UPDATE_INDEX=1; shift ;;
    --browser)
      BROWSER_APP="${2:?--browser requires an app name}"
      shift 2
      ;;
    --) PARSE_EXTRA=1; shift ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *) BOOKS+=("$1"); shift ;;
  esac
done

if [[ ${#BOOKS[@]} -eq 0 ]]; then
  echo "Error: provide at least one book name"
  usage
  exit 1
fi

for BOOK_NAME in "${BOOKS[@]}"; do
  if [[ ! -d "$BOOKS_DIR/$BOOK_NAME" ]]; then
    echo "Error: Book directory '$BOOK_NAME' not found in $BOOKS_DIR"
    exit 1
  fi
  if [[ ! -f "$BOOKS_DIR/$BOOK_NAME/_quarto.yml" ]]; then
    echo "Error: '$BOOK_NAME' has no _quarto.yml"
    exit 1
  fi
done

if [[ $USE_HTTP -eq 0 ]]; then
  if [[ ! -f "$HTTPS_SERVER_PY" ]]; then
    echo "Error: missing $HTTPS_SERVER_PY"
    exit 1
  fi
  if ! command -v openssl >/dev/null 2>&1; then
    echo "Error: openssl is required for HTTPS preview (or pass --http)"
    exit 1
  fi
  if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 is required for HTTPS preview"
    exit 1
  fi
fi

PIDS=()
PORTS_IN_USE=()

cleanup() {
  local pid port ids
  echo ""
  echo "Stopping preview server(s)..."
  for pid in "${PIDS[@]:-}"; do
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      pkill -P "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    fi
  done
  for port in "${PORTS_IN_USE[@]:-}"; do
    if command -v lsof >/dev/null 2>&1; then
      ids="$(lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null || true)"
      if [[ -n "$ids" ]]; then
        # shellcheck disable=SC2086
        kill $ids 2>/dev/null || true
      fi
    fi
  done
}
trap cleanup EXIT INT TERM

scheme() {
  if [[ $USE_HTTP -eq 1 ]]; then
    printf 'http'
  else
    printf 'https'
  fi
}

book_url() {
  printf '%s://localhost:%s/' "$(scheme)" "$1"
}

ensure_certs() {
  mkdir -p "$CERT_DIR"
  if [[ -f "$CERT_FILE" && -f "$KEY_FILE" ]]; then
    return 0
  fi
  echo "Generating local HTTPS cert for localhost (one-time)..."
  # SAN for localhost + 127.0.0.1 (Safari is picky about names)
  local conf
  conf="$(mktemp "${TMPDIR:-/tmp}/indiprev-openssl.XXXXXX.cnf")"
  cat >"$conf" <<'EOF'
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = localhost

[v3_req]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOF
  openssl req -x509 -newkey rsa:2048 -sha256 -days 825 -nodes \
    -keyout "$KEY_FILE" \
    -out "$CERT_FILE" \
    -config "$conf" \
    -extensions v3_req
  rm -f "$conf"
  echo "  cert: $CERT_FILE"
  echo "  key:  $KEY_FILE"
  echo "  Safari will warn once on first visit — use Visit Website / Allow."
}

port_listening() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1
    return $?
  fi
  return 1
}

http_ok() {
  local port="$1"
  local url
  url="$(book_url "$port")"
  # -k: accept self-signed cert for readiness probe
  if [[ $USE_HTTP -eq 1 ]]; then
    curl -fsS -o /dev/null --connect-timeout 1 --max-time 3 "$url" 2>/dev/null \
      || curl -fsS -o /dev/null --connect-timeout 1 --max-time 3 "http://127.0.0.1:${port}/" 2>/dev/null
  else
    curl -kfsS -o /dev/null --connect-timeout 1 --max-time 3 "$url" 2>/dev/null \
      || curl -kfsS -o /dev/null --connect-timeout 1 --max-time 3 "https://127.0.0.1:${port}/" 2>/dev/null
  fi
}

free_port() {
  local port="$1"
  local ids
  if command -v lsof >/dev/null 2>&1; then
    ids="$(lsof -nP -iTCP:"$port" -sTCP:LISTEN -t 2>/dev/null || true)"
    if [[ -n "$ids" ]]; then
      echo "Port $port in use — freeing..."
      # shellcheck disable=SC2086
      kill $ids 2>/dev/null || true
      sleep 1
    fi
  fi
}

wait_ready() {
  local book="$1" port="$2" pid="$3" i=0
  local url
  url="$(book_url "$port")"
  echo "Waiting for $book at $url ..."
  while [[ $i -lt $READY_TIMEOUT ]]; do
    if http_ok "$port"; then
      echo "Ready: $book -> $url"
      return 0
    fi
    if ! kill -0 "$pid" 2>/dev/null && ! port_listening "$port"; then
      echo "Error: server for $book exited before becoming ready."
      return 1
    fi
    sleep 1
    i=$((i + 1))
    if [[ $((i % 20)) -eq 0 ]]; then
      echo "  still waiting (${i}s)..."
    fi
  done
  echo "Error: timed out waiting for $book on port $port"
  return 1
}

open_url() {
  local url="$1"
  if [[ $NO_BROWSER -eq 1 ]]; then
    echo "(no browser) $url"
    return 0
  fi
  if command -v open >/dev/null 2>&1; then
    if open -a "$BROWSER_APP" "$url" 2>/dev/null; then
      echo "Opened in $BROWSER_APP: $url"
      if [[ $USE_HTTP -eq 0 ]]; then
        echo "If Safari blocks the page: allow the local certificate once (Visit Website)."
      fi
      return 0
    fi
    open "$url" 2>/dev/null && echo "Opened: $url" && return 0
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1 || true
    echo "Opened: $url"
    return 0
  fi
  echo "Open manually: $url"
}

update_index() {
  local book="$1"
  if [[ -f "$BOOKS_DIR/$book/scripts/update-index.sh" ]]; then
    echo "Updating index: $book"
    (cd "$BOOKS_DIR/$book" && bash scripts/update-index.sh)
  fi
}

ensure_html_build() {
  local book="$1"
  local idx="$BOOKS_DIR/$book/_book/index.html"
  if [[ -f "$idx" ]]; then
    return 0
  fi
  echo "No $book/_book/index.html yet — running one-shot HTML render..."
  if [[ -f "$BOOKS_DIR/$book/scripts/update-index.sh" ]]; then
    (cd "$BOOKS_DIR/$book" && bash scripts/update-index.sh)
  fi
  (cd "$BOOKS_DIR/$book" && quarto render --to html)
  if [[ ! -f "$idx" ]]; then
    echo "Error: render finished but $idx is still missing"
    return 1
  fi
}

start_static() {
  local book="$1" port="$2"
  local serve_dir="$BOOKS_DIR/$book/_book"

  free_port "$port"
  ensure_html_build "$book" || return 1

  echo "Starting static preview: $book"
  echo "  url:  $(book_url "$port")"
  echo "  path: $serve_dir"

  if [[ $USE_HTTP -eq 1 ]]; then
    (
      cd "$serve_dir"
      exec python3 -m http.server "$port" --bind 127.0.0.1
    ) &
  else
    ensure_certs
    (
      exec python3 "$HTTPS_SERVER_PY" static \
        --port "$port" \
        --dir "$serve_dir" \
        --cert "$CERT_FILE" \
        --key "$KEY_FILE" \
        --bind 127.0.0.1
    ) &
  fi
  local pid=$!
  PIDS+=("$pid")
  PORTS_IN_USE+=("$port")

  wait_ready "$book" "$port" "$pid" || return 1
  open_url "$(book_url "$port")"
  return 0
}

start_live() {
  local book="$1" port="$2"
  local book_dir="$BOOKS_DIR/$book"
  local log
  log="$(mktemp "${TMPDIR:-/tmp}/indiprev-${book}.XXXXXX")"
  # Internal plain HTTP port for Quarto (not opened in browser when HTTPS)
  local up_port=$((port + 10000))

  free_port "$port"
  free_port "$up_port"

  local -a cmd=(quarto preview --port "$up_port" --host 127.0.0.1 --no-browser)
  if [[ "$RENDER_FMT" != "none" ]]; then
    cmd+=(--render "$RENDER_FMT")
  fi
  if [[ ${#QUARTO_EXTRA[@]} -gt 0 ]]; then
    cmd+=("${QUARTO_EXTRA[@]}")
  fi

  echo "Starting live (Quarto) preview: $book"
  echo "  public: $(book_url "$port")"
  if [[ $USE_HTTP -eq 0 ]]; then
    echo "  upstream: http://127.0.0.1:${up_port}/ (Quarto; not opened directly)"
  else
    echo "  quarto: http://127.0.0.1:${up_port}/"
  fi
  echo "  log: $log"
  echo "  note: first Quarto listen can take a while while chapters render."
  echo ""

  (
    cd "$book_dir"
    "${cmd[@]}" 2>&1 | tee -a "$log"
  ) &
  local qpid=$!
  PIDS+=("$qpid")
  PORTS_IN_USE+=("$up_port")

  # Wait until Quarto HTTP is up first
  local i=0
  echo "Waiting for Quarto upstream on :$up_port ..."
  while [[ $i -lt $READY_TIMEOUT ]]; do
    if curl -fsS -o /dev/null --connect-timeout 1 --max-time 2 "http://127.0.0.1:${up_port}/" 2>/dev/null; then
      echo "Quarto upstream ready."
      break
    fi
    if ! kill -0 "$qpid" 2>/dev/null; then
      echo "Error: Quarto exited early. Last log lines:"
      tail -40 "$log" 2>/dev/null || true
      return 1
    fi
    sleep 1
    i=$((i + 1))
    if [[ $((i % 20)) -eq 0 ]]; then
      echo "  still waiting for Quarto (${i}s)..."
    fi
  done
  if [[ $i -ge $READY_TIMEOUT ]]; then
    echo "Error: timed out waiting for Quarto upstream"
    tail -40 "$log" 2>/dev/null || true
    return 1
  fi

  if [[ $USE_HTTP -eq 1 ]]; then
    # Browser hits Quarto HTTP directly
    open_url "http://localhost:${up_port}/"
    # Keep qpid as main server
    return 0
  fi

  ensure_certs
  (
    exec python3 "$HTTPS_SERVER_PY" proxy \
      --port "$port" \
      --upstream "127.0.0.1:${up_port}" \
      --cert "$CERT_FILE" \
      --key "$KEY_FILE" \
      --bind 127.0.0.1
  ) &
  local ppid=$!
  PIDS+=("$ppid")
  PORTS_IN_USE+=("$port")

  wait_ready "$book" "$port" "$ppid" || return 1
  open_url "$(book_url "$port")"
  return 0
}

# --- main ---
if [[ $USE_HTTP -eq 0 ]]; then
  MODE_PROTO="HTTPS"
else
  MODE_PROTO="HTTP"
fi
if [[ $LIVE -eq 1 ]]; then
  MODE_LABEL="live (quarto + ${MODE_PROTO} front-door)"
else
  MODE_LABEL="static (_book + ${MODE_PROTO})"
fi

echo "Books: ${BOOKS[*]}"
echo "Mode:  $MODE_LABEL"
echo "URL:   $(scheme)://localhost:${PORT_BASE}/  browser=$BROWSER_APP"
if [[ $USE_HTTP -eq 0 ]]; then
  echo "Note:  Safari requires HTTPS here; first visit may ask to trust the local cert."
fi
echo ""

if [[ $UPDATE_INDEX -eq 1 ]]; then
  for BOOK_NAME in "${BOOKS[@]}"; do
    update_index "$BOOK_NAME"
  done
  echo ""
fi

i=0
STARTED=0
FAILED=0
for BOOK_NAME in "${BOOKS[@]}"; do
  PORT=$((PORT_BASE + i))
  ok=0
  if [[ $LIVE -eq 1 ]]; then
    start_live "$BOOK_NAME" "$PORT" && ok=1
  else
    start_static "$BOOK_NAME" "$PORT" && ok=1
  fi
  if [[ $ok -eq 1 ]]; then
    STARTED=$((STARTED + 1))
  else
    FAILED=$((FAILED + 1))
  fi
  i=$((i + 1))
  echo ""
done

if [[ $STARTED -eq 0 ]]; then
  echo "No preview servers became ready."
  exit 1
fi

echo "Preview running ($STARTED book(s)). Leave this terminal open."
if [[ $FAILED -gt 0 ]]; then
  echo "Warning: $FAILED book(s) failed — see above."
fi
if [[ $LIVE -eq 0 ]]; then
  echo "Static mode: after edits run ./indipub.sh BOOK then refresh Safari."
  echo "Live reload: ./indiprev.sh BOOK --live"
fi
echo "Press Ctrl-C to stop."

wait || true

#!/usr/bin/env bash
set -euo pipefail

BOOKS_DIR="$(pwd)"
PUBLISH_DIR="$BOOKS_DIR/published_books"
ASSETS_DIR="$PUBLISH_DIR/assets"
HTML_DIR="$PUBLISH_DIR/html"
PDF_DIR="$PUBLISH_DIR/pdf"
EPUB_DIR="$PUBLISH_DIR/epub"

COUNT_OK=0
COUNT_FAIL=0
COUNT_HTML=0
COUNT_PDF=0
COUNT_EPUB=0

ENTRIES_FILE="$(mktemp)"

cleanup() {
  rm -f "$ENTRIES_FILE"
}
trap cleanup EXIT

log() {
  printf '%s\n' "$*"
}

display_name() {
  local raw="$1"
  printf '%s' "$raw" | sed 's/[-_]/ /g'
}

hash_hue() {
  local input="$1"
  local csum
  csum="$(printf '%s' "$input" | cksum | awk '{print $1}')"
  printf '%d' "$(((csum * 137) % 360))"
}

generate_book_cover() {
  local book_name="$1"
  local title
  local hue
  local cover
  local title_len
  local fs

  title="$(display_name "$book_name")"
  hue="$(hash_hue "$book_name")"
  cover="$ASSETS_DIR/${book_name}.svg"
  title_len="${#title}"

  fs=30
  if [ "$title_len" -gt 36 ]; then
    fs=22
  elif [ "$title_len" -gt 26 ]; then
    fs=26
  fi

  cat > "$cover" <<SVG
<svg width="360" height="520" viewBox="0 0 360 520" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="$title cover">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="hsl(${hue} 38% 62%)"/>
      <stop offset="100%" stop-color="hsl($(((hue + 35) % 360)) 34% 44%)"/>
    </linearGradient>
    <linearGradient id="panel" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="rgba(255,255,255,.26)"/>
      <stop offset="100%" stop-color="rgba(255,255,255,.08)"/>
    </linearGradient>
    <filter id="shadow" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="14" stdDeviation="16" flood-color="#000" flood-opacity=".2"/>
    </filter>
  </defs>

  <rect x="14" y="14" width="332" height="492" rx="24" fill="url(#bg)" filter="url(#shadow)"/>
  <rect x="28" y="28" width="304" height="464" rx="18" fill="url(#panel)"/>

  <rect x="42" y="44" width="276" height="132" rx="14" fill="rgba(19,20,27,.24)"/>
  <text x="180" y="74" text-anchor="middle" fill="#f6f8fb" font-family="'Avenir Next','Segoe UI',sans-serif" font-size="10" letter-spacing="2" opacity=".7">BOOK</text>
  <foreignObject x="54" y="84" width="252" height="84">
    <div xmlns="http://www.w3.org/1999/xhtml" style="font-family:'Avenir Next','Segoe UI',sans-serif;font-weight:760;font-size:${fs}px;line-height:1.08;color:#ffffff;text-align:center;display:flex;align-items:center;justify-content:center;height:100%;word-break:break-word;overflow-wrap:anywhere;">
      ${title}
    </div>
  </foreignObject>

  <g transform="translate(52 228)">
    <rect x="0" y="182" width="256" height="10" rx="4" fill="rgba(0,0,0,.26)"/>
    <rect x="10" y="36" width="18" height="146" rx="4" fill="hsl($(((hue + 12) % 360)) 24% 32%)"/>
    <rect x="32" y="26" width="20" height="156" rx="4" fill="hsl($(((hue + 28) % 360)) 27% 38%)"/>
    <rect x="56" y="44" width="14" height="138" rx="4" fill="hsl($(((hue + 45) % 360)) 24% 34%)"/>
    <rect x="74" y="18" width="23" height="164" rx="4" fill="hsl($(((hue + 63) % 360)) 30% 42%)"/>
    <rect x="101" y="30" width="17" height="152" rx="4" fill="hsl($(((hue + 85) % 360)) 27% 36%)"/>
    <rect x="122" y="38" width="14" height="144" rx="4" fill="hsl($(((hue + 106) % 360)) 22% 33%)"/>
    <rect x="140" y="22" width="22" height="160" rx="4" fill="hsl($(((hue + 126) % 360)) 29% 40%)"/>
    <rect x="166" y="32" width="18" height="150" rx="4" fill="hsl($(((hue + 145) % 360)) 27% 37%)"/>
    <rect x="188" y="26" width="20" height="156" rx="4" fill="hsl($(((hue + 166) % 360)) 25% 35%)"/>
    <rect x="212" y="36" width="14" height="146" rx="4" fill="hsl($(((hue + 185) % 360)) 28% 39%)"/>
    <rect x="230" y="20" width="20" height="162" rx="4" fill="hsl($(((hue + 204) % 360)) 30% 42%)"/>
  </g>

  <rect x="42" y="470" width="276" height="6" rx="3" fill="rgba(255,255,255,.34)"/>
</svg>
SVG
}

find_html_entry() {
  local book="$1"
  if [ -f "$HTML_DIR/$book/index.html" ]; then
    printf './html/%s/index.html' "$book"
    return
  fi

  local first_html
  first_html="$(find "$HTML_DIR/$book" -maxdepth 2 -type f -name '*.html' | sort | head -n 1 || true)"
  if [ -n "$first_html" ]; then
    printf './html/%s' "${first_html#"$HTML_DIR/$book/"}"
    return
  fi

  printf ''
}

write_index_header() {
  cat > "$PUBLISH_DIR/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Published Books</title>
  <style>
    :root {
      --bg: #f7f8fb;
      --ink: #171a24;
      --muted: #69718a;
      --surface: #ffffff;
      --line: #e4e8f1;
      --accent: #2458e8;
      --accent-2: #1f8f72;
      --pdf: #cc4545;
      --radius: 16px;
      --shadow: 0 10px 24px rgba(21,35,77,.08);
    }
    body[data-theme="dark"] {
      --bg: #0f1219;
      --ink: #edf1ff;
      --muted: #9ea7c2;
      --surface: #171c27;
      --line: #2a3246;
      --accent: #83a8ff;
      --accent-2: #77dbc1;
      --pdf: #ff8c8c;
      --shadow: 0 16px 34px rgba(0,0,0,.34);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      background: var(--bg);
      color: var(--ink);
      font-family: "Sora", "Avenir Next", "Segoe UI", sans-serif;
    }
    .wrap { max-width: 1160px; margin: 0 auto; padding: 30px 20px 56px; }
    .top {
      display: grid;
      gap: 14px;
      border: 1px solid var(--line);
      border-radius: 18px;
      padding: 18px 18px 16px;
      background: var(--surface);
      box-shadow: var(--shadow);
    }
    .top h1 { margin: 0; font-size: clamp(1.35rem, 2.8vw, 2rem); letter-spacing: -.02em; }
    .top p { margin: 0; color: var(--muted); font-size: .95rem; }
    .controls { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
    .search {
      flex: 1 1 260px;
      min-width: 220px;
      border: 1px solid var(--line);
      background: var(--surface);
      color: var(--ink);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: .94rem;
    }
    .toggle {
      border: 1px solid var(--line);
      background: var(--surface);
      color: var(--ink);
      border-radius: 10px;
      padding: 10px 12px;
      font-size: .86rem;
      font-weight: 700;
      cursor: pointer;
    }
    .stats { display: flex; gap: 8px; flex-wrap: wrap; }
    .stat {
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 5px 10px;
      color: var(--muted);
      font-size: .78rem;
      background: var(--surface);
    }
    .grid {
      margin-top: 18px;
      display: grid;
      gap: 14px;
      grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
    }
    .card {
      border: 1px solid var(--line);
      border-radius: var(--radius);
      background: var(--surface);
      overflow: hidden;
      box-shadow: var(--shadow);
      border-top: 3px solid hsl(var(--book-h) 42% 52%);
      transition: transform .14s ease;
    }
    .card:hover { transform: translateY(-2px); }
    .cover-wrap {
      border-bottom: 1px solid var(--line);
      background: linear-gradient(160deg, hsl(var(--book-h) 42% 95%), hsl(var(--book-h2) 30% 93%));
      padding: 14px;
      display: flex;
      justify-content: center;
    }
    .cover {
      width: min(82%, 220px);
      max-height: 260px;
      object-fit: contain;
      filter: drop-shadow(0 6px 12px rgba(0,0,0,.12));
    }
    .info {
      padding: 12px 13px 14px;
      display: grid;
      gap: 8px;
    }
    .title {
      margin: 0;
      font-size: 1.06rem;
      line-height: 1.22;
      letter-spacing: -.01em;
    }
    .meta {
      margin: 0;
      color: var(--muted);
      font-size: .8rem;
    }
    .formats {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
    }
    .format-link {
      text-decoration: none;
      border: 1px solid;
      border-radius: 8px;
      padding: 6px 9px;
      font-size: .76rem;
      font-weight: 700;
      letter-spacing: .02em;
      transition: opacity .12s ease;
    }
    .format-link:hover { opacity: .86; }
    .format-link.html { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 45%, var(--line)); background: color-mix(in srgb, var(--accent) 11%, var(--surface)); }
    .format-link.pdf { color: var(--pdf); border-color: color-mix(in srgb, var(--pdf) 45%, var(--line)); background: color-mix(in srgb, var(--pdf) 10%, var(--surface)); }
    .format-link.epub { color: var(--accent-2); border-color: color-mix(in srgb, var(--accent-2) 48%, var(--line)); background: color-mix(in srgb, var(--accent-2) 12%, var(--surface)); }
    .empty {
      display: none;
      margin-top: 14px;
      border: 1px dashed var(--line);
      border-radius: 12px;
      padding: 12px;
      color: var(--muted);
      background: var(--surface);
    }
    footer {
      margin-top: 18px;
      border-top: 1px solid var(--line);
      padding-top: 11px;
      color: var(--muted);
      font-size: .8rem;
    }
  </style>
</head>
<body>
  <main class="wrap">
    <section class="top">
      <h1>Published Books</h1>
      <p>Minimal library view for all rendered outputs.</p>
      <div class="controls">
        <input id="bookSearch" class="search" type="search" placeholder="Search books..." aria-label="Search books">
        <button id="themeToggle" class="toggle" type="button">Dark</button>
      </div>
      <div class="stats">
        <span class="stat">Books: <strong id="statBooks">0</strong></span>
        <span class="stat">HTML: <strong id="statHtml">0</strong></span>
        <span class="stat">PDF: <strong id="statPdf">0</strong></span>
        <span class="stat">EPUB: <strong id="statEpub">0</strong></span>
      </div>
    </section>

    <section id="bookGrid" class="grid">
HTML
}

write_index_footer() {
  local end_ts="$1"
  cat >> "$PUBLISH_DIR/index.html" <<HTML
    </section>

    <div id="emptyState" class="empty">No books match your search.</div>

    <footer>
      Generated: $end_ts
    </footer>
  </main>

  <script>
    (function () {
      const body = document.body;
      const cards = Array.from(document.querySelectorAll('.card'));
      const search = document.getElementById('bookSearch');
      const empty = document.getElementById('emptyState');
      const toggle = document.getElementById('themeToggle');

      function setTheme(mode) {
        body.setAttribute('data-theme', mode);
        localStorage.setItem('books_theme_v2', mode);
        toggle.textContent = mode === 'dark' ? 'Light' : 'Dark';
      }

      const saved = localStorage.getItem('books_theme_v2');
      if (saved === 'dark' || saved === 'light') {
        setTheme(saved);
      } else {
        const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
        setTheme(prefersDark ? 'dark' : 'light');
      }

      function refreshStats() {
        const visible = cards.filter(c => c.style.display !== 'none');
        document.getElementById('statBooks').textContent = String(visible.length);
        document.getElementById('statHtml').textContent = String(visible.filter(c => c.dataset.hasHtml === '1').length);
        document.getElementById('statPdf').textContent = String(visible.filter(c => c.dataset.hasPdf === '1').length);
        document.getElementById('statEpub').textContent = String(visible.filter(c => c.dataset.hasEpub === '1').length);
        empty.style.display = visible.length ? 'none' : 'block';
      }

      search.addEventListener('input', () => {
        const q = search.value.trim().toLowerCase();
        cards.forEach(card => {
          card.style.display = card.dataset.search.includes(q) ? '' : 'none';
        });
        refreshStats();
      });

      toggle.addEventListener('click', () => {
        setTheme(body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
      });

      refreshStats();
    })();
  </script>
</body>
</html>
HTML
}

append_book_card() {
  local book_name="$1"
  local has_html="$2"
  local has_pdf="$3"
  local has_epub="$4"
  local html_href="$5"

  local title
  local search_blob
  local hue
  local hue2

  title="$(display_name "$book_name")"
  search_blob="$(printf '%s %s' "$book_name" "$title" | tr '[:upper:]' '[:lower:]')"
  hue="$(hash_hue "$book_name")"
  hue2="$(((hue + 36) % 360))"

  {
    printf '      <article class="card" style="--book-h:%s;--book-h2:%s" data-search="%s" data-has-html="%s" data-has-pdf="%s" data-has-epub="%s">\n' "$hue" "$hue2" "$search_blob" "$has_html" "$has_pdf" "$has_epub"
    printf '        <div class="cover-wrap"><img class="cover" src="./assets/%s.svg" alt="%s cover"></div>\n' "$book_name" "$title"
    printf '        <div class="info">\n'
    printf '          <h2 class="title">%s</h2>\n' "$title"
    printf '          <p class="meta">%s</p>\n' "$book_name"
    printf '          <div class="formats">\n'

    if [ "$has_html" = "1" ] && [ -n "$html_href" ]; then
      printf '            <a class="format-link html" href="%s" target="_blank" rel="noopener">HTML</a>\n' "$html_href"
    fi
    if [ "$has_pdf" = "1" ]; then
      printf '            <a class="format-link pdf" href="./pdf/%s.pdf" target="_blank" rel="noopener">PDF</a>\n' "$book_name"
    fi
    if [ "$has_epub" = "1" ]; then
      printf '            <a class="format-link epub" href="./epub/%s.epub" target="_blank" rel="noopener">EPUB</a>\n' "$book_name"
    fi

    printf '          </div>\n'
    printf '        </div>\n'
    printf '      </article>\n'
  } >> "$ENTRIES_FILE"
}

prepare_publish_dir() {
  if [ -d "$PUBLISH_DIR" ]; then
    log "Cleaning existing published_books directory..."
    rm -rf "$PUBLISH_DIR"
  fi

  mkdir -p "$PUBLISH_DIR" "$ASSETS_DIR" "$HTML_DIR" "$PDF_DIR" "$EPUB_DIR"
}

process_book() {
  local book_dir="$1"
  local book_name
  local pdf_src
  local epub_src
  local html_entry
  local has_html=0
  local has_pdf=0
  local has_epub=0

  book_name="${book_dir%/}"

  log "----------------------------------------"
  log "Found book: $book_name"

  cd "$BOOKS_DIR/$book_name"

  if [ -f "scripts/update-index.sh" ]; then
    log "Running scripts/update-index.sh"
    if ! bash "scripts/update-index.sh"; then
      log "update-index.sh failed for $book_name"
      COUNT_FAIL=$((COUNT_FAIL + 1))
      cd "$BOOKS_DIR"
      return
    fi
  fi

  log "Rendering book with Quarto"
  if ! quarto render; then
    log "Render failed for $book_name"
    COUNT_FAIL=$((COUNT_FAIL + 1))
    cd "$BOOKS_DIR"
    return
  fi

  generate_book_cover "$book_name"

  mkdir -p "$HTML_DIR/$book_name"
  if [ -d "_book" ]; then
    cp -R "_book"/* "$HTML_DIR/$book_name/"
  else
    log "Missing _book output for $book_name"
    COUNT_FAIL=$((COUNT_FAIL + 1))
    cd "$BOOKS_DIR"
    return
  fi

  pdf_src="$(find "_book" -maxdepth 1 -type f -iname '*.pdf' | head -n 1 || true)"
  epub_src="$(find "_book" -maxdepth 1 -type f -iname '*.epub' | head -n 1 || true)"

  if [ -f "$HTML_DIR/$book_name/index.html" ] || [ -n "$(find "$HTML_DIR/$book_name" -maxdepth 2 -type f -name '*.html' | head -n 1 || true)" ]; then
    has_html=1
    COUNT_HTML=$((COUNT_HTML + 1))
  fi

  if [ -n "$pdf_src" ] && [ -f "$pdf_src" ]; then
    cp "$pdf_src" "$PDF_DIR/$book_name.pdf"
    has_pdf=1
    COUNT_PDF=$((COUNT_PDF + 1))
  fi

  if [ -n "$epub_src" ] && [ -f "$epub_src" ]; then
    cp "$epub_src" "$EPUB_DIR/$book_name.epub"
    has_epub=1
    COUNT_EPUB=$((COUNT_EPUB + 1))
  fi

  html_entry="$(find_html_entry "$book_name")"

  append_book_card "$book_name" "$has_html" "$has_pdf" "$has_epub" "$html_entry"

  COUNT_OK=$((COUNT_OK + 1))
  cd "$BOOKS_DIR"
}

main() {
  log "Starting renderpub-codex-v2"
  log "Working directory: $BOOKS_DIR"

  prepare_publish_dir

  local found_any=0
  local d
  for d in */; do
    if [ -d "$d" ] && [ -f "${d}_quarto.yml" ]; then
      found_any=1
      process_book "$d"
    fi
  done

  write_index_header
  cat "$ENTRIES_FILE" >> "$PUBLISH_DIR/index.html"
  write_index_footer "$(date '+%Y-%m-%d %H:%M:%S')"

  log "----------------------------------------"
  log "Render summary"
  log "Rendered successfully: $COUNT_OK"
  log "Failed: $COUNT_FAIL"
  log "HTML outputs: $COUNT_HTML"
  log "PDF outputs: $COUNT_PDF"
  log "EPUB outputs: $COUNT_EPUB"

  if [ "$found_any" -eq 0 ]; then
    log "No book folders with _quarto.yml were found."
  fi

  log "Published output: $PUBLISH_DIR"
  log "Open: $PUBLISH_DIR/index.html"
}

main

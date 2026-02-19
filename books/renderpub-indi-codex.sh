#!/usr/bin/env bash
set -euo pipefail

BOOKS_DIR="$(pwd)"
PUBLISH_DIR="$BOOKS_DIR/published_books"
ASSETS_DIR="$PUBLISH_DIR/assets"
HTML_DIR="$PUBLISH_DIR/html"
PDF_DIR="$PUBLISH_DIR/pdf"
EPUB_DIR="$PUBLISH_DIR/epub"
INDI_BOOKS="${INDI_BOOKS:-${RENDER_BOOKS:-}}"
INCREMENTAL="${INCREMENTAL:-1}"

COUNT_OK=0
COUNT_FAIL=0
COUNT_HTML=0
COUNT_PDF=0
COUNT_EPUB=0
RENDER_OK=0
RENDER_FAIL=0

START_TS="$(date '+%Y-%m-%d %H:%M:%S')"
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
  # Golden-angle spread gives better visual separation across many titles.
  printf '%d' "$(((csum * 137) % 360))"
}

generate_book_cover() {
  local book_name="$1"
  local title
  local hue
  local cover
  local title_len
  local fs
  local fs_sub
  local y1
  local y2
  local sat_a
  local sat_b
  local lit_a
  local lit_b

  title="$(display_name "$book_name")"
  hue="$(hash_hue "$book_name")"
  cover="$ASSETS_DIR/${book_name}.svg"
  title_len="${#title}"

  fs=28
  fs_sub=11
  if [ "$title_len" -gt 38 ]; then
    fs=24
    fs_sub=10
  elif [ "$title_len" -gt 28 ]; then
    fs=27
    fs_sub=10
  else
    fs=31
  fi

  y1=36
  y2=72

  sat_a=40
  sat_b=34
  lit_a=63
  lit_b=45

  cat > "$cover" <<SVG
<svg width="360" height="520" viewBox="0 0 360 520" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="$title cover">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="hsl(${hue} ${sat_a}% ${lit_a}%)"/>
      <stop offset="100%" stop-color="hsl($(((hue + 42) % 360)) ${sat_b}% ${lit_b}%)"/>
    </linearGradient>
    <linearGradient id="glass" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="rgba(255,255,255,.34)"/>
      <stop offset="100%" stop-color="rgba(255,255,255,.08)"/>
    </linearGradient>
    <pattern id="dots" width="16" height="16" patternUnits="userSpaceOnUse">
      <circle cx="2" cy="2" r="1" fill="rgba(255,255,255,.14)"/>
    </pattern>
    <filter id="shadow" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="16" stdDeviation="16" flood-color="#000" flood-opacity=".22"/>
    </filter>
  </defs>

  <rect x="14" y="14" width="332" height="492" rx="24" fill="url(#bg)" filter="url(#shadow)"/>
  <rect x="14" y="14" width="332" height="492" rx="24" fill="url(#dots)"/>
  <rect x="26" y="26" width="308" height="468" rx="18" fill="url(#glass)"/>

  <rect x="40" y="40" width="280" height="130" rx="14" fill="rgba(17,18,26,.28)"/>
  <text x="180" y="$y1" text-anchor="middle" fill="#f5f7fb" font-family="'Avenir Next','Segoe UI',sans-serif" font-size="${fs_sub}" letter-spacing="2" opacity=".72">BOOK</text>
  <foreignObject x="52" y="$y2" width="256" height="86">
    <div xmlns="http://www.w3.org/1999/xhtml" style="font-family:'Avenir Next','Segoe UI',sans-serif;font-weight:750;font-size:${fs}px;line-height:1.08;color:#fdfefe;text-align:center;display:flex;align-items:center;justify-content:center;height:100%;word-break:break-word;overflow-wrap:anywhere;">
      ${title}
    </div>
  </foreignObject>

  <g transform="translate(48 220)">
    <rect x="0" y="184" width="264" height="12" rx="4" fill="rgba(0,0,0,.28)"/>
    <rect x="12" y="36" width="16" height="148" rx="4" fill="hsl($(((hue + 10) % 360)) 28% 33%)"/>
    <rect x="32" y="24" width="20" height="160" rx="4" fill="hsl($(((hue + 25) % 360)) 30% 39%)"/>
    <rect x="56" y="44" width="14" height="140" rx="4" fill="hsl($(((hue + 45) % 360)) 27% 35%)"/>
    <rect x="74" y="18" width="24" height="166" rx="4" fill="hsl($(((hue + 65) % 360)) 32% 43%)"/>
    <rect x="102" y="30" width="17" height="154" rx="4" fill="hsl($(((hue + 85) % 360)) 30% 37%)"/>
    <rect x="123" y="40" width="14" height="144" rx="4" fill="hsl($(((hue + 100) % 360)) 25% 34%)"/>
    <rect x="141" y="22" width="22" height="162" rx="4" fill="hsl($(((hue + 120) % 360)) 31% 42%)"/>
    <rect x="167" y="34" width="18" height="150" rx="4" fill="hsl($(((hue + 140) % 360)) 29% 38%)"/>
    <rect x="189" y="28" width="20" height="156" rx="4" fill="hsl($(((hue + 160) % 360)) 28% 36%)"/>
    <rect x="213" y="38" width="14" height="146" rx="4" fill="hsl($(((hue + 180) % 360)) 30% 40%)"/>
    <rect x="231" y="20" width="21" height="164" rx="4" fill="hsl($(((hue + 200) % 360)) 33% 44%)"/>
  </g>

  <rect x="40" y="470" width="280" height="8" rx="4" fill="rgba(255,255,255,.38)"/>
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
    printf './html/%s/%s' "$book" "${first_html#"$HTML_DIR/$book/"}"
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
      --bg: #f4f6fb;
      --ink: #151823;
      --muted: #5f667a;
      --surface: #ffffff;
      --line: #dce2ef;
      --accent: #175cff;
      --accent-2: #0f8b6d;
      --danger: #d64343;
      --shadow: 0 18px 40px rgba(10,24,58,.12);
      --radius: 18px;
    }
    body[data-theme="dark"] {
      --bg: #0f121a;
      --ink: #eef2ff;
      --muted: #a7b0c8;
      --surface: #171c28;
      --line: #2a3246;
      --accent: #7ea5ff;
      --accent-2: #6ed7bb;
      --danger: #ff8a8a;
      --shadow: 0 20px 42px rgba(0,0,0,.45);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      background:
        radial-gradient(900px 420px at 8% -10%, color-mix(in srgb, var(--accent) 18%, transparent) 0%, transparent 65%),
        radial-gradient(700px 380px at 110% 10%, color-mix(in srgb, var(--accent-2) 20%, transparent) 0%, transparent 65%),
        var(--bg);
      color: var(--ink);
      font-family: "Sora","Avenir Next","Segoe UI",sans-serif;
    }
    .wrap { max-width: 1240px; margin: 0 auto; padding: 32px 22px 72px; }
    .hero {
      border: 1px solid var(--line);
      background: linear-gradient(
        140deg,
        color-mix(in srgb, var(--surface) 88%, #ffffff 12%) 0%,
        color-mix(in srgb, var(--surface) 76%, var(--accent) 24%) 45%,
        color-mix(in srgb, var(--surface) 76%, var(--accent-2) 24%) 100%
      );
      border-radius: 26px;
      box-shadow: var(--shadow);
      padding: 28px;
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 20px;
      align-items: center;
    }
    .hero h1 { margin: 0; font-size: clamp(1.7rem, 3.2vw, 2.7rem); letter-spacing: -.02em; }
    .hero p { margin: 10px 0 0; color: var(--muted); font-size: 1.02rem; }
    .hero svg { width: 170px; height: auto; opacity: .95; }
    .controls {
      margin-top: 20px;
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      align-items: center;
    }
    .theme-toggle {
      border: 1px solid var(--line);
      background: var(--surface);
      color: var(--ink);
      border-radius: 12px;
      padding: 11px 14px;
      font-weight: 700;
      font-size: .9rem;
      cursor: pointer;
    }
    .theme-toggle:hover { border-color: color-mix(in srgb, var(--accent) 45%, var(--line)); }
    .search {
      flex: 1 1 300px;
      min-width: 260px;
      border: 1px solid var(--line);
      border-radius: 12px;
      background: var(--surface);
      padding: 12px 14px;
      font-size: .98rem;
      color: var(--ink);
      outline: none;
    }
    .search:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(23,92,255,.13); }
    .statbar {
      margin-top: 18px;
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
    .chip {
      border: 1px solid var(--line);
      background: var(--surface);
      color: color-mix(in srgb, var(--ink) 80%, #7d87a0 20%);
      border-radius: 999px;
      padding: 7px 11px;
      font-size: .82rem;
      font-weight: 600;
    }
    .grid {
      margin-top: 24px;
      display: grid;
      gap: 18px;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    }
    .card {
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: 0 12px 28px rgba(25,36,74,.08);
      border-top: 4px solid hsl(var(--book-h) 44% 52%);
      display: grid;
      grid-template-rows: auto 1fr;
      transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
    }
    .card:hover {
      transform: translateY(-4px);
      border-color: #b8c7ea;
      box-shadow: 0 18px 36px rgba(23,35,73,.16);
    }
    .cover-wrap {
      padding: 16px;
      display: flex;
      justify-content: center;
      background:
        linear-gradient(
          160deg,
          hsl(var(--book-h) 46% 95%) 0%,
          hsl(var(--book-h2) 34% 93%) 100%
        );
      border-bottom: 1px solid var(--line);
    }
    .cover {
      width: min(86%, 240px);
      max-height: 300px;
      object-fit: contain;
      filter: drop-shadow(0 8px 16px rgba(0,0,0,.14));
    }
    .info { padding: 16px 16px 18px; display: grid; gap: 12px; }
    .title { margin: 0; font-size: 1.2rem; letter-spacing: -.01em; line-height: 1.2; }
    .meta { color: var(--muted); font-size: .86rem; margin: 0; }
    .formats { display: flex; flex-wrap: wrap; gap: 8px; }
    .tag {
      display: inline-flex;
      align-items: center;
      padding: 6px 9px;
      border-radius: 8px;
      border: 1px solid;
      font-size: .75rem;
      font-weight: 700;
      letter-spacing: .02em;
    }
    .tag.html { color: var(--accent); border-color: #abc2ff; background: #edf3ff; }
    .tag.pdf { color: var(--danger); border-color: #f1b4b4; background: #fff0f0; }
    .tag.epub { color: var(--accent-2); border-color: #9fdfcc; background: #eafff7; }
    .actions { display: flex; gap: 8px; flex-wrap: wrap; }
    .btn {
      display: inline-block;
      text-decoration: none;
      border-radius: 9px;
      font-weight: 700;
      font-size: .82rem;
      padding: 8px 11px;
      border: 1px solid transparent;
    }
    .btn.primary { background: var(--accent); color: #fff; }
    .btn.ghost { border-color: var(--line); color: color-mix(in srgb, var(--ink) 86%, #96a1bb 14%); background: var(--surface); }
    .empty {
      display: none;
      margin-top: 22px;
      padding: 14px;
      border: 1px dashed #a9b8db;
      border-radius: 12px;
      color: color-mix(in srgb, var(--ink) 80%, #8fa0c4 20%);
      background: color-mix(in srgb, var(--surface) 86%, #dde8ff 14%);
    }
    footer {
      margin-top: 26px;
      color: var(--muted);
      font-size: .85rem;
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 8px;
      border-top: 1px solid var(--line);
      padding-top: 14px;
    }
    @media (max-width: 860px) {
      .hero { grid-template-columns: 1fr; }
      .hero svg { width: 140px; }
    }
  </style>
</head>
<body>
  <main class="wrap">
    <section class="hero">
      <div>
        <h1>Published Books</h1>
        <p>Rendered Quarto books, aggregated into one browseable library.</p>
      </div>
      <svg viewBox="0 0 220 160" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <defs>
          <linearGradient id="heroA" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="#1d6bff"/>
            <stop offset="100%" stop-color="#0ca57c"/>
          </linearGradient>
        </defs>
        <rect x="18" y="42" width="184" height="14" rx="5" fill="#dce4f7"/>
        <rect x="30" y="20" width="24" height="80" rx="6" fill="#3a5fb7"/>
        <rect x="60" y="10" width="28" height="90" rx="6" fill="#31a68e"/>
        <rect x="94" y="26" width="20" height="74" rx="6" fill="#4f78d9"/>
        <rect x="120" y="16" width="34" height="84" rx="6" fill="url(#heroA)"/>
        <rect x="160" y="22" width="24" height="78" rx="6" fill="#2f9f8a"/>
        <circle cx="38" cy="128" r="16" fill="#eff4ff"/>
        <path d="M31 128h14M38 121v14" stroke="#1d6bff" stroke-width="3" stroke-linecap="round"/>
      </svg>
    </section>

    <section class="controls">
      <input id="bookSearch" class="search" type="search" placeholder="Search books..." aria-label="Search books">
      <button id="themeToggle" class="theme-toggle" type="button" aria-label="Toggle theme">Dark theme</button>
    </section>

    <section class="statbar">
      <span class="chip">Books: <strong id="statBooks">0</strong></span>
      <span class="chip">HTML: <strong id="statHtml">0</strong></span>
      <span class="chip">PDF: <strong id="statPdf">0</strong></span>
      <span class="chip">EPUB: <strong id="statEpub">0</strong></span>
    </section>

    <section id="bookGrid" class="grid">
HTML
}

write_index_footer() {
  local end_ts="$1"
  cat >> "$PUBLISH_DIR/index.html" <<HTML
    </section>

    <div id="emptyState" class="empty">No books match your current search.</div>

    <footer>
      <span>Generated: $end_ts</span>
      <span>Script: renderpub-codex.sh</span>
    </footer>
  </main>

  <script>
    (function () {
      const root = document.body;
      const grid = document.getElementById('bookGrid');
      const cards = Array.from(grid.querySelectorAll('.card'));
      const search = document.getElementById('bookSearch');
      const empty = document.getElementById('emptyState');
      const themeBtn = document.getElementById('themeToggle');
      const savedTheme = localStorage.getItem('books_theme');

      function setTheme(mode) {
        root.setAttribute('data-theme', mode);
        localStorage.setItem('books_theme', mode);
        themeBtn.textContent = mode === 'dark' ? 'Light theme' : 'Dark theme';
      }

      if (savedTheme === 'dark' || savedTheme === 'light') {
        setTheme(savedTheme);
      } else {
        const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
        setTheme(prefersDark ? 'dark' : 'light');
      }

      function refreshStats() {
        const visible = cards.filter(c => c.style.display !== 'none');
        const html = visible.filter(c => c.dataset.hasHtml === '1').length;
        const pdf = visible.filter(c => c.dataset.hasPdf === '1').length;
        const epub = visible.filter(c => c.dataset.hasEpub === '1').length;

        document.getElementById('statBooks').textContent = String(visible.length);
        document.getElementById('statHtml').textContent = String(html);
        document.getElementById('statPdf').textContent = String(pdf);
        document.getElementById('statEpub').textContent = String(epub);

        empty.style.display = visible.length ? 'none' : 'block';
      }

      search.addEventListener('input', () => {
        const q = search.value.trim().toLowerCase();
        cards.forEach((card) => {
          const text = card.dataset.search;
          card.style.display = text.includes(q) ? '' : 'none';
        });
        refreshStats();
      });

      themeBtn.addEventListener('click', () => {
        const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        setTheme(next);
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
    printf '          <p class="meta">Folder: %s</p>\n' "$book_name"
    printf '          <div class="formats">\n'

    if [ "$has_html" = "1" ]; then
      printf '            <span class="tag html">HTML</span>\n'
    fi
    if [ "$has_pdf" = "1" ]; then
      printf '            <span class="tag pdf">PDF</span>\n'
    fi
    if [ "$has_epub" = "1" ]; then
      printf '            <span class="tag epub">EPUB</span>\n'
    fi

    printf '          </div>\n'
    printf '          <div class="actions">\n'

    if [ "$has_html" = "1" ]; then
      printf '            <a class="btn primary" href="%s" target="_blank" rel="noopener">Open HTML</a>\n' "$html_href"
    fi
    if [ "$has_pdf" = "1" ]; then
      printf '            <a class="btn ghost" href="./pdf/%s.pdf" target="_blank" rel="noopener">Open PDF</a>\n' "$book_name"
    fi
    if [ "$has_epub" = "1" ]; then
      printf '            <a class="btn ghost" href="./epub/%s.epub" target="_blank" rel="noopener">Open EPUB</a>\n' "$book_name"
    fi

    printf '          </div>\n'
    printf '        </div>\n'
    printf '      </article>\n'
  } >> "$ENTRIES_FILE"
}

prepare_publish_dir() {
  if [ "$INCREMENTAL" != "1" ] && [ -d "$PUBLISH_DIR" ]; then
    log "Cleaning existing published_books directory..."
    rm -rf "$PUBLISH_DIR"
  fi

  mkdir -p "$PUBLISH_DIR" "$ASSETS_DIR" "$HTML_DIR" "$PDF_DIR" "$EPUB_DIR"
}

clear_book_outputs() {
  local book_name="$1"
  rm -rf "$HTML_DIR/$book_name"
  rm -f "$PDF_DIR/$book_name.pdf" "$EPUB_DIR/$book_name.epub" "$ASSETS_DIR/$book_name.svg"
}

process_book() {
  local book_dir="$1"
  local book_name
  local pdf_src
  local epub_src

  book_name="${book_dir%/}"

  log "----------------------------------------"
  log "Found book: $book_name"

  cd "$BOOKS_DIR/$book_name"

  if [ -f "scripts/update-index.sh" ]; then
    log "Running scripts/update-index.sh"
    if ! bash "scripts/update-index.sh"; then
      log "update-index.sh failed for $book_name"
      RENDER_FAIL=$((RENDER_FAIL + 1))
      cd "$BOOKS_DIR"
      return
    fi
  fi

  log "Rendering book with Quarto"
  if ! quarto render; then
    log "Render failed for $book_name"
    RENDER_FAIL=$((RENDER_FAIL + 1))
    cd "$BOOKS_DIR"
    return
  fi

  clear_book_outputs "$book_name"
  generate_book_cover "$book_name"

  mkdir -p "$HTML_DIR/$book_name"
  if [ -d "_book" ]; then
    cp -R "_book"/* "$HTML_DIR/$book_name/"
  else
    log "Missing _book output for $book_name"
    RENDER_FAIL=$((RENDER_FAIL + 1))
    cd "$BOOKS_DIR"
    return
  fi

  pdf_src="$(find "_book" -maxdepth 1 -type f -iname '*.pdf' | head -n 1 || true)"
  epub_src="$(find "_book" -maxdepth 1 -type f -iname '*.epub' | head -n 1 || true)"

  if [ -n "$pdf_src" ] && [ -f "$pdf_src" ]; then
    cp "$pdf_src" "$PDF_DIR/$book_name.pdf"
  fi

  if [ -n "$epub_src" ] && [ -f "$epub_src" ]; then
    cp "$epub_src" "$EPUB_DIR/$book_name.epub"
  fi

  RENDER_OK=$((RENDER_OK + 1))
  cd "$BOOKS_DIR"
}

rebuild_catalog_entries() {
  local names_file
  local book_name
  local html_entry
  local has_html
  local has_pdf
  local has_epub

  names_file="$(mktemp)"

  find "$HTML_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; >> "$names_file" || true
  find "$PDF_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.pdf' -exec basename {} .pdf \; >> "$names_file" || true
  find "$EPUB_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.epub' -exec basename {} .epub \; >> "$names_file" || true

  : > "$ENTRIES_FILE"
  COUNT_OK=0
  COUNT_FAIL=0
  COUNT_HTML=0
  COUNT_PDF=0
  COUNT_EPUB=0

  while IFS= read -r book_name; do
    [ -n "$book_name" ] || continue

    has_html=0
    has_pdf=0
    has_epub=0

    if [ -f "$HTML_DIR/$book_name/index.html" ] || [ -n "$(find "$HTML_DIR/$book_name" -maxdepth 2 -type f -name '*.html' | head -n 1 || true)" ]; then
      has_html=1
      COUNT_HTML=$((COUNT_HTML + 1))
    fi
    if [ -f "$PDF_DIR/$book_name.pdf" ]; then
      has_pdf=1
      COUNT_PDF=$((COUNT_PDF + 1))
    fi
    if [ -f "$EPUB_DIR/$book_name.epub" ]; then
      has_epub=1
      COUNT_EPUB=$((COUNT_EPUB + 1))
    fi

    [ -f "$ASSETS_DIR/$book_name.svg" ] || generate_book_cover "$book_name"
    html_entry="$(find_html_entry "$book_name")"
    append_book_card "$book_name" "$has_html" "$has_pdf" "$has_epub" "$html_entry"
    COUNT_OK=$((COUNT_OK + 1))
  done < <(sort -u "$names_file")

  rm -f "$names_file"
}

main() {
  log "Starting renderpub-indi-codex"
  log "Working directory: $BOOKS_DIR"
  log "INCREMENTAL=$INCREMENTAL"
  log "INDI_BOOKS=${INDI_BOOKS:-<all books>}"

  prepare_publish_dir

  local found_any=0
  local d
  if [ -n "$INDI_BOOKS" ]; then
    for d in ${INDI_BOOKS//,/ }; do
      d="${d%/}"
      if [ -d "$d" ] && [ -f "${d}/_quarto.yml" ]; then
        found_any=1
        process_book "$d/"
      else
        log "Skipping unknown or invalid book directory: $d"
      fi
    done
  else
    for d in */; do
      if [ -d "$d" ] && [ -f "${d}_quarto.yml" ]; then
        found_any=1
        process_book "$d"
      fi
    done
  fi

  rebuild_catalog_entries

  write_index_header
  cat "$ENTRIES_FILE" >> "$PUBLISH_DIR/index.html"
  write_index_footer "$(date '+%Y-%m-%d %H:%M:%S')"

  log "----------------------------------------"
  log "Render summary"
  log "Books rendered in this run: $RENDER_OK"
  log "Render failures in this run: $RENDER_FAIL"
  log "Books in published catalog: $COUNT_OK"
  log "Catalog HTML outputs: $COUNT_HTML"
  log "Catalog PDF outputs: $COUNT_PDF"
  log "Catalog EPUB outputs: $COUNT_EPUB"

  if [ "$found_any" -eq 0 ]; then
    log "No book folders with _quarto.yml were found."
  fi

  log "Published output: $PUBLISH_DIR"
  log "Open: $PUBLISH_DIR/index.html"
}

main

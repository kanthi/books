#!/usr/bin/env bash
# Full library build + monochrome collection portal.
# Backup of previous script: renderpub.sh.backup
# CI currently uses renderpub-codex-v2.sh; this is the interactive/local portal path.
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

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log() { printf '%s\n' "$*"; }

display_name() {
  printf '%s' "$1" | sed 's/[-_]/ /g'
}

# Soft accents (16). Enough unique slots for current + future books.
# Assignment: preferred slot = hash(name) % N; collisions resolved in sorted name
# order by linear probe. Same book keeps the same color unless a new name takes
# its preferred slot in a collision chain (rare with 16 colors / ~10 books).
ACCENT_PALETTE=(
  "#78E2A0"  # blog green
  "#7eb8d4"  # steel blue
  "#c4a882"  # warm sand
  "#9b8ec4"  # muted lavender
  "#e0a87a"  # soft apricot
  "#6ec6b8"  # teal mint
  "#d4a0b8"  # dusty rose
  "#8faf7a"  # sage
  "#7a9fd4"  # cornflower
  "#c9b27a"  # soft gold
  "#a08fd4"  # soft violet
  "#d48f8f"  # muted coral
  "#5fb8a8"  # sea glass
  "#b8a07a"  # khaki
  "#8fc4d4"  # ice blue
  "#c49b78"  # clay
)

# Collect book folder names (dirs with _quarto.yml), sorted A–Z.
list_book_names() {
  local d names=()
  for d in "$BOOKS_DIR"/*/; do
    [ -f "${d}_quarto.yml" ] || continue
    names+=("$(basename "${d%/}")")
  done
  # Also include published html books (portal-only path)
  if [ -d "$HTML_DIR" ]; then
    for d in "$HTML_DIR"/*/; do
      [ -d "$d" ] || continue
      names+=("$(basename "$d")")
    done
  fi
  if [ "${#names[@]}" -eq 0 ]; then
    return 0
  fi
  printf '%s\n' "${names[@]}" | LC_ALL=C sort -u
}

# Stable preferred palette index from book name (same name → same preferred slot).
preferred_accent_index() {
  local name="$1"
  local csum
  csum="$(printf '%s' "$name" | cksum | awk '{print $1}')"
  printf '%d' "$((csum % ${#ACCENT_PALETTE[@]}))"
}

# Unique accent: hash-preferred + collision resolution among current library.
get_book_accent() {
  local book_name="$1"
  local n="${#ACCENT_PALETTE[@]}"
  local -a books=()
  local -a taken=()
  local b pref slot i

  for ((i = 0; i < n; i++)); do
    taken[i]=0
  done

  while IFS= read -r b; do
    [ -n "$b" ] || continue
    books+=("$b")
  done < <(list_book_names)

  # Assign in sorted order so the mapping is deterministic
  local -a assign_names=()
  local -a assign_idx=()
  for b in "${books[@]+"${books[@]}"}"; do
    pref="$(preferred_accent_index "$b")"
    slot=$pref
    # linear probe until free (unique while books <= palette size)
    i=0
    while [ "${taken[slot]}" -eq 1 ] && [ "$i" -lt "$n" ]; do
      slot=$(( (slot + 1) % n ))
      i=$((i + 1))
    done
    taken[slot]=1
    assign_names+=("$b")
    assign_idx+=("$slot")
  done

  for i in "${!assign_names[@]}"; do
    if [ "${assign_names[i]}" = "$book_name" ]; then
      printf '%s\n' "${ACCENT_PALETTE[${assign_idx[i]}]}"
      return 0
    fi
  done

  # Not in library list — pure hash (stable for that name alone)
  pref="$(preferred_accent_index "$book_name")"
  printf '%s\n' "${ACCENT_PALETTE[$pref]}"
}

# ---------------------------------------------------------------------------
# Cover SVG — title band + bookshelf, unique stable accent per book
# ---------------------------------------------------------------------------

generate_book_cover() {
  local book_name="$1"
  local title accent cover title_len fs title_height title_y icon_y line_h

  title="$(display_name "$book_name")"
  cover="$ASSETS_DIR/${book_name}.svg"
  title_len="${#title}"
  accent="$(get_book_accent "$book_name")"

  # Larger, more readable title type
  fs=22
  line_h="1.2"
  title_height=108
  title_y=14
  if [ "$title_len" -gt 40 ]; then
    fs=15
    line_h="1.15"
    title_height=122
    title_y=12
  elif [ "$title_len" -gt 28 ]; then
    fs=17
    line_h="1.18"
    title_height=116
    title_y=13
  elif [ "$title_len" -gt 18 ]; then
    fs=20
    title_height=112
  elif [ "$title_len" -le 10 ]; then
    fs=28
    title_height=100
  fi

  icon_y=$((178 + (title_height - 108) / 2))

  local sid="${book_name//[^a-zA-Z0-9]/_}"

  cat > "$cover" <<SVG
<svg width="240" height="320" viewBox="0 0 240 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="${title} cover">
  <defs>
    <linearGradient id="titleGrad-${sid}" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="${accent}"/>
      <stop offset="100%" stop-color="${accent}" stop-opacity="0.72"/>
    </linearGradient>
    <linearGradient id="book1-${sid}" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#5a5048"/>
      <stop offset="50%" stop-color="#7a6c5d"/>
      <stop offset="100%" stop-color="#4a433c"/>
    </linearGradient>
    <linearGradient id="book2-${sid}" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#3d6b55"/>
      <stop offset="50%" stop-color="#4f8a6c"/>
      <stop offset="100%" stop-color="#2f5544"/>
    </linearGradient>
    <linearGradient id="book3-${sid}" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#3d4f63"/>
      <stop offset="50%" stop-color="#51687f"/>
      <stop offset="100%" stop-color="#2f3d4d"/>
    </linearGradient>
    <linearGradient id="shelf-${sid}" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#6b5f52"/>
      <stop offset="100%" stop-color="#4a4036"/>
    </linearGradient>
    <filter id="shadow-${sid}" x="-15%" y="-10%" width="130%" height="130%">
      <feDropShadow dx="0" dy="4" stdDeviation="5" flood-color="#000000" flood-opacity="0.35"/>
    </filter>
  </defs>

  <!-- Card shell (re-terminal dark) -->
  <rect width="240" height="320" rx="12" ry="12" fill="#1D1E28" filter="url(#shadow-${sid})"/>
  <rect x="10" y="10" width="220" height="300" rx="8" ry="8" fill="#2a2b36"/>

  <!-- Accent title band -->
  <rect x="10" y="${title_y}" width="220" height="${title_height}" rx="8" ry="8" fill="url(#titleGrad-${sid})"/>

  <foreignObject x="16" y="$((title_y + 4))" width="208" height="$((title_height - 8))">
    <div xmlns="http://www.w3.org/1999/xhtml" style="
      font-family: Inter, ui-sans-serif, system-ui, sans-serif;
      font-size: ${fs}px;
      font-weight: 800;
      color: #12131a;
      text-align: center;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      line-height: ${line_h};
      padding: 8px 10px;
      letter-spacing: -0.025em;
      word-break: break-word;
      overflow-wrap: anywhere;
      text-shadow: 0 1px 0 rgba(255,255,255,0.25);
    ">${title}</div>
  </foreignObject>

  <!-- Dividers -->
  <line x1="28" y1="$((title_y + title_height + 12))" x2="212" y2="$((title_y + title_height + 12))"
        stroke="#5a5c6a" stroke-width="2" opacity="0.85"/>
  <line x1="28" y1="$((title_y + title_height + 17))" x2="212" y2="$((title_y + title_height + 17))"
        stroke="${accent}" stroke-width="1.5" opacity="0.65"/>

  <!-- Bookshelf icon -->
  <g transform="translate(120, ${icon_y})">
    <ellipse cx="0" cy="48" rx="46" ry="7" fill="#000" opacity="0.22"/>
    <rect x="-42" y="36" width="84" height="11" rx="2" fill="url(#shelf-${sid})"/>
    <rect x="-42" y="47" width="84" height="3" rx="1" fill="#3d352e"/>
    <line x1="-36" y1="39" x2="36" y2="39" stroke="#3d352e" stroke-width="0.6" opacity="0.55"/>
    <line x1="-36" y1="43" x2="36" y2="43" stroke="#3d352e" stroke-width="0.5" opacity="0.4"/>

    <g transform="translate(-20, 0)">
      <rect x="-1" y="-16" width="13" height="52" rx="1" fill="#000" opacity="0.25"/>
      <rect x="-2" y="-18" width="12" height="54" rx="1" fill="url(#book1-${sid})"/>
      <rect x="-1" y="-13" width="10" height="1" fill="#2a2520" opacity="0.7"/>
      <rect x="-1" y="22" width="10" height="1" fill="#2a2520" opacity="0.7"/>
    </g>
    <g transform="translate(-4, 0)">
      <rect x="-1" y="-14" width="11" height="50" rx="1" fill="#000" opacity="0.25"/>
      <rect x="-2" y="-16" width="10" height="52" rx="1" fill="url(#book2-${sid})"/>
      <rect x="-1" y="-11" width="8" height="1" fill="#1e3329" opacity="0.7"/>
      <rect x="-1" y="22" width="8" height="1" fill="#1e3329" opacity="0.7"/>
    </g>
    <g transform="translate(11, 0)">
      <rect x="-1" y="-12" width="9" height="48" rx="1" fill="#000" opacity="0.25"/>
      <rect x="-2" y="-14" width="8" height="50" rx="1" fill="url(#book3-${sid})"/>
      <rect x="-1" y="-9" width="6" height="1" fill="#1a2430" opacity="0.7"/>
      <rect x="-1" y="22" width="6" height="1" fill="#1a2430" opacity="0.7"/>
    </g>
    <g transform="translate(24, 0)">
      <rect x="-1" y="-10" width="7" height="46" rx="1" fill="#000" opacity="0.25"/>
      <rect x="-2" y="-12" width="6" height="48" rx="1" fill="${accent}" opacity="0.9"/>
      <rect x="-1" y="-7" width="4" height="1" fill="#000" opacity="0.25"/>
      <rect x="-1" y="22" width="4" height="1" fill="#000" opacity="0.25"/>
    </g>

    <rect x="-40" y="-18" width="5" height="54" rx="1" fill="#3a3b48"/>
    <rect x="35" y="-18" width="5" height="54" rx="1" fill="#3a3b48"/>
    <rect x="-42" y="36" width="84" height="1.5" fill="#8a7b6a" opacity="0.45"/>
  </g>

  <!-- Footer accent + dots -->
  <rect x="10" y="304" width="220" height="4" rx="2" fill="${accent}" opacity="0.85"/>
  <circle cx="28" cy="288" r="2.5" fill="${accent}" opacity="0.55"/>
  <circle cx="212" cy="288" r="2.5" fill="${accent}" opacity="0.55"/>

  <text x="120" y="28" text-anchor="middle" fill="#6a6c7a"
        font-family="Inter, ui-sans-serif, system-ui, sans-serif"
        font-size="9" letter-spacing="2.5" font-weight="600">K19G</text>
</svg>
SVG
}

# ---------------------------------------------------------------------------
# Portal HTML — previous Library layout + kanthi.in colors
# ---------------------------------------------------------------------------

write_index_header() {
  cat > "$PUBLISH_DIR/index.html" <<'HTML'
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="color-scheme" content="dark light">
  <title>Library</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* Layout from prior portal; colors from kanthi.in re-terminal green */
    :root {
      --accent: #78E2A0;
      --accent-contrast: #0b0c10;
      --bg: #1D1E28;
      --bg-elevated: color-mix(in srgb, var(--accent) 4%, #23242f 96%);
      --ink: #f5f5f5;
      --muted: color-mix(in srgb, #ffffff 62%, transparent);
      --faint: color-mix(in srgb, #ffffff 38%, transparent);
      --line: rgba(255, 255, 255, 0.1);
      --line-strong: rgba(255, 255, 255, 0.18);
      --hover: color-mix(in srgb, var(--accent) 10%, transparent);
      --focus: var(--accent);
      --radius: 12px;
      --radius-sm: 8px;
      --shadow: 0 1px 2px rgba(0,0,0,.2), 0 8px 24px rgba(0,0,0,.2);
      --font: "Inter", ui-sans-serif, system-ui, -apple-system, "Segoe UI", sans-serif;
      --mono: ui-monospace, "SF Mono", Menlo, Consolas, monospace;
      --max: 1080px;
    }

    html[data-theme="light"] {
      --accent: #1f9d5c;
      --accent-contrast: #ffffff;
      --bg: #f4f6f5;
      --bg-elevated: #ffffff;
      --ink: #1a1b22;
      --muted: #5c6370;
      --faint: #8b919c;
      --line: rgba(29, 30, 40, 0.1);
      --line-strong: rgba(29, 30, 40, 0.18);
      --hover: color-mix(in srgb, var(--accent) 12%, transparent);
      --focus: var(--accent);
      --shadow: 0 1px 2px rgba(0,0,0,.04), 0 4px 16px rgba(0,0,0,.06);
    }

    *, *::before, *::after { box-sizing: border-box; }
    html { -webkit-text-size-adjust: 100%; }
    body {
      margin: 0;
      min-height: 100vh;
      background: var(--bg);
      color: var(--ink);
      font-family: var(--font);
      font-size: 15px;
      line-height: 1.5;
      -webkit-font-smoothing: antialiased;
    }

    a { color: inherit; }

    .page {
      max-width: var(--max);
      margin: 0 auto;
      padding: 2.5rem 1.25rem 4rem;
    }

    .header {
      display: flex;
      flex-direction: column;
      gap: 1.25rem;
      padding-bottom: 1.75rem;
      border-bottom: 1px solid var(--line);
      margin-bottom: 1.75rem;
    }

    .header-top {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .brand {
      display: flex;
      flex-direction: column;
      gap: 0.35rem;
    }

    .brand-kicker {
      font-family: var(--mono);
      font-size: 0.7rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: var(--faint);
    }

    h1 {
      margin: 0;
      font-size: clamp(1.5rem, 3.5vw, 1.85rem);
      font-weight: 650;
      letter-spacing: -0.03em;
      line-height: 1.15;
      color: var(--ink);
    }

    .subtitle {
      margin: 0;
      max-width: 36rem;
      color: var(--muted);
      font-size: 0.95rem;
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .btn {
      appearance: none;
      border: 1px solid var(--line-strong);
      background: var(--bg-elevated);
      color: var(--ink);
      border-radius: 999px;
      padding: 0.45rem 0.9rem;
      font: inherit;
      font-size: 0.8rem;
      font-weight: 550;
      cursor: pointer;
      transition: background .12s ease, border-color .12s ease, color .12s ease;
    }
    .btn:hover {
      border-color: var(--accent);
      color: var(--accent);
      background: var(--hover);
    }
    .btn:focus-visible {
      outline: 2px solid var(--focus);
      outline-offset: 2px;
    }

    .toolbar {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      align-items: center;
    }

    .search-wrap {
      flex: 1 1 240px;
      min-width: 200px;
      position: relative;
    }

    .search {
      width: 100%;
      border: 1px solid var(--line);
      background: var(--bg-elevated);
      color: var(--ink);
      border-radius: var(--radius-sm);
      padding: 0.65rem 0.85rem 0.65rem 2.25rem;
      font: inherit;
      font-size: 0.9rem;
      transition: border-color .12s ease;
    }
    .search::placeholder { color: var(--faint); }
    .search:focus {
      outline: none;
      border-color: var(--accent);
    }

    .search-icon {
      position: absolute;
      left: 0.75rem;
      top: 50%;
      transform: translateY(-50%);
      width: 14px;
      height: 14px;
      opacity: 0.45;
      pointer-events: none;
    }

    .stats {
      display: flex;
      flex-wrap: wrap;
      gap: 0.4rem;
    }

    .stat {
      font-family: var(--mono);
      font-size: 0.7rem;
      letter-spacing: 0.02em;
      color: var(--muted);
      border: 1px solid var(--line);
      border-radius: 999px;
      padding: 0.3rem 0.65rem;
      background: var(--bg-elevated);
    }
    .stat strong {
      color: var(--accent);
      font-weight: 600;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
      gap: 1rem;
    }

    .card {
      display: flex;
      flex-direction: column;
      background: var(--bg-elevated);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: var(--shadow);
      transition: border-color .14s ease, transform .14s ease;
    }
    .card:hover {
      border-color: color-mix(in srgb, var(--accent) 40%, var(--line));
      transform: translateY(-2px);
    }

    .cover-link {
      display: grid;
      place-items: center;
      width: 100%;
      text-decoration: none;
      background:
        linear-gradient(180deg, transparent 0%, transparent 70%, var(--bg-elevated) 100%),
        repeating-linear-gradient(
          -12deg,
          transparent,
          transparent 11px,
          color-mix(in srgb, var(--accent) 5%, transparent) 11px,
          color-mix(in srgb, var(--accent) 5%, transparent) 12px
        );
      border-bottom: 1px solid var(--line);
      padding: 0.7rem 0.7rem 0.55rem;
      aspect-ratio: 5 / 5.4;
    }

    .cover {
      display: block;
      width: auto;
      height: auto;
      max-width: min(92%, 250px);
      max-height: 94%;
      margin: 0 auto;
      object-fit: contain;
      object-position: center;
      border-radius: 4px;
      box-shadow: 0 8px 18px rgba(0, 0, 0, 0.28);
    }

    .body {
      display: flex;
      flex-direction: column;
      gap: 0.65rem;
      padding: 0.95rem 1rem 1.05rem;
      flex: 1;
    }

    .title {
      margin: 0;
      font-size: 1rem;
      font-weight: 600;
      letter-spacing: -0.02em;
      line-height: 1.25;
    }

    .title a {
      text-decoration: none;
      color: var(--ink);
    }
    .title a:hover {
      color: var(--accent);
      text-decoration: underline;
      text-underline-offset: 3px;
    }

    .meta {
      margin: 0;
      font-family: var(--mono);
      font-size: 0.68rem;
      color: var(--faint);
      letter-spacing: 0.02em;
    }

    .formats {
      display: flex;
      flex-wrap: wrap;
      gap: 0.35rem;
      margin-top: auto;
      padding-top: 0.15rem;
    }

    .format {
      text-decoration: none;
      font-family: var(--mono);
      font-size: 0.68rem;
      font-weight: 550;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      border: 1px solid var(--line-strong);
      border-radius: 999px;
      padding: 0.32rem 0.6rem;
      color: var(--muted);
      background: transparent;
      transition: background .12s ease, color .12s ease, border-color .12s ease;
    }
    .format:hover {
      color: var(--accent-contrast);
      border-color: var(--accent);
      background: var(--accent);
    }
    .format:focus-visible {
      outline: 2px solid var(--focus);
      outline-offset: 2px;
    }

    .empty {
      display: none;
      margin-top: 1rem;
      padding: 1.5rem;
      text-align: center;
      color: var(--muted);
      border: 1px dashed var(--line);
      border-radius: var(--radius);
    }

    footer {
      margin-top: 2.5rem;
      padding-top: 1rem;
      border-top: 1px solid var(--line);
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      gap: 0.5rem;
      font-family: var(--mono);
      font-size: 0.7rem;
      color: var(--faint);
    }

    @media (max-width: 560px) {
      .page { padding: 1.5rem 1rem 3rem; }
      .grid { grid-template-columns: 1fr 1fr; gap: 0.75rem; }
      .cover-link { padding: 0.75rem; }
      .body { padding: 0.75rem; }
    }

    @media (max-width: 380px) {
      .grid { grid-template-columns: 1fr; }
    }

    @media (prefers-reduced-motion: reduce) {
      .card, .btn, .format { transition: none; }
      .card:hover { transform: none; }
    }
  </style>
</head>
<body>
  <div class="page">
    <header class="header">
      <div class="header-top">
        <div class="brand">
          <span class="brand-kicker">K19G · Notes</span>
          <h1>Library</h1>
          <p class="subtitle">Technical books rendered from this monorepo. Read online or download PDF / EPUB.</p>
        </div>
        <div class="header-actions">
          <button type="button" class="btn" id="themeToggle" aria-label="Toggle color theme">Theme</button>
        </div>
      </div>
      <div class="toolbar">
        <div class="search-wrap">
          <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
            <circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>
          </svg>
          <input id="bookSearch" class="search" type="search" placeholder="Search books…" autocomplete="off" aria-label="Search books">
        </div>
        <div class="stats" aria-live="polite">
          <span class="stat">Books <strong id="statBooks">0</strong></span>
          <span class="stat">HTML <strong id="statHtml">0</strong></span>
          <span class="stat">PDF <strong id="statPdf">0</strong></span>
          <span class="stat">EPUB <strong id="statEpub">0</strong></span>
        </div>
      </div>
    </header>

    <main id="bookGrid" class="grid">
HTML
}

append_book_card() {
  local book_name="$1"
  local has_html="$2"
  local has_pdf="$3"
  local has_epub="$4"
  local title
  title="$(display_name "$book_name")"
  local ts
  ts="$(date '+%Y-%m-%d')"

  local primary_href="#"
  if [ "$has_html" = "1" ]; then
    primary_href="./html/${book_name}/index.html"
  elif [ "$has_pdf" = "1" ]; then
    primary_href="./pdf/${book_name}.pdf"
  elif [ "$has_epub" = "1" ]; then
    primary_href="./epub/${book_name}.epub"
  fi

  {
    printf '      <article class="card" data-title="%s" data-name="%s">\n' "$title" "$book_name"
    printf '        <a class="cover-link" href="%s" %s>\n' "$primary_href" \
      "$([ "$has_html" = "1" ] && echo 'target="_blank" rel="noopener"' || echo 'target="_blank" rel="noopener"')"
    printf '          <img class="cover" src="./assets/%s.svg" alt="" width="240" height="320" loading="lazy">\n' "$book_name"
    printf '        </a>\n'
    printf '        <div class="body">\n'
    if [ "$has_html" = "1" ]; then
      printf '          <h2 class="title"><a href="./html/%s/index.html" target="_blank" rel="noopener">%s</a></h2>\n' "$book_name" "$title"
    else
      printf '          <h2 class="title">%s</h2>\n' "$title"
    fi
    printf '          <p class="meta">Updated %s</p>\n' "$ts"
    printf '          <div class="formats">\n'
    if [ "$has_html" = "1" ]; then
      printf '            <a class="format" href="./html/%s/index.html" target="_blank" rel="noopener">HTML</a>\n' "$book_name"
    fi
    if [ "$has_pdf" = "1" ]; then
      printf '            <a class="format" href="./pdf/%s.pdf" target="_blank" rel="noopener">PDF</a>\n' "$book_name"
    fi
    if [ "$has_epub" = "1" ]; then
      printf '            <a class="format" href="./epub/%s.epub" target="_blank" rel="noopener">EPUB</a>\n' "$book_name"
    fi
    printf '          </div>\n'
    printf '        </div>\n'
    printf '      </article>\n'
  } >> "$PUBLISH_DIR/index.html"
}

write_index_footer() {
  local end_ts="$1"
  cat >> "$PUBLISH_DIR/index.html" <<HTML
    </main>

    <div id="emptyState" class="empty">No books match your search.</div>

    <footer>
      <span>Generated ${end_ts}</span>
      <span>Monorepo library portal</span>
    </footer>
  </div>

  <script>
    (function () {
      var root = document.documentElement;
      var stored = localStorage.getItem("library-theme");
      // Default dark to match kanthi.in
      var theme = stored || "dark";

      function applyTheme(t) {
        theme = t;
        root.setAttribute("data-theme", t === "dark" ? "dark" : "light");
        localStorage.setItem("library-theme", theme);
        var btn = document.getElementById("themeToggle");
        if (btn) btn.textContent = theme === "dark" ? "Light" : "Dark";
      }
      applyTheme(theme);

      var toggle = document.getElementById("themeToggle");
      if (toggle) {
        toggle.addEventListener("click", function () {
          applyTheme(theme === "dark" ? "light" : "dark");
        });
      }

      var cards = Array.prototype.slice.call(document.querySelectorAll(".card"));
      var empty = document.getElementById("emptyState");
      var search = document.getElementById("bookSearch");

      function setStat(id, n) {
        var el = document.getElementById(id);
        if (el) el.textContent = String(n);
      }

      setStat("statBooks", cards.length);
      setStat("statHtml", document.querySelectorAll(".format[href*='/html/']").length);
      setStat("statPdf", document.querySelectorAll(".format[href\$='.pdf']").length);
      setStat("statEpub", document.querySelectorAll(".format[href\$='.epub']").length);

      function filter() {
        var q = (search && search.value || "").trim().toLowerCase();
        var visible = 0;
        cards.forEach(function (card) {
          var hay = ((card.getAttribute("data-title") || "") + " " + (card.getAttribute("data-name") || "")).toLowerCase();
          var show = !q || hay.indexOf(q) !== -1;
          card.style.display = show ? "" : "none";
          if (show) visible += 1;
        });
        if (empty) empty.style.display = visible === 0 ? "block" : "none";
      }

      if (search) search.addEventListener("input", filter);
    })();
  </script>
</body>
</html>
HTML
}

# ---------------------------------------------------------------------------
# Process one book
# ---------------------------------------------------------------------------

process_book() {
  local book_dir="$1"
  local book_name="${book_dir%/}"
  local has_html=0 has_pdf=0 has_epub=0
  local pdf_src epub_src

  log "----------------------------------------"
  log "Found book: $book_name"

  cd "$BOOKS_DIR/$book_name"

  if [ -f "scripts/update-index.sh" ]; then
    log "Running scripts/update-index.sh"
    if ! bash "scripts/update-index.sh"; then
      log "update-index.sh failed for $book_name"
      COUNT_FAIL=$((COUNT_FAIL + 1))
      cd "$BOOKS_DIR"
      return 0
    fi
  fi

  log "Rendering book with Quarto"
  if ! quarto render; then
    log "Render failed for $book_name"
    COUNT_FAIL=$((COUNT_FAIL + 1))
    cd "$BOOKS_DIR"
    return 0
  fi

  generate_book_cover "$book_name"

  mkdir -p "$HTML_DIR/$book_name"
  if [ -d "_book" ]; then
    cp -R "_book"/. "$HTML_DIR/$book_name/"
  else
    log "Missing _book output for $book_name"
    COUNT_FAIL=$((COUNT_FAIL + 1))
    cd "$BOOKS_DIR"
    return 0
  fi

  pdf_src="$(find "_book" -maxdepth 1 -type f -iname '*.pdf' | head -n 1 || true)"
  epub_src="$(find "_book" -maxdepth 1 -type f -iname '*.epub' | head -n 1 || true)"

  if [ -f "$HTML_DIR/$book_name/index.html" ]; then
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

  append_book_card "$book_name" "$has_html" "$has_pdf" "$has_epub"
  COUNT_OK=$((COUNT_OK + 1))
  log "OK: $book_name"
  cd "$BOOKS_DIR"
}

# Rebuild portal HTML + covers from an existing published_books tree (no quarto).
rebuild_portal_only() {
  log "Rebuilding portal only from existing published_books/"
  mkdir -p "$ASSETS_DIR"

  write_index_header
  COUNT_OK=0
  COUNT_HTML=0
  COUNT_PDF=0
  COUNT_EPUB=0

  local book_name has_html has_pdf has_epub
  if [ -d "$HTML_DIR" ]; then
    for book_path in "$HTML_DIR"/*/; do
      [ -d "$book_path" ] || continue
      book_name="$(basename "$book_path")"
      has_html=0
      has_pdf=0
      has_epub=0
      generate_book_cover "$book_name"
      [ -f "$HTML_DIR/$book_name/index.html" ] && has_html=1 && COUNT_HTML=$((COUNT_HTML + 1))
      [ -f "$PDF_DIR/$book_name.pdf" ] && has_pdf=1 && COUNT_PDF=$((COUNT_PDF + 1))
      [ -f "$EPUB_DIR/$book_name.epub" ] && has_epub=1 && COUNT_EPUB=$((COUNT_EPUB + 1))
      append_book_card "$book_name" "$has_html" "$has_pdf" "$has_epub"
      COUNT_OK=$((COUNT_OK + 1))
      log "Portal card: $book_name"
    done
  fi

  write_index_footer "$(date '+%Y-%m-%d %H:%M:%S')"
  log "Portal books: $COUNT_OK  HTML: $COUNT_HTML  PDF: $COUNT_PDF  EPUB: $COUNT_EPUB"
  log "Open: $PUBLISH_DIR/index.html"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  log "Starting renderpub (mono portal)"
  log "Working directory: $BOOKS_DIR"

  if [ "${1:-}" = "--portal-only" ]; then
    rebuild_portal_only
    return 0
  fi

  if [ -d "$PUBLISH_DIR" ]; then
    log "Cleaning existing published_books directory..."
    rm -rf "$PUBLISH_DIR"
  fi
  mkdir -p "$PUBLISH_DIR" "$ASSETS_DIR" "$HTML_DIR" "$PDF_DIR" "$EPUB_DIR"

  write_index_header

  local found_any=0 d
  for d in */; do
    if [ -d "$d" ] && [ -f "${d}_quarto.yml" ]; then
      found_any=1
      process_book "$d"
    fi
  done

  write_index_footer "$(date '+%Y-%m-%d %H:%M:%S')"

  log "----------------------------------------"
  log "Render summary"
  log "Rendered successfully: $COUNT_OK"
  log "Failed: $COUNT_FAIL"
  log "HTML: $COUNT_HTML  PDF: $COUNT_PDF  EPUB: $COUNT_EPUB"
  if [ "$found_any" -eq 0 ]; then
    log "No book folders with _quarto.yml were found."
  fi
  log "Published output: $PUBLISH_DIR"
  log "Open: $PUBLISH_DIR/index.html"
}

main "$@"

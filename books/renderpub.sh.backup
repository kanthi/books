#!/bin/bash

# Use current directory
BOOKS_DIR="$(pwd)"
PUBLISH_DIR="$BOOKS_DIR/published_books"

# Print start message
echo "Starting to render all books in current directory..."
echo "Current directory: $BOOKS_DIR"

# Clean up existing published_books directory
if [ -d "$PUBLISH_DIR" ]; then
    echo "🧹 Cleaning up existing published books..."
    rm -rf "$PUBLISH_DIR"
fi

# Create published_books directory structure
echo "📁 Creating directory structure..."
mkdir -p "$PUBLISH_DIR"
mkdir -p "$PUBLISH_DIR/html"
mkdir -p "$PUBLISH_DIR/pdf"
mkdir -p "$PUBLISH_DIR/epub"
mkdir -p "$PUBLISH_DIR/assets"

# Enhanced book cover generator function with smart text handling
generate_book_cover() {
    local book_name="$1"
    local cover_file="$PUBLISH_DIR/assets/${book_name}.svg"

    # Generate a random color from a terminal-like palette
    local colors=("#50fa7b" "#ff79c6" "#bd93f9" "#ffb86c" "#8be9fd" "#f1fa8c")
    local random_color=${colors[$((RANDOM % ${#colors[@]}))]}

    # Clean and format book name for better display
    local display_name=$(echo "$book_name" | sed 's/-/ /g' | sed 's/_/ /g')

    # Smart font sizing based on title length
    local title_length=${#display_name}
    local font_size=20
    local line_height=1.2
    local title_height=100
    local title_y=10

    # Adjust font size and layout based on title length
    if [ $title_length -gt 50 ]; then
        # Very long titles
        font_size=14
        line_height=1.1
        title_height=120
        title_y=5
    elif [ $title_length -gt 35 ]; then
        # Long titles
        font_size=16
        line_height=1.15
        title_height=110
        title_y=7
    elif [ $title_length -gt 25 ]; then
        # Medium titles
        font_size=18
        line_height=1.2
        title_height=105
        title_y=8
    elif [ $title_length -gt 15 ]; then
        # Normal titles
        font_size=20
        line_height=1.2
        title_height=100
        title_y=10
    else
        # Short titles - can use larger font
        font_size=22
        line_height=1.3
        title_height=100
        title_y=10
    fi

    # Adjust book icon position based on title area height
    local icon_y=$((180 + (title_height - 100) / 2))

    # Create an enhanced SVG book cover with smart text handling
    cat > "$cover_file" << EOF
<svg width="240" height="320" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- Title gradient -->
    <linearGradient id="titleGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:${random_color};stop-opacity:1" />
      <stop offset="100%" style="stop-color:${random_color};stop-opacity:0.7" />
    </linearGradient>

    <!-- Shadow filter -->
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="2" dy="4" stdDeviation="3" flood-color="#000000" flood-opacity="0.3"/>
    </filter>

    <!-- Text shadow filter -->
    <filter id="textShadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="1" dy="2" stdDeviation="1" flood-color="#000000" flood-opacity="0.5"/>
    </filter>
  </defs>

  <!-- Main background with shadow -->
  <rect width="240" height="320" fill="#282a36" rx="12" ry="12" filter="url(#shadow)"/>

  <!-- Inner background -->
  <rect width="220" height="300" x="10" y="10" fill="#44475a" rx="8" ry="8"/>

  <!-- Title area with gradient (dynamic height) -->
  <rect width="220" height="${title_height}" x="10" y="${title_y}" fill="url(#titleGrad)" rx="8" ry="8"/>

  <!-- Title text with smart sizing -->
  <foreignObject x="15" y="$((title_y + 5))" width="210" height="$((title_height - 10))">
    <div xmlns="http://www.w3.org/1999/xhtml" style="
      font-family: 'Fira Code', 'Monaco', 'Consolas', monospace;
      font-size: ${font_size}px;
      color: #282a36;
      text-align: center;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      word-wrap: break-word;
      line-height: ${line_height};
      padding: 8px;
      text-shadow: 0 1px 3px rgba(0,0,0,0.4);
      hyphens: auto;
      overflow-wrap: break-word;
      word-break: break-word;
    ">
      ${display_name}
    </div>
  </foreignObject>

  <!-- Decorative elements (positioned after title area) -->
  <line x1="25" y1="$((title_y + title_height + 10))" x2="215" y2="$((title_y + title_height + 10))" stroke="#6272a4" stroke-width="2" opacity="0.8"/>
  <line x1="25" y1="$((title_y + title_height + 15))" x2="215" y2="$((title_y + title_height + 15))" stroke="${random_color}" stroke-width="1" opacity="0.6"/>

  <!-- Skeuomorphic bookshelf icon (positioned dynamically) -->
  <g transform="translate(120, ${icon_y})">
    <defs>
      <!-- Book gradients for 3D effect -->
      <linearGradient id="book1Grad" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" style="stop-color:#8b4513;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#a0522d;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#654321;stop-opacity:1" />
      </linearGradient>

      <linearGradient id="book2Grad" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" style="stop-color:#2e8b57;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#3cb371;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#228b22;stop-opacity:1" />
      </linearGradient>

      <linearGradient id="book3Grad" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" style="stop-color:#4682b4;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#5f9ea0;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#2f4f4f;stop-opacity:1" />
      </linearGradient>

      <linearGradient id="shelfGrad" x1="0%" y1="0%" x2="0%" y2="100%">
        <stop offset="0%" style="stop-color:#8b7355;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#a0522d;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#654321;stop-opacity:1" />
      </linearGradient>
    </defs>

    <!-- Bookshelf shadow -->
    <ellipse cx="0" cy="45" rx="45" ry="8" fill="#000000" opacity="0.2"/>

    <!-- Wooden bookshelf base -->
    <rect x="-40" y="35" width="80" height="12" fill="url(#shelfGrad)" rx="2" ry="2"/>
    <rect x="-40" y="47" width="80" height="3" fill="#654321" rx="1" ry="1"/>

    <!-- Wood grain texture lines -->
    <line x1="-35" y1="38" x2="35" y2="38" stroke="#654321" stroke-width="0.5" opacity="0.6"/>
    <line x1="-35" y1="42" x2="35" y2="42" stroke="#654321" stroke-width="0.5" opacity="0.4"/>
    <line x1="-35" y1="45" x2="35" y2="45" stroke="#654321" stroke-width="0.5" opacity="0.6"/>

    <!-- Book 1 (leftmost) - thick technical book -->
    <g transform="translate(-22, 0)">
      <!-- Book shadow -->
      <rect x="-1" y="-18" width="14" height="53" fill="#000000" rx="1" ry="1" opacity="0.3"/>
      <!-- Book spine -->
      <rect x="-2" y="-20" width="12" height="55" fill="url(#book1Grad)" rx="1" ry="1"/>
      <!-- Book top edge -->
      <rect x="-2" y="-20" width="12" height="2" fill="#a0522d" rx="1" ry="1"/>
      <!-- Spine details -->
      <rect x="-1" y="-15" width="10" height="1" fill="#654321" opacity="0.8"/>
      <rect x="-1" y="-10" width="10" height="1" fill="#654321" opacity="0.8"/>
      <rect x="-1" y="25" width="10" height="1" fill="#654321" opacity="0.8"/>
      <!-- Book title area -->
      <rect x="0" y="-5" width="8" height="15" fill="#8b4513" opacity="0.7" rx="0.5" ry="0.5"/>
    </g>

    <!-- Book 2 (center) - medium book -->
    <g transform="translate(-5, 0)">
      <!-- Book shadow -->
      <rect x="-1" y="-15" width="12" height="50" fill="#000000" rx="1" ry="1" opacity="0.3"/>
      <!-- Book spine -->
      <rect x="-2" y="-17" width="10" height="52" fill="url(#book2Grad)" rx="1" ry="1"/>
      <!-- Book top edge -->
      <rect x="-2" y="-17" width="10" height="2" fill="#3cb371" rx="1" ry="1"/>
      <!-- Spine details -->
      <rect x="-1" y="-12" width="8" height="1" fill="#228b22" opacity="0.8"/>
      <rect x="-1" y="-7" width="8" height="1" fill="#228b22" opacity="0.8"/>
      <rect x="-1" y="25" width="8" height="1" fill="#228b22" opacity="0.8"/>
      <!-- Book title area -->
      <rect x="0" y="-2" width="6" height="12" fill="#2e8b57" opacity="0.7" rx="0.5" ry="0.5"/>
    </g>

    <!-- Book 3 (right) - thin book -->
    <g transform="translate(12, 0)">
      <!-- Book shadow -->
      <rect x="-1" y="-12" width="10" height="47" fill="#000000" rx="1" ry="1" opacity="0.3"/>
      <!-- Book spine -->
      <rect x="-2" y="-14" width="8" height="49" fill="url(#book3Grad)" rx="1" ry="1"/>
      <!-- Book top edge -->
      <rect x="-2" y="-14" width="8" height="2" fill="#5f9ea0" rx="1" ry="1"/>
      <!-- Spine details -->
      <rect x="-1" y="-9" width="6" height="1" fill="#2f4f4f" opacity="0.8"/>
      <rect x="-1" y="-4" width="6" height="1" fill="#2f4f4f" opacity="0.8"/>
      <rect x="-1" y="25" width="6" height="1" fill="#2f4f4f" opacity="0.8"/>
      <!-- Book title area -->
      <rect x="0" y="0" width="4" height="10" fill="#4682b4" opacity="0.7" rx="0.5" ry="0.5"/>
    </g>

    <!-- Book 4 (far right) - very thin book -->
    <g transform="translate(25, 0)">
      <!-- Book shadow -->
      <rect x="-1" y="-10" width="8" height="45" fill="#000000" rx="1" ry="1" opacity="0.3"/>
      <!-- Book spine -->
      <rect x="-2" y="-12" width="6" height="47" fill="${random_color}" rx="1" ry="1"/>
      <!-- Book top edge -->
      <rect x="-2" y="-12" width="6" height="2" fill="${random_color}" rx="1" ry="1" opacity="0.8"/>
      <!-- Spine details -->
      <rect x="-1" y="-7" width="4" height="1" fill="#000000" opacity="0.3"/>
      <rect x="-1" y="25" width="4" height="1" fill="#000000" opacity="0.3"/>
      <!-- Book title area -->
      <rect x="0" y="2" width="2" height="8" fill="${random_color}" opacity="0.5" rx="0.5" ry="0.5"/>
    </g>

    <!-- Bookend (left) -->
    <g transform="translate(-35, 0)">
      <rect x="-3" y="-20" width="6" height="55" fill="#2f2f2f" rx="1" ry="1"/>
      <rect x="-2" y="-19" width="4" height="53" fill="#404040" rx="0.5" ry="0.5"/>
      <circle cx="0" cy="10" r="2" fill="#606060"/>
    </g>

    <!-- Bookend (right) -->
    <g transform="translate(35, 0)">
      <rect x="-3" y="-20" width="6" height="55" fill="#2f2f2f" rx="1" ry="1"/>
      <rect x="-2" y="-19" width="4" height="53" fill="#404040" rx="0.5" ry="0.5"/>
      <circle cx="0" cy="10" r="2" fill="#606060"/>
    </g>

    <!-- Shelf front edge highlight -->
    <rect x="-40" y="35" width="80" height="1" fill="#d2b48c" opacity="0.6" rx="1" ry="1"/>
  </g>

  <!-- Bottom decorative elements -->
  <rect width="220" height="4" x="10" y="306" fill="${random_color}" rx="2" ry="2" opacity="0.8"/>

  <!-- Corner decorations -->
  <circle cx="25" cy="285" r="3" fill="${random_color}" opacity="0.6"/>
  <circle cx="215" cy="285" r="3" fill="${random_color}" opacity="0.6"/>
</svg>
EOF

    echo "$cover_file"
}

# Initialize the index.html with a dark terminal-like theme
cat > "$PUBLISH_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books Collection</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --background: #282a36;
            --foreground: #f8f8f2;
            --black: #21222c;
            --blue: #bd93f9;
            --cyan: #8be9fd;
            --green: #50fa7b;
            --purple: #ff79c6;
            --red: #ff5555;
            --white: #f8f8f2;
            --yellow: #f1fa8c;
            --comment: #6272a4;
            --selection: #44475a;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Fira Code', monospace;
            background-color: var(--background);
            color: var(--foreground);
            line-height: 1.6;
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2rem 0;
            border-bottom: 2px solid var(--selection);
        }

        .header h1 {
            color: var(--cyan);
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .header p {
            color: var(--comment);
            font-size: 1.1rem;
        }

        .books-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2.5rem;
            padding: 2rem 0;
        }

        .book-card {
            background-color: var(--selection);
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3), 0 1px 3px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(98, 114, 164, 0.3);
        }

        .book-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 25px rgba(0, 0, 0, 0.4), 0 10px 10px rgba(0, 0, 0, 0.2);
            border-color: rgba(98, 114, 164, 0.6);
        }

        .book-cover-container {
            position: relative;
            width: 100%;
            height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #44475a 0%, #282a36 100%);
            padding: 20px;
        }

        .book-cover {
            max-width: 240px;
            max-height: 320px;
            width: auto;
            height: auto;
            object-fit: contain;
            display: block;
            filter: drop-shadow(0 8px 16px rgba(0, 0, 0, 0.3));
        }

        .book-info {
            padding: 1.5rem;
        }



        .book-formats {
            display: flex;
            gap: 0.8rem;
            margin-bottom: 1rem;
        }

        .format-link {
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: var(--black);
            color: var(--foreground);
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9rem;
            border: 1px solid var(--comment);
            transition: all 0.2s ease;
        }

        .format-link:hover {
            background-color: var(--comment);
            color: var(--background);
        }

        .format-link.html {
            border-color: var(--blue);
            color: var(--blue);
        }

        .format-link.html:hover {
            background-color: var(--blue);
            color: var(--black);
        }

        .format-link.pdf {
            border-color: var(--red);
            color: var(--red);
        }

        .format-link.pdf:hover {
            background-color: var(--red);
            color: var(--black);
        }

        .format-link.epub {
            border-color: var(--green);
            color: var(--green);
        }

        .format-link.epub:hover {
            background-color: var(--green);
            color: var(--black);
        }

        .book-timestamp {
            color: var(--comment);
            font-size: 0.8rem;
        }

        .terminal-footer {
            margin-top: 3rem;
            padding-top: 1rem;
            border-top: 1px solid var(--selection);
            color: var(--comment);
            font-size: 0.9rem;
            display: flex;
            justify-content: space-between;
        }

        /* Stats styles removed */

        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .books-container {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 1.5rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .book-cover-container {
                height: 280px;
                padding: 15px;
            }

            .book-cover {
                max-width: 200px;
                max-height: 280px;
            }
        }

        @media (max-width: 480px) {
            .books-container {
                grid-template-columns: 1fr;
            }

            .book-formats {
                flex-direction: column;
                gap: 0.5rem;
            }

            .format-link {
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1 style="display: flex; align-items: center; justify-content: center; gap: 24px; line-height: 1;">
            <svg width="240" height="160" viewBox="0 0 60 48" style="flex-shrink: 0; display: block;">
                <defs>
                    <!-- Book gradients for 3D effect -->
                    <linearGradient id="headerBook1" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#8b4513;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#a0522d;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#654321;stop-opacity:1" />
                    </linearGradient>

                    <linearGradient id="headerBook2" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#2e8b57;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#3cb371;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#228b22;stop-opacity:1" />
                    </linearGradient>

                    <linearGradient id="headerBook3" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#4682b4;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#5f9ea0;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#2f4f4f;stop-opacity:1" />
                    </linearGradient>

                    <linearGradient id="headerBook4" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:#8be9fd;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#50fa7b;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#bd93f9;stop-opacity:1" />
                    </linearGradient>

                    <linearGradient id="headerShelf" x1="0%" y1="0%" x2="0%" y2="100%">
                        <stop offset="0%" style="stop-color:#8b7355;stop-opacity:1" />
                        <stop offset="50%" style="stop-color:#a0522d;stop-opacity:1" />
                        <stop offset="100%" style="stop-color:#654321;stop-opacity:1" />
                    </linearGradient>
                </defs>

                <!-- Bookshelf shadow -->
                <ellipse cx="30" cy="44" rx="26" ry="3" fill="#000000" opacity="0.2"/>

                <!-- Wooden bookshelf base -->
                <rect x="4" y="38" width="52" height="6" fill="url(#headerShelf)" rx="1.5" ry="1.5"/>
                <rect x="4" y="44" width="52" height="1.5" fill="#654321" rx="0.75" ry="0.75"/>

                <!-- Wood grain texture -->
                <line x1="6" y1="40" x2="54" y2="40" stroke="#654321" stroke-width="0.4" opacity="0.6"/>
                <line x1="6" y1="42" x2="54" y2="42" stroke="#654321" stroke-width="0.4" opacity="0.4"/>

                <!-- Book 1 (leftmost) - "Linux" -->
                <g transform="translate(8, 22)">
                    <rect x="0" y="0" width="6" height="16" fill="url(#headerBook1)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#a0522d"/>
                    <rect x="0.75" y="3" width="4.5" height="0.4" fill="#654321" opacity="0.8"/>
                    <rect x="0.75" y="13" width="4.5" height="0.4" fill="#654321" opacity="0.8"/>
                    <!-- Book title "Linux" -->
                    <text x="3" y="8.5" text-anchor="middle" fill="#f8f8f2" font-family="Fira Code, monospace" font-size="3" font-weight="bold" transform="rotate(-90, 3, 8.5)">Linux</text>
                </g>

                <!-- Book 2 - "Git" -->
                <g transform="translate(15, 20)">
                    <rect x="0" y="0" width="6" height="18" fill="url(#headerBook2)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#3cb371"/>
                    <rect x="0.75" y="3" width="4.5" height="0.4" fill="#228b22" opacity="0.8"/>
                    <rect x="0.75" y="14" width="4.5" height="0.4" fill="#228b22" opacity="0.8"/>
                    <!-- Book title "Git" -->
                    <text x="3" y="9.5" text-anchor="middle" fill="#f8f8f2" font-family="Fira Code, monospace" font-size="3.5" font-weight="bold" transform="rotate(-90, 3, 9.5)">Git</text>
                </g>

                <!-- Book 3 - "Bash" -->
                <g transform="translate(22, 21)">
                    <rect x="0" y="0" width="6" height="17" fill="url(#headerBook3)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#5f9ea0"/>
                    <rect x="0.75" y="3" width="4.5" height="0.4" fill="#2f4f4f" opacity="0.8"/>
                    <rect x="0.75" y="13" width="4.5" height="0.4" fill="#2f4f4f" opacity="0.8"/>
                    <!-- Book title "Bash" -->
                    <text x="3" y="9" text-anchor="middle" fill="#f8f8f2" font-family="Fira Code, monospace" font-size="3" font-weight="bold" transform="rotate(-90, 3, 9)">Bash</text>
                </g>

                <!-- Book 4 - "Docker" -->
                <g transform="translate(29, 18)">
                    <rect x="0" y="0" width="6" height="20" fill="url(#headerBook4)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#8be9fd"/>
                    <rect x="0.75" y="3" width="4.5" height="0.4" fill="#bd93f9" opacity="0.8"/>
                    <rect x="0.75" y="16" width="4.5" height="0.4" fill="#bd93f9" opacity="0.8"/>
                    <!-- Book title "Docker" -->
                    <text x="3" y="10.5" text-anchor="middle" fill="#282a36" font-family="Fira Code, monospace" font-size="2.8" font-weight="bold" transform="rotate(-90, 3, 10.5)">Docker</text>
                </g>

                <!-- Book 5 - "Python" -->
                <g transform="translate(36, 24)">
                    <rect x="0" y="0" width="6" height="14" fill="url(#headerBook1)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#a0522d"/>
                    <rect x="0.75" y="2.5" width="4.5" height="0.4" fill="#654321" opacity="0.8"/>
                    <rect x="0.75" y="10" width="4.5" height="0.4" fill="#654321" opacity="0.8"/>
                    <!-- Book title "Python" -->
                    <text x="3" y="7.5" text-anchor="middle" fill="#f8f8f2" font-family="Fira Code, monospace" font-size="2.5" font-weight="bold" transform="rotate(-90, 3, 7.5)">Python</text>
                </g>

                <!-- Book 6 (rightmost) - "DevOps" -->
                <g transform="translate(43, 23)">
                    <rect x="0" y="0" width="6" height="15" fill="url(#headerBook2)" rx="0.75" ry="0.75"/>
                    <rect x="0" y="0" width="6" height="0.75" fill="#3cb371"/>
                    <rect x="0.75" y="2.5" width="4.5" height="0.4" fill="#228b22" opacity="0.8"/>
                    <rect x="0.75" y="11" width="4.5" height="0.4" fill="#228b22" opacity="0.8"/>
                    <!-- Book title "DevOps" -->
                    <text x="3" y="8" text-anchor="middle" fill="#f8f8f2" font-family="Fira Code, monospace" font-size="2.3" font-weight="bold" transform="rotate(-90, 3, 8)">DevOps</text>
                </g>

                <!-- Bookends -->
                <rect x="4" y="18" width="3" height="20" fill="#2f2f2f" rx="0.75" ry="0.75"/>
                <rect x="4.3" y="18.75" width="2.4" height="18.5" fill="#404040" rx="0.5" ry="0.5"/>

                <rect x="53" y="18" width="3" height="20" fill="#2f2f2f" rx="0.75" ry="0.75"/>
                <rect x="53.3" y="18.75" width="2.4" height="18.5" fill="#404040" rx="0.5" ry="0.5"/>

                <!-- Shelf highlight -->
                <rect x="4" y="38" width="52" height="0.75" fill="#d2b48c" opacity="0.6" rx="0.75" ry="0.75"/>
            </svg>
            <span style="flex-shrink: 0;">Books Collection</span>
        </h1>
        <p>Comprehensive technical documentation and guides</p>
    </div>

    <div class="books-container">
EOF

# Count for rendered books
count=0
failed=0

# Find all directories that contain _quarto.yml
for book_dir in */; do
    if [ -f "${book_dir}_quarto.yml" ]; then
        echo "----------------------------------------"
        echo "📚 Found book: ${book_dir%/}"

        # Change to the book directory
        cd "$book_dir" || continue

        # Run update-index.sh if it exists
        if [ -f "scripts/update-index.sh" ]; then
            echo "🔄 Running update-index.sh..."
            if ! bash scripts/update-index.sh; then
                echo "❌ Failed to run update-index.sh for ${book_dir%/}"
                cd "$BOOKS_DIR" || exit 1
                continue
            fi
        else
            echo "⚠️  Warning: scripts/update-index.sh not found in ${book_dir%/}"
        fi

        # Run quarto render
        echo "🔄 Rendering book..."
        if quarto render; then
            echo "✅ Successfully rendered ${book_dir%/}"

            # Copy rendered files to published_books directory
            book_name="${book_dir%/}"

            # Create book-specific HTML directory
            mkdir -p "$PUBLISH_DIR/html/$book_name"

            # Generate a book cover
            cover_file=$(generate_book_cover "$book_name")

            # Copy HTML version (entire directory)
            if [ -d "_book" ]; then
                echo "📋 Copying HTML version..."
                cp -r "_book"/* "$PUBLISH_DIR/html/$book_name/"

                # Find and copy PDF file (using find to handle case sensitivity)
                pdf_file=$(find _book -maxdepth 1 -type f -iname "*.pdf")
                if [ ! -z "$pdf_file" ]; then
                    echo "📄 Copying PDF version..."
                    cp "$pdf_file" "$PUBLISH_DIR/pdf/$book_name.pdf"
                else
                    echo "⚠️  No PDF version found for $book_name"
                fi

                # Find and copy EPUB file (using find to handle case sensitivity)
                epub_file=$(find _book -maxdepth 1 -type f -iname "*.epub")
                if [ ! -z "$epub_file" ]; then
                    echo "📱 Copying EPUB version..."
                    cp "$epub_file" "$PUBLISH_DIR/epub/$book_name.epub"
                else
                    echo "⚠️  No EPUB version found for $book_name"
                fi
            else
                echo "❌ No _book directory found for ${book_dir%/}"
                cd "$BOOKS_DIR" || exit 1
                continue
            fi

            # Add entry to index.html
            cat >> "$PUBLISH_DIR/index.html" << EOF
        <div class="book-card">
            <div class="book-cover-container">
                <img src="./assets/${book_name}.svg" alt="${book_name} cover" class="book-cover">
            </div>
            <div class="book-info">
                <div class="book-formats">
EOF

            # Add format links based on what was generated
            if [ -f "$PUBLISH_DIR/html/$book_name/index.html" ]; then
                echo "                    <a href=\"./html/${book_name}/index.html\" class=\"format-link html\" target=\"_blank\">HTML</a>" >> "$PUBLISH_DIR/index.html"
            fi

            if [ -f "$PUBLISH_DIR/pdf/$book_name.pdf" ]; then
                echo "                    <a href=\"./pdf/${book_name}.pdf\" class=\"format-link pdf\" target=\"_blank\">PDF</a>" >> "$PUBLISH_DIR/index.html"
            fi

            if [ -f "$PUBLISH_DIR/epub/$book_name.epub" ]; then
                echo "                    <a href=\"./epub/${book_name}.epub\" class=\"format-link epub\" target=\"_blank\">EPUB</a>" >> "$PUBLISH_DIR/index.html"
            fi

            # Close the book entry
            cat >> "$PUBLISH_DIR/index.html" << EOF
                </div>
                <div class="book-timestamp">Last updated: $(date "+%Y-%m-%d %H:%M")</div>
            </div>
        </div>
EOF

            ((count++))
        else
            echo "❌ Failed to render ${book_dir%/}"
            ((failed++))
        fi

        # Return to books directory
        cd "$BOOKS_DIR" || exit 1
    fi
done

# Close the HTML
cat >> "$PUBLISH_DIR/index.html" << EOF
    </div>

    <div class="terminal-footer">
        <div>Generated on $(date "+%Y-%m-%d %H:%M:%S")</div>
    </div>
</body>
</html>
EOF

echo "----------------------------------------"
echo "📊 Rendering Summary:"
echo "✅ Successfully rendered: $count books"
if [ $failed -gt 0 ]; then
    echo "❌ Failed to render: $failed books"
fi
echo "Total books processed: $((count + failed))"
echo ""
echo "📚 All books have been published to: $PUBLISH_DIR"
echo "🌐 You can browse all books by opening: $PUBLISH_DIR/index.html"
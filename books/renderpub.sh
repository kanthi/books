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

# Create a simple book cover generator function
generate_book_cover() {
    local book_name="$1"
    local cover_file="$PUBLISH_DIR/assets/${book_name}.svg"

    # Generate a random color from a terminal-like palette
    local colors=("#50fa7b" "#ff79c6" "#bd93f9" "#ffb86c" "#8be9fd" "#f1fa8c")
    local random_color=${colors[$((RANDOM % ${#colors[@]}))]}

    # Split the book name into words for better wrapping
    local words=($book_name)
    local line1=""
    local line2=""
    local line3=""

    # Simple text wrapping logic
    if [ ${#words[@]} -eq 1 ]; then
        # Single word - check if it's too long
        if [ ${#book_name} -gt 12 ]; then
            line1="${book_name:0:12}"
            line2="${book_name:12}"
        else
            line1="$book_name"
        fi
    elif [ ${#words[@]} -eq 2 ]; then
        # Two words - put each on separate line if combined length > 15
        if [ $((${#words[0]} + ${#words[1]})) -gt 15 ]; then
            line1="${words[0]}"
            line2="${words[1]}"
        else
            line1="$book_name"
        fi
    else
        # Multiple words - distribute across lines
        line1="${words[0]}"
        if [ ${#words[@]} -gt 1 ]; then
            line2="${words[1]}"
        fi
        if [ ${#words[@]} -gt 2 ]; then
            line3="${words[2]}"
        fi
    fi

    # Create an SVG book cover with better design and text positioning
    cat > "$cover_file" << EOF
<svg width="200" height="280" xmlns="http://www.w3.org/2000/svg">
  <!-- Main background -->
  <rect width="200" height="280" fill="#282a36" rx="8" ry="8"/>

  <!-- Inner background -->
  <rect width="190" height="270" x="5" y="5" fill="#44475a" rx="5" ry="5"/>

  <!-- Title area with gradient effect -->
  <defs>
    <linearGradient id="titleGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:${random_color};stop-opacity:1" />
      <stop offset="100%" style="stop-color:${random_color};stop-opacity:0.8" />
    </linearGradient>
  </defs>

  <!-- Large colored title area -->
  <rect width="190" height="80" x="5" y="5" fill="url(#titleGrad)" rx="5" ry="5"/>

  <!-- Title text with better positioning -->
  <foreignObject x="10" y="10" width="180" height="70">
    <div xmlns="http://www.w3.org/1999/xhtml" style="
      font-family: 'Fira Code', monospace;
      font-size: 18px;
      color: #282a36;
      text-align: center;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      word-wrap: break-word;
      line-height: 1.3;
      padding: 8px;
      text-shadow: 0 1px 2px rgba(0,0,0,0.3);
    ">
      ${book_name}
    </div>
  </foreignObject>

  <!-- Decorative line -->
  <line x1="15" y1="95" x2="185" y2="95" stroke="#6272a4" stroke-width="2" opacity="0.6"/>

  <!-- Modern book icon -->
  <g transform="translate(100, 140)">
    <!-- Book spine -->
    <rect x="-25" y="-20" width="50" height="60" fill="#6272a4" rx="3" ry="3"/>
    <!-- Book pages -->
    <rect x="-22" y="-17" width="44" height="54" fill="#f8f8f2" rx="2" ry="2"/>
    <!-- Page lines -->
    <line x1="-15" y1="-5" x2="15" y2="-5" stroke="#6272a4" stroke-width="1.5" opacity="0.7"/>
    <line x1="-15" y1="5" x2="15" y2="5" stroke="#6272a4" stroke-width="1.5" opacity="0.7"/>
    <line x1="-15" y1="15" x2="10" y2="15" stroke="#6272a4" stroke-width="1.5" opacity="0.7"/>
    <line x1="-15" y1="25" x2="15" y2="25" stroke="#6272a4" stroke-width="1.5" opacity="0.7"/>
  </g>

  <!-- Bottom accent -->
  <rect width="190" height="3" x="5" y="272" fill="${random_color}" rx="1" ry="1" opacity="0.8"/>
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

        /* Header styles removed */

        .books-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .book-card {
            background-color: var(--selection);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);
        }

        .book-cover {
            width: 100%;
            height: 280px;
            object-fit: cover;
            display: block;
        }

        .book-info {
            padding: 1.5rem;
        }

        .book-title {
            color: var(--cyan);
            font-size: 1.2rem;
            margin-bottom: 1rem;
            font-weight: bold;
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
            .books-container {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
        }
    </style>
</head>
<body>
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
            <img src="./assets/${book_name}.svg" alt="${book_name} cover" class="book-cover">
            <div class="book-info">
                <h2 class="book-title">${book_name}</h2>
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
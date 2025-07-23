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

# Initialize the index.html
cat > "$PUBLISH_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Published Books Collection</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .book {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        h2 {
            color: #34495e;
            margin-bottom: 15px;
        }
        .formats {
            display: flex;
            gap: 10px;
        }
        .format-link {
            display: inline-block;
            padding: 8px 15px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .format-link:hover {
            background-color: #2980b9;
        }
        .timestamp {
            color: #7f8c8d;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <h1>Published Books Collection</h1>
    <div id="books">
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
    <div class="book">
        <h2>${book_name}</h2>
        <div class="formats">
EOF

            # Add format links based on what was generated
            if [ -f "$PUBLISH_DIR/html/$book_name/index.html" ]; then
                echo "            <a href=\"./html/${book_name}/index.html\" class=\"format-link\" target=\"_blank\">HTML</a>" >> "$PUBLISH_DIR/index.html"
            fi

            if [ -f "$PUBLISH_DIR/pdf/$book_name.pdf" ]; then
                echo "            <a href=\"./pdf/${book_name}.pdf\" class=\"format-link\" target=\"_blank\">PDF</a>" >> "$PUBLISH_DIR/index.html"
            fi

            if [ -f "$PUBLISH_DIR/epub/$book_name.epub" ]; then
                echo "            <a href=\"./epub/${book_name}.epub\" class=\"format-link\" target=\"_blank\">EPUB</a>" >> "$PUBLISH_DIR/index.html"
            fi

            # Close the book entry
            cat >> "$PUBLISH_DIR/index.html" << EOF
        </div>
        <div class="timestamp">Last updated: $(date)</div>
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

# Close the index.html
cat >> "$PUBLISH_DIR/index.html" << 'EOF'
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

#!/usr/bin/env bash
# Generate _quarto.yml from content/ directory layout.
# Do not hand-edit _quarto.yml; re-run this script after structural changes.
# Supports nested sections (part → section → nested section → chapters).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOK_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT_DIR="$BOOK_DIR/content"
QUARTO_YML="$BOOK_DIR/_quarto.yml"
BOOK_NAME="$(basename "$BOOK_DIR")"

REPO_URL="${BOOK_REPO_URL:-https://github.com/kanthi/books}"
BOOK_AUTHOR="${BOOK_AUTHOR:-K19G}"

if [ ! -d "$CONTENT_DIR" ]; then
  echo "error: content/ not found at $CONTENT_DIR" >&2
  echo "Create content/<NN-part>/ chapters, then re-run this script." >&2
  exit 1
fi

extract_qmd_title() {
  local file="$1"
  local title=""

  if [ -f "$file" ]; then
    title="$(awk '
      BEGIN { in_fm=0 }
      /^---[[:space:]]*$/ {
        if (in_fm == 0) { in_fm=1; next }
        else { exit }
      }
      in_fm && /^title:[[:space:]]*/ {
        sub(/^title:[[:space:]]*/, "")
        gsub(/^["'\'']|["'\'']$/, "")
        print
        exit
      }
    ' "$file")"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi

    title="$(head -n 20 "$file" | grep -E '^#[[:space:]]+' | head -n 1 | sed -E 's/^#[[:space:]]+//')"
    title="${title%% \{*}"
    title="$(printf '%s' "$title" | sed -E 's/[[:space:]]+$//')"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi
  fi

  local dirname
  dirname="$(basename "$(dirname "$file")")"
  humanize_dir_title "$dirname"
}

# Title-case a directory basename with special cases and small-word rules.
humanize_dir_title() {
  local slug title
  slug="$(echo "$1" | sed -E 's/^[0-9]+-?//')"
  # Split CamelCase leftovers: LinearAlgebra → Linear Algebra
  slug="$(echo "$slug" | sed -E 's/([a-z])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')"

  case "$slug" in
    # Linux
    terminals-and-mux)          printf '%s\n' "Terminals and Multiplexers"; return ;;
    help-and-docs)              printf '%s\n' "Help and Docs"; return ;;
    services-and-runtime)       printf '%s\n' "Services and Runtime"; return ;;
    text-and-pipes)             printf '%s\n' "Text and Pipes"; return ;;
    files-and-paths)            printf '%s\n' "Files and Paths"; return ;;
    archives-and-compression)   printf '%s\n' "Archives and Compression"; return ;;
    processes-and-jobs)         printf '%s\n' "Processes and Jobs"; return ;;
    users-and-groups)           printf '%s\n' "Users and Groups"; return ;;
    storage-and-filesystems)    printf '%s\n' "Storage and Filesystems"; return ;;
    system-information)         printf '%s\n' "System Information"; return ;;
    system-monitoring)          printf '%s\n' "System Monitoring"; return ;;
    shell-commands)             printf '%s\n' "Shell Commands"; return ;;
    intro-to-shells)            printf '%s\n' "Intro to Shells"; return ;;
    bash-features)              printf '%s\n' "Bash Features"; return ;;
    lazyvim)                    printf '%s\n' "LazyVim"; return ;;
    modern-tools)               printf '%s\n' "Modern Tools"; return ;;
    # C
    file-io)                    printf '%s\n' "File I/O"; return ;;
    arrays-strings)             printf '%s\n' "Arrays and Strings"; return ;;
    data-types)                 printf '%s\n' "Data Types"; return ;;
    control-flow)               printf '%s\n' "Control Flow"; return ;;
    data-structures)            printf '%s\n' "Data Structures"; return ;;
    modern-c)                   printf '%s\n' "Modern C"; return ;;
    # Go
    concurrency-parallelism)    printf '%s\n' "Concurrency and Parallelism"; return ;;
    performance-tooling)        printf '%s\n' "Performance and Tooling"; return ;;
    network-systems)            printf '%s\n' "Network Systems"; return ;;
    systems-programming)        printf '%s\n' "Systems Programming"; return ;;
    distributed-infra)          printf '%s\n' "Distributed Infrastructure"; return ;;
    observability-sre)          printf '%s\n' "Observability and SRE"; return ;;
    security-hardening)         printf '%s\n' "Security Hardening"; return ;;
    performance-engineering)    printf '%s\n' "Performance Engineering"; return ;;
    modern-go-book-synthesis)   printf '%s\n' "Modern Go Synthesis"; return ;;
    go-deep-dives)              printf '%s\n' "Go Deep Dives"; return ;;
    concurrency-ground-up)      printf '%s\n' "Concurrency Ground Up"; return ;;
    web-development-in-go)      printf '%s\n' "Web Development in Go"; return ;;
    cli-tools-in-go)            printf '%s\n' "CLI Tools in Go"; return ;;
    # NixOS
    front-matter)               printf '%s\n' "Front Matter"; return ;;
    nix-on-linux)               printf '%s\n' "Nix on Linux"; return ;;
    nixos-host)                 printf '%s\n' "NixOS Host"; return ;;
    home-and-flake-layout)      printf '%s\n' "Home and Flake Layout"; return ;;
    services-and-security)      printf '%s\n' "Services and Security"; return ;;
    ops-and-fleet)              printf '%s\n' "Ops and Fleet"; return ;;
    # Maths
    pre-algebra)                printf '%s\n' "Pre-Algebra"; return ;;
    linear-algebra)             printf '%s\n' "Linear Algebra"; return ;;
    discrete-mathematics)       printf '%s\n' "Discrete Mathematics"; return ;;
    number-theory)              printf '%s\n' "Number Theory"; return ;;
    information-theory)         printf '%s\n' "Information Theory"; return ;;
    machine-learning-math)      printf '%s\n' "Machine Learning Math"; return ;;
    algorithms-complexity)      printf '%s\n' "Algorithms and Complexity"; return ;;
    graph-theory)               printf '%s\n' "Graph Theory"; return ;;
    numerical-methods)          printf '%s\n' "Numerical Methods"; return ;;
    data-science-math)          printf '%s\n' "Data Science Math"; return ;;
    probability-advanced)       printf '%s\n' "Probability (Advanced)"; return ;;
    linear-algebra-advanced)    printf '%s\n' "Linear Algebra (Advanced)"; return ;;
    complexity-theory)          printf '%s\n' "Complexity Theory"; return ;;
    # Networking
    lab-platform)               printf '%s\n' "Lab Platform"; return ;;
    networking-foundations)     printf '%s\n' "Networking Foundations"; return ;;
    layer-2)                    printf '%s\n' "Layer 2"; return ;;
    layer-3)                    printf '%s\n' "Layer 3"; return ;;
    interior-routing)           printf '%s\n' "Interior Routing"; return ;;
    ops-automation)             printf '%s\n' "Ops and Automation"; return ;;
    edge-and-services)          printf '%s\n' "Edge and Services"; return ;;
    policy-qos-hardening)       printf '%s\n' "Policy, QoS, and Hardening"; return ;;
    overlays-tunnels)           printf '%s\n' "Overlays and Tunnels"; return ;;
    fabrics-multi-area)         printf '%s\n' "Fabrics and Multi-Area"; return ;;
    # VCS (before generic CamelCase split effects: GitHub → git-hub)
    git-fundamentals)           printf '%s\n' "Git Fundamentals"; return ;;
    core-operations)            printf '%s\n' "Core Operations"; return ;;
    git-internals)              printf '%s\n' "Git Internals"; return ;;
    advanced-branching)         printf '%s\n' "Advanced Branching"; return ;;
    github-intro|git-hub-intro) printf '%s\n' "GitHub Intro"; return ;;
    rewriting-history)          printf '%s\n' "Rewriting History"; return ;;
    advanced-commands)          printf '%s\n' "Advanced Commands"; return ;;
    hooks-automation)           printf '%s\n' "Hooks and Automation"; return ;;
    github-actions|git-hub-actions) printf '%s\n' "GitHub Actions"; return ;;
    github-advanced|git-hub-advanced) printf '%s\n' "GitHub Advanced"; return ;;
    open-source)                printf '%s\n' "Open Source"; return ;;
    team-collaboration)         printf '%s\n' "Team Collaboration"; return ;;
    advanced-topics)            printf '%s\n' "Advanced Topics"; return ;;
    # Python
    data-and-ai)                printf '%s\n' "Data and AI"; return ;;
    systems-and-ops)            printf '%s\n' "Systems and Ops"; return ;;
    computer-science)           printf '%s\n' "Computer Science"; return ;;
    stdlib)                     printf '%s\n' "Standard Library"; return ;;
    stdlib-essentials)          printf '%s\n' "Stdlib Essentials"; return ;;
    getting-started)            printf '%s\n' "Getting Started"; return ;;
    syntax-and-types)           printf '%s\n' "Syntax and Types"; return ;;
    modules-and-packages)       printf '%s\n' "Modules and Packages"; return ;;
    objects-and-classes)        printf '%s\n' "Objects and Classes"; return ;;
    errors-and-io)              printf '%s\n' "Errors and I/O"; return ;;
    names-namespaces-frames)    printf '%s\n' "Names, Namespaces, and Frames"; return ;;
    bytecode-and-eval)          printf '%s\n' "Bytecode and Eval"; return ;;
    gil-and-free-threading)     printf '%s\n' "GIL and Free-Threading"; return ;;
    memory-and-gc)              printf '%s\n' "Memory and GC"; return ;;
    import-system)              printf '%s\n' "Import System"; return ;;
    descriptors-and-slots)      printf '%s\n' "Descriptors and Slots"; return ;;
    linux-python)               printf '%s\n' "Linux and Python"; return ;;
    classical-ml)               printf '%s\n' "Classical ML"; return ;;
    deep-learning)              printf '%s\n' "Deep Learning"; return ;;
    llms-and-agents)            printf '%s\n' "LLMs and Agents"; return ;;
    netops)                     printf '%s\n' "NetOps"; return ;;
    mlops)                      printf '%s\n' "MLOps"; return ;;
    sre)                        printf '%s\n' "SRE"; return ;;
    devops)                     printf '%s\n' "DevOps"; return ;;
  esac

  title="$(echo "$slug" | sed 's/-/ /g' | awk '{
    small["and"]=1; small["or"]=1; small["to"]=1; small["of"]=1;
    small["for"]=1; small["in"]=1; small["on"]=1; small["the"]=1; small["a"]=1;
    for (i=1;i<=NF;i++) {
      w=tolower($i)
      if (i>1 && (w in small)) $i=w
      else $i=toupper(substr(w,1,1)) substr(w,2)
    }
    print
  }')"
  printf '%s\n' "$title"
}

get_metadata() {
  local dir="$1"
  local dirname order title
  dirname="$(basename "$dir")"

  if [[ $dirname =~ ^[0-9]+ ]]; then
    order="${BASH_REMATCH[0]}"
  else
    order="99"
  fi
  title="$(humanize_dir_title "$dirname")"
  printf '%s|%s\n' "$order" "$title"
}

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

cat > "$TMP_FILE" <<EOL
project:
  type: book
  output-dir: _book
  # Dual-theme illustrated SVGs (dark siblings swapped in HTML — see includes/diagrams/STANDARD.md)
  resources:
    - images/*-dark.svg

book:
  title: "$BOOK_NAME"
  author: "$BOOK_AUTHOR"
  date: last-modified
  navbar:
    pinned: true
    right:
      - icon: github
        href: $REPO_URL

  sidebar:
    style: docked
    collapse-level: 1
  reader-mode: true
  chapters:
    - index.qmd
EOL

emit_chapter_files() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local ext doc doc_name file_title

  for ext in qmd md; do
    if [ -f "$folder/index.$ext" ]; then
      file_title="$(extract_qmd_title "$folder/index.$ext")"
      {
        echo "${ind}- text: \"$file_title\""
        echo "${ind}  file: ${rel}/index.$ext"
      } >> "$TMP_FILE"
      break
    fi
  done

  while IFS= read -r -d '' doc; do
    doc_name="$(basename "$doc")"
    [[ "$doc_name" == index.* ]] && continue
    file_title="$(extract_qmd_title "$doc")"
    {
      echo "${ind}- text: \"$file_title\""
      echo "${ind}  file: ${rel}/${doc_name}"
    } >> "$TMP_FILE"
  done < <(find "$folder" -maxdepth 1 -type f \( -name "*.qmd" -o -name "*.md" \) -print0 2>/dev/null | sort -z)
}

emit_section() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local nested_ind="${ind}  "
  local item_ind="${nested_ind}  "
  local name title sub sub_name sub_rel
  local has_nested=0

  name="$(basename "$folder")"
  title="$(humanize_dir_title "$name")"

  {
    echo "${ind}- section: \"$title\""
    echo "${ind}  contents:"
  } >> "$TMP_FILE"

  for sub in "$folder"/*; do
    if [ -d "$sub" ] && [[ ! $(basename "$sub") == _* ]]; then
      has_nested=1
      sub_name="$(basename "$sub")"
      sub_rel="${rel}/${sub_name}"
      emit_section "$sub" "$sub_rel" "$item_ind"
    fi
  done

  emit_chapter_files "$folder" "$rel" "$item_ind"
}

process_directory() {
  local dir="$1"
  local metadata order title
  metadata="$(get_metadata "$dir")"
  order="$(echo "$metadata" | cut -d'|' -f1)"
  title="$(echo "$metadata" | cut -d'|' -f2)"

  {
    echo "    - part: \"$title\""
    echo "      contents:"
  } >> "$TMP_FILE"

  local ext doc doc_name file_title subdir

  for ext in qmd md; do
    if [ -f "$dir/index.$ext" ]; then
      file_title="$(extract_qmd_title "$dir/index.$ext")"
      {
        echo "        - text: \"$file_title\""
        echo "          file: content/$(basename "$dir")/index.$ext"
      } >> "$TMP_FILE"
      break
    fi
  done

  while IFS= read -r -d '' doc; do
    doc_name="$(basename "$doc")"
    [[ "$doc_name" == index.* ]] && continue
    file_title="$(extract_qmd_title "$doc")"
    {
      echo "        - text: \"$file_title\""
      echo "          file: content/$(basename "$dir")/${doc_name}"
    } >> "$TMP_FILE"
  done < <(find "$dir" -maxdepth 1 -type f \( -name "*.qmd" -o -name "*.md" \) -print0 2>/dev/null | sort -z)

  for subdir in "$dir"/*; do
    if [ -d "$subdir" ] && [[ ! $(basename "$subdir") == _* ]]; then
      emit_section "$subdir" "content/$(basename "$dir")/$(basename "$subdir")" "        "
    fi
  done
}

categories=()
while IFS= read -r category; do
  if [ -d "$category" ] && [[ ! $(basename "$category") == _* ]]; then
    metadata="$(get_metadata "$category")"
    order="$(echo "$metadata" | cut -d'|' -f1)"
    categories+=("$order|$category")
  fi
done < <(find "$CONTENT_DIR" -maxdepth 1 -mindepth 1 -type d | sort)

if [ "${#categories[@]}" -gt 0 ]; then
  while IFS= read -r category_info; do
    [ -z "$category_info" ] && continue
    category_path="$(echo "$category_info" | cut -d'|' -f2)"
    process_directory "$category_path"
  done < <(printf "%s\n" "${categories[@]}" | sort -n)
fi

cat >> "$TMP_FILE" <<'EOL'

# Document-level (not valid under book:). HTML title block: date → Published; date-modified → Updated.
date-modified: last-modified

language:
  title-block-modified: "Updated"

format:
  html:
    theme:
      dark: [darkly, styles/dark.scss]
      light: [cosmo, styles/light.scss]
    syntax-highlighting:
      light: styles/zed-light.theme
      dark: styles/zed-dark.theme
    code-fold: true
    toc: true
    number-sections: false
    page-navigation: true
    include-after-body:
      - styles/reader-mode-body.html

  pdf:
    pdf-engine-max-runs: 4
    documentclass: scrreprt
    classoption: ["oneside"]
    number-sections: false
    colorlinks: true
    geometry:
      - top=25mm
      - left=25mm
      - right=25mm
      - bottom=25mm

  epub:
    toc: true
    number-sections: false
    css: styles/epub.css
EOL

mv "$TMP_FILE" "$QUARTO_YML"
trap - EXIT

echo "Updated _quarto.yml for book: $BOOK_NAME"
echo "  content: $CONTENT_DIR"
echo "  output:  $QUARTO_YML"

# Helix: A Modern Modal Editor

Helix is a modern, terminal-based text editor written in Rust. It takes inspiration from Kakoune and Vim, featuring multiple selections, built-in LSP support, and a focus on simplicity and performance.

## What is Helix?

Helix is designed with modern editing principles:
- **Selection-first editing**: Select text first, then act on it
- **Multiple selections**: Edit multiple locations simultaneously
- **Built-in LSP**: Language Server Protocol support out of the box
- **Tree-sitter**: Advanced syntax highlighting and text objects
- **No configuration required**: Works great with zero configuration
- **Fast and lightweight**: Written in Rust for performance

## Why Choose Helix?

- **Modern design**: Built from the ground up with modern editing concepts
- **Zero configuration**: Sensible defaults that work immediately
- **Multiple selections**: Powerful multi-cursor editing
- **Built-in features**: LSP, tree-sitter, and fuzzy finder included
- **Consistent keybindings**: Logical and memorable key combinations
- **Linux-optimized**: Designed with Linux development workflows in mind
- **Active development**: Regular updates and improvements
- **Rust performance**: Fast and memory-efficient on Linux systems

## Installation

### Package Managers

```bash
# Ubuntu/Debian (from source)
sudo apt update
sudo apt install git rustc cargo
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term --locked

# Arch Linux
sudo pacman -S helix

# Fedora
sudo dnf install helix

# SUSE/openSUSE
sudo zypper install helix

# Gentoo
sudo emerge app-editors/helix

# Void Linux
sudo xbps-install helix

# Nix
nix-env -iA nixpkgs.helix

# Cargo (from source)
cargo install helix-term --locked
```

### Building from Source

```bash
# Clone repository
git clone https://github.com/helix-editor/helix
cd helix

# Build and install
cargo install --path helix-term --locked

# Install runtime files
mkdir -p ~/.config/helix
cp -r runtime ~/.config/helix/

# Or use system-wide installation
sudo mkdir -p /usr/local/lib/helix
sudo cp -r runtime /usr/local/lib/helix/
```

### Post-Installation Setup

```bash
# Install language servers (optional but recommended)
# JavaScript/TypeScript
npm install -g typescript-language-server typescript

# Python
pip install python-lsp-server

# Rust (if not already installed)
rustup component add rust-analyzer

# Go
go install golang.org/x/tools/gopls@latest

# Check health and see what's available
hx --health
```

## Basic Concepts

### Selection-First Editing

Unlike Vim's action-first approach, Helix uses selection-first:

```bash
# Vim way: action + motion
dw    # Delete word (action first)

# Helix way: selection + action
w     # Select word
d     # Delete selection
```

### Multiple Selections

Helix excels at multiple selections:

```bash
# Select all occurrences of current selection
%     # Select all matches

# Add selection
C     # Duplicate cursor/selection
Alt-C # Remove primary selection

# Split selections
S     # Split selection on regex
Alt-s # Split selection on lines
```

### Modes

Helix has several modes:
- **Normal mode**: Default mode for navigation and commands
- **Insert mode**: For typing text
- **Select mode**: For making selections
- **Command mode**: For ex-style commands

## Essential Commands

### Starting Helix

```bash
# Open file
hx filename.txt

# Open multiple files
hx file1.txt file2.txt

# Open directory (file picker)
hx .

# Open with specific line/column
hx filename.txt:25:10

# Health check
hx --health
```

### Basic Navigation

```bash
# Character movement
h     # Left
j     # Down
k     # Up
l     # Right

# Word movement
w     # Next word start
b     # Previous word start
e     # Next word end

# Line movement
0     # Line start
^     # First non-whitespace
$     # Line end
g h   # Line start (alternative)
g l   # Line end (alternative)

# Document movement
g g   # Document start
g e   # Document end
Ctrl+u # Page up
Ctrl+d # Page down

# Paragraph movement
[     # Previous paragraph
]     # Next paragraph
```

### Text Selection

```bash
# Basic selection
v     # Enter select mode
V     # Select line
Ctrl+v # Select block (not implemented yet)

# Word/object selection
w     # Select word
W     # Select WORD (whitespace-separated)
p     # Select paragraph
f<char> # Select to character
t<char> # Select until character

# Extend selection
;     # Flip selection direction
Alt+; # Ensure forward selection direction
%     # Select matching bracket
m     # Select matching pair (quotes, brackets, etc.)

# Multiple selections
C     # Duplicate cursor
Alt+C # Remove primary cursor
s     # Select regex matches within selection
S     # Split selection on regex
Alt-s # Split selection on newlines
&     # Align selections
_     # Trim whitespace from selections
```

### Editing Commands

```bash
# Insert modes
i     # Insert before selection
a     # Insert after selection
I     # Insert at line start
A     # Insert at line end
o     # Insert new line below
O     # Insert new line above

# Delete/Change
d     # Delete selection
c     # Change selection (delete and enter insert mode)
Alt+d # Delete line
Alt+c # Change line

# Copy/Paste
y     # Yank (copy) selection
p     # Paste after selection
P     # Paste before selection
Alt+p # Paste every yanked selection
R     # Replace selection with yanked text

# Undo/Redo
u     # Undo
U     # Redo
Alt+u # Earlier in time
Alt+U # Later in time
```

### Search and Replace

```bash
# Search
/     # Search forward
?     # Search backward
n     # Next search result
N     # Previous search result
*     # Search word under cursor

# Replace
r<char> # Replace character
~     # Switch case
`     # Set case to lowercase
Alt+` # Set case to uppercase

# Global replace (in command mode)
:s/old/new/g        # Replace in current selection
:%s/old/new/g       # Replace in entire file
:s/old/new/gc       # Replace with confirmation
```

## File and Buffer Management

### File Operations

```bash
# File commands (in command mode)
:o filename   # Open file
:w           # Write file
:w filename  # Write as filename
:q           # Quit
:q!          # Quit without saving
:wq          # Write and quit

# Buffer navigation
Space b      # Buffer picker
gn           # Next buffer
gp           # Previous buffer
Space x      # Close buffer
```

### File Picker and Fuzzy Finding

```bash
# File operations
Space f      # File picker
Space F      # File picker (from cwd)
Space b      # Buffer picker
Space s      # Symbol picker (LSP)
Space S      # Workspace symbol picker
Space g      # Global search (grep)
Space /      # Global search in current file
Space k      # Show documentation
Space r      # Rename symbol (LSP)
Space a      # Code action (LSP)
```

## Configuration

### Configuration File

Helix uses TOML for configuration:

```toml
# ~/.config/helix/config.toml

theme = "onedark"

[editor]
line-number = "relative"
mouse = true
middle-click-paste = true
scroll-lines = 3
shell = ["sh", "-c"]
text-width = 80
completion-trigger-len = 2
auto-completion = true
auto-format = true
auto-save = false
idle-timeout = 400
preview-completion-insert = true
completion-replace = false
auto-info = true
true-color = false
rulers = [80, 120]
bufferline = "always"
color-modes = false

[editor.statusline]
left = ["mode", "spinner"]
center = ["file-name"]
right = ["diagnostics", "selections", "position", "file-encoding", "file-line-ending", "file-type"]
separator = "│"
mode.normal = "NORMAL"
mode.insert = "INSERT"
mode.select = "SELECT"

[editor.lsp]
display-messages = true
auto-signature-help = true
display-inlay-hints = true
display-signature-help-docs = true
snippets = true
goto-reference-include-declaration = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = true
follow-symlinks = true
deduplicate-links = true
parents = true
ignore = true
git-ignore = true
git-global = true
git-exclude = true
max-depth = 25

[editor.auto-pairs]
'(' = ')'
'{' = '}'
'[' = ']'
'"' = '"'
"'" = "'"
"`" = "`"
'<' = '>'

[editor.search]
smart-case = true
wrap-around = true

[editor.whitespace]
render = "all"
characters = { space = "·", nbsp = "⍽", tab = "→", newline = "⏎", tabpad = "·" }

[editor.indent-guides]
render = true
character = "┊"
skip-levels = 1

[editor.gutters]
layout = ["diff", "diagnostics", "line-numbers", "spacer"]

[editor.soft-wrap]
enable = false
max-wrap = 25
max-indent-retain = 0
wrap-indicator = ""

[keys.normal]
# Custom keybindings
C-s = ":w"
C-o = "file_picker"
C-p = "file_picker"
esc = ["collapse_selection", "keep_primary_selection"]

[keys.insert]
# Insert mode keybindings
C-s = ["normal_mode", ":w", "insert_mode"]
j = { k = "normal_mode" } # jk to exit insert mode

[keys.select]
# Select mode keybindings
esc = ["collapse_selection", "keep_primary_selection", "normal_mode"]
```

### Language Configuration

```toml
# ~/.config/helix/languages.toml

# Override language server configurations
[[language]]
name = "python"
language-server = { command = "pylsp" }
auto-format = true

[language.config.pylsp.plugins]
autopep8 = { enabled = false }
flake8 = { enabled = true }
mccabe = { enabled = false }
pycodestyle = { enabled = false }
pyflakes = { enabled = false }
pylint = { enabled = true }
yapf = { enabled = true }

[[language]]
name = "javascript"
language-server = { command = "typescript-language-server", args = ["--stdio"] }
auto-format = true

[[language]]
name = "typescript"
language-server = { command = "typescript-language-server", args = ["--stdio"] }
auto-format = true

[[language]]
name = "rust"
language-server = { command = "rust-analyzer" }
auto-format = true

[[language]]
name = "go"
language-server = { command = "gopls" }
auto-format = true

[[language]]
name = "html"
language-server = { command = "vscode-html-language-server", args = ["--stdio"] }
auto-format = true

[[language]]
name = "css"
language-server = { command = "vscode-css-language-server", args = ["--stdio"] }
auto-format = true

[[language]]
name = "json"
language-server = { command = "vscode-json-language-server", args = ["--stdio"] }
auto-format = true

# Custom language definitions
[[language]]
name = "log"
scope = "text.log"
file-types = ["log"]
comment-token = "#"
indent = { tab-width = 2, unit = "  " }

[[grammar]]
name = "log"
source = { git = "https://github.com/Tudyx/tree-sitter-log", rev = "main" }
```

### Themes

Helix comes with many built-in themes:

```bash
# List available themes
:theme

# Change theme temporarily
:theme dracula

# Popular themes
:theme onedark
:theme gruvbox
:theme catppuccin_mocha
:theme tokyo-night
:theme solarized_dark
:theme nord
```

### Custom Theme

```toml
# ~/.config/helix/themes/mytheme.toml

"ui.background" = { bg = "#1e1e1e" }
"ui.text" = "#d4d4d4"
"ui.text.focus" = "#ffffff"
"ui.selection" = { bg = "#264f78" }
"ui.cursor" = { fg = "#1e1e1e", bg = "#d4d4d4" }
"ui.cursor.match" = { bg = "#3a3d41" }
"ui.linenr" = "#858585"
"ui.linenr.selected" = "#c6c6c6"
"ui.statusline" = { fg = "#d4d4d4", bg = "#007acc" }
"ui.statusline.inactive" = { fg = "#d4d4d4", bg = "#3c3c3c" }
"ui.popup" = { bg = "#252526" }
"ui.window" = "#3c3c3c"
"ui.help" = { bg = "#252526" }

"error" = "#f44747"
"warning" = "#ff8c00"
"info" = "#0080ff"
"hint" = "#969696"

"diagnostic.error" = { underline = { color = "#f44747", style = "curl" } }
"diagnostic.warning" = { underline = { color = "#ff8c00", style = "curl" } }
"diagnostic.info" = { underline = { color = "#0080ff", style = "curl" } }
"diagnostic.hint" = { underline = { color = "#969696", style = "curl" } }

"syntax.comment" = "#6a9955"
"syntax.keyword" = "#569cd6"
"syntax.string" = "#ce9178"
"syntax.number" = "#b5cea8"
"syntax.boolean" = "#569cd6"
"syntax.type" = "#4ec9b0"
"syntax.function" = "#dcdcaa"
"syntax.variable" = "#9cdcfe"
"syntax.constant" = "#4fc1ff"
"syntax.operator" = "#d4d4d4"
"syntax.punctuation" = "#d4d4d4"
```

## Real-World Usage Scenarios

### Scenario 1: Python Development

```bash
# Open Python project
hx main.py

# Navigate to function definition
gd    # Go to definition (LSP)
gr    # Go to references (LSP)

# Multiple cursor editing
# Select function name
w     # Select word
%     # Select all occurrences
c     # Change all occurrences
new_function_name<Esc>

# Code formatting
:format   # Format current file
# Or enable auto-format in config

# Symbol search
Space s   # Search symbols in file
Space S   # Search symbols in workspace

# Diagnostics
]d        # Next diagnostic
[d        # Previous diagnostic
Space k   # Show hover information
Space a   # Code actions
```

### Scenario 2: Web Development

```bash
# Open HTML file
hx index.html

# Select HTML tag
mt    # Select matching tag pair
c     # Change tag
div<Esc>

# Multiple selections for attributes
# Select class attribute value
f"    # Find quote
mi    # Select inside quotes
%     # Select all similar
c     # Change all
new-class<Esc>

# Navigate between files
Space f   # File picker
# Type filename and Enter

# Global search and replace
Space g   # Global search
# Type search term
# Navigate results with j/k
# Press Enter to go to location
```

### Scenario 3: Configuration File Editing

```bash
# Open config file
hx ~/.config/helix/config.toml

# Navigate to specific section
/editor   # Search for "editor"
n         # Next occurrence

# Select and modify values
f=        # Find equals sign
l         # Move right
w         # Select value
c         # Change value
new_value<Esc>

# Comment/uncomment lines
Alt+;     # Toggle line comment
# Or select multiple lines and comment
V         # Select line
jjj       # Extend selection
Alt+;     # Comment selected lines
```

### Scenario 4: Log File Analysis

```bash
# Open log file
hx /var/log/application.log

# Search for errors
/ERROR    # Search for ERROR
n         # Next occurrence
N         # Previous occurrence

# Select all error lines
*         # Search word under cursor (ERROR)
%         # Select all matches
y         # Yank all error lines

# Open new buffer for analysis
:new
p         # Paste error lines

# Split selections by timestamp
s^\d{4}-\d{2}-\d{2}  # Split on date pattern
```

## Advanced Features

### Multiple Selections Mastery

```bash
# Complex selection scenarios
# Select all function calls
/\w+\(   # Search for function calls
%        # Select all matches

# Select inside parentheses for all matches
mi       # Select inside matching pairs

# Add numbers to each selection
C        # Duplicate cursor to each selection
I        # Insert at beginning
1. <Esc> # Add numbering (manual)

# Or use regex replacement
:s/^/1. /  # Add numbering with regex
```

### Text Objects

```bash
# Built-in text objects
mw    # Select word
mp    # Select paragraph
m(    # Select inside parentheses
m)    # Select around parentheses
m[    # Select inside brackets
m]    # Select around brackets
m{    # Select inside braces
m}    # Select around braces
m"    # Select inside quotes
m'    # Select inside single quotes
m`    # Select inside backticks
mt    # Select inside HTML/XML tags
mf    # Select function
mc    # Select class
ma    # Select argument
```

### Tree-sitter Navigation

```bash
# Navigate syntax tree
Alt+p # Parent node
Alt+c # Child node
Alt+n # Next sibling
Alt+o # Previous sibling

# Select syntax nodes
mf    # Select function
mc    # Select class
ma    # Select argument/parameter
```

### LSP Features

```bash
# Code navigation
gd    # Go to definition
gy    # Go to type definition
gr    # Go to references
gi    # Go to implementation

# Code information
Space k   # Hover information
Space K   # Signature help

# Code modification
Space r   # Rename symbol
Space a   # Code actions
:format   # Format document

# Diagnostics
]d        # Next diagnostic
[d        # Previous diagnostic
]D        # Next error
[D        # Previous error
Space d   # Show diagnostics
```

## Customization and Scripting

### Custom Commands

```toml
# ~/.config/helix/config.toml

[keys.normal]
# Custom command sequences
C-g = [":new", ":insert-output echo 'Hello World'"]
C-t = [":sh date"]

# Macro-like sequences
F1 = ["select_all", "yank", ":new", "paste_after"]
F2 = ["goto_line_start", "insert_mode", "// ", "normal_mode"]
```

### Integration with External Tools

```bash
# Pipe selection to external command
|sort     # Sort selected lines
|uniq     # Remove duplicate lines
|wc -l    # Count lines
|jq       # Format JSON
|xmllint --format -  # Format XML

# Insert command output
:insert-output date
:insert-output ls -la
:insert-output git log --oneline -10
```

### Shell Integration

```bash
# Set Helix as default editor
export EDITOR=hx
export VISUAL=hx

# Git integration
git config --global core.editor hx

# Shell aliases
alias h='hx'
alias hx.='hx .'
alias hxc='hx ~/.config/helix/config.toml'
```

## Performance and Optimization

### Large File Handling

Helix handles large files efficiently:

```bash
# Open large files
hx large_file.log

# Navigate efficiently
gg    # Go to start
ge    # Go to end
Ctrl+u # Page up
Ctrl+d # Page down

# Search in large files
/pattern  # Incremental search
n         # Next match
N         # Previous match
```

### Memory Usage

```bash
# Check memory usage
:debug-info

# Optimize for memory
# Disable unnecessary features in config
[editor]
auto-completion = false
auto-info = false
```

## Troubleshooting

### Common Issues

```bash
# Check health
hx --health

# Language server issues
:lsp-workspace-command
:lsp-restart

# Theme issues
:theme default
:reload-config

# Key binding conflicts
# Check config.toml for conflicting bindings
```

### Debug Mode

```bash
# Start with debug logging
RUST_LOG=debug hx

# Check logs
tail -f ~/.cache/helix/helix.log
```

### Reset Configuration

```bash
# Backup current config
mv ~/.config/helix ~/.config/helix.backup

# Start fresh
hx  # Will create default config
```

## Migration from Other Editors

### From Vim/Neovim

Key differences to remember:
- Selection-first editing
- Different keybindings for some operations
- Built-in LSP and tree-sitter
- No plugin system (yet)

### From VSCode

Helix provides many VSCode-like features:
- Built-in LSP support
- Fuzzy file finding
- Multiple selections
- Integrated terminal (external)

### From Kakoune

Helix is inspired by Kakoune:
- Similar selection-first philosophy
- Multiple selections
- Different keybindings and features

Helix offers a modern, efficient editing experience with powerful features built-in. Its selection-first approach and multiple selections make it particularly effective for complex text manipulation tasks, while the zero-configuration philosophy means you can be productive immediately.
## Next steps

- [tmux](../11-tmux/index.md) for splits and SSH detach
- [Herdr](../12-herdr/index.md) when running AI agent CLIs beside Helix
- [Modern Tools](../10-modern-tools/index.md) — rg, fd, fzf, bat
- [Workflows](../14-workflows/index.md)

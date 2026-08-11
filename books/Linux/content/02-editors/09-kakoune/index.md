# Kakoune: The Selection-Based Editor

Kakoune is a modal editor that emphasizes selection-based editing and multiple selections. Inspired by Vim but with a different philosophy, Kakoune provides powerful text manipulation capabilities through its unique approach to editing.

## What is Kakoune?

Kakoune (kak) is built around several key principles:
- **Selection-first editing**: Select text first, then act on it
- **Multiple selections**: Edit multiple locations simultaneously
- **Orthogonal design**: Commands compose naturally
- **Client-server architecture**: Multiple clients can connect to one session
- **Powerful text objects**: Rich set of selection primitives
- **Minimal configuration**: Works well with minimal setup

## Why Choose Kakoune?

- **Intuitive workflow**: Selection-first approach feels natural
- **Multiple selections**: Powerful multi-cursor editing
- **Composable commands**: Commands work together logically
- **Fast and lightweight**: Efficient C++ implementation optimized for Linux
- **Extensible**: Scriptable with shell commands and Linux utilities
- **Unique approach**: Different from Vim/Emacs paradigms
- **Active community**: Growing ecosystem of plugins and tools
- **Linux-native**: Designed with Linux development workflows in mind

## Installation

### Package Managers

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install kakoune

# Fedora
sudo dnf install kakoune

# Arch Linux
sudo pacman -S kakoune

# SUSE/openSUSE
sudo zypper install kakoune

# Gentoo
sudo emerge app-editors/kakoune

# Void Linux
sudo xbps-install kakoune

# FreeBSD
pkg install kakoune

# OpenBSD
pkg_add kakoune
```

### Building from Source

```bash
# Install dependencies
# Ubuntu/Debian
sudo apt install build-essential libncurses5-dev libncursesw5-dev

# Clone and build
git clone https://github.com/mawww/kakoune.git
cd kakoune
make
sudo make install

# Or install to custom location
make install PREFIX=$HOME/.local
```

### Development Version

```bash
# For latest features
git clone https://github.com/mawww/kakoune.git
cd kakoune
git checkout master
make
sudo make install
```

## Basic Concepts

### Selection-First Philosophy

Unlike Vim's action-first approach, Kakoune uses selection-first:

```bash
# Vim way: action + motion
dw    # Delete word (action first)

# Kakoune way: selection + action
w     # Select word
d     # Delete selection
```

### Multiple Selections

Kakoune excels at multiple selections:

```bash
# Select all occurrences
%     # Select all matches of current selection
Alt+% # Select all matches in buffer

# Split selections
s     # Split selection on regex
Alt+s # Split selection on lines
```

### Modes

Kakoune has several modes:
- **Normal mode**: Default mode for navigation and commands
- **Insert mode**: For typing text
- **Prompt mode**: For entering commands and searches
- **Menu mode**: For selecting from options

## Essential Commands

### Starting Kakoune

```bash
# Open file
kak filename.txt

# Open multiple files
kak file1.txt file2.txt

# Start server session
kak -s session_name filename.txt

# Connect to existing session
kak -c session_name

# List sessions
kak -l

# Kill session
kak -c session_name -e 'kill'
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
Alt+w # Next WORD start
Alt+b # Previous WORD start
Alt+e # Next WORD end

# Line movement
0     # Line start
^     # First non-blank
$     # Line end
Alt+h # Line start (alternative)
Alt+l # Line end (alternative)

# Document movement
g g   # Document start
g e   # Document end
g k   # Buffer top
g j   # Buffer bottom

# Page movement
Ctrl+b # Page up
Ctrl+f # Page down
Ctrl+u # Half page up
Ctrl+d # Half page down
```

### Text Selection

```bash
# Basic selection
x     # Select line
Alt+x # Extend selection to line
s     # Select regex matches
Alt+s # Split selection on lines

# Word selection
w     # Select word
W     # Select WORD
Alt+w # Extend to word
Alt+W # Extend to WORD

# Character selection
f<char> # Select to character
t<char> # Select until character
F<char> # Select to character (backward)
T<char> # Select until character (backward)

# Extend selection
Shift+<motion> # Extend selection with motion
;     # Reduce selection to cursor
Alt+; # Flip selection direction
```

### Multiple Selections

```bash
# Create multiple selections
C     # Copy selection to new line
Alt+C # Copy selection to previous line
%     # Select all matches of current selection
Alt+% # Select all matches in buffer

# Manipulate selections
Alt+k # Keep selections matching regex
Alt+K # Keep selections not matching regex
$     # Pipe selections through command
|     # Pipe and replace selections
!     # Insert command output

# Selection iteration
)     # Rotate main selection forward
(     # Rotate main selection backward
Alt+) # Rotate selections forward
Alt+( # Rotate selections backward
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
Alt+d # Delete to end of line
c     # Change selection (delete and insert)
Alt+c # Change to end of line

# Copy/Paste
y     # Yank (copy) selection
p     # Paste after selection
P     # Paste before selection
Alt+p # Paste all selections
R     # Replace selection with yanked text

# Case manipulation
~     # Switch case
`     # Convert to lowercase
Alt+` # Convert to uppercase

# Indentation
>     # Indent
<     # Unindent
Alt+> # Indent including empty lines
Alt+< # Unindent including empty lines
```

### Search and Replace

```bash
# Search
/     # Search forward
?     # Search backward
n     # Next search result
N     # Previous search result (Alt+n)
*     # Search word under cursor

# Replace
r<char> # Replace character
s     # Select matches for replacement
c     # Change selection
|     # Pipe through sed for replacement

# Global replace example
%     # Select all
s pattern # Select all pattern matches
c replacement<Esc> # Replace all
```

## File and Buffer Management

### Buffer Operations

```bash
# Buffer navigation
g a   # Go to alternate buffer
g f   # Go to file under cursor
g F   # Go to file under cursor (new buffer)

# Buffer commands (in command mode)
:buffer <name>    # Switch to buffer
:buffer-next      # Next buffer
:buffer-previous  # Previous buffer
:delete-buffer    # Close current buffer
:write           # Save buffer
:write-all       # Save all buffers
:quit            # Quit
:quit!           # Quit without saving
:write-quit      # Save and quit
```

### File Operations

```bash
# File commands
:edit <file>     # Open file
:new             # New buffer
:write <file>    # Save as file
:cd <dir>        # Change directory
:pwd             # Show current directory
```

### Window Management

```bash
# Window splitting (requires tmux or similar)
# Kakoune doesn't have built-in splits
# Use tmux or terminal multiplexer

# Multiple clients
kak -s main file.txt    # Start session
kak -c main            # Connect new client
```

## Configuration

### Configuration File

Kakoune configuration is stored in `~/.config/kak/kakrc`:

```bash
# ~/.config/kak/kakrc

# Basic settings
set-option global tabstop 4
set-option global indentwidth 4
set-option global scrolloff 5
set-option global ui_options ncurses_status_on_top=true
set-option global ui_options ncurses_assistant=cat

# Enable line numbers
add-highlighter global/ number-lines -relative -hlcursor

# Enable matching bracket highlighting
add-highlighter global/ show-matching

# Enable whitespace highlighting
add-highlighter global/ show-whitespaces -tab "→" -tabpad "·" -lf "¬" -spc "·"

# Color scheme
colorscheme default

# Key mappings
map global normal <c-p> ': fzf-mode<ret>'
map global normal '#' ': comment-line<ret>'
map global normal '<a-#>' ': comment-block<ret>'

# User mode for custom commands
declare-user-mode user
map global normal <space> ': enter-user-mode user<ret>'
map global user f ': fzf-mode<ret>'
map global user g ': grep '
map global user r ': replace-mode<ret>'

# Auto-pairs
hook global InsertChar \( %{ exec '<a-;>)<left>' }
hook global InsertChar \[ %{ exec '<a-;>]<left>' }
hook global InsertChar \{ %{ exec '<a-;>}<left>' }
hook global InsertChar \" %{ exec '<a-;>"<left>' }
hook global InsertChar \' %{ exec '<a-;>''<left>' }

# Auto-indent
hook global InsertChar \n %{ exec -draft \; K <a-&> }
hook global InsertChar \} %{ exec -draft <a-;> <a-S> 1<a-&> }

# Highlight TODO/FIXME
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb

# File type specific settings
hook global BufSetOption filetype=python %{
    set-option buffer indentwidth 4
    set-option buffer tabstop 4
}

hook global BufSetOption filetype=javascript %{
    set-option buffer indentwidth 2
    set-option buffer tabstop 2
}

hook global BufSetOption filetype=html %{
    set-option buffer indentwidth 2
    set-option buffer tabstop 2
}

# Clipboard integration
map global user y '<a-|>xclip -i -selection clipboard<ret>'
map global user p '!xclip -o -selection clipboard<ret>'

# Save and quit shortcuts
map global user w ': write<ret>'
map global user q ': quit<ret>'
map global user x ': write-quit<ret>'
```

### Plugin Management

Kakoune doesn't have a built-in plugin manager, but you can use external tools:

```bash
# Install plug.kak (plugin manager)
mkdir -p ~/.config/kak/plugins
git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak

# Add to kakrc
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

# Install plugins
plug "andreyorst/fzf.kak"
plug "andreyorst/smarttab.kak"
plug "ul/kak-lsp"
plug "alexherbo2/auto-pairs.kak"
plug "alexherbo2/surround.kak"
plug "delapouite/kakoune-buffers"
plug "occivink/kakoune-snippets"
```

### Popular Plugins

```bash
# Essential plugins configuration

# FZF integration
plug "andreyorst/fzf.kak" config %{
    map global normal <c-p> ': fzf-mode<ret>'
    map global normal <c-o> ': fzf-file<ret>'
}

# LSP support
plug "ul/kak-lsp" do %{
    cargo install --locked --force --path .
} config %{
    set global lsp_diagnostic_line_error_sign '║'
    set global lsp_diagnostic_line_warning_sign '┊'

    define-command ne -docstring 'go to next error/warning from lsp' %{
        lsp-find-error --include-warnings
    }
    define-command pe -docstring 'go to previous error/warning from lsp' %{
        lsp-find-error --previous --include-warnings
    }
    define-command ee -docstring 'go to current error/warning from lsp' %{
        lsp-find-error --include-warnings --previous
        lsp-find-error --include-warnings
    }

    map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"
    map global insert <tab> '<a-;>: try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <tab> }<ret>' -docstring 'Select next snippet placeholder'
    map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
    map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'

    hook global WinSetOption filetype=(c|cpp|cc|rust|javascript|typescript|python) %{
        lsp-enable-window
    }
}

# Surround text objects
plug "alexherbo2/surround.kak" config %{
    map global user s ': surround<ret>' -docstring 'surround'
    map global user S ': surround _ _ * *<ret>' -docstring 'surround with *'
}

# Auto-pairs
plug "alexherbo2/auto-pairs.kak" config %{
    enable-auto-pairs
}

# Snippets
plug "occivink/kakoune-snippets" config %{
    set-option global snippets_directories "%opt{plug_install_dir}/kakoune-snippets/snippets"
}

# Buffer management
plug "delapouite/kakoune-buffers" config %{
    map global user b ': enter-user-mode buffers<ret>' -docstring 'buffers'
    map global user B ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
}
```

## Real-World Usage Scenarios

### Scenario 1: Refactoring Variable Names

```bash
# Open file
kak script.py

# Select variable name
w     # Select word

# Select all occurrences
%     # Select all matches

# Change all occurrences
c     # Change selection
new_variable_name<Esc>

# Save file
:w
```

### Scenario 2: Multiple Line Editing

```bash
# Select multiple lines
x     # Select line
j     # Move down
x     # Extend to next line
j     # Move down
x     # Extend to next line

# Or select lines with pattern
%     # Select all
s^def # Select lines starting with "def"

# Add prefix to all selected lines
I     # Insert at beginning
# Type prefix
<Esc>
```

### Scenario 3: Complex Text Manipulation

```bash
# Select paragraph
<a-a>p # Select around paragraph

# Split into sentences
s\. # Split on periods

# Process each sentence
|capitalize_first_word.sh # Pipe through script

# Or use built-in commands
~     # Switch case of first character
```

### Scenario 4: Log File Analysis

```bash
# Open log file
kak /var/log/application.log

# Select all error lines
%     # Select all
s^.*ERROR.*$ # Select lines containing ERROR

# Copy to new buffer
y     # Yank
:new  # New buffer
p     # Paste

# Analyze timestamps
s\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} # Select timestamps
```

## Advanced Features

### Hooks and Automation

```bash
# Auto-save on focus lost
hook global FocusOut .* %{ write }

# Auto-format on save
hook global BufWritePre .*\.py %{ format }

# Highlight current word
hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        add-highlighter window/word regex "\b\Q%val{selection}\E\b" 0:+u
    } catch %{
        rmhl window/word
    } }
}

# Auto-reload files changed externally
hook global FocusIn .* %{ edit! }
```

### Custom Commands

```bash
# Define custom commands
define-command -docstring "duplicate line" duplicate-line %{
    exec 'x<a-s>y<a-o>p'
}

define-command -docstring "sort selections" sort-selections %{
    exec '|sort<ret>'
}

define-command -docstring "remove duplicates" remove-duplicates %{
    exec '|sort -u<ret>'
}

define-command -docstring "count words" count-words %{
    exec '<a-s>|wc -w<ret>'
}

# Map to keys
map global user d ': duplicate-line<ret>'
map global user s ': sort-selections<ret>'
map global user u ': remove-duplicates<ret>'
map global user c ': count-words<ret>'
```

### Text Objects

```bash
# Built-in text objects
<a-i>w # Inner word
<a-a>w # Around word
<a-i>s # Inner sentence
<a-a>s # Around sentence
<a-i>p # Inner paragraph
<a-a>p # Around paragraph
<a-i>( # Inner parentheses
<a-a>( # Around parentheses
<a-i>{ # Inner braces
<a-a>{ # Around braces
<a-i>[ # Inner brackets
<a-a>[ # Around brackets
<a-i>" # Inner quotes
<a-a>" # Around quotes

# Custom text objects
define-command -docstring "select function" select-function %{
    exec '<a-s>s^def\s+\w+.*?(?=^def|\z)<ret>'
}

map global object f ': select-function<ret>'
```

### Macros and Repetition

```bash
# Record macro
q<register> # Start recording to register
# ... perform actions ...
q           # Stop recording

# Play macro
@<register> # Execute macro from register
@@          # Repeat last macro

# Repeat last command
.           # Repeat last normal mode command
<a-.>       # Repeat last insert mode command
```

## Language-Specific Configurations

### Python Development

```bash
# Python-specific kakrc additions
hook global BufSetOption filetype=python %{
    set-option buffer indentwidth 4
    set-option buffer tabstop 4

    # Python-specific mappings
    map buffer user r ': python-run<ret>'
    map buffer user t ': python-test<ret>'
    map buffer user f ': python-format<ret>'

    # Auto-format with black
    hook buffer BufWritePre .* %{ exec '|black -<ret>' }

    # Highlight Python keywords
    add-highlighter buffer/python-keywords regex \b(def|class|import|from|if|elif|else|for|while|try|except|finally|with|as|return|yield|break|continue|pass|lambda|global|nonlocal)\b 0:keyword
}

define-command python-run %{
    exec '|python3<ret>'
}

define-command python-test %{
    exec '!python3 -m pytest<ret>'
}

define-command python-format %{
    exec '%|black -<ret>'
}
```

### Web Development

```bash
# HTML/CSS/JavaScript configuration
hook global BufSetOption filetype=(html|css|javascript) %{
    set-option buffer indentwidth 2
    set-option buffer tabstop 2

    # Auto-close tags for HTML
    hook buffer InsertChar > %{
        exec -draft '<a-;>h<a-k><[^/][^>]*<ret>a</<c-r>"><left>'
    }
}

# JavaScript-specific
hook global BufSetOption filetype=javascript %{
    map buffer user r ': javascript-run<ret>'
    map buffer user f ': javascript-format<ret>'

    # Format with prettier
    hook buffer BufWritePre .* %{ exec '%|prettier --stdin-filepath %val{buffile}<ret>' }
}

define-command javascript-run %{
    exec '|node<ret>'
}

define-command javascript-format %{
    exec '%|prettier --stdin-filepath %val{buffile}<ret>'
}
```

### Go Development

```bash
# Go-specific configuration
hook global BufSetOption filetype=go %{
    set-option buffer indentwidth 4
    set-option buffer tabstop 4

    map buffer user r ': go-run<ret>'
    map buffer user b ': go-build<ret>'
    map buffer user t ': go-test<ret>'
    map buffer user f ': go-format<ret>'

    # Auto-format with gofmt
    hook buffer BufWritePre .* %{ exec '%|gofmt<ret>' }
}

define-command go-run %{
    exec '!go run %val{buffile}<ret>'
}

define-command go-build %{
    exec '!go build<ret>'
}

define-command go-test %{
    exec '!go test<ret>'
}

define-command go-format %{
    exec '%|gofmt<ret>'
}
```

## Integration with External Tools

### Git Integration

```bash
# Git commands
define-command git-status %{
    exec '!git status<ret>'
}

define-command git-add %{
    exec '!git add %val{buffile}<ret>'
}

define-command git-commit %{
    exec '!git commit<ret>'
}

define-command git-diff %{
    exec '!git diff %val{buffile}<ret>'
}

# Map to user mode
map global user g ': enter-user-mode git<ret>' -docstring 'git'
declare-user-mode git
map global git s ': git-status<ret>' -docstring 'status'
map global git a ': git-add<ret>' -docstring 'add'
map global git c ': git-commit<ret>' -docstring 'commit'
map global git d ': git-diff<ret>' -docstring 'diff'
```

### Build System Integration

```bash
# Build system commands
define-command make %{
    exec '!make<ret>'
}

define-command make-clean %{
    exec '!make clean<ret>'
}

define-command make-install %{
    exec '!make install<ret>'
}

# Map to user mode
map global user m ': enter-user-mode make<ret>' -docstring 'make'
declare-user-mode make
map global make m ': make<ret>' -docstring 'make'
map global make c ': make-clean<ret>' -docstring 'clean'
map global make i ': make-install<ret>' -docstring 'install'
```

### Terminal Integration

```bash
# Terminal commands
define-command terminal %{
    exec '!$SHELL<ret>'
}

define-command terminal-here %{
    exec '!cd %sh{dirname "$kak_buffile"} && $SHELL<ret>'
}

map global user t ': terminal<ret>' -docstring 'terminal'
map global user T ': terminal-here<ret>' -docstring 'terminal here'
```

## Performance and Optimization

### Large File Handling

```bash
# Optimize for large files
hook global BufCreate .*large.* %{
    set-option buffer readonly true
    rmhl buffer/number-lines
    rmhl buffer/show-matching
}

# Disable expensive features for large files
hook global BufOpenFile .* %{
    eval %sh{
        if [ $(wc -l < "$kak_hook_param") -gt 10000 ]; then
            echo "
                rmhl buffer/number-lines
                rmhl buffer/show-matching
                rmhl buffer/show-whitespaces
            "
        fi
    }
}
```

### Memory Optimization

```bash
# Limit history size
set-option global history_size 100

# Disable undo for large operations
define-command no-undo %{
    set-option buffer history_size 0
}

map global user n ': no-undo<ret>' -docstring 'disable undo'
```

## Troubleshooting

### Common Issues

```bash
# Debug mode
kak -d

# Check configuration
:debug info

# Reset to defaults
kak -n  # No user config

# Check key mappings
:map

# Check options
:set-option
```

### Session Management

```bash
# List sessions
kak -l

# Kill session
kak -c session_name -e 'kill'

# Kill all sessions
for session in $(kak -l); do
    kak -c "$session" -e 'kill'
done
```

### Configuration Issues

```bash
# Test configuration
kak -f /dev/null  # Empty config

# Check for errors
kak -e 'echo %val{client_env_TERM}'

# Backup and reset config
mv ~/.config/kak ~/.config/kak.backup
```

Kakoune offers a unique and powerful approach to text editing through its selection-first philosophy and multiple selections. While it has a learning curve, its orthogonal design and composable commands make it highly effective for complex text manipulation tasks.
# Micro: A Modern Terminal Editor

Micro is a modern, intuitive terminal-based text editor that aims to be easy to use and easy to remember. It provides a familiar interface similar to GUI editors while running in the terminal, making it perfect for users transitioning from graphical editors.

## What is Micro?

Micro is designed with simplicity and usability in mind:
- **Intuitive keybindings**: Familiar Ctrl+S, Ctrl+C, Ctrl+V shortcuts
- **Mouse support**: Click to position cursor, select text, scroll
- **Syntax highlighting**: Built-in support for 100+ languages
- **Plugin system**: Extensible with Lua plugins
- **Multiple cursors**: Edit multiple locations simultaneously
- **Linux-optimized**: Excellent performance on Linux systems
- **No configuration required**: Works great out of the box

## Why Choose Micro?

- **Easy to learn**: Familiar keybindings from GUI editors
- **Modern features**: Multiple cursors, syntax highlighting, plugins
- **Lightweight**: Single binary with no dependencies, perfect for Linux servers
- **Customizable**: Extensive configuration options
- **Active development**: Regular updates and improvements
- **Terminal-based**: Works over SSH and in minimal Linux environments
- **Unicode support**: Full Unicode and emoji support
- **System administration**: Great for Linux configuration file editing

## Installation

### Package Managers

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install micro

# Fedora
sudo dnf install micro

# Arch Linux
sudo pacman -S micro

# SUSE/openSUSE
sudo zypper install micro

# Gentoo
sudo emerge app-editors/micro

# Void Linux
sudo xbps-install micro

# Snap (Universal Linux)
sudo snap install micro --classic

# Flatpak
flatpak install flathub io.github.micro-editor.micro
```

### Direct Download

```bash
# Download latest release
curl https://getmic.ro | bash

# Or manually download
wget https://github.com/zyedidia/micro/releases/download/v2.0.11/micro-2.0.11-linux64.tar.gz
tar -xzf micro-2.0.11-linux64.tar.gz
sudo mv micro-2.0.11/micro /usr/local/bin/

# Make executable
chmod +x /usr/local/bin/micro
```

### From Source

```bash
# Install Go if not already installed
# Then build micro
git clone https://github.com/zyedidia/micro
cd micro
make build
sudo mv micro /usr/local/bin/
```

## Basic Usage

### Starting Micro

```bash
# Open new file
micro

# Open existing file
micro filename.txt

# Open multiple files
micro file1.txt file2.txt

# Open directory (file browser)
micro .

# Open with specific settings
micro -colorscheme monokai filename.txt
micro -syntax python script.py
```

### Interface Overview

```
┌─ filename.txt ──────────────────────────────────────────────────────────────┐
│This is the content of your file.                                            │
│You can type directly here.                                                  │
│Mouse clicks work for positioning cursor.                                    │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
Ctrl+Q Quit  Ctrl+S Save  Ctrl+O Open  Ctrl+F Find  Ctrl+Z Undo  Ctrl+Y Redo
```

## Essential Keybindings

### File Operations

```bash
# File management
Ctrl+O          # Open file
Ctrl+S          # Save file
Ctrl+W          # Close current buffer
Ctrl+Q          # Quit micro
Ctrl+E          # Command mode
Ctrl+G          # Open help

# Buffer navigation
Ctrl+Tab        # Next buffer
Ctrl+Shift+Tab  # Previous buffer
Alt+,           # Previous buffer
Alt+.           # Next buffer
```

### Navigation

```bash
# Basic movement
Arrow keys      # Move cursor
Ctrl+Left/Right # Move by word
Ctrl+Up/Down    # Move by paragraph
Home/End        # Beginning/end of line
Ctrl+Home/End   # Beginning/end of file
Page Up/Down    # Page navigation

# Advanced navigation
Ctrl+G          # Go to line
Ctrl+F          # Find
Ctrl+N          # Find next
Ctrl+P          # Find previous
```

### Text Editing

```bash
# Basic editing
Ctrl+Z          # Undo
Ctrl+Y          # Redo
Ctrl+C          # Copy
Ctrl+X          # Cut
Ctrl+V          # Paste
Ctrl+A          # Select all
Ctrl+D          # Duplicate line
Ctrl+K          # Delete line

# Advanced editing
Ctrl+L          # Select line
Ctrl+Shift+Up   # Move line up
Ctrl+Shift+Down # Move line down
Alt+Shift+Left  # Select word left
Alt+Shift+Right # Select word right
```

### Multiple Cursors

```bash
# Multiple cursor operations
Ctrl+MouseClick # Add cursor at click position
Alt+N           # Create cursor at next word occurrence
Alt+P           # Create cursor at previous word occurrence
Alt+C           # Create cursor at all word occurrences
Alt+M           # Remove all cursors except primary
Escape          # Remove all extra cursors
```

### Search and Replace

```bash
# Search operations
Ctrl+F          # Find
Ctrl+N          # Find next
Ctrl+P          # Find previous
Ctrl+R          # Find and replace

# In find/replace dialog
Tab             # Switch between find and replace fields
Enter           # Execute search/replace
Escape          # Cancel dialog
```

## Configuration

### Settings File

Micro stores settings in `~/.config/micro/settings.json`:

```json
{
    "autoclose": true,
    "autoindent": true,
    "autosave": 0,
    "autosu": false,
    "backup": true,
    "backupdir": "",
    "basename": false,
    "colorcolumn": 0,
    "colorscheme": "default",
    "cursorline": true,
    "diffgutter": false,
    "divchars": "|-",
    "divreverse": true,
    "encoding": "utf-8",
    "eofnewline": true,
    "fastdirty": false,
    "fileformat": "unix",
    "filetype": "unknown",
    "hlsearch": false,
    "ignorecase": false,
    "indentchar": " ",
    "infobar": true,
    "keepautoindent": false,
    "keymenu": false,
    "matchbrace": true,
    "matchbraceleft": false,
    "mouse": true,
    "parsecursor": false,
    "paste": false,
    "pluginchannels": [
        "https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json"
    ],
    "pluginrepos": [],
    "readonly": false,
    "rmtrailingws": false,
    "ruler": true,
    "savecursor": false,
    "savehistory": true,
    "saveundo": false,
    "scrollbar": false,
    "scrollmargin": 3,
    "scrollspeed": 2,
    "smartpaste": true,
    "softwrap": false,
    "splitbottom": true,
    "splitright": true,
    "statusformatl": "$(filename) $(modified)($(line),$(col)) $(status.paste)| ft:$(opt:filetype) | $(opt:fileformat) | $(opt:encoding)",
    "statusformatr": "$(bind:ToggleKeyMenu): bindings, $(bind:ToggleHelp): help",
    "statusline": true,
    "sucmd": "sudo",
    "syntax": true,
    "tabmovement": false,
    "tabsize": 4,
    "tabstospaces": false,
    "termtitle": false,
    "useprimary": true,
    "wordwrap": false,
    "xterm": false
}
```

### Common Configuration Changes

```bash
# Set tab size to 2
micro -option tabsize 2

# Enable line numbers
micro -option ruler true

# Set color scheme
micro -option colorscheme monokai

# Enable soft wrapping
micro -option softwrap true

# Auto-save every 10 seconds
micro -option autosave 10

# Remove trailing whitespace on save
micro -option rmtrailingws true

# Make changes permanent
# These settings are automatically saved to settings.json
```

### Keybinding Customization

Create `~/.config/micro/bindings.json`:

```json
{
    "Alt+/": "lua:comment.comment",
    "Ctrl+/": "lua:comment.comment",
    "Ctrl+Shift+D": "DuplicateLine",
    "Ctrl+Shift+K": "DeleteLine",
    "Ctrl+Shift+Up": "MoveLinesUp",
    "Ctrl+Shift+Down": "MoveLinesDown",
    "Ctrl+J": "JumpLine",
    "Ctrl+B": "ToggleBookmark",
    "F3": "FindNext",
    "Shift+F3": "FindPrevious",
    "F4": "Quit",
    "Ctrl+T": "NewTab",
    "Ctrl+Shift+T": "ReopenLastClosedTab"
}
```

### Color Schemes

Micro comes with many built-in color schemes:

```bash
# List available color schemes
micro -option colorscheme help

# Popular color schemes
micro -option colorscheme monokai
micro -option colorscheme solarized
micro -option colorscheme dracula
micro -option colorscheme gruvbox
micro -option colorscheme atom-dark
micro -option colorscheme github
micro -option colorscheme zenburn
```

### Custom Color Scheme

Create `~/.config/micro/colorschemes/mytheme.micro`:

```
color-link default "#d4d4d4,#1e1e1e"
color-link comment "#6a9955"
color-link identifier "#9cdcfe"
color-link constant "#4fc1ff"
color-link statement "#569cd6"
color-link symbol "#d4d4d4"
color-link preproc "#c586c0"
color-link type "#4ec9b0"
color-link special "#dcdcaa"
color-link underlined "#d4d4d4"
color-link error "#f44747"
color-link todo "#ffcc00"
color-link hlsearch "#264f78"
color-link statusline "#d4d4d4,#007acc"
color-link tabbar "#d4d4d4,#2d2d30"
color-link indent-char "#3c3c3c"
color-link line-number "#858585"
color-link current-line-number "#c6c6c6"
color-link diff-added "#28a745"
color-link diff-modified "#ffd33d"
color-link diff-deleted "#d73a49"
color-link gutter-error "#f44747"
color-link gutter-warning "#ff8c00"
color-link cursor-line "#2a2d2e"
color-link color-column "#3c3c3c"
```

## Plugin System

### Plugin Management

```bash
# List installed plugins
micro -plugin list

# Install plugin
micro -plugin install pluginname

# Remove plugin
micro -plugin remove pluginname

# Update plugins
micro -plugin update

# Search for plugins
micro -plugin search keyword

# Plugin information
micro -plugin info pluginname
```

### Popular Plugins

```bash
# Essential plugins
micro -plugin install filemanager    # File browser
micro -plugin install linter         # Code linting
micro -plugin install comment        # Toggle comments
micro -plugin install jump           # Quick navigation
micro -plugin install manipulator    # Text manipulation
micro -plugin install quoter         # Quote manipulation
micro -plugin install snippets       # Code snippets
micro -plugin install autoclose      # Auto-close brackets
micro -plugin install bookmark       # Bookmarks
micro -plugin install diff           # Diff viewer

# Language-specific plugins
micro -plugin install go             # Go language support
micro -plugin install python         # Python support
micro -plugin install html           # HTML support
micro -plugin install css            # CSS support
micro -plugin install javascript     # JavaScript support
```

### Plugin Configuration

Plugins can be configured in `~/.config/micro/settings.json`:

```json
{
    "linter": true,
    "linter.ignoredMessages": [],
    "comment.leader": "# ",
    "filemanager.showdotfiles": true,
    "filemanager.showignored": false,
    "snippets.enabled": true,
    "autoclose.enabled": true
}
```

## Real-World Usage Scenarios

### Scenario 1: Linux System Configuration

```bash
# Edit SSH daemon configuration
sudo micro /etc/ssh/sshd_config

# Navigate to specific setting
Ctrl+F
# Type "PasswordAuthentication"
Enter

# Change the value
# Use mouse to click and position cursor
# Change "yes" to "no"

# Save and restart SSH service
Ctrl+S
Ctrl+Q
sudo systemctl restart sshd

# Alternative: Edit systemd service file
sudo micro /etc/systemd/system/myapp.service

# Add service configuration
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=myapp
ExecStart=/usr/local/bin/myapp
Restart=always

[Install]
WantedBy=multi-user.target

# Save and enable service
Ctrl+S
Ctrl+Q
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp
```

### Scenario 2: Python Development

```bash
# Open Python file
micro script.py

# Enable Python-specific settings
# (Automatically detected by file extension)

# Multiple cursor editing for variable renaming
# Double-click on variable name
Alt+C  # Select all occurrences
# Type new variable name

# Comment/uncomment code blocks
# Select lines with mouse or Shift+arrows
Ctrl+/  # Toggle comments

# Duplicate lines for testing
Ctrl+D  # Duplicate current line

# Save file
Ctrl+S
```

### Scenario 3: Log File Analysis

```bash
# Open log file
micro /var/log/application.log

# Search for errors
Ctrl+F
# Type "ERROR"
Enter

# Navigate through errors
Ctrl+N  # Next occurrence
Ctrl+P  # Previous occurrence

# Select error lines for copying
# Click and drag to select
Ctrl+C  # Copy

# Open new buffer for analysis
Ctrl+E
# Type "tab new"
Enter

# Paste errors
Ctrl+V

# Save analysis
Ctrl+S
# Type filename
Enter
```

### Scenario 4: Web Development

```bash
# Open HTML file
micro index.html

# Use multiple cursors for tag editing
# Select opening tag
Alt+C  # Select all similar tags
# Edit all tags simultaneously

# Navigate between files
Ctrl+O
# Type filename or use arrow keys
Enter

# Split view for CSS editing
Ctrl+E
# Type "hsplit styles.css"
Enter

# Switch between splits
Ctrl+W  # Cycle through splits

# Format code (if formatter plugin installed)
Ctrl+E
# Type "format"
Enter
```

## Advanced Features

### Command Mode

Access command mode with `Ctrl+E`:

```bash
# File operations
open filename.txt       # Open file
save                   # Save current file
save filename.txt      # Save as
quit                   # Quit current buffer
exit                   # Exit micro

# Buffer operations
tab new                # New tab
tab close              # Close current tab
tab switch N           # Switch to tab N
buffer N               # Switch to buffer N

# View operations
hsplit filename.txt    # Horizontal split
vsplit filename.txt    # Vertical split
unsplit               # Close current split

# Search and replace
find pattern          # Find pattern
replace old new       # Replace old with new
replaceall old new    # Replace all occurrences

# Settings
set option value      # Set option
show option          # Show option value
reset option         # Reset option to default

# Plugin operations
plugin install name   # Install plugin
plugin remove name    # Remove plugin
plugin list          # List plugins
plugin update        # Update plugins
```

### Macros

```bash
# Record macro
Ctrl+U  # Start recording
# Perform actions
Ctrl+U  # Stop recording

# Play macro
Ctrl+J  # Execute recorded macro
```

### Bookmarks

```bash
# Set bookmark
Ctrl+B  # Toggle bookmark on current line

# Navigate bookmarks
Alt+Up    # Previous bookmark
Alt+Down  # Next bookmark

# List bookmarks
Ctrl+E
# Type "bookmark list"
Enter
```

### Splits and Tabs

```bash
# Split operations
Ctrl+E hsplit filename  # Horizontal split
Ctrl+E vsplit filename  # Vertical split
Ctrl+W                  # Cycle through splits
Ctrl+Q                  # Close current split

# Tab operations
Ctrl+T                  # New tab
Ctrl+W                  # Close tab
Ctrl+Tab                # Next tab
Ctrl+Shift+Tab          # Previous tab
```

## Integration with Development Tools

### Git Integration

```bash
# View git diff
micro -option diffgutter true filename.txt

# Git commands through shell
Ctrl+E
# Type "term git status"
Enter

# Or use external git tools
# Configure git to use micro as editor
git config --global core.editor micro
```

### Language Server Integration

While micro doesn't have built-in LSP support, you can use external tools:

```bash
# Install language servers
npm install -g typescript-language-server
pip install python-lsp-server

# Use with external LSP client
# Or use plugins that provide LSP integration
micro -plugin install lsp
```

### Build System Integration

```bash
# Run build commands
Ctrl+E
# Type "term make"
Enter

# Or create custom commands
# In settings.json, add:
{
    "build": "make",
    "test": "npm test",
    "run": "python main.py"
}

# Then use:
Ctrl+E
# Type "build" or "test" or "run"
Enter
```

## Customization Examples

### Custom Status Line

```json
{
    "statusformatl": "$(filename) [$(opt:filetype)] $(modified) | Line $(line)/$(lines) Col $(col)",
    "statusformatr": "$(opt:encoding) | $(opt:fileformat) | Micro v$(version)"
}
```

### Custom Key Bindings for Productivity

```json
{
    "Ctrl+Shift+P": "lua:comment.comment",
    "Ctrl+D": "DuplicateLine",
    "Ctrl+Shift+K": "DeleteLine",
    "Ctrl+L": "SelectLine",
    "Ctrl+Shift+L": "SelectToEndOfLine",
    "F2": "Rename",
    "F5": "Reload",
    "F12": "ToggleHelp",
    "Ctrl+`": "ToggleTerminal"
}
```

### File Type Specific Settings

Create `~/.config/micro/settings.json`:

```json
{
    "*.py": {
        "tabsize": 4,
        "tabstospaces": true,
        "rmtrailingws": true
    },
    "*.js": {
        "tabsize": 2,
        "tabstospaces": true
    },
    "*.go": {
        "tabsize": 4,
        "tabstospaces": false
    },
    "*.md": {
        "softwrap": true,
        "wordwrap": true
    }
}
```

## Performance and Optimization

### Large File Handling

```bash
# Open large files efficiently
micro -option syntax false largefile.txt

# Disable features for better performance
micro -option hlsearch false
micro -option matchbrace false
micro -option autoindent false
```

### Memory Usage

```bash
# Check memory usage
ps aux | grep micro

# Optimize for low memory
micro -option backup false
micro -option savehistory false
micro -option saveundo false
```

## Troubleshooting

### Common Issues

```bash
# Terminal compatibility issues
export TERM=xterm-256color
micro filename.txt

# Mouse not working
micro -option mouse true filename.txt

# Colors not displaying correctly
micro -option colorscheme default filename.txt

# Plugin issues
micro -plugin remove problematic-plugin
micro -plugin update
```

### Debug Mode

```bash
# Enable debug logging
micro -debug filename.txt

# Check log file
tail -f ~/.config/micro/log.txt
```

### Reset Configuration

```bash
# Backup current config
mv ~/.config/micro ~/.config/micro.backup

# Start fresh (micro will create new config)
micro
```

## Migration from Other Editors

### From Nano

Micro provides similar simplicity with more features:
- Familiar Ctrl+S, Ctrl+O shortcuts
- Mouse support
- Better syntax highlighting
- Plugin system

### From GUI Editors

Micro bridges the gap between terminal and GUI editors:
- Familiar keybindings (Ctrl+C, Ctrl+V, etc.)
- Mouse support
- Multiple cursors
- Modern interface

### From Vim

For Vim users wanting something simpler:
- No modal editing
- Intuitive keybindings
- Built-in help system
- Less configuration required

Micro excels as a user-friendly terminal editor that doesn't sacrifice power for simplicity. Its familiar interface, modern features, and extensibility make it an excellent choice for developers who want a capable editor without a steep learning curve.
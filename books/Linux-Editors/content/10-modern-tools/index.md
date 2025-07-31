# Modern Linux Development Tools

This chapter covers modern command-line tools and utilities specifically designed to enhance the Linux development experience. These tools are optimized for Linux systems and integrate seamlessly with Linux workflows, providing powerful functionality that complements traditional editors.

## Why Modern Tools on Linux?

- **Native Performance**: Tools written in Rust and Go provide excellent performance on Linux
- **System Integration**: Deep integration with Linux package managers and system services
- **Development Focus**: Designed with Linux development workflows in mind
- **Resource Efficiency**: Optimized for Linux server environments and containers
- **Open Source**: Most tools are open source and align with Linux philosophy

## Terminal-Based Development Tools

### Zellij: Modern Terminal Multiplexer

Zellij is a modern alternative to tmux with better defaults and user experience.

#### Installation

```bash
# Cargo
cargo install zellij

# Arch Linux
sudo pacman -S zellij

# Ubuntu/Debian (from GitHub releases)
wget https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xzf zellij-x86_64-unknown-linux-musl.tar.gz
sudo mv zellij /usr/local/bin/

# SUSE/openSUSE
sudo zypper install zellij

# Gentoo
sudo emerge app-misc/zellij
```

#### Basic Usage

```bash
# Start zellij
zellij

# Key bindings (default)
Ctrl+p n    # New pane
Ctrl+p x    # Close pane
Ctrl+p h/j/k/l  # Navigate panes
Ctrl+p r    # Resize mode
Ctrl+p t    # New tab
Ctrl+p q    # Quit

# Sessions
zellij -s session_name    # Start named session
zellij ls                 # List sessions
zellij a session_name     # Attach to session
```

#### Configuration

```kdl
// ~/.config/zellij/config.kdl
keybinds {
    normal {
        bind "Alt h" { MoveFocus "Left"; }
        bind "Alt l" { MoveFocus "Right"; }
        bind "Alt j" { MoveFocus "Down"; }
        bind "Alt k" { MoveFocus "Up"; }
        bind "Alt n" { NewPane; }
        bind "Alt x" { CloseFocus; }
        bind "Alt t" { NewTab; }
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
    }
}

theme "catppuccin-mocha"
default_shell "zsh"
pane_frames false
```

### Starship: Cross-Shell Prompt

Starship provides a fast, customizable prompt for any shell.

#### Installation

```bash
# Install script
curl -sS https://starship.rs/install.sh | sh

# Cargo
cargo install starship --locked

# Package managers
# Arch Linux
sudo pacman -S starship

# Ubuntu/Debian
sudo apt install starship

# SUSE/openSUSE
sudo zypper install starship

# Gentoo
sudo emerge app-shells/starship
```

#### Configuration

```bash
# Add to shell config (~/.bashrc, ~/.zshrc, etc.)
eval "$(starship init bash)"  # For bash
eval "$(starship init zsh)"   # For zsh
```

```toml
# ~/.config/starship.toml
format = """
[](#9A348E)\
$os\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
"""

[os]
disabled = false
style = "bg:#9A348E"

[username]
show_always = true
style_user = "bg:#9A348E"
style_root = "bg:#9A348E"
format = '[$user ]($style)'
disabled = false

[directory]
style = "bg:#DA627D"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = ""
style = "bg:#FCA17D"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#FCA17D"
format = '[$all_status$ahead_behind ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[rust]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[golang]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[python]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#33658A"
format = '[ ♥ $time ]($style)'
```

### Zoxide: Smart Directory Navigation

Zoxide is a smarter cd command that learns your habits.

#### Installation

```bash
# Install script
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Cargo
cargo install zoxide --locked

# Package managers
sudo pacman -S zoxide  # Arch
sudo zypper install zoxide  # SUSE/openSUSE
sudo emerge app-shells/zoxide  # Gentoo
```

#### Setup

```bash
# Add to shell config
eval "$(zoxide init bash)"  # For bash
eval "$(zoxide init zsh)"   # For zsh
```

#### Usage

```bash
# Navigate to directories
z foo       # cd to highest ranked directory matching foo
z foo bar   # cd to highest ranked directory matching foo and bar
zi foo      # cd with interactive selection

# Add directories
zoxide add /path/to/directory

# Query database
zoxide query foo
zoxide query --list
```

### Eza: Modern ls Replacement

Eza is a modern replacement for ls with better defaults and features.

#### Installation

```bash
# Cargo
cargo install eza

# Arch Linux
sudo pacman -S eza

# Ubuntu/Debian
sudo apt install eza

# SUSE/openSUSE
sudo zypper install eza

# Gentoo
sudo emerge sys-apps/eza
```

#### Usage

```bash
# Basic usage
eza                    # List files
eza -l                 # Long format
eza -la                # Long format with hidden files
eza -T                 # Tree view
eza -T -L 2            # Tree view with depth limit
eza --git              # Show git status
eza --icons            # Show file type icons

# Useful aliases
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza -T'
alias lg='eza -l --git'
```

### Bat: Better Cat

Bat is a cat clone with syntax highlighting and Git integration.

#### Installation

```bash
# Package managers
sudo apt install bat        # Ubuntu/Debian
sudo pacman -S bat          # Arch Linux
sudo zypper install bat     # SUSE/openSUSE
sudo emerge sys-apps/bat    # Gentoo
cargo install bat           # Cargo
```

#### Usage

```bash
# Basic usage
bat file.txt               # View file with syntax highlighting
bat -n file.txt            # Show line numbers
bat -A file.txt            # Show all characters
bat --theme=GitHub file.txt # Use specific theme

# Useful aliases
alias cat='bat'
alias less='bat'

# Integration with other tools
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

### Ripgrep: Fast Text Search

Ripgrep (rg) is a fast grep alternative with better defaults.

#### Installation

```bash
# Package managers
sudo apt install ripgrep    # Ubuntu/Debian
sudo pacman -S ripgrep      # Arch Linux
sudo zypper install ripgrep # SUSE/openSUSE
sudo emerge sys-apps/ripgrep # Gentoo
cargo install ripgrep       # Cargo
```

#### Usage

```bash
# Basic search
rg "pattern"               # Search in current directory
rg "pattern" /path         # Search in specific path
rg -i "pattern"            # Case insensitive
rg -w "word"               # Whole word search
rg -v "pattern"            # Invert match

# File type filtering
rg -t py "pattern"         # Search only Python files
rg -T py "pattern"         # Exclude Python files
rg --type-list             # List available file types

# Advanced options
rg -n "pattern"            # Show line numbers
rg -C 3 "pattern"          # Show 3 lines of context
rg -A 3 -B 3 "pattern"     # Show 3 lines after and before
rg --hidden "pattern"      # Search hidden files
rg --no-ignore "pattern"   # Don't respect .gitignore

# Regular expressions
rg "\d{3}-\d{2}-\d{4}"     # Phone number pattern
rg "^function.*\{$"        # Function definitions
```

### Fd: Better Find

Fd is a simple, fast alternative to find with better defaults.

#### Installation

```bash
# Package managers
sudo apt install fd-find   # Ubuntu/Debian (command is fdfind)
sudo pacman -S fd          # Arch Linux
sudo zypper install fd     # SUSE/openSUSE
sudo emerge sys-apps/fd    # Gentoo
cargo install fd-find      # Cargo
```

#### Usage

```bash
# Basic usage
fd pattern                 # Find files/directories matching pattern
fd -t f pattern            # Find only files
fd -t d pattern            # Find only directories
fd -e py                   # Find Python files
fd -E node_modules pattern # Exclude node_modules

# Advanced options
fd -H pattern              # Include hidden files
fd -I pattern              # Don't respect .gitignore
fd -x command              # Execute command on results
fd pattern -x ls -la       # Execute ls -la on each result

# Useful aliases
alias find='fd'
```

### Delta: Better Git Diff

Delta provides syntax highlighting and better formatting for git diffs.

#### Installation

```bash
# Package managers
sudo apt install git-delta # Ubuntu/Debian
sudo pacman -S git-delta   # Arch Linux
sudo zypper install git-delta # SUSE/openSUSE
sudo emerge dev-util/git-delta # Gentoo
cargo install git-delta    # Cargo
```

#### Configuration

```bash
# Add to ~/.gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    light = false
    side-by-side = true
    line-numbers = true
    syntax-theme = Dracula

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

## File Management Tools

### Broot: Interactive Directory Navigation

Broot provides an interactive way to navigate and manipulate directory trees.

#### Installation

```bash
# Cargo
cargo install broot

# Package managers
sudo pacman -S broot       # Arch Linux
sudo zypper install broot  # SUSE/openSUSE
sudo emerge app-misc/broot # Gentoo

# Install shell integration
broot --install
```

#### Usage

```bash
# Start broot
br                         # Navigate current directory
br /path/to/directory      # Navigate specific directory

# Key bindings
Ctrl+h                     # Toggle hidden files
Ctrl+f                     # Search files
Ctrl+d                     # Delete file/directory
Ctrl+c                     # Copy path
Enter                      # Open file/enter directory
Alt+Enter                  # Open in external editor
```

### Nnn: Terminal File Manager

Nnn is a fast, feature-rich terminal file manager.

#### Installation

```bash
# Package managers
sudo apt install nnn       # Ubuntu/Debian
sudo pacman -S nnn         # Arch Linux
sudo zypper install nnn    # SUSE/openSUSE
sudo emerge app-misc/nnn   # Gentoo

# From source
git clone https://github.com/jarun/nnn.git
cd nnn
make
sudo make install
```

#### Configuration

```bash
# Environment variables
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_COLORS='2136'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'

# Aliases
alias n='nnn -de'
alias N='sudo nnn -dH'
```

#### Usage

```bash
# Basic navigation
j/k or ↑/↓                # Navigate files
h/l or ←/→                # Navigate directories
Enter                     # Open file/enter directory
q                         # Quit
?                         # Help

# File operations
d                         # Delete
r                         # Rename
c                         # Copy
v                         # Move
s                         # Select files
a                         # Select all
A                         # Invert selection

# Advanced features
;                         # Plugin menu
!                         # Shell
e                         # Edit in $EDITOR
p                         # Show file info
```

## Development Environment Tools

### Direnv: Environment Management

Direnv automatically loads and unloads environment variables based on directory.

#### Installation

```bash
# Package managers
sudo apt install direnv    # Ubuntu/Debian
sudo pacman -S direnv      # Arch Linux
sudo zypper install direnv # SUSE/openSUSE
sudo emerge dev-util/direnv # Gentoo

# Add to shell config
eval "$(direnv hook bash)" # For bash
eval "$(direnv hook zsh)"  # For zsh
```

#### Usage

```bash
# Create .envrc file in project directory
echo 'export DATABASE_URL="postgres://localhost/mydb"' > .envrc
echo 'export DEBUG=true' >> .envrc

# Allow the .envrc file
direnv allow

# The environment variables are now loaded when you cd into the directory
# and unloaded when you leave
```

#### Advanced .envrc Examples

```bash
# Python virtual environment
layout python3
pip install -r requirements.txt

# Node.js version management
use node 18

# Go module
export GOPATH=$PWD/.go
export PATH=$GOPATH/bin:$PATH

# Docker development
export COMPOSE_FILE=docker-compose.dev.yml
export DOCKER_BUILDKIT=1

# Load from .env file
dotenv

# Path manipulation
PATH_add bin
PATH_add scripts
```

### Mise: Runtime Version Manager

Mise (formerly rtx) manages multiple runtime versions for different languages.

#### Installation

```bash
# Install script
curl https://mise.run | sh

# Cargo
cargo install mise

# Package managers
sudo pacman -S mise        # Arch Linux
sudo zypper install mise   # SUSE/openSUSE
# For Gentoo, install via cargo or from source
```

#### Setup

```bash
# Add to shell config
echo 'eval "$(mise activate bash)"' >> ~/.bashrc  # For bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc    # For zsh
```

#### Usage

```bash
# Install runtimes
mise install node@18       # Install Node.js 18
mise install python@3.11   # Install Python 3.11
mise install go@1.21       # Install Go 1.21

# Set global versions
mise global node@18
mise global python@3.11

# Set local versions (creates .mise.toml)
mise local node@16
mise local python@3.9

# List available versions
mise list-remote node
mise list-remote python

# List installed versions
mise list
```

#### Configuration

```toml
# .mise.toml
[tools]
node = "18"
python = "3.11"
go = "1.21"

[env]
NODE_ENV = "development"
DEBUG = "true"

[tasks.dev]
run = "npm run dev"
description = "Start development server"

[tasks.test]
run = "npm test"
description = "Run tests"
```

### Just: Command Runner

Just is a command runner similar to make but with better syntax.

#### Installation

```bash
# Cargo
cargo install just

# Package managers
sudo pacman -S just        # Arch Linux
sudo zypper install just   # SUSE/openSUSE
sudo emerge sys-devel/just # Gentoo

# Install script
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin
```

#### Usage

Create a `justfile`:

```just
# Default recipe
default:
    @just --list

# Development server
dev:
    npm run dev

# Run tests
test:
    npm test

# Build project
build:
    npm run build

# Deploy to production
deploy: build
    rsync -av dist/ user@server:/var/www/

# Clean build artifacts
clean:
    rm -rf dist/
    rm -rf node_modules/

# Install dependencies
install:
    npm install

# Format code
fmt:
    prettier --write .
    eslint --fix .

# Docker commands
docker-build:
    docker build -t myapp .

docker-run:
    docker run -p 3000:3000 myapp

# Database commands
db-migrate:
    npx prisma migrate dev

db-seed:
    npx prisma db seed

# Variables
port := "3000"
env := "development"

# Recipe with parameters
serve port=port:
    NODE_ENV={{env}} npm start -- --port {{port}}

# Conditional recipes
backup:
    #!/usr/bin/env bash
    if [ -f "database.db" ]; then
        cp database.db "database.db.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Database backed up"
    else
        echo "No database file found"
    fi
```

```bash
# Run recipes
just                       # Run default recipe
just dev                   # Run dev recipe
just serve 8080            # Run serve with custom port
just --list                # List all recipes
```

## Text Processing Tools

### Jq: JSON Processor

Jq is a lightweight command-line JSON processor.

#### Installation

```bash
# Package managers
sudo apt install jq       # Ubuntu/Debian
sudo pacman -S jq         # Arch Linux
sudo zypper install jq    # SUSE/openSUSE
sudo emerge app-misc/jq   # Gentoo
```

#### Usage

```bash
# Basic usage
echo '{"name": "John", "age": 30}' | jq '.'
echo '{"name": "John", "age": 30}' | jq '.name'
echo '[{"name": "John"}, {"name": "Jane"}]' | jq '.[0].name'

# Filter arrays
echo '[1,2,3,4,5]' | jq '.[] | select(. > 3)'

# Transform data
echo '{"users": [{"name": "John", "age": 30}, {"name": "Jane", "age": 25}]}' | \
  jq '.users | map({name, adult: (.age >= 18)})'

# Real-world examples
curl -s https://api.github.com/users/octocat | jq '.name, .public_repos'
docker inspect container_name | jq '.[0].NetworkSettings.IPAddress'
kubectl get pods -o json | jq '.items[].metadata.name'
```

### Yq: YAML Processor

Yq is like jq but for YAML files.

#### Installation

```bash
# Go version (recommended)
go install github.com/mikefarah/yq/v4@latest

# Package managers
sudo apt install yq       # Ubuntu/Debian
sudo zypper install yq    # SUSE/openSUSE
sudo emerge app-misc/yq   # Gentoo
```

#### Usage

```bash
# Basic usage
yq '.name' config.yaml
yq '.database.host' config.yaml
yq '.services[0].name' docker-compose.yml

# Modify YAML
yq '.database.port = 5432' config.yaml
yq '.services[0].image = "nginx:latest"' docker-compose.yml

# Multiple files
yq eval-all '. as $item ireduce ({}; . * $item)' file1.yaml file2.yaml
```

### Sd: Sed Alternative

Sd is a more intuitive alternative to sed for find and replace operations.

#### Installation

```bash
# Cargo
cargo install sd

# Package managers
sudo pacman -S sd         # Arch Linux
sudo zypper install sd    # SUSE/openSUSE
sudo emerge sys-apps/sd   # Gentoo
```

#### Usage

```bash
# Basic find and replace
sd 'old_text' 'new_text' file.txt
sd '\d{4}-\d{2}-\d{2}' 'DATE' file.txt

# In-place editing
sd -i 'old_text' 'new_text' file.txt

# Preview changes
sd 'old_text' 'new_text' file.txt --preview

# Multiple files
sd 'old_text' 'new_text' *.txt
```

## Monitoring and System Tools

### Htop: Process Viewer

Htop is an interactive process viewer and system monitor.

#### Installation

```bash
# Package managers
sudo apt install htop     # Ubuntu/Debian
sudo pacman -S htop       # Arch Linux
sudo zypper install htop  # SUSE/openSUSE
sudo emerge sys-process/htop # Gentoo
```

#### Usage

```bash
# Start htop
htop

# Key bindings
F1                        # Help
F2                        # Setup
F3                        # Search
F4                        # Filter
F5                        # Tree view
F6                        # Sort by
F9                        # Kill process
F10                       # Quit
```

### Bottom: System Monitor

Bottom (btm) is a cross-platform system monitor written in Rust.

#### Installation

```bash
# Cargo
cargo install bottom

# Package managers
sudo pacman -S bottom     # Arch Linux
sudo zypper install bottom # SUSE/openSUSE
sudo emerge sys-process/bottom # Gentoo

# Debian/Ubuntu
curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
sudo dpkg -i bottom_0.9.6_amd64.deb
```

#### Usage

```bash
# Start bottom
btm

# Key bindings
?                         # Help
q                         # Quit
/                         # Search
Tab                       # Next widget
Shift+Tab                 # Previous widget
+/-                       # Zoom in/out
```

### Procs: Process Information

Procs is a modern replacement for ps with better output formatting.

#### Installation

```bash
# Cargo
cargo install procs

# Package managers
sudo pacman -S procs      # Arch Linux
sudo zypper install procs # SUSE/openSUSE
sudo emerge sys-process/procs # Gentoo
```

#### Usage

```bash
# Basic usage
procs                     # List all processes
procs firefox             # Find processes matching "firefox"
procs --tree              # Tree view
procs --watch             # Watch mode
procs --sortd cpu         # Sort by CPU usage (descending)
```

## Linux-Specific Integration

### Systemd Integration

Many modern tools can be integrated with systemd for better Linux system management:

```bash
# Create user service for auto-updating tools
mkdir -p ~/.config/systemd/user

# Auto-update mise tools
cat > ~/.config/systemd/user/mise-update.service << 'EOF'
[Unit]
Description=Update mise tools
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mise upgrade
User=%i
EOF

cat > ~/.config/systemd/user/mise-update.timer << 'EOF'
[Unit]
Description=Update mise tools daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable the timer
systemctl --user enable mise-update.timer
systemctl --user start mise-update.timer
```

### Linux Distribution Package Management

```bash
# Create a script to install modern tools across different distros
#!/bin/bash
# install-modern-tools.sh

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

install_tools() {
    local distro=$(detect_distro)

    case $distro in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y ripgrep fd-find bat eza zoxide starship direnv
            ;;
        arch|manjaro)
            sudo pacman -S ripgrep fd bat eza zoxide starship direnv
            ;;
        fedora)
            sudo dnf install -y ripgrep fd-find bat eza zoxide starship direnv
            ;;
        opensuse*|suse)
            sudo zypper install -y ripgrep fd bat eza zoxide starship direnv
            ;;
        gentoo)
            sudo emerge sys-apps/ripgrep sys-apps/fd sys-apps/bat sys-apps/eza \
                       app-shells/zoxide app-shells/starship dev-util/direnv
            ;;
        *)
            echo "Unsupported distribution: $distro"
            echo "Please install tools manually using cargo or from source"
            ;;
    esac
}

install_tools
```

### Linux Desktop Integration

```bash
# Create desktop entries for terminal-based tools
mkdir -p ~/.local/share/applications

# Helix desktop entry
cat > ~/.local/share/applications/helix.desktop << 'EOF'
[Desktop Entry]
Name=Helix
Comment=A post-modern modal text editor
Exec=gnome-terminal -- hx %F
Icon=text-editor
Terminal=false
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
EOF

# Micro desktop entry
cat > ~/.local/share/applications/micro.desktop << 'EOF'
[Desktop Entry]
Name=Micro
Comment=A modern and intuitive terminal-based text editor
Exec=gnome-terminal -- micro %F
Icon=text-editor
Terminal=false
Type=Application
Categories=Development;TextEditor;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
EOF

# Update desktop database
update-desktop-database ~/.local/share/applications
```

## Integration Examples

### Complete Development Setup

```bash
# ~/.zshrc or ~/.bashrc

# Modern tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

# Aliases
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza -T'
alias cat='bat'
alias find='fd'
alias grep='rg'
alias ps='procs'
alias top='btm'

# Functions
function fzf-edit() {
    local file
    file=$(fd --type f | fzf --preview 'bat --color=always {}')
    if [[ -n $file ]]; then
        $EDITOR "$file"
    fi
}

function fzf-cd() {
    local dir
    dir=$(fd --type d | fzf --preview 'eza -T {} | head -50')
    if [[ -n $dir ]]; then
        cd "$dir"
    fi
}

# Key bindings
bindkey '^F' fzf-edit
bindkey '^G' fzf-cd
```

### Project Template with Modern Tools

```bash
# project-setup.sh
#!/bin/bash

PROJECT_NAME=$1
if [[ -z $PROJECT_NAME ]]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

# Create project directory
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git
git init

# Create .envrc for direnv
cat > .envrc << 'EOF'
export PROJECT_NAME=$(basename $PWD)
export NODE_ENV=development
export DEBUG=true

# Add project bin to PATH
PATH_add bin
PATH_add scripts

# Load .env if it exists
dotenv_if_exists
EOF

# Create .mise.toml for runtime management
cat > .mise.toml << 'EOF'
[tools]
node = "18"
python = "3.11"

[env]
NODE_ENV = "development"

[tasks.dev]
run = "npm run dev"
description = "Start development server"

[tasks.test]
run = "npm test"
description = "Run tests"

[tasks.build]
run = "npm run build"
description = "Build project"
EOF

# Create justfile for task running
cat > justfile << 'EOF'
# List available recipes
default:
    @just --list

# Install dependencies
install:
    npm install

# Start development server
dev:
    npm run dev

# Run tests
test:
    npm test

# Build project
build:
    npm run build

# Format code
fmt:
    prettier --write .
    eslint --fix .

# Clean build artifacts
clean:
    rm -rf dist/
    rm -rf node_modules/
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.DS_Store
*.log
EOF

# Allow direnv
direnv allow

echo "Project $PROJECT_NAME created successfully!"
echo "Run 'cd $PROJECT_NAME && just install' to get started"
```

## Linux-Specific Troubleshooting

### Permission Issues

```bash
# Fix common permission issues with modern tools
# Ensure tools are executable
chmod +x ~/.local/bin/*

# Fix cargo-installed tools permissions
chmod +x ~/.cargo/bin/*

# Add to PATH if needed
echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
```

### Package Manager Conflicts

```bash
# Handle conflicts between package managers
# Remove system package before installing via cargo
sudo apt remove ripgrep  # Remove system version
cargo install ripgrep    # Install latest via cargo

# Or use alternatives command on Debian/Ubuntu
sudo update-alternatives --install /usr/bin/rg rg /usr/bin/rg 10
sudo update-alternatives --install /usr/bin/rg rg ~/.cargo/bin/rg 20
```

### Performance Optimization for Linux

```bash
# Optimize tools for Linux systems
# Set environment variables for better performance
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export BAT_THEME="Dracula"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Create ripgrep config for Linux development
cat > ~/.ripgreprc << 'EOF'
# Search hidden files but not .git
--hidden
--glob=!.git/*

# Follow symbolic links
--follow

# Smart case search
--smart-case

# Show line numbers
--line-number

# Limit search depth for performance
--max-depth=10
EOF
```

### Container Integration

```bash
# Use modern tools in Docker containers
# Dockerfile example
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust for cargo-based tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install modern tools
RUN cargo install ripgrep fd-find bat eza zoxide starship

# Set up shell with modern tools
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
RUN echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
RUN echo 'alias ls=eza' >> ~/.bashrc
RUN echo 'alias cat=bat' >> ~/.bashrc
```

These modern tools significantly enhance the Linux development experience by providing better defaults, improved performance, and more intuitive interfaces compared to traditional Unix tools. They integrate seamlessly with Linux systems and are optimized for Linux development workflows, making them essential tools for modern Linux developers and system administrators.
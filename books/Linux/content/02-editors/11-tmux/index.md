---
title: "tmux"
---

# tmux: Terminal Multiplexer

**tmux** is the default long-session tool for Linux servers and SSH. It keeps shells, editors, and builds running after disconnects, and it splits one terminal into windows and panes you can script and reattach from anywhere.

If you learn only one multiplexer, learn this one.

## Why tmux

- **Detach / reattach** — close SSH without killing jobs
- **Windows and panes** — layouts for editor + shell + logs
- **Scriptable** — create sessions from shell scripts and automation
- **Ubiquitous** — packages on virtually every distro
- **Pairs with any editor** — nvim, Helix, nano, Emacs `-nw`

Related tools: **GNU screen** (older), **Zellij** (friendlier defaults), **Herdr** (agent-aware). See the intro on [Terminal Workspaces](../00-intro/02-terminal-workspaces.md) and the Herdr chapter.

## Installation

```bash
# Debian / Ubuntu
sudo apt update && sudo apt install -y tmux

# Fedora
sudo dnf install -y tmux

# Arch
sudo pacman -S tmux

# openSUSE
sudo zypper install tmux

# Alpine
sudo apk add tmux

# Nix
nix profile install nixpkgs#tmux
# or in a flake/devShell: pkgs.tmux

# macOS (if you dual-boot workflows)
brew install tmux
```

Verify:

```bash
tmux -V
```

## Mental model

```text
tmux server (background)
 └── session "work"
      ├── window 0: editor
      │     ├── pane 0: nvim
      │     └── pane 1: shell
      └── window 1: logs
            └── pane 0: journalctl -f
```

| Object | What it is |
|--------|------------|
| **Server** | Background process owning all sessions |
| **Session** | Named group you attach to (`work`, `prod`) |
| **Window** | Full-screen tab inside a session |
| **Pane** | Split rectangle inside a window |

## Quick start lab

```bash
# Create a named session
tmux new -s work

# Inside tmux — prefix is Ctrl-b by default
# Split vertical / horizontal
Ctrl-b %
Ctrl-b "

# Move between panes
Ctrl-b o
Ctrl-b ←/→/↑/↓

# New window, rename, switch
Ctrl-b c
Ctrl-b ,
Ctrl-b n / Ctrl-b p
Ctrl-b 0..9

# Detach (jobs keep running)
Ctrl-b d

# List and reattach
tmux ls
tmux attach -t work
```

## Essential keybindings

Prefix is shown as `C-b` (hold Ctrl, press b, release, then press the command key).

### Sessions

| Keys | Action |
|------|--------|
| `C-b d` | Detach |
| `C-b s` | Session picker |
| `C-b $` | Rename session |

### Windows

| Keys | Action |
|------|--------|
| `C-b c` | New window |
| `C-b ,` | Rename window |
| `C-b n` / `C-b p` | Next / previous |
| `C-b w` | Window list |
| `C-b &` | Kill window |
| `C-b f` | Find window by name |

### Panes

| Keys | Action |
|------|--------|
| `C-b %` | Split left/right |
| `C-b "` | Split top/bottom |
| `C-b o` | Next pane |
| `C-b ;` | Last pane |
| `C-b x` | Kill pane |
| `C-b z` | Zoom pane (toggle fullscreen) |
| `C-b {` / `C-b }` | Swap panes |
| `C-b Space` | Cycle layouts |
| `C-b C-o` | Rotate panes |
| `C-b q` | Show pane numbers (then type number) |

### Copy mode (scrollback)

| Keys | Action |
|------|--------|
| `C-b [` | Enter copy mode |
| `q` | Quit copy mode |
| `C-b ]` | Paste tmux buffer |

With vi mode (recommended):

```tmux
set -g mode-keys vi
```

Then in copy mode: `v` begin selection, `y` copy (depending on version/config—see config section).

## Command-line interface

You can drive tmux without keybindings—ideal for scripts and muscle memory via shell aliases.

```bash
# Sessions
tmux new -s api -d                 # create detached
tmux new -s api -c ~/src/api       # start in directory
tmux attach -t api
tmux attach -t api -d              # attach and detach others
tmux switch -t api
tmux rename-session -t api backend
tmux kill-session -t api
tmux kill-server                   # nuclear: all sessions

# Windows
tmux new-window -t api -n tests
tmux select-window -t api:tests
tmux kill-window -t api:tests

# Panes
tmux split-window -h -t api
tmux split-window -v -t api
tmux select-pane -t api:0.1
tmux send-keys -t api:0.1 'htop' Enter

# Info
tmux list-sessions
tmux list-windows -t api
tmux list-panes -t api
tmux display-message -p '#S #I #P'
```

### Send keys and automation

```bash
# Start a dev layout detached
SESSION=dev
tmux has-session -t "$SESSION" 2>/dev/null || {
  tmux new-session -d -s "$SESSION" -n editor -c "$HOME/proj"
  tmux send-keys -t "$SESSION:editor" 'nvim' Enter
  tmux split-window -h -t "$SESSION:editor" -c "$HOME/proj"
  tmux send-keys -t "$SESSION:editor.1" 'git status' Enter
  tmux new-window -t "$SESSION" -n run -c "$HOME/proj"
  tmux send-keys -t "$SESSION:run" 'just dev' Enter
}
tmux attach -t "$SESSION"
```

## Configuration (`~/.tmux.conf`)

Reload after edits:

```bash
tmux source-file ~/.tmux.conf
# or inside tmux: C-b : source-file ~/.tmux.conf
```

### Sensible starter config

```tmux
# ~/.tmux.conf — practical defaults

# Terminal & color
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -g history-limit 50000
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g set-clipboard on

# Timing
set -sg escape-time 10
set -g focus-events on

# Vi keys
set -g mode-keys vi
set -g status-keys vi

# Prefix: keep Ctrl-b or switch to Ctrl-a (uncomment)
# unbind C-b
# set -g prefix C-a
# bind C-a send-prefix

# Splits in current path
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Pane move (vim-like)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Reload config
bind r source-file ~/.tmux.conf \; display-message "reloaded"

# Copy mode (vi)
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Status
set -g status-interval 5
set -g status-left-length 40
set -g status-left "#[bold]#S #[fg=colour8]| "
set -g status-right "#{?client_prefix,PREFIX ,}%Y-%m-%d %H:%M"
setw -g window-status-current-format "#[bold]#I:#W*"
setw -g window-status-format "#I:#W"
```

### Nested tmux (SSH jump hosts)

When you run tmux locally and on a remote:

```tmux
# Local: prefix C-b
# Remote: send prefix with C-b C-b (default) or rebind remote to C-a
```

Or use different prefixes per machine and document them.

## Nested editors and key conflicts

| Symptom | Likely cause |
|---------|----------------|
| `C-b` does nothing useful in Vim | You pressed tmux prefix; press again or wait |
| Esc feels slow in Vim | Raise `escape-time` was high; set to `10` |
| Colors wrong in nvim | `default-terminal` / `terminal-overrides` |
| Mouse selects but cannot paste | Copy-mode vs terminal clipboard; enable `set-clipboard` and OSC52-aware terminal |

Neovim tip: avoid binding `C-b` without checking tmux.

Helix/Zed: fewer conflicts; still test zoom (`C-b z`) and copy mode.

## SSH workflows

```bash
# Reattach or create
ssh host 'tmux new -A -s main'

# From local alias
alias tmain='ssh -t host tmux new -A -s main'
```

`new -A` attaches if the session exists, otherwise creates it.

### Keepalive

```bash
# ~/.ssh/config
Host *
  ServerAliveInterval 30
  ServerAliveCountMax 4
```

tmux survives SSH death; keepalive reduces nuisance disconnects.

## Plugins (optional)

[TPM](https://github.com/tmux-plugins/tpm) is the common plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

```tmux
# end of ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'   # save/restore sessions
set -g @plugin 'tmux-plugins/tmux-continuum'  # auto-save
set -g @plugin 'tmux-plugins/tmux-yank'       # clipboard helpers

run '~/.tmux/plugins/tpm/tpm'
```

Install plugins: `C-b I` (capital i).

**Resurrect** restores windows after reboot *if you save*; it is not magic. Critical production jobs still need systemd or proper process supervision.

## Pairing with editors

### Neovim / Vim

```bash
tmux new -s code -c ~/src/app
# pane 0
nvim
# C-b %
# pane 1
cargo test -- --nocapture
```

Or use Neovim’s built-in terminal (`:terminal`) and keep tmux for session persistence only—one full-window nvim is a valid style.

### Helix

```bash
hx .
# use tmux panes for cargo/npm; Helix file picker for buffers
```

### Emacs

```bash
emacs -nw
# or detach-friendly: emacsclient -nw after emacs --daemon
```

### Nano / Micro

Fine inside panes; rely on tmux for multi-tasking rather than editor splits.

## Comparison: tmux vs screen vs Zellij vs Herdr

| Feature | tmux | screen | Zellij | Herdr |
|---------|------|--------|--------|-------|
| Portability | Excellent | Excellent | Good | Growing |
| Defaults UX | OK | Dated | Great | Mouse + agent UI |
| Scripting | Excellent | OK | Good | CLI + socket API |
| Agent awareness | No | No | No | **Yes** |
| Typical use | SSH, servers | Legacy | Dev laptops | AI agent herds |

Use **tmux** as the baseline skill. Add **Herdr** when agents are the workload.

## Troubleshooting

```bash
# Server alive?
tmux ls

# Stuck session
tmux kill-session -t name

# Reset server (destroys all)
tmux kill-server

# Config error on start
tmux -f /dev/null new -s clean

# 24-bit color test
tmux new 'curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash'
```

Permission or socket issues after reboot: stale sockets under `/tmp/tmux-$(id -u)/`—remove only when no server should run.

## Cheatsheet card

```text
C-b d     detach              C-b c     new window
C-b %     vsplit              C-b "     hsplit
C-b z     zoom                C-b x     kill pane
C-b [     copy mode           C-b ]     paste
C-b n/p   next/prev window    C-b s     sessions
tmux new -A -s name           attach or create
```

## Practice checklist

- [ ] Create, detach, reattach a named session over SSH
- [ ] Build a 3-pane layout and zoom the editor
- [ ] Put vi keys in copy mode and yank a stack trace
- [ ] Write a 15-line script that recreates your dev session
- [ ] Survive an intentional SSH disconnect mid-`sleep 300`

Next: [Herdr](../12-herdr/index.md) for agent-native workspaces, or [Workflows](../14-workflows/index.md) for full recipes with Neovim/Helix/Zed.

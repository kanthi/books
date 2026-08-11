---
title: "Workflows"
---

# Workflows: Editors + Workspaces + Tools

Isolated chapters teach tools. This chapter **composes** them into daily Linux workflows you can copy and adapt.

## Stack templates

### 1) Server / sysadmin (minimal)

```text
SSH → tmux → vi or nano → rg/sed when needed
```

```bash
ssh -t host 'tmux new -A -s ops'
# inside:
sudoedit /etc/nginx/nginx.conf    # respects $EDITOR if set
journalctl -u nginx -f            # other pane
```

Skills: [Vi](../01-vi/index.md), [Nano](../04-nano/index.md), [tmux](../11-tmux/index.md).

### 2) Terminal IDE (Neovim)

```text
tmux session "dev"
  window editor: nvim (LazyVim optional)
  window shell:  tests / services
  window git:    lazygit
```

```bash
export EDITOR=nvim
tmux new -A -s dev -c ~/src/app
# C-b c for new windows; or splits with C-b %
```

Skills: [Neovim](../03-neovim/index.md), [LazyVim](../06-lazyvim/index.md), [tmux](../11-tmux/index.md), modern tools (lazygit, rg).

### 3) Selection-first modal (Helix)

```text
tmux or bare terminal
  hx .
  companion pane: cargo test --watch / npm run dev
```

```bash
export EDITOR=hx
hx .
```

Skills: [Helix](../07-helix/index.md), [tmux](../11-tmux/index.md).

### 4) Friendly modeless (Micro)

```text
micro config.yaml
# or panes in tmux for logs
```

Skills: [Micro](../08-micro/index.md).

### 5) Desktop GUI + agents (Zed + Herdr)

```text
Zed  → project editing, diagnostics, collab
Herdr → agent CLIs, long commands, detachable state
```

```bash
export EDITOR="zed --wait"
cd ~/src/app && zed .
# other terminal:
herdr
# panes: claude / codex / just dev
```

Skills: [Zed](../13-zed/index.md), [Herdr](../12-herdr/index.md).

### 6) Multi-agent feature work (Herdr-centric)

```text
Herdr workspace "feature-x"
  tab agents:  agent A (impl) | agent B (tests/review)
  tab runtime: dev server | lazygit | nvim/hx
```

```bash
herdr
# create panes; run agents; jump to blocked
```

When a pane needs a human editor for a messy conflict:

```bash
# in a free pane
nvim
# or open GUI if local
zed --wait path/to/conflicted.go
```

### 7) Emacs as environment

```text
emacs -nw  or  emacsclient -nw
  magit, vterm/eshell, org
optional outer tmux for detach only
```

Skills: [Emacs](../05-emacs/index.md).

## Cross-cutting recipes

### Open search hits in your editor

```bash
# ripgrep → fzf → editor
rg -n "TODO|FIXME" | fzf | awk -F: '{print $1, $2}' | while read -r f l; do
  $EDITOR +"$l" "$f"
done

# simpler: fzf file open
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
f() { local f; f=$(fzf --preview 'bat --color=always {}') && $EDITOR "$f"; }
```

### Git commit with correct blocking editor

```bash
# TUI
git config --global core.editor "nvim"
# GUI
git config --global core.editor "zed --wait"
# VSCodium
git config --global core.editor "codium --wait"
```

### kubectl / sudoedit

```bash
export EDITOR=nvim
sudoedit /etc/ssh/sshd_config
kubectl edit deploy/api
```

### One-shot session script (tmux)

```bash
#!/usr/bin/env bash
set -euo pipefail
S=app
ROOT=~/src/app
tmux has-session -t "$S" 2>/dev/null && exec tmux attach -t "$S"
tmux new-session -d -s "$S" -n edit -c "$ROOT"
tmux send-keys -t "$S:edit" 'nvim' Enter
tmux split-window -h -t "$S:edit" -c "$ROOT"
tmux send-keys -t "$S:edit.2" 'git status -sb' Enter
tmux new-window -t "$S" -n run -c "$ROOT"
tmux send-keys -t "$S:run" 'just dev' Enter
tmux attach -t "$S"
```

### Agent + editor discipline

1. **One writable branch per agent** (or worktree) to avoid clobbering
2. Human owns merge commits and production credentials
3. Keep secrets out of agent prompts and shared panes
4. Detach Herdr/tmux instead of killing terminals mid-run

```bash
git worktree add ../app-agent-b -b agent/b
# point second agent cwd at ../app-agent-b
```

## Keybinding peace treaty

| Tool | Reserve |
|------|---------|
| tmux | `Ctrl-b` as prefix |
| Herdr | prefix + mouse; do not nest blindly |
| Vim/Neovim | leader key (often `Space`) |
| Helix | `Space` for pickers |
| Terminal emulator | do not bind `Ctrl-b` / `Ctrl-a` if you can avoid it |

If something “eats” a key, ask: **emulator → multiplexer → editor** in that order.

## Dotfiles layout (suggested)

```text
~/.config/
  nvim/          or helix/  or micro/
  tmux/tmux.conf or ~/.tmux.conf
  git/config
  zed/settings.json
  herdr/         (per current Herdr docs)
```

Store in a git repo; bootstrap with a single `install` script. Do not share machine-local secrets in that repo.

## Choosing under pressure

```text
Production on fire, unfamiliar host
  → vi or nano, no plugins

Laptop, feature sprint, two agents
  → Herdr + Zed or nvim

Teaching a newcomer Linux
  → nano or Micro, then show vi exits

Deep C++/Rust refactor alone
  → Helix or LazyVim + tmux tests pane
```

## Practice: build your “default”

Write this down and stick to it for a month:

```text
Daily editor: _______________
Session tool:  tmux / herdr / both: ________
$EDITOR:      _______________
Search:       rg + fzf + bat
Git UI:       lazygit / magit / zed / plain
```

Then deepen *that* stack using the matching chapters—not every chapter at once.

## See also

- [Choosing an Editor](../00-intro/01-choosing-an-editor.md)
- [Terminal Workspaces](../00-intro/02-terminal-workspaces.md)
- [tmux](../11-tmux/index.md)
- [Herdr](../12-herdr/index.md)
- [Zed](../13-zed/index.md)
- [Modern Tools](../10-modern-tools/index.md)

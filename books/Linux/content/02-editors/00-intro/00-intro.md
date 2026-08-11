---
title: "Overview"
---

# Overview: Editing on Linux

Linux gives you more than one way to change a file. Some editors exist to survive a broken package manager. Others are full IDEs in the terminal. Multiplexers keep processes alive after SSH drops. Agent runtimes such as **Herdr** treat AI coding agents as first-class citizens of that same terminal world.

This chapter orients you so the rest of the book is a map, not a maze.

## The three layers

Think in layers rather than “best editor”:

| Layer | Job | Examples |
|-------|-----|----------|
| **Buffer editor** | Change text | vi, Vim, Neovim, Helix, nano, Emacs, Zed |
| **Workspace / session** | Keep panes and processes alive | tmux, screen, Zellij, Herdr |
| **Companion CLI** | Search, navigate, review | rg, fd, fzf, bat, delta, lazygit |

You almost always combine one item from each layer.

```text
┌─────────────────────────────────────────────┐
│  Herdr / tmux / Zellij  (session layer)     │
│  ┌──────────────┐  ┌──────────────────────┐ │
│  │  nvim / hx   │  │  shell / tests / AI  │ │
│  │  (editor)    │  │  agent               │ │
│  └──────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────┘
         ▲
         │  fd | fzf | rg | bat | git delta
```

## Why terminal editors still matter

- **SSH and servers**: No display server; your editor must be TUI or remote-aware
- **Rescue and initramfs**: Often only `vi` or `nano` exist
- **Latency**: Modal editors stay efficient on high-latency links
- **Scriptability**: `$EDITOR` hooks for git, kubectl, crontab, sudoedit
- **Agents**: Coding agents live in terminals; workspaces must outlive laptop sleep

## Editor families (quick map)

| Family | Feel | Best when |
|--------|------|-----------|
| **vi / Vim / Neovim** | Modal, action-oriented | Everywhere, plugins, muscle memory |
| **LazyVim** | Neovim distribution | Fast IDE-like Neovim without building from zero |
| **Helix / Kakoune** | Selection-first modal | Modern defaults, multi-cursor, less config |
| **nano / Micro** | Modeless, discoverable | Quick edits, newcomers |
| **Emacs** | Self-contained environment | Deep customization, org, mail, magit |
| **Zed** | Fast GUI (native) | Local projects, multiplayer, GPU-accelerated UI |

Deep chapters later cover each in turn.

## Workspace tools (quick map)

| Tool | Strength | Weakness |
|------|----------|----------|
| **tmux** | Ubiquitous, scriptable, SSH staple | Defaults feel dated; config is a project |
| **GNU screen** | Ancient availability | Weaker ergonomics than tmux |
| **Zellij** | Friendly defaults, layouts | Less universal on bare servers |
| **Herdr** | Agent state, detachable agent herds, API | Newer; focused on agent workflows |

If you only learn one classic multiplexer, learn **tmux**. If you run multiple AI coding agents, add **Herdr**.

## A sane default stack (2026)

For day-to-day Linux development:

```bash
# Editor (pick one)
export EDITOR=nvim          # or hx, micro, code --wait, zed --wait

# Search / browse
# ripgrep, fd, fzf, bat, eza, delta, zoxide

# Session
# tmux for long SSH + builds
# herdr when juggling Claude Code / Codex / opencode / etc.
```

Example daily flow:

1. `herdr` or `tmux new -s work`
2. Left pane: editor (`nvim`, `hx`, or Zed on the host)
3. Right pane: shell, tests, or an agent
4. Detach (`Ctrl-b d` in tmux, or Herdr detach) without killing jobs

## Learning order inside this book

1. **Choosing an editor** — decision criteria
2. **Terminal workspaces** — mental model shared by tmux/Herdr/Zellij
3. **One classic editor** — vi or nano so you are never stuck
4. **One daily driver** — Neovim/LazyVim, Helix, or Micro
5. **tmux** — sessions, windows, panes, copy-mode
6. **Herdr** — agent-aware workspaces
7. **Zed** — if you want a modern GUI on Linux desktops
8. **Modern tools** — upgrade the shell around the editor

## Practice goals

After the foundations:

- [ ] Open, edit, save, and exit with **both** nano and vi
- [ ] Create a tmux session, split panes, detach, reattach over SSH
- [ ] Set `$EDITOR` and use `git commit` so it opens your editor
- [ ] Search a repo with `rg` and open a hit in your editor
- [ ] (Optional) Run two coding agents under Herdr and jump to a blocked pane

## What “deepen” means here

Each editor chapter aims for **production usefulness**, not marketing blurbs:

- Install on common distros
- Modal/modeless model explained clearly
- Navigation, edit, search, buffers
- Config file locations and a sensible starter config
- Integration with git, LSP (where relevant), and multiplexers
- Migration notes from adjacent tools

Start with [Choosing an Editor](01-choosing-an-editor.md) or jump straight to the part that matches your path.

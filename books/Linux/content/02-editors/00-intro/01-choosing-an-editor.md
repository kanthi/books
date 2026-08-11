---
title: "Choosing an Editor"
---

# Choosing an Editor

There is no universal best editor. There is a best fit for **constraints** (SSH? rescue? GPU GUI?), **tasks** (one-line config vs multi-package refactor), and **time** you will invest in config and muscle memory.

## Decision matrix

| Constraint | Prefer |
|------------|--------|
| Broken system, single-user mode | `vi` (often busybox/nvi) or `nano` |
| Fresh server, no packages yet | whatever is installed: usually `vi`/`vim`/`nano` |
| Long SSH session, many panes | Editor + **tmux** or **Herdr** |
| Want IDE features with little config | **LazyVim**, **Helix**, **Zed**, or VSCodium |
| Love customization / Lisp | **Emacs** |
| Hate modes | **nano**, **Micro**, Zed/VS Code |
| Maximum portability of skills | **vi** family |
| Multiple AI agents | **Herdr** + any editor |
| Low latency typing feel | modal TUI (Vim/Helix) or native GUI (**Zed**) |

## Time investment vs power

```text
Low setup ────────────────────────────────────── High setup
nano → Micro → Helix → LazyVim → Neovim → Emacs
         ↑              ↑
       Zed          Vim configs
```

- **Low setup**: useful in an afternoon
- **Medium**: productive in a week
- **High**: multi-month craft (full Neovim/Emacs ecosystems)

Helix and LazyVim intentionally sit in the “powerful but opinionated defaults” band. Classic Vim and Emacs reward long investment.

## Modal vs modeless

**Modeless** (nano, Micro, most GUIs): typing always inserts text; commands use chords (`Ctrl+…`) or menus.

**Modal** (vi, Vim, Neovim, Helix, Kakoune): normal mode is for verbs and motions; insert mode is for typing. Modes feel strange for a day and then become a force multiplier for structured edits.

**Selection-first** (Helix, Kakoune): select the region, then act. Vim-style is often **action + motion** (`dw` = delete word). Both are modal; the order differs.

## GUI vs TUI vs remote

| Kind | Examples | Notes |
|------|----------|-------|
| **TUI** | nvim, hx, nano, emacs -nw | Best over SSH; pair with tmux/Herdr |
| **Native GUI** | Zed, gvim, Emacs GUI | Best local UX; use remote mounts/SSHFS carefully |
| **Electron GUI** | VS Code / Codium | Huge ecosystem; heavier RAM |
| **Remote bridge** | code-server, SSH remote | GUI feel on remote machine |

On a headless VPS, prioritize TUI. On a Linux workstation, Zed or a terminal editor inside a nice terminal (Kitty, WezTerm, Ghostty, Alacritty) is common.

## Compatibility with the rest of your stack

Ask:

1. Does `$EDITOR` work for git, crontab, kubectl edit?
2. Does it speak **LSP** for your languages?
3. Can it run inside **tmux** without keybinding wars?
4. Can you open it from **fzf** / file managers?
5. For agents: does the tool leave a real PTY (Herdr/tmux care about this)?

Example git wiring:

```bash
git config --global core.editor "nvim"
# or: "hx"
# or: "zed --wait"
# or: "code --wait"
```

## Recommendation cheat sheet

| You are… | Start with | Graduate to |
|----------|------------|-------------|
| New to Linux | nano | Micro or Helix |
| Sysadmin | vi + nano | Vim + tmux |
| App developer (terminal) | LazyVim or Helix | custom Neovim |
| App developer (desktop) | Zed or VSCodium | same + tmux for servers |
| Polyglot power user | Neovim or Emacs | your own distro |
| Running AI coding agents | any editor + **Herdr** | scripted Herdr workspaces |

## Anti-patterns

- Switching editors every week before learning motions
- Copy-pasting a 2 000-line Neovim config you do not understand
- Using only a GUI and freezing when SSH drops you into `vi`
- Nested multiplexers without a plan (tmux inside Herdr inside tmux)
- Fighting keybindings: leave **prefix** keys alone until you need them

## Pick one for thirty days

1. Choose **one** daily editor from this book
2. Choose **one** session tool (tmux for general, Herdr for agents)
3. Install **rg**, **fd**, **fzf**, **bat**
4. Write a half-page cheatsheet of *your* ten commands
5. Only then evaluate a second editor

Next: [Terminal Workspaces](02-terminal-workspaces.md) for the session layer, then dive into a concrete editor part.

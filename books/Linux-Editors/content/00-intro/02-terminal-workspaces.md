---
title: "Terminal Workspaces"
---

# Terminal Workspaces

Editors change buffers. **Workspaces** change how long processes live, how many shells you juggle, and whether closing a laptop kills a four-hour test or an AI agent.

This chapter is the shared mental model for **tmux**, **screen**, **Zellij**, and **Herdr**. Dedicated chapters go deeper; modern-tools covers Zellij in the CLI toolkit chapter.

## Problems workspaces solve

| Problem | Without workspace | With workspace |
|---------|-------------------|----------------|
| SSH disconnect | Shells die | Detach; processes continue |
| Many tasks | Terminal tabs on the client only | Server-side panes/windows |
| Pairing / reattach | Lost context | Named sessions |
| AI agents | One agent per terminal window; easy to lose | Herdr tracks agent state across panes |
| Layout | Rebuild every login | Scripted layouts |

## Core concepts (shared vocabulary)

### Session

A **session** is a named container for state that outlives a single client connection.

```bash
# tmux-shaped idea
tmux new -s api
tmux attach -t api
tmux ls
```

Herdr uses a background **server** plus attachable clients; named sessions group workspaces similarly.

### Window / tab

A **window** (tmux) or **tab** (Zellij/Herdr) is a full-screen layout unit. You switch windows to change “desktops” inside the session.

### Pane

A **pane** is a split region inside a window: editor left, tests right, logs below.

```text
┌────────────┬────────────┐
│   editor   │   shell    │
│            ├────────────┤
│            │   agent    │
└────────────┴────────────┘
```

### Prefix key

Most multiplexers use a **prefix** chord so keybindings do not steal from Vim/Emacs.

| Tool | Default prefix (typical) |
|------|---------------------------|
| tmux | `Ctrl-b` then key |
| screen | `Ctrl-a` then key |
| Zellij | mode-based (`Ctrl-p`, `Ctrl-t`, …) |
| Herdr | `Ctrl-b` familiar for tmux users; also mouse-first |

**Rule:** if keys “do nothing” in Vim, check you are not inside a multiplexer waiting for a second key after prefix.

### Detach / attach

- **Detach**: client disconnects; session keeps running
- **Attach**: reconnect from another terminal or host

```bash
# tmux
Ctrl-b d                 # detach
tmux attach -t api       # reattach

# Herdr (conceptually)
# detach leaves the server + agents running; run herdr again to attach
```

## Choosing among multiplexers

```text
Need maximum portability on random servers?
  └─ tmux (or screen if tmux missing)

Want nicer defaults and layouts without much config?
  └─ Zellij

Running Claude Code / Codex / opencode / other agent CLIs?
  └─ Herdr (can still live inside or beside tmux)

Only local GUI terminal tabs?
  └─ Fine for simple work; still learn tmux for remote
```

### When not to nest

Avoid:

```text
tmux → herdr → tmux → nvim
```

Prefer one outer session manager:

```text
herdr
  ├─ nvim
  ├─ agent
  └─ shell

# or

tmux
  ├─ nvim
  ├─ shell
  └─ optional: herdr only if you need agent UI features
```

Herdr docs note it can run **inside** tmux as the outer terminal environment, but agent detection does not inspect tmux sessions *launched inside* a Herdr pane. Keep the layering intentional.

## Editor integration patterns

### Pattern A — editor full window

```text
Window 1: nvim
Window 2: shell / tests
Window 3: docs / top
```

Simple; great with Vim tabs/buffers for files.

### Pattern B — editor + shell split

```text
Pane left: hx or nvim
Pane right: cargo test / npm run dev
```

Classic pair-programming-with-yourself layout.

### Pattern C — agent herd (Herdr)

```text
Workspace "api"
  Tab agents: Claude Code | Codex | opencode
  Tab runtime: dev server | logs
```

Herdr surfaces **working / blocked / idle** so you jump to the agent that needs input.

### Pattern D — remote box

```bash
ssh build-box
tmux attach -t build || tmux new -s build
# or
herdr --remote build-box
```

## Copy mode and scrollback

Terminal multiplexers own **scrollback**. Mouse scrolling may enter copy-mode.

tmux essentials:

```bash
Ctrl-b [          # copy mode
# move with vi keys if mode-keys vi
Space / Enter     # start/end selection (emacs mode defaults vary)
Ctrl-b ]          # paste buffer
```

Configure vi keys:

```tmux
# ~/.tmux.conf
set -g mode-keys vi
set -g status-keys vi
```

## Persistence expectations

| Event | tmux/screen/Zellij | Herdr |
|-------|--------------------|-------|
| Close terminal emulator | Session survives if server running | Server keeps panes |
| SSH drop | Session survives | Session survives |
| Reboot | Dead unless you script restore | Layout restore / agent resume features (see Herdr docs) |
| `kill-server` / stop | Everything dies | Everything dies |

Do not assume reboot survival without explicit tooling (systemd user services, tmux-resurrect, Herdr session state features).

## Minimal practice lab

```bash
# 1. Session
tmux new -s lab

# 2. Split
Ctrl-b %          # vertical split
Ctrl-b "          # horizontal split
Ctrl-b o          # next pane

# 3. Run something long
ping -c 1000 1.1.1.1

# 4. Detach and kill the terminal window entirely
Ctrl-b d

# 5. Prove it lived
tmux attach -t lab
```

Then repeat a similar flow after reading the **tmux** and **Herdr** parts.

## Keybindings to keep conflict-free

If you use Vim/Neovim:

- Prefer tmux prefix `Ctrl-b` (default) or `Ctrl-a` only if you rebind screen habits carefully
- In Neovim, avoid binding the same chords tmux uses without `passthrough`
- For Helix/Zed, conflicts are fewer; still test copy-mode and pane zoom

## Next chapters

- **tmux** — the portable standard for SSH and long jobs
- **Herdr** — agent-native workspaces and CLI/API
- **Workflows** — concrete editor + multiplexer recipes
- **Modern tools** — Zellij, prompts, file jumpers, git pagers

The workspace layer is not optional once your work outlives a single shell. Learn detach/attach early; everything else is efficiency.

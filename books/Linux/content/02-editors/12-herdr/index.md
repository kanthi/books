---
title: "Herdr"
---

# Herdr: Agent-Native Terminal Workspaces

**Herdr** (pronounced like “herder”) is a terminal workspace manager built for **AI coding agents** and long-lived terminal work. It owns real PTY panes, keeps them running in a background server, and tracks whether each agent is **working**, **blocked**, or **idle**—so you jump to the pane that needs you instead of hunting through tabs.

It is not a replacement for Neovim or Helix. It is the **session layer** those editors (and agent CLIs) live inside—similar in spirit to tmux, but agent-aware.

Official site: [https://herdr.dev/](https://herdr.dev/) · Docs: [https://herdr.dev/docs/](https://herdr.dev/docs/)

## Why Herdr exists

Classic multiplexers (tmux, screen, Zellij) are process-agnostic: a pane is a pane. In 2026 many developers run **Claude Code**, **Codex**, **opencode**, **Cursor agent CLIs**, **Grok**, and similar tools that:

- Run for a long time
- Block waiting for approval or input
- Multiply (one agent per task or worktree)

Herdr adds:

| Capability | What you get |
|------------|----------------|
| **Background server** | Agents keep running when you detach or close the laptop lid (machine still on) |
| **Agent detection** | Sidebar/state for working / blocked / idle |
| **Mouse-first UX** | Click panes, drag splits, right-click menus—no prefix required to start |
| **tmux-like prefix** | `Ctrl-b` family bindings if you already know tmux |
| **CLI + socket API** | Agents and scripts split panes, wait on status, read output |
| **Remote attach** | Work on a box over SSH-style remote modes |

Herdr does **not** wrap or replace your agents. You run the same CLIs; Herdr owns their terminals.

## Install

### Quick install (Linux / macOS)

```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

Ensure the install location is on your `PATH`, then:

```bash
herdr
herdr update          # later, for installer-managed binaries
```

### Package managers

```bash
# Homebrew
brew install herdr

# mise
mise use -g herdr
# fallback if registry is old:
# mise use -g github:herdrdev/herdr

# Nix (pin a release tag in real use)
nix profile install github:herdrdev/herdr/v0.x.y
# or: nix run github:herdrdev/herdr/v0.x.y
```

### Manual binary

Download from [GitHub releases](https://github.com/herdrdev/herdr/releases):

| System | Asset |
|--------|--------|
| Linux x86_64 | `herdr-linux-x86_64` |
| Linux aarch64 | `herdr-linux-aarch64` |

```bash
chmod +x herdr-linux-x86_64
mv herdr-linux-x86_64 ~/.local/bin/herdr
```

### Channels

Direct installs default to **stable** on Linux/macOS. Preview builds:

```bash
herdr channel set preview
herdr channel set stable
```

Homebrew / mise / Nix updates go through those tools, not always `herdr update`.

## Concepts

```text
herdr-server (background)
 └── session (default or named)
      ├── workspace "api"
      │     ├── tab "agents"
      │     │     ├── pane: claude (blocked)
      │     │     └── pane: codex (working)
      │     └── tab "runtime"
      │           ├── pane: dev server
      │           └── pane: nvim / hx
      └── workspace "docs"
```

| Term | Meaning |
|------|---------|
| **Server** | Owns PTYs; survives client disconnect |
| **Client** | Renders UI; attach/detach |
| **Workspace** | Project-scale unit (often one repo or concern) |
| **Tab** | Layout group inside a workspace |
| **Pane** | Real terminal (shell, editor, agent) |
| **Agent state** | Rolled up from pane → tab → workspace |

## Quick start

```bash
# Start (spawns/connects to server, opens client)
herdr

# Inside: open your usual tools in panes
claude          # or codex, opencode, etc.
nvim
just test

# Detach — leave the herd running (see keyboard docs for exact bind)
# Default family: Ctrl-b then q  (detach; leave everything running)
```

Reattach later with `herdr` again. Named sessions:

```bash
herdr session list
herdr session attach work
herdr session attach side-project
herdr session stop work
herdr session delete side-project
```

Remote-oriented usage (patterns from docs):

```bash
# SSH to the machine, then run herdr like tmux
ssh you@server
herdr

# Or remote client mode when supported
herdr --remote workbox
herdr --remote workbox --session agents
```

Direct attach by agent label when configured:

```bash
herdr agent attach reviewer
```

## Keyboard and mouse

Herdr is **mouse-native**: click panes, drag borders, use context menus.

If you know tmux, the **prefix** model will feel familiar (`Ctrl-b` by default for many actions). Common ideas from the keyboard guide:

| Action | Typical binding |
|--------|-----------------|
| Workspace navigation | prefix+w |
| Detach (leave running) | prefix+q |
| New workspace | prefix+Shift+n |
| Rename workspace | prefix+Shift+w |
| Close workspace | prefix+Shift+d |
| Goto picker | prefix+g |
| Toggle sidebar | prefix+b |
| Close tab | prefix+Shift+x |

Bindings are configurable—see [Configuration](https://herdr.dev/docs/configuration/) for the live reference. Prefer the docs over memorizing a fork’s defaults.

## CLI automation

Herdr exposes a CLI (and socket API) so **you or an agent** can drive structure:

```bash
# Shape a workspace
herdr workspace create --cwd ~/project --label api
herdr tab create --label logs

# Panes
herdr pane split 1-1 --direction right
herdr pane run 1-2 "just test"

# Wait for agent status, then inspect output
herdr wait agent-status 1-1 --status done
herdr pane read 1-2 --source recent-unwrapped
```

Report custom metadata for the UI:

```bash
herdr pane report-metadata <pane_id> \
  --source my-agent-hook \
  --token model=opus \
  --token summary="reviewing authentication"
```

Exact subcommands evolve—run `herdr --help` and the [CLI / socket API docs](https://herdr.dev/docs/socket-api/) for your installed version.

## Working with editors

Herdr is the outer frame; pick any editor from this book:

| Editor | Pattern |
|--------|---------|
| **Neovim / LazyVim** | Pane for `nvim`, pane(s) for agents, pane for tests |
| **Helix** | Same; Helix picker for files, Herdr for agents |
| **Zed** | GUI editor on the host; Herdr for remote/agent PTYs (or local agent panes) |
| **Micro / nano** | Fine for quick edits in a pane beside an agent |

Example layout intent:

```text
Workspace: payments-service
┌──────────────────┬────────────────────┐
│ nvim             │ claude (agent)     │
│                  ├────────────────────┤
│                  │ cargo test -q      │
└──────────────────┴────────────────────┘
```

### `$EDITOR` still matters

Agents and git often spawn editors:

```bash
export EDITOR=nvim
export VISUAL=nvim
# or: export EDITOR="zed --wait"
```

## Herdr vs tmux vs Zellij

| | **tmux** | **Zellij** | **Herdr** |
|--|----------|------------|-----------|
| Primary job | General sessions | Friendly multiplexer | Agent herds + sessions |
| Agent state | Manual | Manual | First-class |
| Scripting | Excellent | Good | CLI + socket API |
| Availability on bare VPS | Highest | Medium | Install binary |
| Mouse UX | Optional | Good | Core |
| Nested with tmux | Common | Common | Supported carefully |

**Practical combo:**

- **tmux** on every server as baseline skill
- **Herdr** on machines where you run multiple coding agents
- Avoid deep nesting: do not put *tmux inside Herdr inside tmux* without a reason

Herdr can run **inside** an outer tmux. Conversely, if a shell auto-starts tmux *inside* a Herdr pane, Herdr may see `tmux` as the process instead of the agent—disable auto-tmux in those panes.

## Agents and detection

Herdr detects many agent CLIs out of the box (Claude Code, Codex, opencode, Cursor-related tools, Grok, Copilot-style CLIs, and others—see current [agents docs](https://herdr.dev/docs/agents/)).

States roll up:

- **Blocked** — needs you (approval, question)
- **Working** — busy
- **Idle / done** — quiet

Your job becomes: open the sidebar, jump to **blocked**, answer, move on.

## Configuration sketch

Configuration covers keybindings, themes, sidebar, notifications, scrollback, and advanced options. Paths and schema are versioned—start from:

```bash
# After first run, check docs for config file location and examples
# https://herdr.dev/docs/configuration/
```

When customizing:

1. Change one key family at a time
2. Keep a “panic” path: mouse + command palette / goto picker
3. Store config in git with your dotfiles

## Plugins

Herdr supports **plugins** (manifest + executable actions/hooks) and a marketplace direction. Plugins can restore layouts, add overlays, or react to events such as worktree creation.

Sketch (illustrative—verify against current plugin docs):

```toml
[[actions]]
id = "list-workspaces"
title = "List workspaces"
contexts = ["workspace"]
command = ["node", "index.js"]
```

See [Plugins](https://herdr.dev/docs/plugins/) and [Marketplace](https://herdr.dev/docs/marketplace/).

## Session state and persistence

Important mental model (aligned with Herdr docs):

- Detach ≠ kill: panes keep running in the server
- Restart/restore behavior depends on session state features and agent resume support
- Protocol-breaking upgrades may require stopping the old server (`herdr server stop` / `herdr session stop <name>`) after `herdr update`

For production data jobs, still use proper supervisors (systemd, containers). Herdr is for **interactive and agent** workspaces, not a substitute for process monitoring of daemons—though many people run dev servers inside panes safely.

## Security notes

- Treat a machine running agent CLIs with **repo and cloud credentials** as sensitive
- Remote attach expands the attack surface—use SSH hardening, keys, and least privilege
- Do not paste secrets into agent panes you will share or record
- Review plugin source before installing community plugins

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| `herdr: command not found` | Restart shell; check PATH / installer location |
| Cannot reattach | `herdr session list`; confirm server not stopped |
| Agent shows as idle/wrong | Pane may be nested tmux/shell wrapper; run agent as direct pane command |
| After update, client/server mismatch | Stop old server, start fresh client |
| Keys stolen by outer tmux | Use mouse, or send prefix twice, or simplify nesting |

```bash
herdr update
herdr server stop      # default session server
herdr                  # start clean
```

## Practice lab

1. Install Herdr and run `herdr`
2. Create two panes: shell + a long `ping` or `htop`
3. Detach, close the terminal emulator, reattach—confirm processes lived
4. Run two agent CLIs (or two shells pretending to be agents) in one workspace
5. Use the sidebar / goto picker to jump between them
6. Script a workspace with `herdr workspace create` and `herdr pane split` if your version supports those verbs

## When to use what

```text
SSH to random prod bastion, edit nginx.conf
  → tmux + vi/nano

Local multi-repo app work with one shell
  → tmux or Zellij + nvim/hx/zed

Three coding agents + dev server + editor
  → Herdr (+ your editor of choice)
```

## Further reading

- [Herdr docs home](https://herdr.dev/docs/)
- [Install](https://herdr.dev/docs/install/)
- [Agents](https://herdr.dev/docs/agents/)
- [How to work](https://herdr.dev/docs/how-to-work/)
- [Persistence and remote](https://herdr.dev/docs/persistence-remote/)
- [Keyboard](https://herdr.dev/docs/keyboard/)
- Agent onboarding prompt from docs: point your agent at `https://herdr.dev/agent-guide.md`

Next: [Zed](../13-zed/index.md) for a modern native GUI editor, or [Workflows](../14-workflows/index.md) to combine Herdr with Neovim/Helix/tmux deliberately.

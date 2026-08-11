# tmux

## Overview

`tmux` is a **terminal multiplexer**: multiple windows and panes inside detachable sessions that survive SSH disconnects. Prefer it over `nohup` for interactive long-lived remote work, and over ad-hoc background jobs when you need to reattach and see output. For production services still prefer **systemd**.

## Syntax

```bash
tmux [command] [options]
tmux [-L socket-name] [-S socket-path] [-f file]
```

Most daily use is either bare `tmux` or a short subcommand (`new`, `attach`, `ls`, `kill-session`).

## Install (Ubuntu)

```bash
sudo apt update
sudo apt install tmux
tmux -V
```

## Prefix key

Default prefix: **Ctrl-b**, then a command key. (Many people rebind to Ctrl-a.)

| After prefix | Action |
|--------------|--------|
| `c` | New window |
| `,` | Rename window |
| `n` / `p` | Next / previous window |
| `0`–`9` | Select window by index |
| `w` | Window list |
| `&` | Kill window |
| `%` | Split pane **left/right** |
| `"` | Split pane **top/bottom** |
| `o` / arrow keys | Cycle / move between panes |
| `;` | Last pane |
| `x` | Kill pane (confirm) |
| `z` | Zoom toggle (pane fullscreen) |
| `{` / `}` | Swap panes |
| `Space` | Cycle pane layouts |
| `d` | Detach session |
| `s` | Session list |
| `$` | Rename session |
| `[` | Copy / scroll mode |
| `]` | Paste buffer |
| `?` | List keys |
| `:` | Command prompt |

## Common CLI commands

| Command | Description |
|---------|-------------|
| `tmux` | New session (default name) |
| `tmux new -s NAME` | Named session |
| `tmux new -d -s NAME [cmd]` | Detached session (optional command) |
| `tmux ls` | List sessions |
| `tmux attach -t NAME` | Attach |
| `tmux attach -d -t NAME` | Attach and detach others |
| `tmux switch -t NAME` | Switch (from inside tmux) |
| `tmux kill-session -t NAME` | Kill session |
| `tmux kill-server` | Kill all sessions (careful) |
| `tmux list-windows -t NAME` | Windows in session |

## Key Use Cases

1. Survive laptop sleep / SSH drops during deploys
2. Pair multiple panes (logs + editor + shell)
3. Long builds or trainers you can reattach to
4. Named sessions per project (`tmux new -s api`)

## Examples with Explanations

### Example: create, detach, reattach

```bash
tmux new -s deploy
# ... work ...
# Ctrl-b d
tmux ls
tmux attach -t deploy
# short form:
tmux a -t deploy
```

Core workflow. Detach leaves processes running on the server.

### Example: start detached job session

```bash
tmux new -d -s train 'python3 train.py 2>&1 | tee train.log'
tmux attach -t train
```

Session exists immediately; attach when you want the TTY.

### Example: nested SSH-safe habit

```bash
ssh host
tmux new -s work || tmux attach -t work
```

Create-or-attach pattern for a daily session.

### Example: splits for ops

Inside a session:

1. `Ctrl-b %` — vertical split (side by side)
2. `Ctrl-b "` — horizontal split
3. `Ctrl-b z` — zoom the pane you care about
4. Run `journalctl -fu nginx` in one pane, shell in another

### Example: scripted window layout

```bash
tmux new -d -s app
tmux rename-window -t app:0 shell
tmux new-window -t app -n logs 'journalctl -f'
tmux new-window -t app -n top 'htop'
tmux split-window -h -t app:shell
tmux attach -t app
```

Good for standardizing a “ops dashboard” session.

### Example: send keys to a session (automation)

```bash
tmux new -d -s patch
tmux send-keys -t patch 'sudo apt update && sudo apt upgrade' C-m
```

Use sparingly; prefer scripts over pseudo-interactive automation when possible.

### Example: shared socket / pair-ish access

```bash
tmux -S /tmp/pair.sock new -s pair
# other user (permissions permitting):
tmux -S /tmp/pair.sock attach -t pair
```

For real pairing, tools like `tmate` or proper access control may be better.

### Example: minimal `~/.tmux.conf`

```tmux
set -g mouse on
set -g history-limit 50000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
# rebind prefix to Ctrl-a (optional):
# unbind C-b
# set -g prefix C-a
# bind C-a send-prefix
```

Reload from inside tmux: `Ctrl-b :` then `source-file ~/.tmux.conf`.

### Example: copy mode (scrollback)

`Ctrl-b [` → move with arrows/PageUp → `Space` begin selection → `Enter` copy (bindings vary with mode-keys vi/emacs) → `Ctrl-b ]` paste.

With mouse on, scroll and select often work directly.

## Safety

- `tmux kill-server` ends **all** sessions for that server socket — confirm `tmux ls` first.
- Detached sessions still consume resources; clean up dead project sessions.
- Do not run secrets printing in shared sessions.
- Nested tmux (local + remote) confuses prefixes — use a different remote prefix or SSH directly into remote tmux only.

## Notes & Pitfalls

- Environment variables are captured at **session start**; re-login SSH agent sockets often need `tmux setenv` or plugin tooling after laptop sleep.
- `TERM`/`COLORTERM` mismatches cause weird colors — prefer `tmux -2` legacy force or correct `terminal-overrides` in conf for modern terminals.
- Clipboard integration needs `xclip`/`wl-clipboard` and conf bindings on desktop Linux.
- Version differences: Ubuntu LTS tmux may lag plugin ecosystem features — check `tmux -V`.
- Prefer one session per task rather than infinite windows without names.

## Related Commands

- `screen` — older multiplexer
- `byobu` — profile/enhancement layer over tmux/screen
- `tmate` — easy remote sharing
- `abduco` / `dtach` — minimal detach only
- `nohup` / `systemd-run` — non-interactive longevity
- `ssh` — usual transport

## Additional Resources

- `man tmux`
- `tmux list-keys` / `tmux list-commands`

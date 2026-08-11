# screen

## Overview

`screen` is the classic terminal multiplexer: detachable sessions that survive hangups. It is still available on Ubuntu and many rescue environments, but **new muscle memory should prefer `tmux`** unless you are on a host that only has `screen` or you maintain legacy automation. Concepts map closely: sessions, windows, detach/attach.

## Syntax

```bash
screen [options] [command [args]]
screen -S name
screen -r [name]
screen -ls
```

## Install (Ubuntu)

```bash
sudo apt update
sudo apt install screen
screen -v
```

## Prefix key

Default prefix: **Ctrl-a**, then a command key. (Note: conflicts with readline “beginning of line” — press `Ctrl-a a` to send literal Ctrl-a.)

| After prefix | Action |
|--------------|--------|
| `c` | New window |
| `n` / `p` | Next / previous window |
| `"` | Window list |
| `A` | Rename window |
| `k` | Kill window |
| `S` | Split **horizontal** (regions) |
| `|` | Split **vertical** (modern screen; if unbound, use conf) |
| `Tab` | Focus next region |
| `X` | Remove region |
| `d` | Detach |
| `[` / `Esc` | Copy / scroll mode |
| `]` | Paste |
| `?` | Help |
| `:` | Command line |

## Common CLI options

| Option | Description |
|--------|-------------|
| `-S name` | Session name |
| `-dmS name cmd` | Start detached named session running `cmd` |
| `-ls` / `-list` | List sessions |
| `-r name` | Reattach |
| `-R` | Reattach if exists else create |
| `-d -r name` | Detach elsewhere then reattach here |
| `-x name` | Multi-display attach (share session) |
| `-X stuff '…'` | Send input to a session |
| `-wipe` | Remove dead session entries |

## Key Use Cases

1. Keep a shell alive across SSH drops on legacy hosts
2. Detached long runners where tmux is not installed
3. Sharing a session with `-x` for quick co-debugging
4. Rescue environments that ship `screen` only

## Examples with Explanations

### Example: create, detach, resume

```bash
screen -S deploy
# ... work ...
# Ctrl-a d
screen -ls
screen -r deploy
```

If only one detached session exists, `screen -r` is enough.

### Example: create-or-attach

```bash
screen -D -RR work
```

Aggressive “get me a session named work” pattern used in older docs; know it may detach others.

### Example: start detached command

```bash
screen -dmS train bash -lc 'python3 train.py 2>&1 | tee train.log'
screen -r train
```

`-dmS` = detached + create + name. Wrap with `bash -lc` when you need login profile or pipelines.

### Example: list and wipe zombies

```bash
screen -ls
screen -wipe
```

Dead sessions after crashes leave “Dead ???” entries; wipe cleans the registry.

### Example: multi-attach

```bash
screen -x deploy
```

Second terminal joins the same session (both see the same windows).

### Example: send commands from outside

```bash
screen -S deploy -X stuff 'systemctl status nginx^M'
```

`^M` is Enter. Fragile compared to real scripts — use for glue only.

### Example: log session output

Inside screen: `Ctrl-a H` toggles logging to `screenlog.n` in the cwd (default). Or start with:

```bash
screen -L -S logged
```

### Example: minimal `~/.screenrc`

```screen
startup_message off
defscrollback 10000
shell -$SHELL
# harder status line:
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W}%c %{g}]'
```

### Example: vertical split note

Classic `screen` was weak at tiling compared to tmux. Recent GNU screen supports vertical splits (`Ctrl-a |` when bound). If your Ubuntu version feels awkward for panes, that is a normal reason to switch to tmux.

## Safety

- Killing the wrong session loses unsaved editor buffers in that session.
- `screen -X` can inject input into interactive tools — dangerous on shared sessions.
- Multi-attach (`-x`) shares keystrokes; coordinate before typing production commands.
- Session sockets live under hard-to-guess paths but are still local privilege boundaries — do not relax directory permissions carelessly.

## Notes & Pitfalls

- **Prefix conflicts** with Emacs/readline Ctrl-a — muscle memory cost is the #1 complaint.
- Escape detachment: `Ctrl-a d` vs nested screen/ssh needs extra care (`Ctrl-a a d` patterns).
- Environment variable staleness after reattach (SSH_AUTH_SOCK) same class of problem as tmux.
- Prefer tmux for new documentation and training unless constrained.
- BusyBox or tiny systems may ship neither; fall back to `nohup`/`systemd`.

## Related Commands

- `tmux` — modern default multiplexer
- `byobu` — friendly wrapper (can use screen backend)
- `tmate` — remote pairing
- `abduco` / `dtach` — detach without windows
- `nohup` — minimal HUP immunity

## Additional Resources

- `man screen`
- `Ctrl-a ?` inside a session

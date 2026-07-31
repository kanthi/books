# tmux

## Overview
`tmux` is a terminal multiplexer: detachable sessions, windows, and panes. Prefer it over `nohup` for interactive long-lived work over SSH.

## Syntax
```bash
tmux [command] [options]
```

## Common Commands
```bash
tmux                    # new session
tmux new -s work
tmux ls
tmux attach -t work
tmux attach -d -t work  # detach others
tmux kill-session -t work
tmux new -d -s job './long.sh'
```

## Prefix
Default prefix: **Ctrl-b**, then key.

| Key | Action |
|-----|--------|
| `c` | New window |
| `,` | Rename window |
| `n` / `p` | Next/prev window |
| `"` | Split horizontal |
| `%` | Split vertical |
| `o` / arrows | Switch pane |
| `z` | Zoom pane |
| `d` | Detach |
| `x` | Kill pane |
| `[` | Copy/scroll mode |
| `?` | Key list |

## Config sketch (`~/.tmux.conf`)
```tmux
set -g mouse on
set -g history-limit 50000
set -g base-index 1
```

## Examples with Explanations
```bash
tmux new -s deploy
# Ctrl-b d
tmux ls
tmux a -t deploy
tmux new -d -s train 'python train.py > train.log 2>&1'
```

## Related Commands
- `screen` — older mux  
- `byobu` — profile wrapper  
- `systemd-run` — non-interactive services  
- `abduco` / `dtach` — minimal detach

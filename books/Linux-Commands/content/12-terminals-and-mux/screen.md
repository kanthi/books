# screen

## Overview
`screen` multiplexes terminal sessions: detach from SSH, reattach later, multiple windows. Older than `tmux` but still common on minimal servers.

## Syntax
```bash
screen [options] [command]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-S name` | Session name |
| `-ls` | List sessions |
| `-r name` | Reattach |
| `-d -r name` | Detach elsewhere then reattach |
| `-x` | Multi-attach |
| `-dmS name cmd` | Start detached |

Prefix key: **Ctrl-a** then command key.

## Essential keys (after Ctrl-a)
| Key | Action |
|-----|--------|
| `c` | New window |
| `n` / `p` | Next / prev |
| `"` | Window list |
| `A` | Rename window |
| `d` | Detach |
| `k` | Kill window |
| `|` / `S` | Split regions (version-dependent) |
| `?` | Help |
| `[` | Copy/scrollback mode |

## Examples with Explanations
```bash
screen -S deploy
# ... work ...
# Ctrl-a d
screen -ls
screen -r deploy
screen -dmS train ./long-job.sh
```

## Notes
- Config: `~/.screenrc`.  
- Prefer `tmux` for modern splits/scriptability unless screen is all you have.  
- Nested screen: `Ctrl-a a` sends prefix to inner.

## Related Commands
- `tmux` — modern default choice  
- `byobu` — wrapper  
- `nohup` / `systemd-run` — non-interactive longevity

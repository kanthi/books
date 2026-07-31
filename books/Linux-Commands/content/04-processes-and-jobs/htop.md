# htop

## Overview
`htop` is an interactive process viewer — a friendlier alternative to `top` with mouse support, trees, and easy filters. Install via `sudo apt install htop`.

## Syntax
```bash
htop [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d tenths` | Delay (tenths of a second) |
| `-u user` | Only this user |
| `-p PID,…` | Only these PIDs |
| `-t` / `--tree` | Tree view |
| `-C` | Monochrome |

## Useful keys
| Key | Action |
|-----|--------|
| `F1`/`h` | Help |
| `F2` | Setup (meters, columns) |
| `F3`/`/` | Search |
| `F4`/`\` | Filter |
| `F5` | Tree |
| `F6` | Sort column |
| `F9`/`k` | Kill (pick signal) |
| `F7`/`F8` | Nice − / + |
| `Space` | Tag |
| `u` | User filter |
| `H`/`K` | Hide user/kernel threads |
| `p` | Show full path |
| `q` | Quit |

## Examples with Explanations
```bash
htop
htop -u "$USER"
htop -p $(pgrep -d, nginx)
htop -t
```

## Tips
- Setup → display options: show CPU in “bar” or detailed numbers.  
- For scripts use `ps`/`pidstat`, not htop.  
- Alternatives: `btop`, `atop`.

## Related Commands
- `top` — always present  
- `ps` — snapshots  
- `vmstat` / `iostat` — subsystem stats

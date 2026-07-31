# killall

## Overview
`killall` sends a signal to all processes matching a **name**. Linux (psmisc) `killall` matches command names; some UNIX variants differ dangerously — always check `man killall` on the system.

## Syntax
```bash
killall [options] name...
```

## Common Options (psmisc)
| Option | Description |
|--------|-------------|
| `-i` | Interactive |
| `-I` | Case-insensitive |
| `-e` | Exact long names |
| `-u user` | Only user’s processes |
| `-s` / `--signal` | Signal name/number |
| `-v` | Verbose |
| `-w` | Wait for death |
| `-n` | No effect dry-ish (`-0` style exists via signal 0) |

## Safety
Prefer `pkill -x` / `systemctl` for precision. Confirm with `pgrep -a name` first. Do not use on multi-tenant hosts without filters.

## Examples with Explanations
```bash
pgrep -a firefox
killall -i firefox
killall -s HUP nginx
killall -u "$USER" myworker
killall -v -w myworker
```

## Related Commands
- `pkill` / `pgrep`  
- `kill`  
- `systemctl stop`

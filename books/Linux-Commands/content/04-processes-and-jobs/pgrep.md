# pgrep / pkill

## Overview
`pgrep` lists PIDs matching selection criteria; `pkill` sends signals to those processes. Both understand process names, users, and full command lines better than brittle `ps | grep` pipelines.

## Syntax
```bash
pgrep [options] pattern
pkill [options] pattern
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Show full command line (pgrep) |
| `-l` | List name and PID |
| `-u user` | Only this user |
| `-f` | Match full command line |
| `-x` | Exact name match |
| `-n / -o` | Newest / oldest only |
| `-signal` | Signal name or number (pkill) |
| `-c` | Count matches |

## Key Use Cases
1. Find PIDs by name for scripts
2. Signal groups of workers
3. Avoid `ps | grep` false positives
4. Operate on one user's processes only

## Safety
`pkill pattern` can match more than you expect — prefer `-x`, `-f` with a specific string, and `-u`. On production, prefer `systemctl stop/restart` for managed units.

## Examples with Explanations
### Find nginx worker PIDs
```bash
pgrep -a nginx
```
Names plus args; good sanity check before signaling.

### Exact name
```bash
pgrep -x sshd
```
Avoids matching `sshd-session` style names unless wanted.

### Graceful reload pattern
```bash
pkill -HUP nginx
# or: kill -HUP $(pgrep -x nginx | head -1)
```
SIGHUP is conventional for config reload when supported.

### Kill only your processes
```bash
pkill -u "$USER" -f "python train.py"
```
User filter reduces collateral damage on shared hosts.

### Count
```bash
pgrep -c -u www-data php-fpm
```
Useful in monitoring scripts.

## Notes & Pitfalls
- Both tools share selection flags; difference is list vs signal.
- Exit status 0 = match found, 1 = no match.

## Related Commands
- `ps` — rich process table
- `kill` / `killall` — signal by PID or name
- `pidof` — simple name→PID
- `systemctl` — prefer for supervised services

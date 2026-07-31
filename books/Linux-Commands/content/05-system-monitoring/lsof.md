# lsof

## Overview
`lsof` lists open files. On Linux, “files” include sockets, devices, and pipes — so it is essential for “who holds this port?” and “what files does this process have open?”.

## Syntax
```bash
lsof [options]
lsof -p PID
lsof -i :port
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p PID` | Files for a process |
| `-i` | Internet sockets (optional address/port filter) |
| `-iTCP:443 -sTCP:LISTEN` | Listening TCP on 443 |
| `-u user` | Files for a user |
| `+D dir` | Recurse directory (expensive) |
| `-n -P` | No DNS / no port name resolution (faster) |
| `-c name` | Command name prefix |

## Key Use Cases
1. Find process listening on a port
2. Debug deleted-but-open files filling disks
3. See files held by a stuck process
4. Audit network endpoints per process

## Examples with Explanations
### Who listens on port 22?
```bash
sudo lsof -nP -iTCP:22 -sTCP:LISTEN
```
Classic “what owns this port?” check (also see `ss -lntp`).

### Open files for a PID
```bash
sudo lsof -p $(pgrep -x nginx | head -1)
```
Configs, logs, and sockets held by that process.

### Deleted files still open
```bash
sudo lsof +L1 | grep deleted
# or: sudo lsof -nP | grep '(deleted)'
```
Process keeps space until close/restart — common disk-full mystery.

### Files under a mount
```bash
sudo lsof /var
```
See activity before unmount (`umount` busy).

### Network connections for a user
```bash
sudo lsof -u deploy -a -i
```
`-a` ANDs the filters.

## Notes & Pitfalls
- Often needs root for system-wide or other users’ processes.
- Heavy on huge systems; narrow with `-p`, `-i`, `-u`.

## Related Commands
- `ss` — modern socket statistics
- `fuser` — PIDs using a file/port
- `strace` — syscall-level view
- `lsof -i` vs `netstat` — prefer `ss` for sockets alone

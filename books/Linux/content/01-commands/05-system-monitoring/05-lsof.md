# lsof

## Overview

`lsof` lists **open files**. On Linux, “files” include regular files, directories, block/char devices, pipes, and **sockets** — so it answers both “what files does this process hold?” and “who has this port?”. Essential for busy `umount`, deleted-but-open disk space mysteries, and classic port ownership checks (modern alternative for sockets alone: `ss -lntp`).

## Syntax

```bash
lsof [options]
lsof -p PID
lsof -i :port
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p PID` | Files for process (comma-separated PIDs) |
| `-i` | Internet sockets; optional address/port filter |
| `-iTCP:443 -sTCP:LISTEN` | Listening TCP on 443 |
| `-u user` | Files for user |
| `-c name` | Command name prefix match |
| `+D dir` | Recurse directory (expensive) |
| `+f -- path` | Path as filesystem (busy mount checks) |
| `-n` | No host DNS resolution (faster) |
| `-P` | No port name resolution (show numbers) |
| `-a` | AND selections (default is often OR — easy footgun) |
| `-t` | PIDs only (for scripts/kill pipelines) |
| `-R` | Show parent PID |

## Key Use Cases

1. Who is listening on a TCP/UDP port?
2. Why is umount busy?
3. Deleted files still holding disk space
4. Audit files/sockets for a PID or user

## Examples with Explanations

### Who listens on port 22?

```bash
sudo lsof -nP -iTCP:22 -sTCP:LISTEN
# modern alternative focused on sockets:
ss -lntp | grep ':22'
```

`-nP` skips DNS and service names for speed and stable output.

### Open files for a PID

```bash
sudo lsof -p "$(pgrep -x nginx | head -1)"
sudo lsof -p 1234 -nP
```

Configs, logs, `.so` mappings, and sockets held by that process.

### Deleted files still open (disk full mystery)

```bash
sudo lsof +L1
sudo lsof -nP | grep '(deleted)'
# focus large ones:
sudo lsof +L1 | awk 'NR==1 || $7 ~ /[0-9]/ {print}' | head
```

A process can keep a deleted log open — `df` shows full, `du` does not account for it until restart/close.

### Files under a mount (before umount)

```bash
sudo lsof +f -- /mnt/data
sudo lsof /var
sudo fuser -vm /mnt/data
```

Identify shells (cwd), daemons, and lockers preventing `umount`.

### Network connections for a user

```bash
sudo lsof -u deploy -a -i
sudo lsof -a -u deploy -iTCP -sTCP:ESTABLISHED -nP
```

`-a` ANDs the filters — without it, `-u` and `-i` can OR and surprise you.

### Command name filter

```bash
sudo lsof -c python -nP
sudo lsof -c java -i -nP
```

Prefix match on the command column.

### PIDs only for scripting

```bash
sudo lsof -t -iTCP:8080 -sTCP:LISTEN
# careful:
# sudo kill "$(sudo lsof -t -iTCP:8080 -sTCP:LISTEN)"
```

### UNIX sockets / pipes (advanced)

```bash
sudo lsof -U | head
sudo lsof -p PID -a -U
```

Useful for local agent debugging (docker.sock, etc.).

## Understanding Output

Typical columns:

| Column | Meaning |
|--------|---------|
| `COMMAND` | Process name |
| `PID` | Process ID |
| `USER` | Owner |
| `FD` | File descriptor (`cwd`, `txt`, `mem`, `0u`, `1w`, `2u`, `DEL`, …) |
| `TYPE` | `REG`, `DIR`, `CHR`, `FIFO`, `IPv4`, `IPv6`, `unix`, … |
| `DEVICE` | Device numbers |
| `SIZE/OFF` | Size or offset |
| `NODE` | Inode / protocol node |
| `NAME` | Path, socket endpoint, or `(deleted)` |

FD suffixes: `r` read, `w` write, `u` read/write. `cwd` is current working directory — a common umount blocker when your shell sits on the mount.

## Notes & Pitfalls

- Root is required for other users’ processes and many sockets.
- Full-system `lsof` is expensive on busy hosts — narrow with `-p`, `-i`, `-u`, paths.
- Default combination of tests can be **OR**; use `-a` when you mean AND.
- Prefer `ss -lntp` for “what listens where?” when you only care about sockets.
- NFS and FUSE paths can hang lsof if the remote is stuck — try scoped queries first.
- Containers: run lsof in the same PID/mount namespace you care about (host vs container).

## Related Commands

- `ss` — modern socket statistics
- `fuser` — PIDs using a file, mount, or port
- `strace` — syscall-level open/connect trail
- `lsof` vs `netstat` — prefer `ss` for sockets-only
- `fuser -vm` / `findmnt` — umount busy workflow
- `ps` / `pgrep` — find PIDs before `lsof -p`

## Additional Resources

- `man lsof`
- `man ss`
- `man fuser`

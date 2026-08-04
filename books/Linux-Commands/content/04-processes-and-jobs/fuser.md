# fuser

## Overview

`fuser` lists PIDs using a file, mount point, or network port. It is a concise complement to **`lsof`**: faster for “who is blocking my umount?” and optional signaling of those processes.

## Syntax

```bash
fuser [options] name...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-v` | Verbose (USER, PID, ACCESS, COMMAND) |
| `-m` | Argument is a mount / filesystem |
| `-k` | Kill processes (default SIGKILL with `-k` alone on many builds—**confirm man**) |
| `-i` | Interactive confirm before kill |
| `-n tcp\|udp` | Namespace for ports |
| `-u` | Append user |
| `-4` / `-6` | Address family |
| `-M` | Check is a mountpoint |
| `signal` | e.g. `-TERM` before `-k` on some implementations |

Access codes (verbose): `c` current dir, `e` executable, `f` open file, `r` root dir, `m` mmap, etc.

## Key Use Cases

1. Find processes preventing `umount`
2. See who holds a TCP/UDP port
3. Signal processes holding a lock file

## Examples with Explanations

### Mount busy

```bash
sudo fuser -vm /mnt/data
sudo fuser -vm /mnt/data  # review
# last resort:
sudo fuser -kim /mnt/data  # interactive kill on mount
```

### Ports

```bash
sudo fuser -v 22/tcp
sudo fuser -v 8080/tcp
sudo fuser -n tcp 5432
```

Prefer also: `ss -ltnp | grep 8080`.

### Files

```bash
fuser -v /var/log/app.log
fuser -ki file.lock
```

### One-liner recipes

```bash
# Before umount
sudo fuser -vm /mnt && sudo umount /mnt

# Who owns this listening port?
sudo ss -ltnp | grep ':8080'
sudo fuser -v 8080/tcp
```

## Notes & Pitfalls

- **`-k` is destructive**—always `-v` first; prefer `-i`.
- Default signal behavior differs slightly by util-linux version—read `man fuser` on the host.
- Network namespace: ports need `tcp`/`udp` suffix or `-n`.
- Containers: fuser inside vs on host sees different process IDs/namespaces.

## 2026-relevant notes

- For listeners, **`ss -lntp`** is usually clearer than fuser alone.
- Combine with `lsof -t` for scripts that need PID lists.
- Lazy umount (`umount -l`) hides problems—fix the holders when possible.

## Related Commands

- `lsof` — detailed open files
- `ss` — sockets
- `umount` — detach mounts
- `fuser -k` vs `kill` — scope differs

## Additional Resources

- `man fuser`

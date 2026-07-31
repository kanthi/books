# fuser

## Overview
`fuser` identifies processes using files, mount points, or ports. Complementary to `lsof` with concise PID lists and optional signaling.

## Syntax
```bash
fuser [options] name...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` | Verbose (USER, PID, ACCESS, COMMAND) |
| `-m` | Name specifies a filesystem/mount |
| `-k` | Kill processes (SIGKILL by default with -k) |
| `-i` | Interactive confirm before kill |
| `-n tcp|udp` | Select namespace for ports |
| `80/tcp` | Port syntax example |

## Key Use Cases
1. Find who blocks unmount
2. See PIDs on a TCP port
3. Signal processes holding a file

## Safety
`-k` sends kill signals; always prefer `-iv` first on shared systems.

## Examples with Explanations
### Who uses a mount?
```bash
sudo fuser -vm /mnt/data
```
Verbose list before `umount`.

### Port holders
```bash
sudo fuser -v 22/tcp
```
Processes bound to SSH port.

### Interactive kill on a file
```bash
fuser -ki file.lock
```
Ask before signaling.

## Related Commands
- `lsof` — richer open-file detail
- `ss -lntp` — listeners
- `umount` — detach when idle

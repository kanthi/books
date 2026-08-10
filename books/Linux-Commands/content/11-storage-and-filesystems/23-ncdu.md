# ncdu

## Overview

`ncdu` (NCurses Disk Usage) is an interactive `du` for finding what consumes space. Faster feedback than reading raw `du` trees; great on full root filesystems.

```bash
sudo apt install ncdu
```

## Syntax

```bash
ncdu [options] [path]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-x` | One filesystem only |
| `-r` | Read-only (no delete) |
| `-o file` | Export scan |
| `-f file` | Load export |
| `-e` | Extended info (more stat calls) |
| `--exclude pattern` | Skip paths |

## Examples with Explanations

### Scan root (one FS)

```bash
sudo ncdu -x /
```

Navigate with arrows; `d` deletes (if not `-r`); `q` quits.

### Home directory

```bash
ncdu -x "$HOME"
```

### Export for later / remote analysis

```bash
sudo ncdu -x -o /tmp/root.ncdu /
ncdu -f /tmp/root.ncdu
```

## Notes & Pitfalls

- Needs read permission; use `sudo` for system trees.  
- Exclude bind mounts and huge network mounts with `-x` / `--exclude`.  
- Deleting from ncdu is still delete — careful on production.

## Related Commands

- `du` / `dust` / `duf` — other usage views  
- `df` — filesystem free space  
- `find` — age-based cleanup  

## Additional Resources

- `man ncdu`

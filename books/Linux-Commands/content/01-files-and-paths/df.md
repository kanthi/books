# df

## Overview
`df` reports filesystem disk space usage for mounted filesystems. Use it for “is the disk full?” before diving into per-directory `du`.

## Syntax
```bash
df [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human-readable powers of 1024 |
| `-H` | Powers of 1000 |
| `-T` | Print filesystem type |
| `-i` | Inode usage instead of blocks |
| `-l` | Local filesystems only |
| `--output=` | Select columns (GNU) |
| `-t type` / `-x type` | Include/exclude type |

## Examples with Explanations
### Human overview
```bash
df -h
df -hT
```

### Inodes exhausted?
```bash
df -ih
```
Many small files can fill inodes while `df -h` still shows free space.

### Specific path
```bash
df -h /var
df -h .
```
Shows the filesystem containing that path.

### Portable script columns
```bash
df -P / | tail -1
```

### Exclude tmpfs noise
```bash
df -h -x tmpfs -x devtmpfs
```

## Understanding Output
- **Size/Used/Avail/Use%** — block capacity  
- **Mounted on** — mountpoint  
- **100% Use** may still allow root-reserved space on ext*  

## Related Commands
- `du` — directory usage  
- `lsblk` — block devices  
- `findmnt` — mount table  
- `ncdu` — interactive du (if installed)

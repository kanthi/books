# du

## Overview
`du` estimates file space usage for files and directories. Essential for finding what is consuming disk after `df` shows a full filesystem.

## Syntax
```bash
du [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human-readable |
| `-s` | Summarize (total only) |
| `-a` | All files, not just dirs |
| `-c` | Grand total |
| `-d n` / `--max-depth=n` | Limit depth |
| `-x` | One filesystem |
| `-b` | Bytes |
| `--apparent-size` | Logical size vs allocated |

## Examples with Explanations
### Top-level breakdown
```bash
sudo du -h -d 1 /var 2>/dev/null | sort -h
```

### Largest children of current dir
```bash
du -h -d 1 . 2>/dev/null | sort -h | tail
```

### Summary of one tree
```bash
du -sh /var/log
```

### Stay on one mount
```bash
du -xhd 1 /
```

### Apparent size vs disk usage
```bash
du -h file.sparse
du -h --apparent-size file.sparse
```

### Combine with find for huge files
```bash
find /var -xdev -type f -size +100M -exec du -h {} + 2>/dev/null | sort -h | tail
```

## Notes & Pitfalls
- Permission denied dirs understate totals without `sudo`.
- Hard links can double-count depending on options/version.
- Prefer `ncdu` for interactive exploration when available.

## Related Commands
- `df` — filesystem free space  
- `ls -lS` — single directory sizes  
- `ncdu` / `dust` — modern UIs

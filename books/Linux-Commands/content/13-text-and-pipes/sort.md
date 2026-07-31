# sort

## Overview
`sort` orders lines of text. Combine with `uniq`, `cut`, and `awk` for classic data munging pipelines.

## Syntax
```bash
sort [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Numeric |
| `-h` | Human sizes (`2K`, `3G`) |
| `-r` | Reverse |
| `-u` | Unique (like sort\|uniq) |
| `-k F1[,F2]` | Key fields (1-based) |
| `-t CHAR` | Field separator |
| `-f` | Fold case |
| `-V` | Version sort |
| `-M` | Month names |
| `-s` | Stable |
| `-o file` | Output file (can be input) |
| `-c` / `-C` | Check sorted |
| `-m` | Merge already-sorted inputs |
| `-z` | NUL-terminated lines |
| `--parallel=N` | Parallel sort (GNU) |

## Examples with Explanations
```bash
sort names.txt
sort -n numbers.txt
sort -nr numbers.txt
sort -k2,2 file.txt
sort -t: -k3,3n /etc/passwd
sort -h sizes.txt
sort -u file.txt
sort -o file.txt file.txt
du -h | sort -h | tail
ps aux | sort -nrk 3 | head    # by %CPU column
```

### Locale
Sort order depends on `LC_COLLATE` / `LANG`. Use `LC_ALL=C sort` for byte order.

## Related Commands
- `uniq` — adjacent duplicates  
- `comm` — compare sorted files  
- `cut` / `awk` — fields  
- `shuf` — randomize

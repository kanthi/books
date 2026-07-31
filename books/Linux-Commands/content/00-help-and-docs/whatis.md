# whatis

## Overview
`whatis` prints single-line descriptions from the man-db whatis index. Use it when you want a one-sentence reminder of what a command is without opening the full manual. Same idea as `man -f`.

## Syntax
```bash
whatis [options] name...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-s list` | Only these sections (e.g. `1,8`) |
| `-l` | Long / multi-line when available |
| `-r` | Interpret name as regex (implementation-dependent) |
| `-w` | Wildcard match |

## Examples with Explanations
```bash
whatis ls
whatis passwd
whatis passwd chmod mount
whatis -s 5 passwd          # file format page, not the command
man -f ls                   # equivalent
```

### Missing database
If you see “nothing appropriate”:
```bash
sudo mandb
# or on some systems: sudo makewhatis
whatis ls
```

### Combine with type
```bash
type mount
whatis mount
man 8 mount
```

## Related Commands
- `apropos` / `man -k` — keyword search across descriptions  
- `man` — full page  
- `info` — Texinfo manuals  
- `command -v` / `type` — how the shell resolves a name

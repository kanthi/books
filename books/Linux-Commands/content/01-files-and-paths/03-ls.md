# ls

## Overview
`ls` lists directory contents. Combined with options for long format, sorting, and classification, it is the primary tool for inspecting the filesystem tree from the shell.

## Syntax
```bash
ls [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | Long format (mode, owner, size, mtime) |
| `-a` / `-A` | All (include `.`/`..`) / almost all (hide `.`/`..`) |
| `-h` | Human-readable sizes (with `-l`) |
| `-r` | Reverse sort |
| `-t` / `-S` | Sort by mtime / size |
| `-R` | Recursive |
| `-1` | One per line |
| `-d` | List directories themselves, not contents |
| `-F` | Classify (`/`, `*`, `@`, …) |
| `--color=auto` | Colorize |
| `-i` | Inode numbers |
| `-X` | Sort by extension |

## Examples with Explanations
### Everyday
```bash
ls
ls -la
ls -lah /var/log
```

### Sort by time / size
```bash
ls -lt          # newest first
ls -lt | head
ls -lS          # largest first
```

### Directories only
```bash
ls -d */
ls -ld /etc /var
```

### Recursive (prefer tree/find for big trees)
```bash
ls -R src | head
```

### One column for scripts
```bash
ls -1 *.md
```

### Inodes and classification
```bash
ls -li
ls -F
```

## Notes & Pitfalls
- Aliases often map `ls` to `ls --color=auto`; scripts should call `command ls` or `/bin/ls` if needed.
- Locale affects sort order.
- For recursive size, use `du` not `ls -R`.

## Related Commands
- `tree` — visual hierarchy  
- `find` — search criteria  
- `stat` — one-file metadata  
- `dir` / `vdir` — rare synonyms

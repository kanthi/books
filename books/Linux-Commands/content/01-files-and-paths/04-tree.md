# tree

## Overview

`tree` prints a directory hierarchy as an indented tree. It is excellent for quick structural overviews, documentation screenshots, and seeing project layout without a full recursive `ls`. Often an optional package (`sudo apt install tree` / `dnf install tree`).

For huge trees, limit depth (`-L`) and prune noisy dirs (`-I`). For size-oriented exploration, prefer `du`, `dust`, `duf`, or `ncdu`.

## Syntax

```bash
tree [options] [directory ...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-L n` | Max depth |
| `-a` | Include hidden files |
| `-d` | Directories only |
| `-f` | Print full path prefix for each entry |
| `-i` | No indentation lines (plain list with nesting) |
| `-h` | Human-readable sizes (with size options) |
| `-s` | Raw sizes |
| `--du` | Report directory sizes (when supported) |
| `-P pattern` | Include only matching files |
| `-I pattern` | Exclude pattern (often `|`-separated) |
| `-C` / `-n` | Color on / off |
| `-H url` | HTML output with base URL |
| `-J` / `-X` | JSON / XML (newer tree) |
| `--gitignore` | Honor `.gitignore` (newer tree) |
| `-p` / `-u` / `-g` | Permissions / user / group |
| `-D` | Show modified time |
| `--dirsfirst` | List directories before files |

## Examples with Explanations

### Shallow overview

```bash
tree -L 2
tree -L 3 /etc
tree -d -L 3 /etc/systemd
```

### Hide dependency / VCS noise

```bash
tree -I 'node_modules|.git|dist|target|.venv|__pycache__'
tree -L 2 -I 'node_modules|.git'
```

### Hidden files and permissions

```bash
tree -a -L 1 ~
tree -pug -L 2 /var/www
```

### Sizes

```bash
tree -h -L 2 --du        # if your tree supports --du
tree -h -L 1 /var
```

### Full paths and filtering

```bash
tree -f -L 2
tree -P '*.service' -L 3 /etc/systemd
tree -P '*.md' -I node_modules
```

### HTML report

```bash
tree -H '.' -L 2 -o /tmp/tree.html
# open /tmp/tree.html in a browser
```

### JSON for tooling (when available)

```bash
tree -J -L 2 > tree.json
```

### Compare with find / eza

```bash
tree -L 2
find . -maxdepth 2
eza -T -L 2              # modern ls alternative with tree mode
```

### Document a project layout

```bash
tree -L 2 -I '.git|node_modules' > STRUCTURE.txt
```

## Notes / Pitfalls

- Not installed by default on many minimal servers — package name is usually `tree`.
- Unbounded `tree` on `/` or large NFS shares is slow and noisy; always use `-L` / `-I`.
- Patterns for `-P`/`-I` are **not** full shell globs in all versions; check `man tree`.
- Color codes can break logs; use `-n` or redirect carefully.
- Do not treat `tree` as a security audit tool; it follows normal user permissions and may hide unreadable dirs.

## 2026-relevant notes

- Prefer `eza -T` or `lsd --tree` if you already use modern `ls` replacements; keep classic `tree` for portable docs.
- `--gitignore` support varies; upgrade `tree` or combine with `fd` for git-aware listing.
- In monorepos, generate shallow trees for READMEs rather than committing giant dumps.

## Related Commands

- `ls -R` — recursive list
- `find` — programmable walk and filters
- `eza -T` / `lsd --tree` — modern tree views
- `du` / `dust` / `ncdu` — size-oriented
- `fd` — fast file find with ignores

## Additional Resources

- `man tree`

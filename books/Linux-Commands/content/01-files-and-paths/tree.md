# tree

## Overview
`tree` prints a directory hierarchy as an indented tree. Optional package on many systems (`sudo apt install tree`).

## Syntax
```bash
tree [options] [directory...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-L n` | Max depth |
| `-a` | Include hidden |
| `-d` | Directories only |
| `-f` | Full paths |
| `-h` | Human sizes (with `-s`/`--du` variants) |
| `-I pattern` | Exclude pattern |
| `-P pattern` | Include only matching |
| `-C` | Color |
| `-H url` | HTML output |
| `--gitignore` | Honor gitignore (newer tree) |

## Examples with Explanations
```bash
tree -L 2
tree -d -L 3 /etc
tree -I 'node_modules|.git|dist'
tree -h -L 2 --du   # if supported
tree -a -L 1 ~
```

## Related Commands
- `ls -R` — recursive list  
- `find` — programmable walk  
- `ncdu` — size-oriented tree

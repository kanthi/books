# dust

## Overview
`dust` is an intuitive, visual replacement for `du` written in Rust. It presents directory sizes as a tree-based bar chart, allowing quick identification of large files and folders consuming disk space.

## Syntax
```bash
dust [options] [path...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d NUM`, `--depth NUM` | Limit directory depth traversal |
| `-n NUM`, `--number-of-lines NUM` | Limit output to top NUM lines |
| `-r`, `--reverse` | Reverse sort order |
| `-i`, `--ignore-hidden` | Do not include hidden files in calculations |
| `-e PATTERN`, `--filter PATTERN` | Exclude files matching regex pattern |

## Key Use Cases
1. Finding disk space hogs visually inside directory trees.
2. Limiting depth scans for faster directory analysis (`-d`).
3. Excluding temporary build folders from storage breakdown (`-e`).

## Examples with Explanations
### Example 1: Basic Usage
```bash
dust
```
Scans the current directory and renders a terminal bar chart of disk usage.

### Example 2: Depth Limit Scan
```bash
dust -d 2 /var/log
```
Analyzes disk usage under `/var/log` up to 2 directory levels deep.

## Related Commands
- `du` - Traditional disk usage estimator
- `ncdu` - Ncurses interactive disk usage analyzer
- `duf` - Modern disk space utility (`df` replacement)

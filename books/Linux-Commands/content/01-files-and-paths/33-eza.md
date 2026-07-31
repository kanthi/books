# eza

## Overview
`eza` is a modern, actively maintained replacement for `ls`. It provides color-coded output, file type icons, Git file status, tree views, and extended attribute visualization.

## Syntax
```bash
eza [options] [path...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l`, `--long` | Display extended file attributes and metadata |
| `-a`, `--all` | Show hidden dotfiles |
| `-T`, `--tree` | Recurse into directories as a visual tree |
| `--git` | Show Git status for tracked files |
| `--icons` | Render contextual file/directory icons |

## Key Use Cases
1. Inspecting file metadata with Git integration in local repos.
2. Generating quick file tree diagrams directly in the terminal.
3. Colorized directory browsing with human-readable sizes.

## Examples with Explanations
### Example 1: Detailed File Listing with Git Status
```bash
eza -la --git --icons
```
Lists all files (including hidden ones) with metadata, file icons, and Git modification flags.

### Example 2: Tree View
```bash
eza -T -L 2
```
Displays directory structure down to 2 levels deep as a tree.

## Related Commands
- `ls` - Standard POSIX directory listing tool
- `tree` - Recursive directory tree visualizer

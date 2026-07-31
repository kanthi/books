# procs

## Overview
`procs` is a modern replacement for `ps` written in Rust. It displays process information with syntax highlighting, human-readable units, tree views, and multi-column process search filters.

## Syntax
```bash
procs [options] [pattern]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t`, `--tree` | Display process list as a parent-child process tree |
| `-w`, `--watch` | Watch mode with live periodic updates |
| `--sortd KEY` | Sort processes descending by keyword (e.g. `cpu`, `mem`) |
| `-i`, `--insert COLUMN` | Insert additional metadata column (e.g., `user`, `group`, `tcp`) |

## Key Use Cases
1. Inspecting processes with automatic color highlights for different users and CPU usage.
2. Viewing process trees without needing complex `ps` flags.
3. Filtering process lists directly by keyword or port.

## Examples with Explanations
### Example 1: Basic Process Search
```bash
procs nginx
```
Displays all processes matching `nginx` with memory, CPU, and user information.

### Example 2: Tree View
```bash
procs --tree
```
Displays all running processes formatted in an easy-to-read process hierarchy tree.

## Related Commands
- `ps` - Standard process status utility
- `top` / `htop` - Interactive process viewers

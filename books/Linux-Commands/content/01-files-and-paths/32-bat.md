# bat

## Overview
`bat` is a modern cat clone with syntax highlighting, Git integration, line numbering, and automatic paging.

## Syntax
```bash
bat [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l`, `--language LANG` | Force syntax highlighting for a specific language |
| `-p`, `--plain` | Plain mode (disable line numbers, headers, and decorations) |
| `-A`, `--show-all` | Show non-printable characters (tabs, spaces, newlines) |
| `--diff` | Show only lines that have changed relative to the Git index |

## Key Use Cases
1. Reading source code files with auto-detected syntax coloring.
2. Viewing Git repository file changes directly in the shell.
3. Quick code inspection with line numbers.

## Examples with Explanations
### Example 1: View File with Syntax Highlighting
```bash
bat script.py
```
Displays `script.py` with automatic syntax highlighting and line numbers.

### Example 2: View Git Diff Context
```bash
bat --diff index.qmd
```
Displays `index.qmd` showing added/modified line markers from Git.

## Related Commands
- `cat` - Standard concatenation tool
- `less` - Terminal file pager

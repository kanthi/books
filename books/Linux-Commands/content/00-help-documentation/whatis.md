# whatis

## Overview
The `whatis` command displays one-line manual page descriptions. It's useful for quickly finding out what a command does without reading the full manual page.

## Syntax
```bash
whatis [options] name ...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Debug mode |
| `-v` | Verbose mode |
| `-w` | Match whole words only |
| `-r` | Use regex for matching |
| `-l` | List format output |
| `-s section` | Search only specified sections |
| `-m system` | Search alternate system |
| `--long` | Don't trim output to terminal width |

## Key Use Cases
1. Quick command reference
2. Command discovery
3. Brief command descriptions
4. Manual section lookup
5. Command verification

## Examples with Explanations
### Example 1: Basic Usage
```bash
whatis ls
```
Show description of ls command

### Example 2: Multiple Commands
```bash
whatis cp mv rm
```
Show descriptions for multiple commands

### Example 3: Regex Search
```bash
whatis -r '^zip.*'
```
Find all commands starting with 'zip'

## Understanding Output
Format:
```
command (section) - description
```
Example:
```
ls (1) - list directory contents
```

## Common Usage Patterns
1. Check command purpose:
   ```bash
   whatis command
   ```
2. Find related commands:
   ```bash
   whatis -w "*pdf*"
   ```
3. Search specific section:
   ```bash
   whatis -s 1 command
   ```

## Performance Analysis
- Fast command lookup
- Database-driven searches
- Regular expression support
- Section-specific searches
- Multiple command lookup

## Related Commands
- `man` - Full manual pages
- `apropos` - Search descriptions
- `info` - GNU info documentation
- `type` - Command type information
- `whereis` - Locate command binary

## Additional Resources
- [Linux Man Pages](https://linux.die.net/man/)
- [Manual Sections](https://en.wikipedia.org/wiki/Man_page#Manual_sections)
- [Command Documentation](https://www.kernel.org/doc/man-pages/)

# man

## Overview
The `man` command displays system reference manuals. It provides detailed documentation for commands, file formats, system calls, library functions, and more.

## Syntax
```bash
man [options] [section] page
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f` | Same as whatis |
| `-k` | Same as apropos |
| `-w` | Show manual file path |
| `-a` | Show all pages |
| `-K` | Search for string |
| `-l` | Local file |
| `-p pager` | Choose pager |
| `-t` | Format for printing |
| `-H browser` | HTML browser |
| `-S list` | Manual sections |
| `-M path` | Manual path |

## Manual Sections
| Section | Content |
|---------|----------|
| 1 | User commands |
| 2 | System calls |
| 3 | Library functions |
| 4 | Special files |
| 5 | File formats |
| 6 | Games |
| 7 | Miscellaneous |
| 8 | System administration |
| 9 | Kernel routines |

## Key Use Cases
1. Command reference
2. System documentation
3. Programming help
4. Configuration info
5. Troubleshooting

## Examples with Explanations
### Example 1: View Manual
```bash
man ls
```
Show ls command manual

### Example 2: Specific Section
```bash
man 5 passwd
```
Show passwd file format

### Example 3: Search Pages
```bash
man -k directory
```
Search for directory-related pages

## Common Usage Patterns
1. Quick reference:
   ```bash
   man command
   ```
2. Find command:
   ```bash
   man -k keyword
   ```
3. All sections:
   ```bash
   man -a command
   ```

## Navigation Commands
| Key | Action |
|-----|--------|
| `space` | Next page |
| `b` | Previous page |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `q` | Quit |

## Related Commands
- `info` - GNU documentation
- `apropos` - Search manuals
- `whatis` - One-line manual
- `manpath` - Manual path
- `less` - Page viewer

## Additional Resources
- [Man Manual](https://man7.org/linux/man-pages/man1/man.1.html)
- [Documentation Guide](https://www.cyberciti.biz/faq/linux-unix-man-command-examples/)
- [System Administration](https://www.tecmint.com/linux-man-command-examples/)

## Best Practices
1. Use sections
2. Search effectively
3. Read thoroughly
4. Take notes
5. Cross-reference

## Documentation Types
1. Commands
2. Configuration
3. Programming
4. System
5. Standards

## Troubleshooting
1. Missing pages
2. Display issues
3. Search problems
4. Path configuration
5. Language settings

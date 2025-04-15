# info

## Overview
The `info` command reads documentation in Info format. It provides a more detailed and structured alternative to man pages, primarily for GNU software.

## Syntax
```bash
info [options] [command]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Use all matching manuals |
| `-k` | Look up string |
| `-n` | Show specific node |
| `-f` | Specify Info file |
| `-w` | Show file location |
| `-h` | Show help |
| `-v` | Show version |
| `--index-search` | Search index |
| `--show-options` | Show options node |
| `--subnodes` | Recursively output |
| `--vi-keys` | Use vi-like keys |

## Navigation Keys
| Key | Action |
|-----|--------|
| `?` | List commands |
| `h` | Tutorial |
| `n` | Next node |
| `p` | Previous node |
| `u` | Up node |
| `l` | Last node |
| `[` | Beginning of node |
| `]` | End of node |
| `q` | Quit |
| `s` | Search |

## Key Use Cases
1. GNU documentation
2. Detailed manuals
3. Tutorial reading
4. Reference lookup
5. System learning

## Examples with Explanations
### Example 1: View Info
```bash
info ls
```
Show ls documentation

### Example 2: Search String
```bash
info --index-search="pattern"
```
Search in index

### Example 3: Show Options
```bash
info --show-options command
```
Display command options

## Common Usage Patterns
1. Basic viewing:
   ```bash
   info command
   ```
2. Specific node:
   ```bash
   info -n 'node' file
   ```
3. All nodes:
   ```bash
   info --subnodes file
   ```

## Menu Structure
1. Top node
2. Directory node
3. Menu items
4. Cross references
5. Navigation

## Related Commands
- `man` - Manual pages
- `pinfo` - Alternative viewer
- `apropos` - Search documentation
- `whatis` - Brief descriptions
- `texinfo` - Create Info files

## Additional Resources
- [Info Manual](https://www.gnu.org/software/texinfo/manual/info/)
- [GNU Documentation](https://www.gnu.org/manual/manual.html)
- [System Guide](https://www.tecmint.com/linux-info-command-examples/)

## Best Practices
1. Learn navigation
2. Use search
3. Follow menus
4. Read tutorials
5. Take notes

## Documentation Types
1. Programs
2. Libraries
3. Utilities
4. System
5. Tutorials

## Troubleshooting
1. Navigation issues
2. Display problems
3. Missing files
4. Search failures
5. Key bindings

# info

## Overview
The `info` command reads documentation in Info format. It provides a more detailed and structured documentation system than man pages, particularly for GNU software.

## Syntax
```bash
info [options] [command]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-k keyword` | Look up keyword in all indices |
| `-f file` | Specify Info file to read |
| `-n nodename` | Go to specific node |
| `-h` | Display help |
| `-w name` | Show which Info file documents name |
| `--show-options` | Go to command-line options node |
| `--subnodes` | Recursively output menu items |
| `--vi-keys` | Use vi-like key bindings |

## Key Use Cases
1. Read detailed GNU documentation
2. Navigate structured documentation
3. Search documentation
4. Find command options
5. Learn about GNU software

## Examples with Explanations
### Example 1: Basic Usage
```bash
info ls
```
Show documentation for ls command

### Example 2: Search Keyword
```bash
info --apropos=keyword
```
Search for keyword in all Info documents

### Example 3: Output All Nodes
```bash
info --subnodes ls > ls-info.txt
```
Save complete ls documentation to file

## Understanding Output
Navigation commands:
- `n`: Next node
- `p`: Previous node
- `u`: Up node
- `l`: Last node
- `d`: Directory node
- `t`: Top node
- `q`: Quit
- `h`: Help

## Common Usage Patterns
1. View command documentation:
   ```bash
   info command
   ```
2. Search in all documents:
   ```bash
   info --apropos="search term"
   ```
3. View specific section:
   ```bash
   info -n 'section name' command
   ```

## Performance Analysis
- Faster than web browsers
- More detailed than man pages
- Structured navigation
- Cross-referenced documentation
- Hypertext-like links

## Related Commands
- `man` - Display manual pages
- `help` - Show shell builtin help
- `whatis` - Display command descriptions
- `apropos` - Search manual pages

## Additional Resources
- [GNU Info Manual](https://www.gnu.org/software/texinfo/manual/info/)
- [Info vs Man](https://www.gnu.org/software/texinfo/manual/texinfo/html_node/Info-Files.html)
- [Texinfo Documentation](https://www.gnu.org/software/texinfo/)

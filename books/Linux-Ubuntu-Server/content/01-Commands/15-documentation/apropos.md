# apropos

## Overview
The `apropos` command searches the manual page names and descriptions for a specified keyword. It's useful for finding commands when you don't know their exact names.

## Syntax
```bash
apropos [options] keyword...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Match all keywords |
| `-e` | Use exact match |
| `-r` | Use regex pattern |
| `-s sections` | Search sections |
| `-l` | Long output format |
| `-w` | Show page locations |
| `-C` | Case sensitive |
| `-L locale` | Set locale |
| `-M path` | Set manual path |
| `-S` | Sort output |
| `-v` | Verbose output |

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
1. Command discovery
2. Function lookup
3. Documentation search
4. Topic exploration
5. Learning tools

## Examples with Explanations
### Example 1: Basic Search
```bash
apropos directory
```
Find directory-related commands

### Example 2: Multiple Keywords
```bash
apropos -a search file
```
Match all keywords

### Example 3: Exact Match
```bash
apropos -e chmod
```
Exact command match

## Common Usage Patterns
1. General search:
   ```bash
   apropos keyword
   ```
2. Section search:
   ```bash
   apropos -s 1 keyword
   ```
3. Regex search:
   ```bash
   apropos -r 'pattern'
   ```

## Search Tips
1. Use keywords
2. Try synonyms
3. Check sections
4. Use regex
5. Combine terms

## Related Commands
- `man` - Manual pages
- `whatis` - Command description
- `info` - GNU documentation
- `manpath` - Manual path
- `catman` - Create index

## Additional Resources
- [Apropos Manual](https://man7.org/linux/man-pages/man1/apropos.1.html)
- [Documentation Guide](https://www.cyberciti.biz/faq/linux-unix-apropos-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-apropos-command/)

## Best Practices
1. Be specific
2. Use options
3. Check all results
4. Verify matches
5. Document findings

## Output Format
1. Command name
2. Section number
3. Description
4. Manual path
5. Match context

## Troubleshooting
1. No matches
2. Too many results
3. Wrong section
4. Database issues
5. Locale problems

# whatis

## Overview
The `whatis` command displays one-line manual page descriptions. It searches the whatis database for complete words and shows brief descriptions of system commands.

## Syntax
```bash
whatis [options] keyword...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Debug mode |
| `-v` | Verbose output |
| `-r` | Regex search |
| `-w` | Wildcard search |
| `-s sections` | Search sections |
| `-l` | Long output |
| `-M path` | Set manual path |
| `-L locale` | Set locale |
| `--regex` | Use regex |
| `--wildcard` | Use wildcards |
| `--long` | Long format |

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
1. Quick reference
2. Command verification
3. Brief descriptions
4. Command learning
5. Documentation check

## Examples with Explanations
### Example 1: Basic Usage
```bash
whatis ls
```
Show ls command description

### Example 2: Multiple Commands
```bash
whatis cp mv rm
```
Show multiple descriptions

### Example 3: Wildcard Search
```bash
whatis -w "lp*"
```
Search with wildcard

## Common Usage Patterns
1. Single command:
   ```bash
   whatis command
   ```
2. Section search:
   ```bash
   whatis -s 1 command
   ```
3. Regex search:
   ```bash
   whatis -r pattern
   ```

## Search Tips
1. Use exact names
2. Try wildcards
3. Check sections
4. Multiple keywords
5. Verify results

## Related Commands
- `man` - Manual pages
- `apropos` - Search descriptions
- `info` - GNU documentation
- `mandb` - Create database
- `catman` - Format manuals

## Additional Resources
- [Whatis Manual](https://man7.org/linux/man-pages/man1/whatis.1.html)
- [Documentation Guide](https://www.cyberciti.biz/faq/linux-unix-whatis-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-whatis-command-examples/)

## Best Practices
1. Update database
2. Verify commands
3. Check sections
4. Document findings
5. Cross-reference

## Output Format
1. Command name
2. Section number
3. Brief description
4. Multiple matches
5. Error messages

## Troubleshooting
1. No matches
2. Database issues
3. Wrong section
4. Locale problems
5. Path configuration

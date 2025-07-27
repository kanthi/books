# grep

## Overview
The `grep` command searches input files for lines containing a match to a given pattern. It supports basic and extended regular expressions for pattern matching.

## Syntax
```bash
grep [options] pattern [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Ignore case |
| `-v` | Invert match |
| `-n` | Show line numbers |
| `-l` | List matching files |
| `-c` | Count matches |
| `-r` | Recursive search |
| `-w` | Match whole words |
| `-x` | Match whole lines |
| `-E` | Extended regex |
| `-F` | Fixed strings |
| `-A n` | After context |
| `-B n` | Before context |
| `-C n` | Context lines |

## Pattern Types
| Type | Description |
|------|-------------|
| Basic | Simple patterns |
| Extended | Advanced patterns |
| Fixed | Literal strings |
| Perl | Perl regex |

## Key Use Cases
1. Text search
2. Pattern matching
3. File filtering
4. Log analysis
5. Code search

## Examples with Explanations
### Example 1: Basic Search
```bash
grep "pattern" file
```
Search for pattern

### Example 2: Recursive Search
```bash
grep -r "pattern" directory/
```
Search in directory

### Example 3: Count Matches
```bash
grep -c "pattern" file
```
Count matching lines

## Common Usage Patterns
1. Case insensitive:
   ```bash
   grep -i "pattern" file
   ```
2. Multiple patterns:
   ```bash
   grep -e "pat1" -e "pat2" file
   ```
3. Context lines:
   ```bash
   grep -C 2 "pattern" file
   ```

## Regular Expressions
1. Character classes
2. Anchors
3. Quantifiers
4. Alternation
5. Grouping

## Related Commands
- `egrep` - Extended grep
- `fgrep` - Fixed strings
- `rgrep` - Recursive grep
- `zgrep` - Compressed files
- `pgrep` - Process grep

## Additional Resources
- [Grep Manual](https://www.gnu.org/software/grep/manual/grep.html)
- [Usage Guide](https://www.cyberciti.biz/faq/grep-command-examples/)
- [Pattern Matching](https://www.tecmint.com/linux-grep-command-examples/)

## Best Practices
1. Quote patterns
2. Use context
3. Check options
4. Verify matches
5. Document usage

## Performance Tips
1. Use fixed strings
2. Limit recursion
3. Exclude dirs
4. Buffer size
5. Parallel grep

## Troubleshooting
1. Pattern syntax
2. File permissions
3. Binary files
4. Character encoding
5. Memory usage

# sed

## Overview
The `sed` (Stream Editor) command is used to perform basic text transformations on an input stream. It's a powerful tool for parsing and transforming text using regular expressions.

## Syntax
```bash
sed [options] 'command' [input-file]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Suppress output |
| `-e script` | Add script |
| `-f file` | Add script file |
| `-i` | Edit files in place |
| `-r` | Extended regex |
| `-E` | Extended regex |
| `-s` | Separate files |
| `-l N` | Line length |
| `--debug` | Debug info |
| `--help` | Show help |
| `--version` | Show version |

## Common Commands
| Command | Description |
|---------|-------------|
| `p` | Print line |
| `d` | Delete line |
| `s/pat/rep/` | Substitute |
| `y/pat/rep/` | Transform chars |
| `i` | Insert text |
| `a` | Append text |
| `c` | Change line |
| `q` | Quit |
| `r file` | Read file |
| `w file` | Write to file |

## Key Use Cases
1. Text substitution
2. Line filtering
3. Text transformation
4. File editing
5. Data extraction

## Examples with Explanations
### Example 1: Basic Substitution
```bash
sed 's/old/new/' file
```
Replace first occurrence

### Example 2: Global Substitution
```bash
sed 's/old/new/g' file
```
Replace all occurrences

### Example 3: Delete Lines
```bash
sed '/pattern/d' file
```
Delete matching lines

## Common Usage Patterns
1. Multiple commands:
   ```bash
   sed -e 's/a/b/' -e 's/x/y/'
   ```
2. In-place edit:
   ```bash
   sed -i 's/old/new/g' file
   ```
3. Line range:
   ```bash
   sed '1,5s/old/new/' file
   ```

## Security Considerations
1. File permissions
2. Backup files
3. Regular expressions
4. Input validation
5. Command injection

## Related Commands
- `awk` - Pattern scanning
- `grep` - Pattern matching
- `tr` - Character translation
- `cut` - Select fields
- `perl` - Perl language

## Additional Resources
- [Sed Manual](https://www.gnu.org/software/sed/manual/sed.html)
- [Usage Guide](https://www.cyberciti.biz/faq/sed-command-examples/)
- [Text Processing](https://www.tecmint.com/linux-sed-command-tips-tricks/)

## Best Practices
1. Test commands
2. Use backups
3. Quote patterns
4. Document changes
5. Verify results

## Regular Expressions
1. Basic regex
2. Extended regex
3. Back references
4. Character classes
5. Anchors

## Troubleshooting
1. Pattern matching
2. File permissions
3. Backup issues
4. Syntax errors
5. Line endings

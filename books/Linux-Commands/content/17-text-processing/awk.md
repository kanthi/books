# awk

## Overview
The `awk` command is a powerful text processing language for pattern scanning and processing. It treats input as records and fields, making it ideal for structured text manipulation.

## Syntax
```bash
awk [options] 'program' [input-file]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-F fs` | Field separator |
| `-f file` | Program file |
| `-v var=val` | Set variable |
| `-W version` | Show version |
| `-W help` | Show help |
| `-W lint` | Check syntax |
| `-W exec` | Execute only |
| `-W compat` | Compatibility |
| `-W copyleft` | Show license |
| `-W usage` | Show usage |

## Built-in Variables
| Variable | Description |
|----------|-------------|
| `$0` | Entire line |
| `$1-$n` | Field number |
| `NF` | Number of fields |
| `NR` | Record number |
| `FS` | Field separator |
| `RS` | Record separator |
| `OFS` | Output field sep |
| `ORS` | Output record sep |
| `FILENAME` | Current file |
| `FNR` | File record number |

## Key Use Cases
1. Field processing
2. Text analysis
3. Report generation
4. Data extraction
5. File transformation

## Examples with Explanations
### Example 1: Print Fields
```bash
awk '{print $1, $3}' file
```
Print first and third fields

### Example 2: Field Separator
```bash
awk -F: '{print $1}' /etc/passwd
```
Print usernames from passwd

### Example 3: Pattern Match
```bash
awk '/pattern/ {print}' file
```
Print matching lines

## Common Usage Patterns
1. Sum column:
   ```bash
   awk '{sum += $1} END {print sum}'
   ```
2. Count matches:
   ```bash
   awk '/pattern/ {count++} END {print count}'
   ```
3. Format output:
   ```bash
   awk '{printf "%-10s %s\n", $1, $2}'
   ```

## Programming Features
1. Variables
2. Arrays
3. Functions
4. Control flow
5. Regular expressions

## Related Commands
- `sed` - Stream editor
- `grep` - Pattern matching
- `cut` - Select fields
- `tr` - Character translation
- `perl` - Perl language

## Additional Resources
- [Awk Manual](https://www.gnu.org/software/gawk/manual/)
- [Usage Guide](https://www.cyberciti.biz/faq/awk-command-examples/)
- [Text Processing](https://www.tecmint.com/learn-linux-awk-command-examples/)

## Best Practices
1. Use functions
2. Comment code
3. Test patterns
4. Handle errors
5. Document usage

## Common Functions
1. length()
2. substr()
3. index()
4. match()
5. split()

## Troubleshooting
1. Field separation
2. Pattern matching
3. Variable scope
4. Syntax errors
5. File handling

# tr

## Overview
The `tr` command translates or deletes characters from standard input, writing to standard output. It's useful for character-based transformations and basic text processing.

## Syntax
```bash
tr [options] set1 [set2]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Complement set1 |
| `-d` | Delete chars |
| `-s` | Squeeze repeats |
| `-t` | Truncate set1 |
| `--help` | Show help |
| `--version` | Show version |

## Character Sets
| Set | Description |
|-----|-------------|
| `[:alnum:]` | Letters and numbers |
| `[:alpha:]` | Letters |
| `[:blank:]` | Space and tab |
| `[:cntrl:]` | Control chars |
| `[:digit:]` | Digits |
| `[:graph:]` | Printable and visible |
| `[:lower:]` | Lowercase letters |
| `[:print:]` | Printable chars |
| `[:punct:]` | Punctuation |
| `[:space:]` | Whitespace |
| `[:upper:]` | Uppercase letters |
| `[:xdigit:]` | Hex digits |

## Key Use Cases
1. Case conversion
2. Character deletion
3. Space normalization
4. Line ending conversion
5. Basic encryption

## Examples with Explanations
### Example 1: Case Conversion
```bash
tr '[:lower:]' '[:upper:]'
```
Convert to uppercase

### Example 2: Delete Characters
```bash
tr -d '\n'
```
Remove newlines

### Example 3: Squeeze Spaces
```bash
tr -s ' '
```
Reduce multiple spaces

## Common Usage Patterns
1. Remove spaces:
   ```bash
   tr -d ' '
   ```
2. Convert case:
   ```bash
   tr 'A-Z' 'a-z'
   ```
3. Clean text:
   ```bash
   tr -cd '[:print:]'
   ```

## Translation Examples
1. DOS to Unix:
   ```bash
   tr -d '\r'
   ```
2. Rot13 encoding:
   ```bash
   tr 'A-Za-z' 'N-ZA-Mn-za-m'
   ```
3. Remove punctuation:
   ```bash
   tr -d '[:punct:]'
   ```

## Related Commands
- `sed` - Stream editor
- `awk` - Text processing
- `cut` - Select fields
- `fold` - Wrap text
- `expand` - Convert tabs

## Additional Resources
- [Tr Manual](https://www.gnu.org/software/coreutils/tr)
- [Usage Guide](https://www.cyberciti.biz/faq/linux-tr-command-examples/)
- [Text Processing](https://www.tecmint.com/linux-tr-command-examples/)

## Best Practices
1. Quote sets
2. Check input
3. Verify output
4. Document usage
5. Handle errors

## Common Transformations
1. Whitespace
2. Case conversion
3. Line endings
4. Special chars
5. Encoding

## Troubleshooting
1. Character sets
2. Input format
3. Output encoding
4. Set matching
5. Performance

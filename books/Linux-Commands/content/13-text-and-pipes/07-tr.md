# tr

## Overview
The `tr` (translate) command translates or deletes characters from standard input. It's used for character substitution, deletion, and squeezing repeated characters.

## Syntax
```bash
tr [options] set1 [set2]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Complement set1 |
| `-d` | Delete characters in set1 |
| `-s` | Squeeze repeated characters |
| `-t` | Truncate set1 to length of set2 |

## Character Sets
| Set | Description |
|-----|-------------|
| `[:alnum:]` | Alphanumeric characters |
| `[:alpha:]` | Alphabetic characters |
| `[:digit:]` | Digits 0-9 |
| `[:lower:]` | Lowercase letters |
| `[:upper:]` | Uppercase letters |
| `[:space:]` | Whitespace characters |
| `[:punct:]` | Punctuation characters |
| `[:print:]` | Printable characters |
| `[:cntrl:]` | Control characters |

## Key Use Cases
1. Case conversion
2. Character replacement
3. Delete unwanted characters
4. Format text data
5. Clean input data

## Examples with Explanations
### Example 1: Uppercase Conversion
```bash
echo "hello world" | tr '[:lower:]' '[:upper:]'
```
Output: `HELLO WORLD`

### Example 2: Delete Characters
```bash
echo "hello123world" | tr -d '[:digit:]'
```
Output: `helloworld`

### Example 3: Replace Characters
```bash
echo "hello world" | tr ' ' '_'
```
Output: `hello_world`

### Example 4: Squeeze Repeated Characters
```bash
echo "hello    world" | tr -s ' '
```
Output: `hello world`

## Common Usage Patterns
1. Convert to lowercase:
   ```bash
   echo "HELLO" | tr '[:upper:]' '[:lower:]'
   ```
2. Remove newlines:
   ```bash
   cat file.txt | tr -d '\n'
   ```
3. Replace multiple characters:
   ```bash
   echo "a,b;c:d" | tr ',;:' '   '
   ```

## Character Ranges
1. Letter ranges:
   ```bash
   echo "hello" | tr 'a-z' 'A-Z'
   ```
2. Number ranges:
   ```bash
   echo "123" | tr '1-3' 'abc'
   ```
3. Custom ranges:
   ```bash
   echo "hello" | tr 'helo' '1234'
   ```

## Advanced Usage
1. Complement sets:
   ```bash
   echo "hello123" | tr -cd '[:alpha:]'  # Keep only letters
   ```
2. Multiple operations:
   ```bash
   echo "Hello World" | tr '[:upper:]' '[:lower:]' | tr ' ' '_'
   ```
3. ROT13 encoding:
   ```bash
   echo "hello" | tr 'a-zA-Z' 'n-za-mN-ZA-M'
   ```

## Text Processing
1. Clean CSV data:
   ```bash
   cat data.csv | tr -d '"' | tr ',' '\t'
   ```
2. Format phone numbers:
   ```bash
   echo "1234567890" | tr '0-9' '(###) ###-####'
   ```
3. Remove control characters:
   ```bash
   cat file.txt | tr -d '[:cntrl:]'
   ```

## Performance Analysis
- Very fast character processing
- Stream-based operation
- Minimal memory usage
- Efficient for large files
- Good pipeline performance

## Related Commands
- `sed` - Stream editor
- `awk` - Text processing
- `cut` - Extract fields
- `sort` - Sort lines
- `uniq` - Remove duplicates

## Best Practices
1. Use character classes for portability
2. Test transformations on sample data
3. Combine with other text tools
4. Handle special characters carefully
5. Consider locale settings

## Data Cleaning
1. Remove punctuation:
   ```bash
   echo "Hello, World!" | tr -d '[:punct:]'
   ```
2. Normalize whitespace:
   ```bash
   echo "hello    world" | tr -s '[:space:]' ' '
   ```
3. Extract numbers:
   ```bash
   echo "abc123def456" | tr -cd '[:digit:]'
   ```

## File Processing
1. Convert line endings:
   ```bash
   tr -d '\r' < dos_file.txt > unix_file.txt
   ```
2. Create word list:
   ```bash
   cat text.txt | tr '[:space:][:punct:]' '\n' | tr -s '\n'
   ```
3. Count characters:
   ```bash
   cat file.txt | tr -cd '[:alpha:]' | wc -c
   ```

## Integration Examples
1. With find for filename processing:
   ```bash
   find . -name "*.txt" | tr '[:upper:]' '[:lower:]'
   ```
2. Log processing:
   ```bash
   tail -f access.log | tr ',' '\t' | cut -f1
   ```
3. Data format conversion:
   ```bash
   cat data.txt | tr ';' ',' > data.csv
   ```

## Scripting Applications
1. Input validation:
   ```bash
   validate_input() {
       echo "$1" | tr -cd '[:alnum:]' | grep -q . || return 1
   }
   ```
2. Password generation:
   ```bash
   generate_password() {
       tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12
   }
   ```

## Special Characters
1. Handle tabs:
   ```bash
   echo -e "hello\tworld" | tr '\t' ' '
   ```
2. Process escape sequences:
   ```bash
   echo "hello\nworld" | tr '\\' '/'
   ```
3. Unicode handling:
   ```bash
   echo "café" | tr 'é' 'e'
   ```

## Troubleshooting
1. Character encoding issues
2. Locale-specific behavior
3. Special character handling
4. Set length mismatches
5. Unexpected transformations

## Security Applications
1. Sanitize input:
   ```bash
   echo "$user_input" | tr -cd '[:alnum:]._-'
   ```
2. Remove dangerous characters:
   ```bash
   echo "$filename" | tr -d '/<>:|*?"\\'
   ```

## Performance Optimization
1. Use character classes:
   ```bash
   # Faster
   tr '[:lower:]' '[:upper:]'
   # Slower
   tr 'abcdefghijklmnopqrstuvwxyz' 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
   ```
2. Combine operations:
   ```bash
   # Single tr call is faster
   echo "Hello World" | tr '[:upper:] ' '[:lower:]_'
   ```

## Real-world Examples
1. Log analysis:
   ```bash
   grep ERROR /var/log/app.log | tr '[:upper:]' '[:lower:]' | sort | uniq -c
   ```
2. Data migration:
   ```bash
   cat old_format.txt | tr '|' ',' | tr -s ' ' > new_format.csv
   ```
3. Text normalization:
   ```bash
   cat document.txt | tr -s '[:space:]' ' ' | tr '[:upper:]' '[:lower:]'
   ```
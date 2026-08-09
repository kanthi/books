# head

## Overview
The `head` command displays the first lines of files or input streams. By default, it shows the first 10 lines, making it useful for previewing file contents.

## Syntax
```bash
head [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n num` | Show first num lines |
| `-c num` | Show first num bytes |
| `-q` | Suppress headers |
| `-v` | Always show headers |
| `-z` | Line delimiter is NUL |
| `--lines=num` | Same as -n |
| `--bytes=num` | Same as -c |

## Key Use Cases
1. Preview file contents
2. Extract file headers
3. Sample data examination
4. Log file monitoring
5. Quick file inspection

## Examples with Explanations
### Example 1: Default Usage
```bash
head file.txt
```
Shows first 10 lines of file

### Example 2: Specific Line Count
```bash
head -n 5 file.txt
```
Shows first 5 lines

### Example 3: Multiple Files
```bash
head -n 3 *.txt
```
Shows first 3 lines of each txt file

### Example 4: Byte Count
```bash
head -c 100 file.txt
```
Shows first 100 bytes

## Common Usage Patterns
1. Quick file preview:
   ```bash
   head -20 logfile.log
   ```
2. CSV header inspection:
   ```bash
   head -1 data.csv
   ```
3. Combined with tail:
   ```bash
   head -50 file.txt | tail -10
   ```

## Advanced Usage
1. Suppress filename headers:
   ```bash
   head -q file1.txt file2.txt
   ```
2. Always show headers:
   ```bash
   head -v file.txt
   ```
3. Process substitution:
   ```bash
   head -5 <(command)
   ```

## Performance Analysis
- Very fast for small line counts
- Efficient streaming operation
- Minimal memory usage
- Good for large files
- Stops reading after required lines

## Related Commands
- `tail` - Show last lines
- `more` - Page through files
- `less` - Advanced pager
- `cat` - Display entire file
- `sed` - Stream editor

## Best Practices
1. Use appropriate line counts
2. Combine with other text tools
3. Consider byte vs line counting
4. Use for quick file validation
5. Helpful for debugging scripts

## Integration Examples
1. Log analysis:
   ```bash
   head -100 /var/log/syslog | grep error
   ```
2. Data sampling:
   ```bash
   head -1000 large_dataset.csv > sample.csv
   ```
3. Script debugging:
   ```bash
   head -5 "$input_file" | while read line; do
       echo "Processing: $line"
   done
   ```

## Scripting Applications
1. File validation:
   ```bash
   if head -1 "$file" | grep -q "^#"; then
       echo "File has header"
   fi
   ```
2. Quick content check:
   ```bash
   head -n 1 *.conf | grep -v "^#"
   ```
## Additional Examples
```bash
head file.txt
head -n 50 file.txt
head -n -20 file.txt         # all but last 20 (GNU)
head -c 1K binary.dat
```

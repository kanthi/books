# wc

## Overview
The `wc` (word count) command counts lines, words, characters, and bytes in files or input streams. It's essential for text analysis and file statistics.

## Syntax
```bash
wc [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | Count lines only |
| `-w` | Count words only |
| `-c` | Count bytes only |
| `-m` | Count characters only |
| `-L` | Length of longest line |
| `--files0-from=file` | Read null-separated filenames |

## Default Output Format
Without options, `wc` shows:
```
lines words bytes filename
```

Example output:
```
  42  156  892 file.txt
```

## Key Use Cases
1. Count lines in files
2. Analyze text statistics
3. Monitor file growth
4. Validate data processing
5. Script automation

## Examples with Explanations
### Example 1: Basic Count
```bash
wc file.txt
```
Shows lines, words, and bytes count

### Example 2: Lines Only
```bash
wc -l file.txt
```
Shows only line count

### Example 3: Multiple Files
```bash
wc *.txt
```
Shows counts for all text files plus totals

## Understanding Counts
- **Lines**: Number of newline characters
- **Words**: Sequences of non-whitespace characters
- **Characters**: Including multibyte characters
- **Bytes**: Raw byte count (may differ from characters)

## Common Usage Patterns
1. Count log entries:
   ```bash
   wc -l /var/log/syslog
   ```
2. Monitor file growth:
   ```bash
   watch "wc -l growing_file.log"
   ```
3. Pipeline counting:
   ```bash
   ps aux | wc -l
   ```

## Advanced Usage
1. Longest line length:
   ```bash
   wc -L file.txt
   ```
2. Character vs byte count:
   ```bash
   wc -m file.txt  # characters
   wc -c file.txt  # bytes
   ```
3. Multiple file totals:
   ```bash
   wc -l *.log
   ```

## Pipeline Integration
1. Count command output:
   ```bash
   ls | wc -l
   ```
2. Count unique lines:
   ```bash
   sort file.txt | uniq | wc -l
   ```
3. Count pattern matches:
   ```bash
   grep "error" log.txt | wc -l
   ```

## Performance Analysis
- Very fast operation
- Efficient for large files
- Minimal memory usage
- Good pipeline performance
- Streaming capability

## Related Commands
- `nl` - Number lines
- `sort` - Sort lines
- `uniq` - Remove duplicates
- `cut` - Extract fields
- `awk` - Text processing

## Additional Resources
- [GNU wc manual](https://www.gnu.org/software/coreutils/manual/html_node/wc-invocation.html)
- [Word Count Examples](https://www.tecmint.com/wc-command-examples/)

## Best Practices
1. Use specific options for clarity
2. Combine with other text tools
3. Consider character encoding
4. Use in scripts for validation
5. Monitor with watch for real-time updates

## Scripting Examples
1. File size validation:
   ```bash
   if [ $(wc -l < file.txt) -gt 1000 ]; then
       echo "File too large"
   fi
   ```
2. Progress monitoring:
   ```bash
   TOTAL=$(wc -l < input.txt)
   echo "Processing $TOTAL lines"
   ```
3. Log rotation trigger:
   ```bash
   [ $(wc -l < logfile) -gt 10000 ] && logrotate config
   ```

## Character Encoding
Difference between `-c` and `-m`:
- `-c` counts bytes
- `-m` counts characters (important for UTF-8)

Example with Unicode:
```bash
echo "café" | wc -c  # 5 bytes
echo "café" | wc -m  # 4 characters
```

## Common Patterns
1. Count non-empty lines:
   ```bash
   grep -c "." file.txt
   ```
2. Count files in directory:
   ```bash
   ls -1 | wc -l
   ```
3. Count unique users:
   ```bash
   cut -d: -f1 /etc/passwd | wc -l
   ```

## Integration Examples
1. With find:
   ```bash
   find . -name "*.py" -exec wc -l {} + | tail -1
   ```
2. With xargs:
   ```bash
   find . -name "*.txt" | xargs wc -l
   ```
3. Log analysis:
   ```bash
   tail -f access.log | while read line; do
       echo "Total requests: $(wc -l < access.log)"
   done
   ```

## Troubleshooting
1. Binary files giving unexpected results
2. Character encoding issues
3. Very large files
4. Empty files
5. Permission problems

## Real-world Applications
1. Code metrics:
   ```bash
   find . -name "*.py" | xargs wc -l | tail -1
   ```
2. Data validation:
   ```bash
   [ $(wc -l < data.csv) -eq $(wc -l < expected.csv) ]
   ```
3. Monitoring:
   ```bash
   wc -l /var/log/messages | awk '{print $1}' > line_count.txt
   ```
# uniq

## Overview
The `uniq` command filters out repeated lines in a file or input stream. It works on adjacent duplicate lines, so input is typically sorted first.

## Syntax
```bash
uniq [options] [input [output]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Count occurrences |
| `-d` | Show duplicates only |
| `-u` | Show unique lines only |
| `-i` | Ignore case |
| `-f n` | Skip first n fields |
| `-s n` | Skip first n characters |
| `-w n` | Compare first n characters |
| `--group` | Group adjacent lines |

## Key Use Cases
1. Remove duplicate lines
2. Count line occurrences
3. Find unique entries
4. Data deduplication
5. Log analysis

## Examples with Explanations
### Example 1: Remove Duplicates
```bash
sort file.txt | uniq
```
Removes adjacent duplicate lines

### Example 2: Count Occurrences
```bash
sort file.txt | uniq -c
```
Shows count of each unique line

### Example 3: Show Only Duplicates
```bash
sort file.txt | uniq -d
```
Shows only lines that appear multiple times

## Understanding Behavior
Important notes:
- Only removes adjacent duplicates
- Usually used with `sort` first
- Case-sensitive by default
- Compares entire lines unless specified

## Common Usage Patterns
1. Deduplicate sorted data:
   ```bash
   sort data.txt | uniq > clean.txt
   ```
2. Find most common entries:
   ```bash
   sort file.txt | uniq -c | sort -nr
   ```
3. Case-insensitive deduplication:
   ```bash
   sort file.txt | uniq -i
   ```

## Field-Based Operations
1. Skip fields:
   ```bash
   uniq -f 2 file.txt
   ```
2. Skip characters:
   ```bash
   uniq -s 5 file.txt
   ```
3. Compare specific width:
   ```bash
   uniq -w 10 file.txt
   ```

## Advanced Usage
1. Group similar lines:
   ```bash
   sort file.txt | uniq --group
   ```
2. Show unique only:
   ```bash
   sort file.txt | uniq -u
   ```
3. Complex counting:
   ```bash
   sort file.txt | uniq -c | awk '$1 > 5'
   ```

## Performance Analysis
- Very fast operation
- Memory usage minimal
- Works well with large files
- Streaming operation (doesn't load entire file)
- Efficient for pipeline processing

## Related Commands
- `sort` - Sort lines
- `comm` - Compare sorted files
- `join` - Join lines
- `cut` - Extract fields
- `awk` - Text processing

## Additional Resources
- [GNU uniq manual](https://www.gnu.org/software/coreutils/manual/html_node/uniq-invocation.html)
- [Uniq Command Examples](https://www.tecmint.com/uniq-command-examples/)

## Best Practices
1. Always sort input first
2. Use with other text processing tools
3. Consider case sensitivity needs
4. Test field/character skipping carefully
5. Use counting for analysis

## Common Patterns
1. Top 10 most frequent:
   ```bash
   sort file.txt | uniq -c | sort -nr | head -10
   ```
2. Find unique IPs in log:
   ```bash
   awk '{print $1}' access.log | sort | uniq
   ```
3. Remove blank line duplicates:
   ```bash
   sort file.txt | uniq | grep -v '^$'
   ```

## Integration Examples
1. With grep:
   ```bash
   grep "pattern" *.log | sort | uniq -c
   ```
2. With cut:
   ```bash
   cut -d',' -f1 data.csv | sort | uniq
   ```
3. Log analysis:
   ```bash
   tail -f access.log | sort | uniq -c
   ```

## Troubleshooting
1. Duplicates not removed (need sort first)
2. Case sensitivity issues
3. Field counting problems
4. Character encoding issues
5. Large file processing
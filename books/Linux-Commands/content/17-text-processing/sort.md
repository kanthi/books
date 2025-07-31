# sort

## Overview
The `sort` command sorts lines of text files or standard input. It provides various sorting options including numeric, alphabetic, and custom field-based sorting.

## Syntax
```bash
sort [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Numeric sort |
| `-r` | Reverse order |
| `-u` | Unique lines only |
| `-f` | Ignore case |
| `-k field` | Sort by field |
| `-t char` | Field separator |
| `-o file` | Output to file |
| `-c` | Check if sorted |
| `-m` | Merge sorted files |
| `-s` | Stable sort |
| `-R` | Random sort |
| `-h` | Human numeric sort |

## Sort Types
| Type | Description |
|------|-------------|
| Alphabetic | Default text sorting |
| Numeric | Numerical value sorting |
| Human | Human-readable numbers (1K, 2M) |
| Month | Month name sorting |
| Version | Version number sorting |
| Random | Random order |

## Key Use Cases
1. Sort text files
2. Organize data
3. Remove duplicates
4. Prepare data for processing
5. System administration tasks

## Examples with Explanations
### Example 1: Basic Sort
```bash
sort file.txt
```
Sorts lines alphabetically

### Example 2: Numeric Sort
```bash
sort -n numbers.txt
```
Sorts numbers in numerical order

### Example 3: Sort by Field
```bash
sort -k 2 -t ',' data.csv
```
Sorts CSV by second field

## Field-Based Sorting
Specify fields using `-k`:
- `-k 2` - Sort by field 2
- `-k 2,4` - Sort by fields 2 through 4
- `-k 2n` - Numeric sort on field 2
- `-k 2r` - Reverse sort on field 2

## Common Usage Patterns
1. Remove duplicates:
   ```bash
   sort -u file.txt
   ```
2. Sort and save:
   ```bash
   sort file.txt -o sorted.txt
   ```
3. Multiple field sort:
   ```bash
   sort -k 1,1 -k 2n file.txt
   ```

## Advanced Sorting
1. Case-insensitive:
   ```bash
   sort -f file.txt
   ```
2. Reverse numeric:
   ```bash
   sort -nr file.txt
   ```
3. Month sorting:
   ```bash
   sort -M months.txt
   ```

## Performance Analysis
- Memory usage increases with file size
- External sorting for large files
- Use `-S` to specify buffer size
- Consider using `--parallel` for multi-core systems
- Temporary files created for large sorts

## Related Commands
- `uniq` - Remove duplicates
- `cut` - Extract fields
- `awk` - Text processing
- `join` - Join sorted files
- `comm` - Compare sorted files

## Additional Resources
- [GNU sort manual](https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html)
- [Sort Command Examples](https://www.tecmint.com/sort-command-linux/)

## Best Practices
1. Use appropriate sort type
2. Specify field separators clearly
3. Test with small datasets first
4. Consider memory limitations
5. Use stable sort when needed

## Locale Considerations
- Sorting affected by locale settings
- Use `LC_ALL=C` for consistent results
- Consider character encoding
- Collation rules vary by locale

## Troubleshooting
1. Unexpected sort order
2. Memory limitations
3. Field separator issues
4. Locale-related problems
5. Large file handling

## Integration Examples
1. With pipes:
   ```bash
   cat file.txt | sort | uniq
   ```
2. With find:
   ```bash
   find . -name "*.txt" | sort
   ```
3. Log analysis:
   ```bash
   sort -k 4 -t ' ' access.log
   ```
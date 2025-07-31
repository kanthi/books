# basename

## Overview
The `basename` command strips directory and suffix from filenames, returning just the filename portion of a path. It's essential for path manipulation in scripts.

## Syntax
```bash
basename name [suffix]
basename option... name...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Support multiple arguments |
| `-s suffix` | Remove trailing suffix |
| `-z` | End output with NUL character |

## Key Use Cases
1. Extract filename from path
2. Remove file extensions
3. Script path manipulation
4. Batch file processing
5. Log file naming

## Examples with Explanations
### Example 1: Basic Usage
```bash
basename /path/to/file.txt
```
Returns: `file.txt`

### Example 2: Remove Extension
```bash
basename /path/to/file.txt .txt
```
Returns: `file`

### Example 3: Multiple Files
```bash
basename -a /path/file1.txt /other/file2.log
```
Returns: `file1.txt` and `file2.log`

## Common Usage Patterns
1. Script naming:
   ```bash
   SCRIPT_NAME=$(basename "$0")
   ```
2. Remove extensions:
   ```bash
   basename "$file" .conf
   ```
3. Process multiple files:
   ```bash
   for file in *.txt; do
       name=$(basename "$file" .txt)
       echo "Processing: $name"
   done
   ```

## Related Commands
- `dirname` - Extract directory path
- `realpath` - Get absolute path
- `pathchk` - Check path validity

## Best Practices
1. Quote variables to handle spaces
2. Use with dirname for complete path manipulation
3. Consider using parameter expansion as alternative
4. Test with edge cases (empty paths, root directory)

## Integration Examples
1. Backup script:
   ```bash
   backup_name="backup-$(basename "$PWD")-$(date +%Y%m%d)"
   ```
2. Log rotation:
   ```bash
   logname=$(basename "$logfile" .log)
   mv "$logfile" "${logname}-$(date +%Y%m%d).log"
   ```
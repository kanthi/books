# dirname

## Overview
The `dirname` command strips the last component from file names, returning the directory path portion. It's the complement to `basename` for path manipulation.

## Syntax
```bash
dirname name...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-z` | End output with NUL character |

## Key Use Cases
1. Extract directory path
2. Script directory detection
3. Relative path calculation
4. File organization
5. Path validation

## Examples with Explanations
### Example 1: Basic Usage
```bash
dirname /path/to/file.txt
```
Returns: `/path/to`

### Example 2: Current Directory
```bash
dirname file.txt
```
Returns: `.`

### Example 3: Script Directory
```bash
SCRIPT_DIR=$(dirname "$0")
```
Gets the directory containing the script

## Common Usage Patterns
1. Change to script directory:
   ```bash
   cd "$(dirname "$0")"
   ```
2. Create parent directories:
   ```bash
   mkdir -p "$(dirname "$target_file")"
   ```
3. Relative path operations:
   ```bash
   parent_dir=$(dirname "$PWD")
   ```

## Related Commands
- `basename` - Extract filename
- `realpath` - Get absolute path
- `readlink` - Read symbolic links

## Best Practices
1. Quote paths to handle spaces
2. Use with basename for complete path parsing
3. Consider absolute vs relative paths
4. Handle edge cases (root directory, current directory)

## Integration Examples
1. Backup to parent directory:
   ```bash
   backup_dir="$(dirname "$PWD")/backups"
   ```
2. Config file location:
   ```bash
   config_dir="$(dirname "$0")/config"
   ```
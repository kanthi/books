# realpath

## Overview
The `realpath` command prints the resolved absolute path by resolving symbolic links and relative path components like `.` and `..`.

## Syntax
```bash
realpath [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-e` | All components must exist |
| `-m` | No components need exist |
| `-L` | Resolve symbolic links |
| `-P` | Don't resolve symbolic links |
| `-q` | Suppress error messages |
| `-s` | Don't expand symbolic links |
| `-z` | End output with NUL |
| `--relative-to=dir` | Print relative path |
| `--relative-base=dir` | Print absolute unless under base |

## Key Use Cases
1. Resolve absolute paths
2. Canonical path determination
3. Symbolic link resolution
4. Script portability
5. Path normalization

## Examples with Explanations
### Example 1: Basic Usage
```bash
realpath ../file.txt
```
Returns absolute path of the file

### Example 2: Relative Path
```bash
realpath --relative-to=/home/user /home/user/docs/file.txt
```
Returns: `docs/file.txt`

### Example 3: Multiple Files
```bash
realpath *.txt
```
Returns absolute paths for all txt files

## Common Usage Patterns
1. Script location:
   ```bash
   SCRIPT_PATH=$(realpath "$0")
   SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
   ```
2. Canonical comparison:
   ```bash
   if [ "$(realpath file1)" = "$(realpath file2)" ]; then
       echo "Same file"
   fi
   ```
3. Relative path calculation:
   ```bash
   realpath --relative-to="$PWD" /absolute/path
   ```

## Related Commands
- `readlink` - Read symbolic links
- `basename` - Extract filename
- `dirname` - Extract directory
- `pwd` - Print working directory

## Best Practices
1. Use for portable path handling
2. Check if files exist when needed
3. Handle symbolic links appropriately
4. Consider relative vs absolute needs
5. Quote paths with spaces

## Integration Examples
1. Config file resolution:
   ```bash
   CONFIG=$(realpath "${CONFIG_FILE:-./config.conf}")
   ```
2. Backup path calculation:
   ```bash
   BACKUP_PATH=$(realpath "$HOME/../backups")
   ```
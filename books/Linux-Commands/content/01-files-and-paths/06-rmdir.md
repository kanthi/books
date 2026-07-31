# rmdir

## Overview
The `rmdir` command removes empty directories. It's a safer alternative to `rm -r` as it only removes directories that contain no files or subdirectories.

## Syntax
```bash
rmdir [options] directory...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p` | Remove directory and its ancestors |
| `--ignore-fail-on-non-empty` | Ignore directories containing files |
| `-v` | Verbose mode |
| `--parents` | Remove directory and its ancestors |
| `--help` | Display help message |
| `--version` | Output version information |

## Key Use Cases
1. Remove empty directories
2. Clean up directory structure
3. Remove directory hierarchies
4. Safe directory removal
5. Directory structure verification

## Examples with Explanations
### Example 1: Basic Usage
```bash
rmdir empty_directory
```
Remove a single empty directory

### Example 2: Remove Parent Directories
```bash
rmdir -p parent/child/grandchild
```
Remove nested empty directories

### Example 3: Verbose Removal
```bash
rmdir -v directory
```
Show what's being done

## Understanding Output
- No output by default
- With -v:
  - 'rmdir: removing directory, directory_name'
- Error messages for:
  - Directory not empty
  - No such file or directory
  - Permission denied
  - Not a directory

## Common Usage Patterns
1. Remove multiple directories:
   ```bash
   rmdir dir1 dir2 dir3
   ```
2. Remove directory tree:
   ```bash
   rmdir -p a/b/c
   ```
3. Check if empty:
   ```bash
   rmdir directory 2>/dev/null
   ```

## Performance Analysis
- Fast operation
- Directory entry updates
- Parent directory modification
- Permission checking
- Error handling overhead

## Related Commands
- `rm` - Remove files/directories
- `mkdir` - Create directories
- `find` - Find and remove
- `ls` - List directory contents
- `pwd` - Print working directory

## Additional Resources
- [GNU Coreutils - rmdir](https://www.gnu.org/software/coreutils/manual/html_node/rmdir-invocation.html)
- [Linux Directory Management](https://tldp.org/LDP/intro-linux/html/sect_03_03.html)
- [Directory Operations Guide](https://www.tecmint.com/linux-rmdir-command-examples/)

## Safety Features
- Only removes empty directories
- Prevents accidental deletion of files
- Can remove directory hierarchies safely
- Provides clear error messages
- No force option available

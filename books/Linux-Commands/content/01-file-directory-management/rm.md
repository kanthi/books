# rm

## Overview
The `rm` (remove) command deletes files and directories. It's a powerful command that can recursively remove directory trees and includes safety features to prevent accidental deletions.

## Syntax
```bash
rm [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r, -R` | Remove directories recursively |
| `-f` | Force removal (no prompting) |
| `-i` | Interactive (prompt before removal) |
| `-I` | Prompt once before removing many files |
| `-d` | Remove empty directories |
| `-v` | Verbose mode |
| `--preserve-root` | Do not remove '/' (default) |
| `--one-file-system` | Stay on one filesystem |
| `--no-preserve-root` | Allow removing '/' |

## Key Use Cases
1. Delete files
2. Remove directories
3. Clean up temporary files
4. Batch file deletion
5. System cleanup

## Examples with Explanations
### Example 1: Remove File
```bash
rm file
```
Delete a single file

### Example 2: Remove Directory
```bash
rm -r directory
```
Remove directory and contents

### Example 3: Safe Remove
```bash
rm -i file
```
Remove with confirmation prompt

## Understanding Output
- No output by default
- With -v:
  - 'removed file' messages
- Error messages for:
  - Permission denied
  - No such file
  - Directory not empty
  - Operation not permitted

## Common Usage Patterns
1. Safe recursive removal:
   ```bash
   rm -ri directory/
   ```
2. Force removal:
   ```bash
   rm -f file
   ```
3. Remove empty directories:
   ```bash
   rm -d empty_dir/
   ```

## Performance Analysis
- Directory entry updates
- Inode management
- Filesystem considerations
- Large directory impact
- Security implications

## Related Commands
- `rmdir` - Remove empty directories
- `shred` - Secure file deletion
- `unlink` - Remove one file
- `find` - Find and remove
- `trash` - Move to trash

## Additional Resources
- [GNU Coreutils - rm](https://www.gnu.org/software/coreutils/manual/html_node/rm-invocation.html)
- [Linux File Deletion](https://tldp.org/LDP/intro-linux/html/sect_03_03.html)
- [Safe File Removal](https://www.tecmint.com/linux-rm-command-examples/)

## Safety Warning
⚠️ Use `rm` with caution:
- Always verify the files to be deleted
- Use -i for interactive mode
- Be extremely careful with -r and -f
- Consider using trash instead
- Never run rm -rf / or similar commands

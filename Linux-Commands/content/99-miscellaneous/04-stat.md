# stat

## Overview
The `stat` command displays detailed information about files or file systems. It shows file attributes such as size, permissions, timestamps, inode information, and more.

## Syntax
```bash
stat [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f` | Display file system status instead of file status |
| `-L` | Follow links (show information about the linked file) |
| `-c FORMAT` | Use custom format for output |
| `--printf=FORMAT` | Like -c, but interpret backslash escapes |
| `-t` | Print information in terse form |
| `--format=FORMAT` | Use specified FORMAT instead of default |

## Key Use Cases
1. View detailed file metadata and timestamps
2. Check file system information
3. Get inode information
4. Format output for scripting
5. Check file permissions and ownership details

## Examples with Explanations
### Example 1: Basic Usage
```bash
stat filename.txt
```
Shows complete information about filename.txt including size, permissions, timestamps, and inode details.

### Example 2: Custom Format
```bash
stat -c "%n %s %y" filename.txt
```
Shows only the filename (%n), size (%s), and last modification time (%y).

### Example 3: File System Information
```bash
stat -f /home
```
Displays information about the file system containing /home.

## Understanding Output
The default output includes:
- File name and type
- Size in bytes
- Block size and blocks allocated
- Device ID and Inode number
- Links count
- Access permissions
- UID/GID
- Access time (atime)
- Modification time (mtime)
- Change time (ctime)
- Birth time (if available)

## Common Usage Patterns
- Use `-f` when you need file system information
- Use `-c` with format strings for scripting
- Use `-L` when working with symbolic links
- Combine with `find` for batch file information

## Performance Analysis
- Minimal system impact for single files
- Can be resource-intensive when used with many files
- Consider using `ls -l` for basic information when full details aren't needed

## Related Commands
- `ls` - List directory contents with basic file information
- `file` - Determine file type
- `du` - Estimate file space usage
- `df` - Report file system disk space usage

## Additional Resources
- [Man Page](https://man7.org/linux/man-pages/man1/stat.1.html)
- [GNU Coreutils Documentation](https://www.gnu.org/software/coreutils/manual/html_node/stat-invocation.html)
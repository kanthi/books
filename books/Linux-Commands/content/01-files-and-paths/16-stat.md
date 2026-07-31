# stat

## Overview
The `stat` command displays detailed information about files and filesystems, including permissions, timestamps, size, and inode details.

## Syntax
```bash
stat [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c format` | Custom format |
| `-f` | Display filesystem status |
| `-L` | Follow symbolic links |
| `-t` | Terse format |
| `--printf=format` | Printf-style format |

## File Information Fields
| Field | Description |
|-------|-------------|
| File | Filename |
| Size | File size in bytes |
| Blocks | Number of blocks allocated |
| IO Block | Filesystem block size |
| Device | Device ID |
| Inode | Inode number |
| Links | Number of hard links |
| Access | File permissions |
| Uid/Gid | User and group IDs |
| Access time | Last access time |
| Modify time | Last modification time |
| Change time | Last status change time |
| Birth time | File creation time (if supported) |

## Key Use Cases
1. View detailed file information
2. Check file permissions and ownership
3. Analyze timestamps
4. Filesystem analysis
5. Debugging file issues

## Examples with Explanations
### Example 1: Basic File Information
```bash
stat file.txt
```
Shows complete file information

### Example 2: Filesystem Information
```bash
stat -f /home
```
Displays filesystem statistics

### Example 3: Custom Format
```bash
stat -c "%n %s %y" file.txt
```
Shows filename, size, and modification time

## Format Specifiers
| Specifier | Description |
|-----------|-------------|
| `%n` | Filename |
| `%s` | Total size in bytes |
| `%b` | Number of blocks |
| `%f` | Raw mode in hex |
| `%F` | File type |
| `%a` | Access rights in octal |
| `%A` | Access rights in human readable form |
| `%u` | User ID |
| `%g` | Group ID |
| `%U` | User name |
| `%G` | Group name |
| `%x` | Time of last access |
| `%y` | Time of last modification |
| `%z` | Time of last change |

## Common Usage Patterns
1. Check permissions:
   ```bash
   stat -c "%a %n" file.txt
   ```
2. Compare timestamps:
   ```bash
   stat -c "%y %n" file1 file2
   ```
3. Find inode number:
   ```bash
   stat -c "%i" file.txt
   ```

## Timestamp Analysis
Understanding timestamps:
- Access time (atime): Last read
- Modify time (mtime): Last content change
- Change time (ctime): Last metadata change
- Birth time (btime): Creation time (ext4, btrfs)

## Performance Analysis
- Fast operation
- No file content reading
- Minimal system resources
- Good for scripting
- Efficient metadata access

## Related Commands
- `ls -l` - Basic file listing
- `file` - File type detection
- `du` - Disk usage
- `find` - File searching
- `lsattr` - Extended attributes

## Additional Resources
- [GNU stat manual](https://www.gnu.org/software/coreutils/manual/html_node/stat-invocation.html)
- [Stat Command Examples](https://www.tecmint.com/stat-command-examples/)

## Best Practices
1. Use custom formats for scripting
2. Check filesystem support for features
3. Understand timestamp meanings
4. Use with other tools for analysis
5. Consider timezone effects

## Scripting Examples
1. Find files modified today:
   ```bash
   stat -c "%y %n" * | grep $(date +%Y-%m-%d)
   ```
2. Check if file is executable:
   ```bash
   [[ $(stat -c "%a" file) -ge 100 ]] && echo "Executable"
   ```
3. Compare file ages:
   ```bash
   stat -c "%Y" file1 file2 | sort -n
   ```

## Filesystem Information
Using `-f` option shows:
- Filesystem type
- Block size
- Total blocks
- Free blocks
- Available blocks
- Total inodes
- Free inodes

## Troubleshooting
1. Permission denied errors
2. Symbolic link handling
3. Filesystem compatibility
4. Timestamp interpretation
5. Format string errors

## Integration Examples
1. With find:
   ```bash
   find . -name "*.txt" -exec stat -c "%n %s" {} \;
   ```
2. With awk:
   ```bash
   stat -c "%s %n" * | awk '$1 > 1000000'
   ```
3. Monitoring script:
   ```bash
   stat -c "%y" important.txt > timestamp.log
   ```
## Additional Examples
```bash
stat file.txt
stat -c '%n %s %U:%G %a' file.txt
stat -f /                 # filesystem status (Linux: -f different on BSD)
stat -c '%y' file.txt     # mtime
```

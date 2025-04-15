# df

## Overview
The `df` (disk free) command reports file system disk space usage. It shows the amount of disk space used and available on all mounted file systems.

## Syntax
```bash
df [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human readable sizes |
| `-i` | List inode information |
| `-T` | Print file system type |
| `-a` | Show all file systems |
| `-l` | Local file systems only |
| `-t type` | Include specific types |
| `-x type` | Exclude specific types |
| `-P` | POSIX output format |
| `--total` | Show total usage |

## Key Use Cases
1. Disk space monitoring
2. Storage management
3. Capacity planning
4. System maintenance
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
df -h
```
Show human-readable disk usage

### Example 2: Inode Usage
```bash
df -i
```
Display inode information

### Example 3: Specific Type
```bash
df -t ext4
```
Show only ext4 filesystems

## Understanding Output
Columns explained:
- Filesystem: Device/partition
- Size: Total size
- Used: Used space
- Avail: Available space
- Use%: Usage percentage
- Mounted on: Mount point

## Common Usage Patterns
1. Check space usage:
   ```bash
   df -h /
   ```
2. Monitor inodes:
   ```bash
   df -i /var
   ```
3. Show file system types:
   ```bash
   df -T
   ```

## Performance Analysis
- Fast execution
- Minimal system impact
- Real-time information
- Network fs impact
- Cache utilization

## Related Commands
- `du` - Directory usage
- `mount` - Show mounted filesystems
- `lsblk` - List block devices
- `fdisk` - Partition table
- `findmnt` - Mount points

## Additional Resources
- [GNU Coreutils - df](https://www.gnu.org/software/coreutils/manual/html_node/df-invocation.html)
- [Linux Filesystem Guide](https://tldp.org/LDP/sag/html/filesystems.html)
- [Storage Management](https://www.tecmint.com/how-to-check-disk-space-in-linux/)

## Monitoring Tips
1. Regular space checks
2. Inode monitoring
3. Alert thresholds
4. Trend analysis
5. Capacity planning

## Best Practices
1. Use human readable format
2. Check both space and inodes
3. Monitor critical filesystems
4. Document thresholds
5. Regular maintenance

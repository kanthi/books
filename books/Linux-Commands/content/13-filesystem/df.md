# df

## Overview
The `df` (Disk Free) command displays information about file system disk space usage. It shows the total size, used space, available space, and mount points.

## Syntax
```bash
df [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human readable |
| `-H` | SI units (1000) |
| `-i` | Show inodes |
| `-T` | Show file system type |
| `-l` | Local file systems only |
| `-a` | All file systems |
| `-x fstype` | Exclude file system type |
| `--total` | Show total |
| `-P` | POSIX output format |
| `--output` | Select output columns |

## Output Columns
| Column | Description |
|--------|-------------|
| `Filesystem` | Device/partition name |
| `Size` | Total size |
| `Used` | Used space |
| `Avail` | Available space |
| `Use%` | Usage percentage |
| `Mounted on` | Mount point |
| `Type` | File system type |
| `Inodes` | Inode information |

## Key Use Cases
1. Space monitoring
2. Capacity planning
3. Storage management
4. System monitoring
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
df -h
```
Show human-readable sizes

### Example 2: Show File System Type
```bash
df -T
```
Include file system types

### Example 3: Check Inodes
```bash
df -i
```
Show inode information

## Common Usage Patterns
1. Check space:
   ```bash
   df -h /
   ```
2. All file systems:
   ```bash
   df -a
   ```
3. Specific type:
   ```bash
   df -t ext4
   ```

## Security Considerations
1. Root access
2. Hidden file systems
3. Network mounts
4. Quotas
5. Permissions

## Related Commands
- `du` - Disk usage
- `mount` - Mount file systems
- `fdisk` - Partition table
- `lsblk` - Block devices
- `findmnt` - Mount points

## Additional Resources
- [Df Manual](https://man7.org/linux/man-pages/man1/df.1.html)
- [File System Guide](https://www.cyberciti.biz/faq/df-command-examples-in-linux-unix/)
- [System Administration](https://www.tecmint.com/how-to-check-disk-space-in-linux/)

## Best Practices
1. Regular monitoring
2. Alert thresholds
3. Documentation
4. Trend analysis
5. Capacity planning

## File System Types
1. ext4
2. xfs
3. btrfs
4. tmpfs
5. nfs

## Troubleshooting
1. Space issues
2. Inode exhaustion
3. Mount problems
4. Network issues
5. Performance impact

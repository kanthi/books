# fdisk

## Overview
The `fdisk` command manipulates disk partition tables. It's used to view, create, delete, change, and copy partitions on storage devices.

## Syntax
```bash
fdisk [options] device
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List partitions |
| `-b sectorsize` | Sector size |
| `-u` | Display units |
| `-v` | Version info |
| `-c` | Compatibility mode |
| `-w` | Write table |
| `-s partition` | Size in blocks |
| `-t type` | Specify type |
| `-h` | Help |
| `-x` | Expert mode |

## Interactive Commands
| Command | Description |
|---------|-------------|
| `m` | Help menu |
| `p` | Print table |
| `n` | New partition |
| `d` | Delete partition |
| `t` | Change type |
| `v` | Verify table |
| `w` | Write changes |
| `q` | Quit without saving |
| `l` | List types |
| `x` | Expert mode |

## Key Use Cases
1. Partition management
2. Disk organization
3. System setup
4. Storage planning
5. Data management

## Examples with Explanations
### Example 1: List Partitions
```bash
fdisk -l /dev/sda
```
Show partition table

### Example 2: Create Partition
```bash
fdisk /dev/sdb
n    # new partition
p    # primary partition
1    # partition number
     # default first sector
+10G # size
w    # write changes
```

### Example 3: Delete Partition
```bash
fdisk /dev/sdb
d    # delete partition
1    # partition number
w    # write changes
```

## Common Usage Patterns
1. View partitions:
   ```bash
   fdisk -l
   ```
2. Change type:
   ```bash
   fdisk /dev/sdb
   t    # type
   83   # Linux
   w    # write
   ```
3. Expert mode:
   ```bash
   fdisk -x /dev/sdb
   ```

## Security Considerations
1. Root access required
2. Data loss risk
3. System integrity
4. Backup importance
5. Boot safety

## Related Commands
- `parted` - Partition editor
- `gdisk` - GPT fdisk
- `sfdisk` - Script-friendly
- `cfdisk` - Curses interface
- `mkfs` - Create filesystem

## Additional Resources
- [Fdisk Manual](https://man7.org/linux/man-pages/man8/fdisk.8.html)
- [Partition Guide](https://www.cyberciti.biz/faq/linux-partition-howto-set-up-hard-disk-partition/)
- [System Administration](https://www.tecmint.com/fdisk-commands-to-manage-linux-disk-partitions/)

## Best Practices
1. Backup first
2. Verify changes
3. Check alignment
4. Plan layout
5. Document changes

## Partition Types
1. Linux (83)
2. Swap (82)
3. Extended (5)
4. NTFS (7)
5. LVM (8e)

## Troubleshooting
1. Table errors
2. Boot problems
3. Alignment issues
4. Type conflicts
5. Size limits

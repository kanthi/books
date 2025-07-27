# lsblk

## Overview
The `lsblk` command lists information about all available block devices. It shows the block devices in a tree-like format.

## Syntax
```bash
lsblk [options] [device...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Show all devices |
| `-b` | Print sizes in bytes |
| `-d` | Don't show slaves |
| `-f` | Show filesystems |
| `-m` | Show permissions |
| `-n` | Don't show headings |
| `-o columns` | Output columns |
| `-p` | Show full paths |
| `-r` | Raw output |
| `-t` | Show topology |
| `-x column` | Sort by column |

## Output Columns
| Column | Description |
|--------|-------------|
| `NAME` | Device name |
| `MAJ:MIN` | Major:minor device numbers |
| `RM` | Removable device |
| `SIZE` | Device size |
| `RO` | Read-only device |
| `TYPE` | Device type |
| `MOUNTPOINT` | Mount point |
| `FSTYPE` | Filesystem type |
| `LABEL` | Filesystem label |
| `UUID` | Filesystem UUID |

## Key Use Cases
1. Device enumeration
2. Storage management
3. System configuration
4. Troubleshooting
5. Documentation

## Examples with Explanations
### Example 1: Basic Usage
```bash
lsblk
```
Show block devices

### Example 2: Show Filesystems
```bash
lsblk -f
```
Include filesystem information

### Example 3: Custom Output
```bash
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
```
Select specific columns

## Common Usage Patterns
1. All information:
   ```bash
   lsblk -a
   ```
2. Raw output:
   ```bash
   lsblk -r
   ```
3. Tree topology:
   ```bash
   lsblk -t
   ```

## Security Considerations
1. Device access
2. Root privileges
3. Sensitive info
4. Network devices
5. Removable media

## Related Commands
- `blkid` - Block device info
- `fdisk` - Partition table
- `mount` - Mount filesystems
- `df` - Disk usage
- `parted` - Partition editor

## Additional Resources
- [Lsblk Manual](https://man7.org/linux/man-pages/man8/lsblk.8.html)
- [Block Device Guide](https://www.cyberciti.biz/faq/linux-list-disk-partitions-command/)
- [System Administration](https://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/)

## Best Practices
1. Regular checks
2. Documentation
3. Verification
4. Monitoring
5. Change tracking

## Device Types
1. disk
2. part
3. lvm
4. crypt
5. loop

## Troubleshooting
1. Missing devices
2. Access errors
3. Display issues
4. Format problems
5. Device naming

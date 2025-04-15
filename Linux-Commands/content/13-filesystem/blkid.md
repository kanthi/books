# blkid

## Overview
The `blkid` command locates and prints block device attributes. It's used to find UUID, LABEL, TYPE, and other filesystem information.

## Syntax
```bash
blkid [options] [device...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c file` | Read from cache file |
| `-g` | Garbage collect |
| `-h` | Display help |
| `-l` | Lookup only |
| `-L label` | Look up device by label |
| `-U uuid` | Look up device by UUID |
| `-p` | Low-level probe |
| `-s tag` | Show specified tag |
| `-t NAME=value` | Find by tag |
| `-v` | Verbose output |
| `-w file` | Write to cache file |

## Output Tags
| Tag | Description |
|-----|-------------|
| `UUID` | Filesystem UUID |
| `LABEL` | Filesystem label |
| `TYPE` | Filesystem type |
| `PTTYPE` | Partition table type |
| `PARTUUID` | Partition UUID |
| `PARTLABEL` | Partition label |
| `USAGE` | Usage type |
| `VERSION` | Version info |

## Key Use Cases
1. Device identification
2. Filesystem detection
3. UUID lookup
4. Label lookup
5. System configuration

## Examples with Explanations
### Example 1: Basic Usage
```bash
blkid
```
Show all block devices

### Example 2: Specific Device
```bash
blkid /dev/sda1
```
Show device attributes

### Example 3: Find by UUID
```bash
blkid -U "uuid-string"
```
Lookup device by UUID

## Common Usage Patterns
1. List all:
   ```bash
   blkid
   ```
2. Find label:
   ```bash
   blkid -L "label"
   ```
3. Show type:
   ```bash
   blkid -s TYPE
   ```

## Security Considerations
1. Root access
2. Device permissions
3. Cache security
4. Information exposure
5. System access

## Related Commands
- `lsblk` - List block devices
- `fdisk` - Partition table
- `mount` - Mount filesystems
- `findfs` - Find by label/UUID
- `e2label` - Change label

## Additional Resources
- [Blkid Manual](https://man7.org/linux/man-pages/man8/blkid.8.html)
- [Device Management Guide](https://www.cyberciti.biz/faq/linux-finding-using-uuids-to-update-fstab/)
- [System Administration](https://www.tecmint.com/find-linux-filesystem-type/)

## Best Practices
1. Use UUIDs
2. Regular updates
3. Cache management
4. Documentation
5. Verification

## Filesystem Types
1. ext4
2. xfs
3. btrfs
4. swap
5. vfat

## Troubleshooting
1. Device access
2. Cache issues
3. Missing info
4. Version conflicts
5. Format errors

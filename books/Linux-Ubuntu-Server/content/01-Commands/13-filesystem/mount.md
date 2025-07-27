# mount

## Overview
The `mount` command attaches file systems and devices to the system directory tree. It's essential for accessing storage devices and network shares.

## Syntax
```bash
mount [-t type] [-o options] device dir
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Mount all |
| `-t type` | File system type |
| `-o options` | Mount options |
| `-r` | Read-only |
| `-w` | Read-write |
| `-v` | Verbose |
| `-n` | Don't update /etc/mtab |
| `-L label` | Mount by label |
| `-U uuid` | Mount by UUID |
| `--bind` | Bind mount |
| `--rbind` | Recursive bind |

## Mount Options
| Option | Description |
|--------|-------------|
| `ro` | Read-only |
| `rw` | Read-write |
| `user` | User mountable |
| `nouser` | No user mount |
| `exec` | Allow execution |
| `noexec` | No execution |
| `auto` | Mountable with -a |
| `noauto` | Skip with -a |
| `defaults` | Default options |
| `_netdev` | Network device |

## Key Use Cases
1. Storage access
2. Network shares
3. ISO mounting
4. Temporary mounts
5. System setup

## Examples with Explanations
### Example 1: Basic Mount
```bash
mount /dev/sdb1 /mnt
```
Mount device to directory

### Example 2: Type Specific
```bash
mount -t ext4 /dev/sdc1 /data
```
Mount ext4 filesystem

### Example 3: Network Share
```bash
mount -t nfs server:/share /mnt/nfs
```
Mount NFS share

## Common Usage Patterns
1. Show mounts:
   ```bash
   mount
   ```
2. Read-only:
   ```bash
   mount -o ro /dev/sdb1 /mnt
   ```
3. Bind mount:
   ```bash
   mount --bind /source /target
   ```

## Security Considerations
1. Mount options
2. User permissions
3. Network security
4. Execute permissions
5. Device access

## Related Commands
- `umount` - Unmount
- `fstab` - Mount table
- `findmnt` - Find mounts
- `lsblk` - List blocks
- `blkid` - Block IDs

## Additional Resources
- [Mount Manual](https://man7.org/linux/man-pages/man8/mount.8.html)
- [File System Guide](https://www.cyberciti.biz/faq/mount-drive-linux-command-syntax/)
- [System Administration](https://www.tecmint.com/mount-filesystem-in-linux/)

## Best Practices
1. Use UUIDs
2. Check options
3. Verify mounts
4. Document changes
5. Regular checks

## File System Types
1. ext4
2. xfs
3. nfs
4. cifs
5. iso9660

## Troubleshooting
1. Mount errors
2. Permission denied
3. Network issues
4. Device busy
5. Wrong fs type

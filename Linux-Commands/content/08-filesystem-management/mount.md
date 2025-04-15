# mount

## Overview
The `mount` command attaches the filesystem found on a device to the Linux directory tree. It's essential for accessing data on various storage devices and network shares.

## Syntax
```bash
mount [-t type] [-o options] device directory
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t type` | Specify filesystem type |
| `-o options` | Mount options |
| `-a` | Mount all filesystems in fstab |
| `-r` | Mount read-only |
| `-w` | Mount read-write |
| `-v` | Verbose mode |
| `-L label` | Mount by label |
| `-U UUID` | Mount by UUID |

## Key Use Cases
1. Mount storage devices
2. Access network shares
3. Mount ISO images
4. Temporary filesystems
5. System maintenance

## Examples with Explanations
### Example 1: Basic Mount
```bash
mount /dev/sdb1 /mnt/usb
```
Mounts device sdb1 to /mnt/usb directory

### Example 2: Mount with Type
```bash
mount -t ntfs /dev/sda2 /mnt/windows
```
Mounts NTFS filesystem

### Example 3: Mount ISO
```bash
mount -o loop image.iso /mnt/iso
```
Mounts an ISO file

## Understanding Output
- Device name
- Mount point
- Filesystem type
- Mount options
- Status messages

## Common Usage Patterns
1. Mount with specific options:
   ```bash
   mount -o rw,user,exec /dev/sdc1 /media/data
   ```
2. Mount network share:
   ```bash
   mount -t nfs server:/share /mnt/nfs
   ```
3. View mounted filesystems:
   ```bash
   mount | grep "/dev/sd"
   ```

## Performance Analysis
- Consider filesystem type for performance
- Use appropriate mount options
- Monitor I/O performance
- Check filesystem status

## Related Commands
- `umount` - Unmount filesystems
- `df` - Show mounted filesystem usage
- `fsck` - Check filesystem
- `blkid` - List block device attributes
- `lsblk` - List block devices

## Additional Resources
- [Linux mount manual](https://man7.org/linux/man-pages/man8/mount.8.html)
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)

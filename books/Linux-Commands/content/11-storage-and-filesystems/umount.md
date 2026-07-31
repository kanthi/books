# umount

## Overview
`umount` detaches a filesystem from the directory tree. Pair with `mount`, `lsblk`, and `findmnt` for storage workflows.

## Syntax
```bash
umount [options] <mountpoint|device>
umount -a
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | Lazy unmount (detach when busy) |
| `-f` | Force (mainly for NFS) |
| `-r` | Remount read-only if unmount fails |
| `-v` | Verbose |

## Key Use Cases
1. Detach USB/data disks cleanly
2. Unmount before fsck or repartition
3. Clear busy NFS mounts
4. Release mounts in scripts/chroots

## Safety
Never unmount the root filesystem on a live system. Ensure no critical writes are in flight; prefer clean process shutdown over `-f` on local disks.

## Examples with Explanations
### Unmount by mountpoint
```bash
sudo umount /mnt/data
```
Preferred: use the path you mounted on.

### Unmount by device
```bash
sudo umount /dev/sdb1
```
Equivalent when you know the block device.

### Busy mount diagnosis
```bash
findmnt /mnt/data
sudo lsof +f -- /mnt/data
sudo fuser -vm /mnt/data
```
See who still uses the mount before retrying.

### Lazy unmount
```bash
sudo umount -l /mnt/data
```
Detaches immediately; cleanup when references drop — use carefully.

## Related Commands
- `mount` — attach filesystems
- `lsblk` / `findmnt` — topology
- `lsof` / `fuser` — busy files
- `fsck` — check offline filesystems

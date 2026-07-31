# mount

## Overview
`mount` attaches a filesystem (device, network share, bind path, tmpfs, …) onto a directory in the single directory tree. Persistent mounts belong in `/etc/fstab` or systemd `.mount` units; `mount` itself is the live operation.

## Syntax
```bash
mount [-t type] [-o options] device dir
mount                    # list mounts
mount -a                 # all fstab entries
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t type` | Filesystem type (`ext4`, `xfs`, `nfs`, `tmpfs`, `cifs`, …) |
| `-o opts` | Comma options (`ro`, `noexec`, `nosuid`, `defaults`, …) |
| `-a` | Mount all fstab filesystems |
| `-r` | Read-only |
| `--bind` | Bind mount a directory |
| `-v` | Verbose |

## Key Use Cases
1. Attach disks and USB volumes  
2. Mount NFS/CIFS shares  
3. Bind mounts for chroots/containers  
4. Temporary tmpfs workspaces  

## Safety
Wrong device on `mkfs`/`mount` can expose or overwrite data. Always verify with `lsblk -f` and `blkid` first. Unmount cleanly with `umount` before disconnecting storage.

## Examples with Explanations
### List
```bash
mount | column -t
findmnt
findmnt -t ext4
```

### Mount a partition
```bash
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
# or by UUID (stable):
sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data
```

### Read-only
```bash
sudo mount -o ro /dev/sdb1 /mnt/data
```

### NFS
```bash
sudo mount -t nfs server:/export/path /mnt/nfs
```

### Bind mount
```bash
sudo mount --bind /var/www /mnt/www-view
```

### tmpfs
```bash
sudo mount -t tmpfs -o size=1G tmpfs /mnt/scratch
```

### From fstab
```bash
sudo mount -a
sudo mount /mnt/data    # if listed in fstab
```

## Understanding Output
`mount` with no args lists source, target, type, and options. Prefer `findmnt` for tree views and JSON (`findmnt -J`).

## Notes & Pitfalls
- Prefer **UUID=** or **LABEL=** in fstab over `/dev/sdX` names.  
- “Target is busy” on umount → `lsof`/`fuser`/`findmnt`.  
- Systemd may auto-manage mounts; check `systemctl status mnt-data.mount`.  

## Related Commands
- `umount` — detach  
- `lsblk` / `blkid` — identify devices  
- `findmnt` — rich listing  
- `df` — space on mounted filesystems  
- `fstab(5)` — persistence  

## Additional Resources
- `man mount`  
- `man fstab`

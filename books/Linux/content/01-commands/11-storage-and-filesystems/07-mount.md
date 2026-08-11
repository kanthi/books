# mount

## Overview

`mount` attaches a filesystem (block device, network share, bind path, tmpfs, …) onto a directory in the single Linux directory tree. Persistent mounts belong in `/etc/fstab` or systemd `.mount` units; interactive `mount` is for live operations and troubleshooting.

## Syntax

```bash
mount [-t type] [-o options] device dir
mount                         # list mounts
mount -a                      # all fstab entries due at boot
mount -o remount,opts dir
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t type` | Filesystem type (`ext4`, `xfs`, `nfs4`, `cifs`, `tmpfs`, `overlay`, …) |
| `-o opts` | Mount options (`ro`, `noexec`, `nosuid`, `nodev`, `defaults`, …) |
| `-a` | Mount all appropriate fstab entries |
| `-r` / `-w` | Read-only / read-write |
| `--bind` / `--rbind` | Bind mount (recursive) |
| `-v` | Verbose |
| `--source` / `--target` | Explicit long options |

## Key Use Cases

1. Attach disks and USB volumes  
2. Mount NFS/CIFS shares  
3. Bind mounts for chroots, containers, and rebuilds  
4. Temporary tmpfs workspaces  
5. Remount root or data with new options  

## Safety

- Wrong device → wrong data exposure. Verify with `lsblk -f` and `blkid` **before** mounting.  
- Prefer `UUID=` / `LABEL=` in fstab over volatile `/dev/sdX` names.  
- Network mounts can hang the shell on outage — consider `soft`/`timeo` options and separate automount units.  
- Unmount cleanly (`umount`) before yanking USB or unplugging SAN LUNs.

## Examples with Explanations

### Inventory

```bash
findmnt
findmnt -t ext4,xfs
mount | column -t
findmnt -J | jq .          # if jq installed
```

Prefer `findmnt` for tree and JSON views.

### Mount a partition by UUID

```bash
lsblk -f
sudo mkdir -p /mnt/data
sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data
df -h /mnt/data
```

### Read-only mount (forensics / recovery)

```bash
sudo mount -o ro /dev/sdb1 /mnt/data
```

### NFS

```bash
sudo mount -t nfs4 -o rw,hard,timeo=600 server.example:/export/path /mnt/nfs
```

Options trade durability vs hang behavior — know your storage SLA.

### CIFS / SMB

```bash
sudo mount -t cifs //server/share /mnt/share \
  -o credentials=/root/.smbcred,uid=1000,gid=1000,iocharset=utf8
```

Keep credentials files mode `600`.

### Bind mounts

```bash
sudo mount --bind /var/www /mnt/www-view
sudo mount --rbind /home /mnt/chroot/home
```

Bind mounts share the same filesystem; `rbind` includes submounts.

### tmpfs

```bash
sudo mount -t tmpfs -o size=1G,mode=0755 tmpfs /mnt/scratch
```

RAM-backed; contents vanish on unmount/reboot.

### Remount

```bash
sudo mount -o remount,ro /
sudo mount -o remount,rw /
```

Common in recovery environments.

### fstab-driven

```bash
# /etc/fstab example:
# UUID=…  /mnt/data  ext4  defaults,nofail  0  2
sudo mount -a
sudo mount /mnt/data
findmnt /mnt/data
```

`nofail` avoids boot hangs if the disk is absent (laptops/USB).

### Overlay (container-style)

```bash
sudo mount -t overlay overlay -o lowerdir=/base,upperdir=/upper,workdir=/work /merged
```

Used heavily by container engines; easy to get wrong — read `overlay` docs before production use.

## Understanding Output

With no arguments, `mount` lists source, target, type, and options. Exit status non-zero means the mount failed (busy target, bad superblock, missing helper binary for NFS/CIFS, permission denied).

## Notes & Pitfalls

- Helpers live as `mount.nfs`, `mount.cifs` — missing packages cause cryptic errors.  
- “Target is busy” on umount → `lsof +f -- /mnt/data`, `fuser -vm /mnt/data`.  
- Systemd may own the mount: `systemctl status mnt-data.mount`.  
- `user`/`users` fstab options allow non-root mount/umount with restrictions.  
- Mount namespaces (containers) mean `findmnt` inside a pod is not the host’s view.

## Related Commands

- `umount` — detach  
- `lsblk` / `blkid` — identify devices  
- `findmnt` — rich listing  
- `df` / `du` — space usage  
- `losetup` — loop devices for images  
- `fstab(5)` — persistence  

## Additional Resources

- `man mount`  
- `man fstab`  
- `man systemd.mount`

# umount

## Overview

`umount` detaches a mounted filesystem from the directory tree. Use it before safe device removal, before offline `fsck`/`mkfs`, or when tearing down bind/NFS mounts. Prefer the **mountpoint** path over the device node. If the target is busy, find holders with `lsof`/`fuser`/`findmnt` rather than forcing blindly.

## Syntax

```bash
umount [options] <mountpoint|device>
umount -a [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | Lazy unmount — detach now, cleanup when busy refs drop |
| `-f` | Force (mainly stale NFS); dangerous on local disks |
| `-r` | If unmount fails, try remount read-only |
| `-v` | Verbose |
| `-a` | Unmount all (respects filters; use carefully) |
| `-t type` | Limit by filesystem type (with `-a`) |
| `-R` | Recursive unmount of target and children (newer util-linux) |

## Key Use Cases

1. Clean detach of USB/data disks before unplug
2. Unmount before `fsck`, repartition, or `mkfs`
3. Clear busy or stale NFS mounts
4. Tear down bind mounts in chroots/containers/scripts

## Safety

- Do **not** unmount `/` on a live system.
- Prefer stopping writers (services, shells with cwd on the mount) over `-f` on local media.
- Lazy (`-l`) hides problems; processes may still hold files until exit.
- Unmounting active databases or VMs can corrupt data — shut them down first.

## Examples with Explanations

### Unmount by mountpoint (preferred)

```bash
sudo umount /mnt/data
```

Matches how you mounted it; unambiguous when one device has multiple mounts.

### Unmount by device

```bash
sudo umount /dev/sdb1
```

Works when you know the block device; fails if not mounted or still busy.

### Confirm before and after

```bash
findmnt /mnt/data
lsblk -f /dev/sdb
sudo umount /mnt/data
findmnt /mnt/data || echo "unmounted"
```

### Busy mount diagnosis

```bash
findmnt /mnt/data
sudo lsof +f -- /mnt/data
sudo fuser -vm /mnt/data
# common causes: shell cwd on mount, open logs, NFS locks, container bind
cd /   # if your shell is the culprit
sudo umount /mnt/data
```

“Target is busy” almost always means open files or a process cwd under the tree.

### Lazy unmount

```bash
sudo umount -l /mnt/data
```

Detaches from the namespace immediately; actual teardown when references drop. Use for stuck mounts when you understand leftover processes may still write until they exit.

### Force NFS (last resort)

```bash
sudo umount -f /mnt/nfs
# or lazy: sudo umount -l /mnt/nfs
```

For **stale** NFS when the server is gone. Avoid `-f` as a habit on local ext4/xfs.

### Remount read-only fallback

```bash
sudo umount -r /mnt/data
```

If full unmount fails, try to freeze writes via remount-ro (util-linux behavior with `-r`).

### Multiple mounts / bind trees

```bash
findmnt -R /mnt/data
sudo umount -R /mnt/data   # if supported: recursive
# else unmount children first, then parent
```

Binds and nested mounts must be torn down from the leaves upward if recursive umount is unavailable.

### Before fsck

```bash
sudo umount /mnt/data
sudo fsck -n /dev/sdb1
```

Never run repairing fsck on a read-write mounted filesystem.

## Understanding Output

Success is silent (exit 0). Failures print to stderr:

| Message | Typical cause |
|---------|----------------|
| `target is busy` | Open files / cwd / mounts beneath |
| `not mounted` | Wrong path or already unmounted |
| `must be superuser` | Need root for most system mounts |

## Notes & Pitfalls

- Systemd may manage mounts as `*.mount` units — `systemctl stop mnt-data.mount` can be cleaner than raw umount.
- USB: unmount **then** wait for LED idle before unplug; otherwise risk corruption.
- `udisksctl unmount -b /dev/sdb1` is the desktop-friendly path on Ubuntu workstations.
- Open-but-deleted files on other filesystems don’t block this umount; busy means *this* mount’s tree.
- In containers, mounts may be shared/slave — unmount semantics follow mount propagation.

## Related Commands

- `mount` — attach filesystems
- `findmnt` — show what is mounted
- `lsblk` — device ↔ mountpoint map
- `lsof` / `fuser` — who is busy
- `fsck` — check offline filesystems
- `systemctl` — systemd mount units

## Additional Resources

- `man umount`
- `man findmnt`

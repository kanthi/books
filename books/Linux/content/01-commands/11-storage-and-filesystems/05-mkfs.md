# mkfs

## Overview

`mkfs` builds a filesystem on a block device (partition, LV, loop file). On Ubuntu you usually call the type-specific tools: `mkfs.ext4`, `mkfs.xfs`, `mkfs.vfat`, `mkfs.btrfs`. **This destroys existing data** on the target. Pair with `lsblk`/`blkid` for identity, `fdisk` for partitions, and `mount`/`fstab` for use.

## Syntax

```bash
sudo mkfs -t type [fs-options] device
sudo mkfs.ext4 [options] device
sudo mkfs.xfs [options] device
sudo mkfs.vfat [options] device
```

## Common Options

Options vary by filesystem. Operators commonly use:

| Tool / option | Description |
|---------------|-------------|
| `mkfs.ext4 -L label` | Volume label |
| `mkfs.ext4 -m percent` | Reserved blocks for root (default ~5%) |
| `mkfs.ext4 -N inodes` | Inode count (rare; plan for many tiny files) |
| `mkfs.xfs -L label` | Label |
| `mkfs.xfs -f` | Force overwrite existing FS |
| `mkfs.vfat -F 32 -n NAME` | FAT32 + short volume name |
| `mkfs -t type` | Generic front-end |

Swap is **not** mkfs: use `mkswap`.

## Safety

1. Confirm device with `lsblk -o NAME,SIZE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS` and `sudo blkid`.
2. Ensure the target is **unmounted** and not in use (`findmnt`, `lsof`, `fuser`).
3. Never `mkfs` the wrong disk on multi-disk or cloud hosts — match size/serial.
4. Prefer operating on `/dev/disk/by-id/…` or by-uuid only **after** you know the new FS UUID (identity changes on format).
5. Have backups; there is no undo.

## Key Use Cases

1. Format a new data partition after `fdisk`
2. Format an LVM logical volume
3. Prepare USB media (vfat/exfat) for interchange
4. Rebuild a filesystem after intentional wipe (with backups)

## Examples with Explanations

### Verify target, then ext4 data disk

```bash
lsblk -f
lsblk -o NAME,SIZE,MODEL,SERIAL,MOUNTPOINTS /dev/sdb
sudo findmnt /dev/sdb1   # should be empty / not mounted
sudo mkfs.ext4 -L data /dev/sdb1
sudo blkid /dev/sdb1
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
df -h /mnt/data
```

Label `-L data` shows up in `lsblk -f` and can be used as `LABEL=data` in fstab (UUID is still more unique).

### XFS data volume

```bash
sudo mkfs.xfs -f -L data /dev/sdb1
```

`-f` forces if a filesystem signature already exists. XFS is common for large sequential workloads; repair path is `xfs_repair`, not classic `fsck` semantics.

### FAT32 for USB interoperability

```bash
sudo mkfs.vfat -F 32 -n KEY /dev/sdc1
```

Good for firmware, Windows interchange, EFI-related media. Volume name length limits apply (`-n`).

### Reduce ext* reserved space on large data disks

```bash
sudo mkfs.ext4 -m 0.5 -L bulk /dev/sdb1
# or later: sudo tune2fs -m 1 /dev/sdb1
```

Default ~5% reserved for root wastes terabytes on multi-TB bulk disks. Root filesystem often keeps a higher reserve on purpose.

### LVM logical volume

```bash
# after lvcreate …
sudo mkfs.ext4 -L pgdata /dev/mapper/vg-data
# or: /dev/vg/data symlink
lsblk -f /dev/mapper/vg-data
```

Format the LV (mapper node), not a raw PV member disk.

### Capture UUID for fstab

```bash
UUID=$(sudo blkid -s UUID -o value /dev/sdb1)
echo "UUID=$UUID  /mnt/data  ext4  defaults,nofail  0  2"
# install into /etc/fstab after review, then:
sudo mount -a
```

`nofail` helps boot continue if an optional data disk is missing (tune to policy).

### Whole-disk vs partition

```bash
# Prefer a partition table even for single-use data disks (clearer, ESP-friendly patterns).
# mkfs on whole /dev/sdb works but confuses some tools and dual-boot assumptions.
sudo fdisk /dev/sdb   # create one partition first
sudo mkfs.ext4 -L data /dev/sdb1
```

## Understanding Output

Successful mkfs prints progress and superblock/UUID details (ext*). Afterward:

```bash
lsblk -f /dev/sdb1
sudo blkid /dev/sdb1
```

Expect new `FSTYPE`, `UUID`, and optional `LABEL`. Old UUIDs in fstab become stale — update them.

## Notes & Pitfalls

- **Irreversible** for practical purposes; snapshots/backups first.
- XFS: use `xfs_repair` offline; `fsck.xfs` does little.
- btrfs/zfs have their own create tools and operational models.
- Cloud disks: detach/attach order can rename `/dev/sdX` — use UUID in fstab.
- Encryption: `cryptsetup luksFormat` then mkfs on `/dev/mapper/…`, not the raw LUKS device path alone without opening.
- Filesystem choice: ext4 default on Ubuntu root; XFS common for large data; vfat for portable USB.

## Related Commands

- `fdisk` / `parted` — partitions before mkfs
- `blkid` / `lsblk -f` — verify identity after format
- `tune2fs` — tune ext* without reformat
- `mkswap` / `swapon` — swap
- `mount` / `umount` / fstab — use the new FS
- `wipefs` — inspect/clear old signatures

## Additional Resources

- `man mkfs`
- `man mkfs.ext4`
- `man mkfs.xfs`

# losetup

## Overview

`losetup` associates regular files with **loop devices** (`/dev/loopN`) so the kernel can treat an image file like a block device—mount ISOs, inspect disk images, or access partitions inside a raw `.img`.

## Syntax

```bash
losetup [options] [loopdev] [file]
losetup [options] -f file
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a`, `--all` | List active loop devices |
| `-f`, `--find` | Find first unused loop device |
| `-f --show` | Find, attach, print device path |
| `-d`, `--detach` | Detach |
| `-D`, `--detach-all` | Detach all (careful) |
| `-j file` | Show loops for file |
| `-r`, `--read-only` | Read-only |
| `-P`, `--partscan` | Scan partition table → `/dev/loopNp1`… |
| `-b SIZE` | Logical block size |
| `-o OFFSET` | Data offset |
| `--sizelimit` | Limit size |
| `-L`, `--nooverlap` | Refuse overlapping |

## Key Use Cases

1. Mount disk/ISO images
2. Access partitions inside a raw disk image
3. Filesystem experiments without real disks
4. Detach leftover loops after failed scripts

## Examples with Explanations

### Attach and list

```bash
sudo losetup -fP --show disk.img
sudo losetup -a
lsblk
```

### Mount ISO

```bash
sudo losetup -f --show -r image.iso
# or directly:
sudo mount -o loop,ro image.iso /mnt/iso
```

Modern `mount -o loop` calls losetup for you.

### Partitions inside image

```bash
sudo losetup -fP --show disk.img
lsblk /dev/loop0
sudo mount /dev/loop0p1 /mnt/p1
```

### Detach

```bash
sudo umount /mnt/p1
sudo losetup -d /dev/loop0
sudo losetup -j disk.img
```

### One-liner recipes

```bash
# Attach, print, and lsblk
dev=$(sudo losetup -fP --show disk.img); echo "$dev"; lsblk "$dev"

# Clean orphan loops (review first!)
sudo losetup -a
# sudo losetup -D   # nuclear option
```

## Notes & Pitfalls

- Always **umount before detach**.
- Sparse image files and sparse loop mappings can confuse free-space calculations.
- Permission: root required for setup.
- Snap/container environments may restrict loop devices.
- For qcow2 use `qemu-nbd` or `guestmount`, not raw losetup alone.

## 2026-relevant notes

- Cloud “custom image” workflows still use loop/nbd for injection of SSH keys and cloud-init.
- Prefer `udisksctl loop-setup` on desktops for user-friendly attach.
- `losetup -P` + `lsblk` is the standard recovery path for raw VM disks copied as files.

## Related Commands

- `mount` / `umount` — filesystem attach
- `lsblk` / `blkid` — inspect
- `kpartx` — map partitions (alternative)
- `qemu-nbd` — qcow2 as block

## Additional Resources

- `man losetup`
- util-linux documentation

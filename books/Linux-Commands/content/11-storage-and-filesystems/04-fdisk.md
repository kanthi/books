# fdisk

## Overview

`fdisk` creates and edits DOS/MBR and GPT partition tables on block devices. Interactive by default; list-only with `-l`. For scripted GPT layouts many operators prefer `sfdisk` or `parted`; for pure GPT recovery, `gdisk` is another common tool. After partitioning you still need `mkfs` (or LVM/crypt setup) before data use.

## Syntax

```bash
sudo fdisk [-l] [device...]
sudo fdisk device          # interactive editor
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | List partition tables (no write) |
| `-x` | Extra detail when listing |
| `-w always\|never` | Wipe signatures when writing (newer util-linux) |
| `-t dos\|gpt` | Restrict label type (context-dependent) |

Interactive keys (common):

| Key | Action |
|-----|--------|
| `m` | Help |
| `p` | Print table |
| `g` | New empty GPT |
| `o` | New empty DOS/MBR |
| `n` | New partition |
| `d` | Delete partition |
| `t` | Change type (Linux filesystem, LVM, EFI, …) |
| `w` | Write table to disk and exit |
| `q` | Quit **without** saving |

## Safety

**Writing a partition table can destroy access to existing data.** Treat `w` as irreversible without backups.

1. Identify the **correct** disk: `lsblk -f`, `lsblk -o NAME,SIZE,MODEL,SERIAL,TRAN`, `sudo fdisk -l`.
2. Never guess `sdb` vs `sdc` on multi-disk hosts — match size/model/serial.
3. Do not rewrite tables on mounted system disks without a recovery plan and offline/maintenance window.
4. Prefer working on **data** disks first; practice on disposable VMs.
5. After write, re-read the table (`partprobe` / reboot if needed) before `mkfs`.

## Key Use Cases

1. List all disks and partitions before storage work
2. Create GPT layout on a new data disk
3. Add a partition for LVM or a second filesystem
4. Dump/restore layouts via `sfdisk` for clones

## Examples with Explanations

### List all disks (read-only)

```bash
sudo fdisk -l
sudo fdisk -l /dev/sdb
sudo fdisk -l /dev/nvme0n1
```

Safe first step. Confirms capacity, label type (Disklabel type: gpt/dos), and existing partitions.

### Confirm target before editing

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL,TRAN
lsblk -f /dev/sdb
# only proceed if size/model match the disk you intend to wipe
```

Wrong-device mistakes are the most common disaster with fdisk/mkfs.

### Interactive GPT data disk (sketch)

```bash
sudo fdisk /dev/sdb
# g          → new GPT
# n          → new partition (accept defaults for whole disk, or +200G etc.)
# t          → type if needed (Linux filesystem is typical; LVM has its own type)
# p          → review
# w          → write (point of no return for the old table)
```

Quit with `q` instead of `w` if anything looks wrong. Partition numbers and paths: `/dev/sdb1`, NVMe uses `/dev/nvme0n1p1`.

### Kernel re-read after write

```bash
sudo partprobe /dev/sdb
# or: sudo blockdev --rereadpt /dev/sdb
lsblk /dev/sdb
cat /proc/partitions | grep sdb
```

If nodes do not appear, a reboot or removing leftover holders may be required.

### Next steps after partitioning

```bash
sudo mkfs.ext4 -L data /dev/sdb1
# or: sudo pvcreate /dev/sdb1 && … LVM …
lsblk -f /dev/sdb
sudo blkid /dev/sdb1
```

fdisk only lays out partitions; filesystems and fstab are separate.

### Scripted dump / restore (sfdisk)

```bash
sudo sfdisk -d /dev/sdb > sdb.layout
# restore to same-size disk (DESTRUCTIVE — verify target):
# sudo sfdisk /dev/sdb < sdb.layout
```

Use for clone pipelines; still verify device identity before restore.

### EFI system partition type (boot disk work)

```bash
# In fdisk: type often "EFI System" (GPT). Wrong type can break boot loaders.
# Prefer known-good installers for OS disks; manual ESP edits need care.
```

OS boot disks deserve extra caution — prefer installer tooling unless you know the boot chain.

## Understanding Output

`fdisk -l` shows device path, size, sector size, disk identifier, and a table of partitions (number, start/end sectors, size, type). Modern util-linux fdisk aligns partitions automatically for 4K devices. GPT entries have PARTUUIDs visible via `lsblk -o NAME,PARTUUID` or `blkid`.

## Notes & Pitfalls

- Device naming: SATA/SCSI `/dev/sdX`, NVMe `/dev/nvmeXnY` + `pN` partitions, virtio often `/dev/vdX`.
- Alignment is usually automatic; avoid manual cylinder math on modern disks.
- Changing a live root partition table is high risk — use rescue media.
- Residual filesystem signatures: wipe carefully (`wipefs`) only when intentional.
- Cloud images may already be GPT with growable partitions — don’t blindly recreate.
- After type change to LVM/RAID, tools expect the matching stack (`pvcreate`, mdadm, …).

## Related Commands

- `parted` / `gdisk` — alternative partition editors
- `sfdisk` — scriptable dump/restore
- `mkfs` — create filesystem on a partition
- `lsblk` / `blkid` — verify layout and UUIDs
- `partprobe` / `blockdev --rereadpt` — refresh kernel view
- `wipefs` — inspect/clear signatures (destructive)

## Additional Resources

- `man fdisk`
- `man sfdisk`
- `man parted`

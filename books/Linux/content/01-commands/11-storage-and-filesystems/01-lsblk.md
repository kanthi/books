# lsblk

## Overview

`lsblk` lists block devices (disks, partitions, LVM logical volumes, loop devices, ROM) as a tree. First stop when you plug in a disk, write fstab entries, or answer “what is `/dev/sdb1`?”. It shows topology and filesystem metadata; it does **not** report free space inside filesystems — use `df` / `duf` for capacity.

## Syntax

```bash
lsblk [options] [device...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-f` | Filesystem view: FSTYPE, LABEL, UUID, FSAVAIL, FSUSE%, mountpoints |
| `-o COLS` | Custom column list |
| `-p` | Full device paths (`/dev/sda` not `sda`) |
| `-a` | Include empty devices |
| `-d` | Devices only (no partition children) |
| `-e 7` | Exclude major number 7 (loop) — hide snap noise |
| `-J` / `-O` | JSON / all known columns |
| `-t` | Topology (alignment, scheduler, discard) |
| `-S` | SCSI devices only |
| `-n` | No header (script-friendly with `-o`) |
| `-r` | Raw (no tree indentation) |

Useful columns: `NAME,SIZE,TYPE,FSTYPE,LABEL,UUID,MOUNTPOINTS,MODEL,TRAN,ROTA,SERIAL,PARTUUID`.

## Key Use Cases

1. Inventory disks after attach (USB, cloud volume, NVMe)
2. Collect UUID/LABEL for durable fstab lines
3. Distinguish SSD/NVMe vs spinning (`ROTA`, `TRAN`)
4. Map LVM/mapper children under parent disks
5. Feed scripts with JSON or selected columns

## Examples with Explanations

### Everyday inventory

```bash
lsblk
lsblk -f
lsblk -p
```

Default tree shows NAME, MAJ:MIN, RM, SIZE, RO, TYPE, MOUNTPOINTS. `-f` adds FSTYPE/LABEL/UUID — the view you want before mount or fstab work. `-p` prints full paths for copy-paste into commands.

### UUID-ready view for fstab

```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS
lsblk -o NAME,PARTUUID,UUID,FSTYPE,MOUNTPOINTS -p
```

Prefer `UUID=` (or `PARTUUID=` for partitions without a FS yet) over `/dev/sdX` names that can reorder on reboot.

### Hide loop noise (snaps)

```bash
lsblk -e 7
lsblk -e 7 -f
# or filter: lsblk | grep -v loop
```

Ubuntu systems with many snaps flood the tree with loop devices. Major 7 is loop; exclude it for human scanning.

### JSON for scripts

```bash
lsblk -J -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS | jq .
lsblk -J -o NAME,SIZE,TYPE,MOUNTPOINTS | jq -r '.blockdevices[].name'
```

Stable structure for automation; combine with `jq` rather than parsing the pretty tree.

### Topology / rotational / transport

```bash
lsblk -d -o NAME,SIZE,ROTA,TYPE,TRAN,MODEL,SERIAL
# ROTA=0 often SSD/NVMe; TRAN=nvme|sata|usb|sas
```

`-d` limits to whole disks. Use this when capacity planning or placing I/O-heavy workloads (prefer `TRAN=nvme` over USB).

### One device subtree

```bash
lsblk -f /dev/nvme0n1
lsblk -f /dev/sdb
```

Focus on a single parent and its partitions/holders — less noise on multi-disk hosts.

### Align with blkid and mounts

```bash
lsblk -f
sudo blkid
findmnt -D
```

Cross-check: `lsblk` topology, `blkid` superblock tags, `findmnt` what is actually mounted.

### Empty or new disk check

```bash
lsblk -f /dev/sdb
# no FSTYPE / no children → raw or unpartitioned; confirm size matches expectation
```

Before `fdisk`/`mkfs`, verify size and that nothing is already mounted on that path.

## Understanding Output

| Field | Meaning |
|-------|---------|
| Tree indent | Parent disk → partitions → LVM/dm children |
| `TYPE` | `disk`, `part`, `lvm`, `crypt`, `loop`, `rom`, … |
| `FSTYPE` | Superblock type (`ext4`, `xfs`, `vfat`, `crypto_LUKS`, …); empty ≈ raw/unformatted |
| `UUID` / `LABEL` | Filesystem identity for fstab |
| `MOUNTPOINTS` | Where mounted (multiple possible with binds on recent util-linux) |
| `ROTA` | `1` rotational disk, `0` usually SSD/NVMe |
| `TRAN` | Transport: `nvme`, `sata`, `usb`, … |
| `RM` | Removable flag |

Kernel device names (`sda` vs `sdb`, `nvme0n1p1`) are **not** stable across boots or controller probe order.

## Notes & Pitfalls

- Kernel names change; always pin mounts with UUID/LABEL/PARTUUID.
- `lsblk` is not free-space accounting — use `df -h` / `findmnt -D` for capacity.
- Some details need root; listing usually works unprivileged.
- Multipath hosts may show both `/dev/sdX` and `/dev/mapper/mpath*` — mount the multipath node.
- Cloud “detach/attach” can renumber disks; re-run `lsblk` after attach before scripting.
- RAID/LVM: format/mount the logical device, not a single member disk.

## Related Commands

- `blkid` — probe UUID/LABEL/TYPE from superblocks
- `findmnt` — mounts as tree/table/JSON
- `df` / `duf` — capacity of mounted filesystems
- `fdisk` / `parted` — partition tables
- `lvs` / `vgs` / `pvs` — LVM detail
- `ls -l /dev/disk/by-uuid` — udev stable symlinks

## Additional Resources

- `man lsblk`
- `man 8 lsblk` column list (`--help` also lists columns)

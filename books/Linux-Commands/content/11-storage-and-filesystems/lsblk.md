# lsblk

## Overview
`lsblk` lists block devices (disks, partitions, LVM, loop, ROM) as a tree. First stop when you plug in a disk, build fstab entries, or figure out “what is `/dev/sdb1`?”.

## Syntax
```bash
lsblk [options] [device...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f` | Filesystem type, LABEL, UUID, FSAVAIL, mountpoints |
| `-o COLS` | Custom columns |
| `-p` | Full device paths |
| `-a` | Empty devices too |
| `-d` | Devices only (no holders/slaves tree expansion styles) |
| `-e 7` | Exclude major numbers (e.g. loop) |
| `-J` / `-O` | JSON / all columns |
| `-t` | Topology (alignment, sched) |
| `-S` | SCSI devices only |

Useful columns: `NAME,SIZE,TYPE,FSTYPE,LABEL,UUID,MOUNTPOINTS,MODEL,TRAN,ROTA`.

## Examples with Explanations
### Everyday inventory
```bash
lsblk
lsblk -f
lsblk -p
```

### UUID-ready view for fstab
```bash
lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS
```

### Hide loop noise (snaps)
```bash
lsblk -e 7
# or: lsblk | grep -v loop
```

### JSON for scripts
```bash
lsblk -J -o NAME,SIZE,TYPE,MOUNTPOINTS | jq .
```

### Topology / rotational?
```bash
lsblk -d -o NAME,SIZE,ROTA,TYPE,TRAN,MODEL
# ROTA=0 often SSD/NVMe; TRAN=nvme|sata|usb
```

### One device
```bash
lsblk -f /dev/nvme0n1
```

## Understanding Output
- Tree shows parent disk → partitions → LVM/mapper children.  
- Multiple `MOUNTPOINTS` possible with bind mounts (util-linux recent).  
- Empty FSTYPE usually means raw/unformatted or special.

## Notes & Pitfalls
- Kernel names (`sdX`, `nvme0n1p1`) can change; prefer UUID/LABEL in fstab.  
- `lsblk` does not free space of *filesystems* — use `df` for that.  
- Needs permissions for some details; usually fine unprivileged for listing.

## Related Commands
- `blkid` — superblock UUID/LABEL probe  
- `findmnt` — mounts as tree/table  
- `df` — capacity  
- `fdisk` / `parted` — partition tables  
- `lvs`/`vgs`/`pvs` — LVM detail

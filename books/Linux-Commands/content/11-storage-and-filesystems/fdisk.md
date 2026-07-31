# fdisk

## Overview
`fdisk` manipulates DOS/MBR and GPT partition tables on block devices. Interactive by default. For scripting GPT, many prefer `parted` or `sfdisk`.

## Syntax
```bash
sudo fdisk [-l] [device...]
sudo fdisk device          # interactive
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List partitions |
| `-x` | Extra list detail |
| `-w always\|never` | Wipe signatures when writing (newer) |

Interactive keys (common): `m` help, `p` print, `n` new, `d` delete, `t` type, `w` write, `q` quit.

## Safety
Writing a partition table can destroy data. Double-check device (`lsblk`, `fdisk -l`). Do not change mounted system disks without a recovery plan.

## Examples with Explanations
### List all
```bash
sudo fdisk -l
sudo fdisk -l /dev/sdb
```

### Interactive create (sketch)
```bash
sudo fdisk /dev/sdb
# g  (new GPT)
# n  (new partition — accept defaults or set size)
# t  (type, e.g. 20 Linux filesystem / 31 Linux LVM)
# p  (review)
# w  (write)
```

### Kernel re-read
```bash
sudo partprobe /dev/sdb
# or: sudo blockdev --rereadpt /dev/sdb
lsblk /dev/sdb
```

### Scripted dump/restore (sfdisk)
```bash
sudo sfdisk -d /dev/sdb > sdb.layout
# sudo sfdisk /dev/sdb < sdb.layout
```

## Notes
- After partitioning: `mkfs`, then `mount` or LVM.  
- NVMe devices: `/dev/nvme0n1`, partitions `/dev/nvme0n1p1`.  
- Alignment is usually automatic on modern fdisk.

## Related Commands
- `parted` / `gdisk` — GPT-focused tools  
- `sfdisk` — scriptable  
- `mkfs` — create filesystem  
- `lsblk` / `blkid`

# parted

## Overview

`parted` creates and modifies **partition tables** (GPT/MSDOS) on block devices. Prefer it for GPT disks and scripted partitioning; `fdisk` remains common for interactive MBR/GPT on small admin tasks. Mistakes destroy data — work on the correct device only.

## Syntax

```bash
sudo parted [options] device [command...]
sudo parted device print
```

## Common Commands (interactive or CLI)

| Command | Description |
|---------|-------------|
| `print` | Show partition table |
| `mklabel gpt\|msdos` | Create new disklabel (**wipes**) |
| `mkpart` | Create partition |
| `rm N` | Delete partition number N |
| `resizepart` | Resize partition boundary |
| `unit GiB` | Display/input units |
| `align-check` | Alignment check |

## Safety

- **Double-check** `lsblk` / `by-id` paths before any `mklabel` or `rm`.  
- `mklabel` destroys the existing table.  
- After partitioning, create filesystems with `mkfs` and update `fstab` by UUID.  
- On disks with LVM/RAID, coordinate with `pvcreate`/`mdadm` first.

## Examples with Explanations

### Print table

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,UUID
sudo parted /dev/sdb print
sudo parted -l
```

### GPT with one partition (scripted)

```bash
sudo parted -s /dev/sdb mklabel gpt
sudo parted -s /dev/sdb mkpart primary ext4 1MiB 100%
sudo parted /dev/sdb align-check optimal 1
sudo mkfs.ext4 /dev/sdb1
```

### Interactive

```bash
sudo parted /dev/sdb
# (parted) unit GiB
# (parted) print
# (parted) quit
```

## Notes & Pitfalls

- Kernel may need `partprobe` or a re-plug to re-read tables.  
- NVMe partitions look like `/dev/nvme0n1p1` (note the `p`).  
- Cloud disks often already have GPT — don’t re-label casually.

## Related Commands

- `fdisk` / `gdisk` — alternate partitioners  
- `lsblk` / `blkid` — inventory  
- `mkfs` / `mount` — after partitioning  
- `wipefs` — clear signatures  

## Additional Resources

- `man parted`  
- `info parted`

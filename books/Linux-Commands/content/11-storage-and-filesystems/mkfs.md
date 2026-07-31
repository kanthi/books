# mkfs

## Overview
`mkfs` builds a filesystem on a device (partition, LV, file). Usually invoked as `mkfs.ext4`, `mkfs.xfs`, `mkfs.vfat`, etc.

## Syntax
```bash
sudo mkfs -t type [fs-options] device
sudo mkfs.ext4 [options] device
sudo mkfs.xfs [options] device
```

## Safety
**Destroys existing data** on the target. Confirm with `lsblk -f` that the device is correct and unmounted. Never mkfs the wrong disk on a multi-disk host.

## Examples with Explanations
### ext4 data disk
```bash
sudo mkfs.ext4 -L data /dev/sdb1
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
```

### XFS
```bash
sudo mkfs.xfs -f -L data /dev/sdb1
```

### FAT32 for USB interoperability
```bash
sudo mkfs.vfat -F 32 -n KEY /dev/sdc1
```

### Check after create
```bash
lsblk -f /dev/sdb1
blkid /dev/sdb1
```

### ext4 with fewer reserved blocks (non-root data)
```bash
sudo mkfs.ext4 -m 0.5 -L bulk /dev/sdb1
```
Default ~5% reserved for root on ext*; large data disks often reduce this.

## Notes
- Prefer labels/UUIDs in fstab after create.  
- LVM: mkfs on `/dev/mapper/vg-lv` not the raw disk if using LVM.  
- Swap uses `mkswap`, not mkfs.

## Related Commands
- `fsck` — check later  
- `tune2fs` — tune ext*  
- `blkid` / `lsblk -f`  
- `mount` / `fstab`

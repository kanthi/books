# resize2fs

## Overview

`resize2fs` grows or shrinks **ext2/ext3/ext4** filesystems. Growing online (mounted) is common after `lvextend` or partition expansion; shrinking requires an offline (unmounted) filesystem and extreme care.

## Syntax

```bash
sudo resize2fs [options] device [size]
```

If `size` is omitted, the filesystem expands to the size of the underlying partition/LV.

## Common Options

| Option | Description |
|--------|-------------|
| `-p` | Progress bars |
| `-f` | Force (rare) |
| `-M` | Shrink to minimum size (offline) |
| `-d flags` | Debug |

## Safety

- **Shrink** only when unmounted, after full backup and `e2fsck -f`.  
- Grow the **block device first** (`lvextend`, `parted resizepart`), then `resize2fs`.  
- XFS uses `xfs_growfs` (grow only) — not this tool.  
- Btrfs/ZFS have their own grow tools.

## Examples with Explanations

### Grow to fill LV after lvextend

```bash
sudo lvextend -L +20G /dev/vg0/root
sudo resize2fs /dev/vg0/root
df -h /
```

### Explicit size

```bash
sudo resize2fs /dev/vg0/data 50G
```

### Offline shrink (dangerous — backup first)

```bash
sudo umount /mnt/data
sudo e2fsck -f /dev/vg0/data
sudo resize2fs /dev/vg0/data 30G
# then shrink LV if desired (lvreduce), carefully matching sizes
```

## Notes & Pitfalls

- Kernel/online resize support is standard for grow on ext4; shrink is offline-only.  
- Cloud “growpart” + resize2fs is a common first-boot pattern.  
- Always match units with LVM tools (`g` vs `G` conventions).

## Related Commands

- `lvextend` / `lvs`  
- `e2fsck` / `tune2fs`  
- `xfs_growfs` — XFS  
- `findmnt` / `df`  

## Additional Resources

- `man resize2fs`

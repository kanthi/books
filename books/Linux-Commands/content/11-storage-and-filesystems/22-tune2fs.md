# tune2fs

## Overview

`tune2fs` adjusts tunable parameters on **ext2/ext3/ext4** filesystems: labels, UUID, mount-count checks, reserved blocks, feature flags, and more. Inspect with `tune2fs -l` before changing anything.

## Syntax

```bash
sudo tune2fs [options] device
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | List current superblock contents |
| `-L label` | Set volume label |
| `-U UUID\|random\|time` | Set UUID |
| `-c max-mount-counts` | Max mounts between fsck (`-1` disables) |
| `-i interval` | Max time between fsck |
| `-m percent` | Reserved blocks % for root |
| `-r blocks` | Reserved block count |
| `-o mount-options` | Default mount options |
| `-O features` | Set/clear features (careful) |

## Safety

- Wrong device ruins the wrong filesystem — confirm with `blkid` / `lsblk -f`.  
- Feature flag changes (`-O`) can make a volume unmountable on older kernels.  
- Reserved block percentage affects usable free space for non-root users.

## Examples with Explanations

### Inspect

```bash
sudo tune2fs -l /dev/vg0/root | egrep -i 'label|uuid|block count|reserved|mount count|check'
```

### Label and UUID

```bash
sudo tune2fs -L ROOT /dev/vg0/root
sudo tune2fs -U random /dev/sdb1
sudo blkid /dev/sdb1
# update fstab if UUID changed!
```

### Reserved space (big data disks)

```bash
sudo tune2fs -m 1 /dev/vg0/data     # 1% reserved instead of default ~5%
```

### Disable frequent forced fsck by mount count

```bash
sudo tune2fs -c -1 /dev/vg0/data
sudo tune2fs -i 0 /dev/vg0/data
```

Still run intentional checks after crashes.

## Related Commands

- `blkid` / `e2label` — labels/UUIDs  
- `resize2fs` — size changes  
- `e2fsck` / `fsck` — checks  
- `dumpe2fs` — alternate dump  

## Additional Resources

- `man tune2fs`

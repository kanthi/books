# blkid

## Overview
`blkid` probes devices for filesystem/RAID signatures and prints **TYPE**, **UUID**, **LABEL**. Use it when writing durable `/etc/fstab` entries.

## Syntax
```bash
sudo blkid [options] [device...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p` | Low-level probe |
| `-s TAG` | Only UUID, LABEL, TYPE, … |
| `-o value\|export\|list\|udev` | Formats |
| `-U UUID` | Path lookup by UUID |
| `-L LABEL` | Path lookup by LABEL |

## Examples with Explanations
```bash
sudo blkid
sudo blkid /dev/sdb1
sudo blkid -o export /dev/sdb1
sudo blkid -s UUID -o value /dev/sdb1
sudo blkid -U 123e4567-e89b-12d3-a456-426614174000
sudo blkid -L data
```

### fstab line sketch
```bash
UUID=$(sudo blkid -s UUID -o value /dev/sdb1)
echo "UUID=$UUID  /mnt/data  ext4  defaults  0  2"
```

### Compare with lsblk
```bash
lsblk -f
sudo blkid
```

## Notes
- May need root to read some devices.  
- Cache file `/etc/blkid.tab` or similar is managed automatically.  
- Multipath/LVM paths may show multiple names for one UUID.

## Related Commands
- `lsblk -f`  
- `findmnt`  
- `udevadm info -q property -n /dev/sdb1`

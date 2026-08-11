# wipefs

## Overview

`wipefs` probes and can **erase filesystem, RAID, or partition-table signatures** from a device without zeroing the entire disk. Useful before re-initializing disks that still claim to be members of LVM/MD/crypto volumes.

From `util-linux`.

## Syntax

```bash
wipefs [options] device
sudo wipefs -a device
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Erase all magic strings |
| `-o offset` | Erase specific offset |
| `-n` | Dry-run / no probe write (see man for version) |
| `-p` | From partition table probe |
| `-t type` | Limit to type |
| `-f` | Force |

## Safety

- This makes existing data **hard to mount**; it is destructive even though it is not a full shred.  
- Confirm the device with `lsblk -f` and `blkid`.  
- Prefer undoing LVM/MD membership with proper tools when the array is still healthy.

## Examples with Explanations

### Probe signatures

```bash
sudo wipefs /dev/sdb
sudo wipefs -p /dev/sdb
```

### Erase all signatures

```bash
sudo wipefs -a /dev/sdb
sudo blkid /dev/sdb          # should be empty
```

### After wipe — new filesystem

```bash
sudo parted -s /dev/sdb mklabel gpt
sudo parted -s /dev/sdb mkpart primary 1MiB 100%
sudo mkfs.xfs /dev/sdb1
```

## Related Commands

- `blkid` — list signatures  
- `lsblk -f` — overview  
- `dd` — full overwrite (different goal)  
- `cryptsetup` / `pvremove` / `mdadm` — structured teardown  

## Additional Resources

- `man wipefs`

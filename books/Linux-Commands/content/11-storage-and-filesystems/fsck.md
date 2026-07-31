# fsck

## Overview
`fsck` checks and repairs filesystems. It is a front-end that runs type-specific tools (`fsck.ext4`, `fsck.xfs` is limited, etc.). **Never run a destructive check on a mounted read-write filesystem.**

## Syntax
```bash
fsck [options] [-t type] [device|mountpoint...]
fsck.ext4 [options] device
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t type` | Filesystem type |
| `-A` | All filesystems from fstab |
| `-R` | Skip root (with `-A`) |
| `-M` | Skip mounted |
| `-N` | Dry-run (show what would run) |
| `-y` | Assume yes to repairs |
| `-n` | Assume no (report only; ext*) |
| `-f` | Force check even if clean |
| `-C` | Progress (ext*) |
| `-V` | Verbose |

## Safety
1. Identify device with `lsblk -f` / `blkid`.  
2. Unmount: `sudo umount /dev/sdXN` (or boot rescue/maintenance mode for root).  
3. Prefer read-only report before `-y`.  
4. **XFS:** use `xfs_repair` on unmounted devices; `fsck.xfs` is mostly a no-op.  
5. Backups matter — repair can discard corrupt data.

## Examples with Explanations
### Report-only on unmounted ext4
```bash
sudo umount /mnt/data
sudo fsck -n /dev/sdb1
# or
sudo e2fsck -n /dev/sdb1
```

### Repair with prompts
```bash
sudo fsck -f /dev/sdb1
```

### Auto-yes (careful)
```bash
sudo fsck -y /dev/sdb1
```

### Force ext4 check
```bash
sudo e2fsck -f -y /dev/sdb1
```

### Dry-run which helpers would run
```bash
sudo fsck -N -A
```

### Root filesystem
Boot into recovery/single-user or live USB; root must not be RW-mounted. Systemd may offer `fsck` on boot when unclean shutdown bits are set.

## Exit codes (bitmask)
| Bit | Meaning |
|-----|---------|
| 0 | Clean |
| 1 | Errors corrected |
| 2 | Reboot required |
| 4 | Uncorrected errors |
| 8 | Operational error |
| 16 | Usage error |

## Related Commands
- `umount` / `mount`  
- `tune2fs -l` — ext* superblock info  
- `xfs_repair` / `btrfs check` — type-specific  
- `smartctl` — disk health (smartmontools)  
- `journalctl -b` — boot-time fsck messages

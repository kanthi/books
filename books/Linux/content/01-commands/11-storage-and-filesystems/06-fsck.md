# fsck

## Overview

`fsck` checks and optionally repairs filesystems. It is a front-end that dispatches to type-specific helpers (`fsck.ext4` → `e2fsck`, etc.). **Never run a repairing check on a mounted read-write filesystem** — unmount first, or use recovery/single-user media for the root FS. XFS is special: use `xfs_repair` offline; `fsck.xfs` is effectively a no-op.

## Syntax

```bash
fsck [options] [-t type] [device|mountpoint...]
fsck.ext4 [options] device
e2fsck [options] device
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t type` | Filesystem type (or from blkid/fstab) |
| `-A` | All filesystems from fstab |
| `-R` | Skip root (with `-A`) |
| `-M` | Skip mounted filesystems |
| `-N` | Dry-run — show what would run |
| `-y` | Assume “yes” to all repairs (careful) |
| `-n` | Assume “no” / report-only (ext* via e2fsck) |
| `-f` | Force check even if clean |
| `-C` | Progress bar (ext*) |
| `-V` | Verbose |
| `-T` | Hide title |

## Safety

1. Identify the device: `lsblk -f`, `sudo blkid`.
2. Unmount: `sudo umount /dev/sdXN` (or boot rescue for root).
3. Prefer **report-only** (`-n` / e2fsck `-n`) before auto-yes (`-y`).
4. **XFS:** `sudo xfs_repair -n /dev/…` then `xfs_repair` without `-n`; do not expect `fsck.xfs` to repair.
5. Repairs can delete corrupt inodes/data — backups matter.
6. Do not fsck the live RW root; use recovery, live USB, or vendor maintenance mode.

## Key Use Cases

1. After unclean shutdown / journal errors
2. Before reusing a suspect data disk
3. Boot-time automatic checks (fstab pass field / systemd)
4. Forced ext* check after resize or corruption reports

## Examples with Explanations

### Report-only on unmounted ext4

```bash
lsblk -f /dev/sdb1
sudo umount /mnt/data 2>/dev/null || true
sudo findmnt /dev/sdb1 && { echo "still mounted — abort"; exit 1; }
sudo fsck -n /dev/sdb1
# or explicit:
sudo e2fsck -n /dev/sdb1
```

`-n` opens read-only and reports problems without writing fixes.

### Interactive repair

```bash
sudo umount /mnt/data
sudo fsck -f /dev/sdb1
```

Answer prompts carefully. `-f` forces a full check even if the FS is marked clean.

### Auto-yes repair (after backup / when you accept loss)

```bash
sudo e2fsck -f -y /dev/sdb1
```

Convenient for automation and clearly disposable data; risky on irreplaceable volumes without backups.

### Dry-run which helpers would run

```bash
sudo fsck -N -A
sudo fsck -N /dev/sdb1
```

Shows the planned `fsck.<type>` invocations without executing checks.

### Force ext4 check with progress

```bash
sudo e2fsck -f -C 0 /dev/sdb1
```

Progress on file descriptor 0’s tty-style reporting; useful on large volumes.

### Root filesystem

```bash
# Boot Ubuntu recovery / live USB, find root device:
lsblk -f
# ensure root is not mounted RW, then:
sudo e2fsck -f /dev/nvme0n1p2
# systemd may run fsck on boot when dirty flags are set — check:
journalctl -b | grep -i fsck
```

Plan downtime. For cloud VMs, attach the disk to a rescue instance and fsck there.

### XFS path

```bash
sudo umount /mnt/data
sudo xfs_repair -n /dev/sdb1    # no-modify scan
sudo xfs_repair /dev/sdb1       # repair
# NOT: fsck.xfs  (does not repair)
```

### Mount and verify after clean check

```bash
sudo fsck -n /dev/sdb1
sudo mount /dev/sdb1 /mnt/data
dmesg | tail
df -h /mnt/data
```

## Understanding Output / Exit codes

Messages vary by helper. e2fsck prints phases (superblock, bitmaps, inodes, directory structure, …).

Exit code is a **bitmask** (bits can combine):

| Bit | Meaning |
|-----|---------|
| 0 | No errors |
| 1 | File system errors corrected |
| 2 | System should be rebooted |
| 4 | File system errors left uncorrected |
| 8 | Operational error |
| 16 | Usage or syntax error |
| 32 | Fsck canceled by user |
| 128 | Shared library error |

```bash
sudo fsck -n /dev/sdb1
echo $?   # interpret with the table above
```

## Notes & Pitfalls

- Mounted RW checks are unsafe; some tools refuse, others can destroy data.
- fstab sixth field controls boot fsck order/pass; `0` skips.
- btrfs/zfs use native check/scrub tools, not classic fsck workflows.
- Hardware faults: pair with `smartctl` — repairing FS won’t fix a dying disk.
- Journal-only recovery often happens automatically on mount for ext*; full fsck is for deeper issues.
- `-y` can remove damaged files to restore consistency — that is success for fsck, data loss for you.

## Related Commands

- `umount` / `mount` — offline requirement
- `tune2fs -l` — ext* superblock / mount counts
- `xfs_repair` / `btrfs check` — type-specific
- `smartctl` — disk health (smartmontools)
- `journalctl -b` — boot-time fsck messages
- `blkid` / `lsblk -f` — identify devices

## Additional Resources

- `man fsck`
- `man e2fsck`
- `man xfs_repair`

# hdparm

## Overview

`hdparm` gets and sets **ATA/SATA disk** parameters: identify data, power management, read-ahead, write-cache, and controversial performance timings. Useful for bare-metal disk troubleshooting. Wrong settings can risk **data loss** — especially write-cache and dangerous benchmark flags.

Prefer vendor tools / smartmontools for health; use `hdparm` carefully.

## Syntax

```bash
hdparm [options] device
```

Device is typically `/dev/sda` (whole disk), not a partition.

## Common Options

| Option | Description |
|--------|-------------|
| `-I` | Detailed identity information |
| `-i` | Kernel’s identify summary |
| `-C` | Power mode status |
| `-M` | AAM acoustic (legacy) |
| `-B` | APM level |
| `-S` | Standby timeout |
| `-W` | Write-cache on/off query/set |
| `-a` / `-A` | Read-ahead |
| `-t` / `-T` | Timing buffered disk / cache reads (**benchmark load**) |
| `--security-*` | ATA security (dangerous) |
| `-y` / `-Y` | Standby / sleep now |
| `-z` | Reread partition table |

## Examples with Explanations

### Identify

```bash
sudo hdparm -I /dev/sda
sudo hdparm -i /dev/sda
sudo smartctl -a /dev/sda
```

### Power status

```bash
sudo hdparm -C /dev/sda
```

### Read-only info queries (safer)

```bash
sudo hdparm -W /dev/sda
sudo hdparm -a /dev/sda
```

### Benchmarks (I/O heavy; maintenance window)

```bash
sudo hdparm -tT /dev/sda
```

Interprets sequential throughput roughly; not a substitute for `fio`.

### Write cache (know the risk)

```bash
sudo hdparm -W /dev/sda
# enabling write cache without barriers/UPS can lose data on power loss
```

Prefer filesystem/mount and device defaults unless you know the storage stack.

### Reread partitions

```bash
sudo hdparm -z /dev/sda
# often partprobe / blockdev --rereadpt also used
```

## Notes / Pitfalls

- **Never** experiment with `--security-erase` / passwords on disks you care about without full understanding.
- USB bridges and NVMe devices may ignore or poorly implement ATA commands — NVMe has `nvme` CLI.
- Cloud block volumes often virtualize away hdparm usefulness.
- Timing tests stress disks — avoid on production peaks.
- Requires root.

## 2026-relevant notes

- NVMe dominates SSDs: learn `nvme list`, `nvme smart-log` alongside `hdparm`.
- For spinning rust power policies on laptops, distro power tools may be safer than manual `-B`/`-S`.
- Always have backups before storage experiments.

## Related Commands

- `smartctl` — SMART health
- `nvme` — NVMe admin
- `lsblk` / `fdisk` / `blkid` — topology
- `fio` — proper benchmarks
- `blockdev` — low-level block ioctls

## Additional Resources

- `man hdparm` (read warnings)

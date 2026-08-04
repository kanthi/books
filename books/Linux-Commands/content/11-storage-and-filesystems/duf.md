# duf

## Overview

`duf` is a modern, colorful **disk usage / free space** viewer — a friendlier alternative to `df -h`. It groups local, network, special, and inaccessible filesystems with readable tables. Optional install (`apt install duf`, etc.). Keep `df` for scripts and minimal systems.

## Syntax

```bash
duf [options] [device/path...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-all` | Show all filesystems including pseudo |
| `-only local|network|fuse|special|loops|binds` | Filter types |
| `-only-mp` / `-only-device` | Filter by mount/device strings |
| `-hide` | Hide types |
| `-output` | Choose columns |
| `-sort` | Sort key (`size`, `used`, `avail`, `usage`, …) |
| `-json` | JSON output |
| `-style` | UI style |
| `-theme` | Color theme |
| `-width` | Width |
| `-inodes` | Inode view |
| `-avail-threshold` / `-usage-threshold` | Highlight thresholds |

Confirm with `duf --help` for your version.

## Examples with Explanations

### Everyday

```bash
duf
duf -only local
duf /
duf -sort usage
```

### Inodes

```bash
duf -inodes
df -ih
```

### JSON

```bash
duf -json | jq .
```

### Hide noise

```bash
duf -hide special,loops,binds
# or only local disks:
duf -only local
```

### Compare with df

```bash
df -hT
duf
findmnt
```

### Threshold awareness

```bash
duf -usage-threshold 0.8
```

Highlights nearly full mounts when supported.

## Notes / Pitfalls

- Not portable to bare recovery images — know `df -hT`.
- Colors/unicode need a capable terminal.
- Bind mounts and snap loops can still clutter — filter them.
- JSON schema may change across versions.
- Network FS free space can be misleading (quotas, cloud buckets).

## 2026-relevant notes

- Excellent interactive upgrade alongside `dust`/`eza`/`bat`.
- Monitoring systems should still scrape `node_exporter`/`df` metrics, not duf.
- Btrfs/ZFS may need native tools for pool-level free space accuracy.

## Related Commands

- `df` — portable free space
- `findmnt` — mount tree
- `du` / `dust` / `ncdu` — directory usage
- `lsblk` — block devices
- `btrfs filesystem usage` / `zpool list` — volume managers

## Additional Resources

- `duf --help`
- [muesli/duf](https://github.com/muesli/duf)

# blkid

## Overview

`blkid` probes block devices for filesystem, RAID, and crypto signatures and prints tags such as **TYPE**, **UUID**, and **LABEL**. Use it when building durable `/etc/fstab` lines, verifying a format succeeded, or resolving `UUID=` / `LABEL=` to a device path. Complements `lsblk -f` (topology) with superblock-focused output.

## Syntax

```bash
sudo blkid [options] [device...]
```

Without a device, lists known devices (may use cache; root improves completeness).

## Common Options

| Option | Description |
|--------|-------------|
| `-p` | Low-level probe (bypass some cache behavior) |
| `-s TAG` | Show only tag(s): `UUID`, `LABEL`, `TYPE`, `PARTUUID`, … |
| `-o value\|export\|list\|udev\|full` | Output format |
| `-U UUID` | Look up device path by filesystem UUID |
| `-L LABEL` | Look up device path by LABEL |
| `-c /dev/null` | Ignore cache file (force fresh probe) |

## Key Use Cases

1. Copy UUID into fstab after `mkfs`
2. Resolve `UUID=` or `LABEL=` to `/dev/…` path
3. Confirm filesystem type before mount/fsck
4. Script-friendly single-value extraction (`-o value`)

## Examples with Explanations

### List all probed devices

```bash
sudo blkid
sudo blkid -c /dev/null
```

Shows TYPE/UUID/LABEL (and more) per device. `-c /dev/null` avoids stale cache after recent formats.

### One device

```bash
sudo blkid /dev/sdb1
sudo blkid -p /dev/sdb1
```

### Export form (shell-friendly)

```bash
sudo blkid -o export /dev/sdb1
# DEVNAME=/dev/sdb1
# UUID=…
# TYPE=ext4
```

Easy to `eval` carefully or parse line-by-line in scripts.

### UUID only (fstab snippets)

```bash
sudo blkid -s UUID -o value /dev/sdb1
UUID=$(sudo blkid -s UUID -o value /dev/sdb1)
echo "UUID=$UUID  /mnt/data  ext4  defaults  0  2"
```

Prefer this over hard-coding `/dev/sdX`.

### Lookup by UUID or LABEL

```bash
sudo blkid -U 123e4567-e89b-12d3-a456-426614174000
sudo blkid -L data
ls -l /dev/disk/by-uuid/
ls -l /dev/disk/by-label/
```

Returns the device node currently bound to that identity. udev symlinks under `/dev/disk/by-*` are the other stable interface.

### Compare with lsblk

```bash
lsblk -f
sudo blkid
```

`lsblk -f` is tree-oriented; `blkid` is probe-oriented. Use both when something disagrees (cache, multipath aliases).

### After mkfs verification

```bash
sudo mkfs.ext4 -L data /dev/sdb1
sudo blkid -c /dev/null /dev/sdb1
lsblk -f /dev/sdb1
```

Confirm new UUID/LABEL before writing fstab.

### udev property style

```bash
sudo blkid -o udev /dev/sdb1
# ID_FS_UUID=…
# ID_FS_TYPE=…
```

Matches tags udev exposes; useful when correlating with `udevadm info`.

## Understanding Output

Typical line:

```text
/dev/sdb1: UUID="…" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="…"
```

| Tag | Role |
|-----|------|
| `TYPE` | Filesystem/crypto/RAID signature |
| `UUID` | Filesystem UUID (fstab `UUID=`) |
| `LABEL` | Human label (`LABEL=`) |
| `PARTUUID` | GPT partition UUID (stable even before FS) |
| `PARTLABEL` | GPT partition name |

No output often means no recognized signature (raw, wiped, or inaccessible without root).

## Notes & Pitfalls

- Root is often required for reliable probing of all devices.
- Cache can lag immediately after format — use `-c /dev/null` or `-p` when suspicious.
- Multipath/LVM: same UUID may appear under several paths; mount via mapper/multipath node consistently.
- LABEL collisions: two disks with `LABEL=data` make `LABEL=` fstab ambiguous — prefer UUID.
- LUKS: outer device shows `crypto_LUKS`; filesystem UUID appears on the opened mapper device.
- Swap shows `TYPE="swap"` with its own UUID (`/etc/crypttab` / fstab swap lines).

## Related Commands

- `lsblk -f` — topology + FS columns
- `findmnt` — active mounts
- `udevadm info -q property -n /dev/sdb1` — udev properties
- `ls /dev/disk/by-uuid` — stable symlinks
- `wipefs -n` — list signatures without blkid cache

## Additional Resources

- `man blkid`
- `man fstab`

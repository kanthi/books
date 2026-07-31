# losetup

## Overview
`losetup` is used to set up and control loop devices in Linux, mapping regular files into block devices.

## Syntax
```bash
losetup [options] [loopdev] [file]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a`, `--all` | List status of all active loop devices |
| `-f`, `--find` | Find the first unused loop device |
| `-d`, `--detach LOOPDEV` | Detach specified loop device |
| `-r`, `--read-only` | Set up read-only loop device |
| `-P`, `--partscan` | Force kernel to scan partition table on newly created loop device |

## Key Use Cases
1. Mounting disk image files (`.img`, `.iso`) as block devices.
2. Creating virtual storage devices for testing filesystems.
3. Accessing individual partitions inside disk image files using `-P`.

## Examples with Explanations
### Example 1: Map Image File to Loop Device
```bash
losetup -fP disk.img
```
Finds an available loop device, maps `disk.img`, and scans partition tables.

### Example 2: Detach Loop Device
```bash
losetup -d /dev/loop0
```
Unbinds and detaches `/dev/loop0`.

## Related Commands
- `mount` - Mount filesystems
- `lsblk` - List block devices

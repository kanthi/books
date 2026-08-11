# dmesg

## Overview

`dmesg` prints the kernel ring buffer: hardware detection, driver messages, OOM kills, I/O errors, and other kernel-level events. First stop when a device doesn’t appear, a disk fails, or the system OOMs. On systemd systems, the same stream is also available via `journalctl -k`.

## Syntax

```bash
dmesg [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-H` | Human-readable timestamps |
| `-T` | Absolute human timestamps |
| `-k` | Kernel messages only |
| `-u` | Userspace messages (facility filter) |
| `-w` / `--follow` | Wait for new messages |
| `-W` | Follow after clearing wait logic variants |
| `-l level` | Filter by level |
| `-f facility` | Filter by facility |
| `-n level` | Set console log level |
| `-C` / `-c` | Clear / read-and-clear |
| `-x` | Decode facility/level prefixes |
| `-e` | Local time / reltime variants (see man) |
| `--color` | Colorize |

## Examples with Explanations

### Recent kernel messages

```bash
dmesg | less
dmesg -T | less
dmesg -H
```

### Follow live (plug hardware)

```bash
dmesg -w
# or
journalctl -kf
```

### Errors and warnings

```bash
dmesg -T -l err,warn
dmesg -T | grep -iE 'error|fail|oom|i/o'
```

### OOM investigation

```bash
dmesg -T | grep -i 'killed process'
journalctl -k | grep -i oom
```

### USB / disk events

```bash
dmesg -T | tail -50
dmesg -T | grep -i usb
dmesg -T | grep -i sd
```

### Clear buffer (careful)

```bash
sudo dmesg -C
```

Usually unnecessary; prefer filtering by time.

### Permissions

```bash
# unprivileged may see restricted buffer on modern kernels
sudo dmesg
# sysctl kernel.dmesg_restrict
```

## Notes / Pitfalls

- Ring buffer is finite — old messages drop; use journal persistence for history.
- Timestamps with `-T` depend on timekeeping across suspend/boot.
- Don’t spam `dmesg -c` on production; you lose context for others.
- Userspace app logs are **not** here — use `journalctl` / syslog.
- Containers may not expose full host kernel messages.

## 2026-relevant notes

- `journalctl -k -b` for current boot kernel logs is often more convenient with persistent journal.
- Hardware still fails the same way — `dmesg` remains essential on bare metal.
- PSI and detailed MM logs complement OOM dmesg lines on modern kernels.

## Related Commands

- `journalctl -k` — kernel via journal
- `udevadm` — device events
- `lspci` / `lsusb` — hardware lists
- `smartctl` — disk health
- `sysctl` — kernel parameters including log levels

## Additional Resources

- `man dmesg`

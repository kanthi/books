---
title: Intro
---

# Intro

Write and maintain traditional logs: kernel ring buffer, syslog-style messages, and rotation. On systemd systems, pair these with `journalctl` from Services and runtime.

## Commands in this part

| Command | Role |
|---------|------|
| `dmesg` | dmesg prints the kernel ring buffer: hardware detection, driver messages, OOM kills, I/O errors, and other… |
| `logger` | logger writes messages to the system log from the shell or scripts. |
| `logrotate` | logrotate rotates, compresses, and retires log files so they do not fill disks. |


## Suggested starting points

1. Kernel messages: `dmesg` (and `journalctl -k`).
2. Emit a message: `logger`.
3. Manage growth: `logrotate`.

## Related parts

- Services and runtime — `journalctl`
- Text and pipes — mine log files with `grep`/`jq`
- Archives and compression — `zgrep` on rotated `.gz` logs

Continue with the individual command pages in this part.

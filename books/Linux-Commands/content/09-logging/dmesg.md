# dmesg

## Overview
`dmesg` (diagnostic message) displays or controls the kernel ring buffer. It is used to examine kernel boot messages, driver initialization events, hardware errors, and out-of-memory (OOM) killer events.

## Syntax
```bash
dmesg [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-H`, `--human` | Enable human-readable, colorized output with timestamps |
| `-T`, `--ctime` | Print human-readable timestamps |
| `-l`, `--level LEVEL` | Restrict output to specific facility levels (e.g. `emerg`, `alert`, `crit`, `err`, `warn`, `info`) |
| `-w`, `--follow` | Wait for new messages (similar to `tail -f`) |
| `-C`, `--clear` | Clear the kernel ring buffer (requires root privileges) |

## Key Use Cases
1. Inspecting kernel events during boot troubleshooting.
2. Detecting hardware insertion/removal (USB, disk, network interface).
3. Investigating process termination caused by OOM (Out Of Memory) events.

## Examples with Explanations
### Example 1: View Kernel Warnings and Errors with Timestamps
```bash
dmesg -T -l err,warn
```
Displays all kernel error and warning messages with human-readable timestamps.

### Example 2: Monitor Real-time Kernel Events
```bash
dmesg -w
```
Follows the kernel ring buffer in real time as new device or kernel events occur.

## Related Commands
- `journalctl` - Query systemd journal logs
- `uname` - Print system and kernel information

# systemd-analyze

## Overview

`systemd-analyze` diagnoses **boot performance** and unit graphs: how long boot took, which units delayed it, whether unit files are valid, and whether calendar/timer expressions parse. First tool when “the box boots slowly”.

## Syntax

```bash
systemd-analyze [options] [subcommand]
```

## Common Subcommands

| Subcommand | Description |
|------------|-------------|
| `time` | Firmware/loader/kernel/userspace timings |
| `blame` | Units sorted by time to start |
| `critical-chain` | Critical path to default target |
| `plot > boot.svg` | SVG timeline |
| `verify UNIT…` | Static unit file checks |
| `calendar EXPR` | Explain calendar schedule |
| `security UNIT` | Sandbox exposure score (newer) |
| `dot` | Dependency graph (graphviz) |

## Examples with Explanations

### Boot timings

```bash
systemd-analyze time
systemd-analyze blame | head
systemd-analyze critical-chain
```

### Plot

```bash
systemd-analyze plot > /tmp/boot.svg
# open in a browser
```

### Verify units after editing

```bash
systemd-analyze verify /etc/systemd/system/myapp.service
```

### Calendar expressions (timers)

```bash
systemd-analyze calendar 'Mon..Fri *-*-* 09:00:00'
systemd-analyze calendar 'weekly'
```

### Security profile (where available)

```bash
systemd-analyze security ssh.service | head
```

## Notes & Pitfalls

- First boot after kernel update can skew blame times.  
- Network mounts and cloud-init often dominate critical-chain.  
- Containers without systemd won’t produce meaningful host boot data.

## Related Commands

- `systemctl`  
- `journalctl -b`  
- `systemd-run`  
- `bootctl` — EFI bootloader (where applicable)  

## Additional Resources

- `man systemd-analyze`

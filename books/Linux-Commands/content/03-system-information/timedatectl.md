# timedatectl

## Overview
`timedatectl` views and sets system time, timezone, and NTP synchronization via systemd.

## Syntax
```bash
timedatectl [options] [command]
```

## Common Commands
| Command | Description |
|---------|-------------|
| `status` | Show clock/NTP state (default) |
| `list-timezones` | Available zones |
| `set-timezone Zone` | Set zone |
| `set-time 'YYYY-MM-DD HH:MM:SS'` | Manual time |
| `set-ntp true\|false` | Enable systemd-timesyncd/NTP |

## Examples with Explanations
```bash
timedatectl
timedatectl status
timedatectl list-timezones | grep -i america
sudo timedatectl set-timezone America/New_York
sudo timedatectl set-ntp true
timedatectl show
```

### Check sync
```bash
timedatectl | grep -i ntp
# or
systemctl status systemd-timesyncd
# chrony users: chronyc tracking
```

## Notes
- Prefer NTP over manual `set-time` on networked hosts.  
- RTC vs UTC: `timedatectl set-local-rtc 0` recommended for Linux.  
- Containers may inherit host time and restrict changes.

## Related Commands
- `date` — print/format time  
- `hwclock` — hardware clock  
- `chronyc` / `ntpstat` — other NTP stacks

# last

## Overview
`last` reads the login wtmp database and shows recent logins, reboots, and shutdowns — useful for security reviews and “when did this box reboot?”.

## Syntax
```bash
last [options] [username...] [tty...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n NUM / -NUM` | Show NUM lines |
| `-a` | Display hostname in last column |
| `-x` | Include shutdown/runlevel entries |
| `-F` | Full timestamps |
| `-i` | Numeric IPs |
| `reboot` | As argument: show reboot lines only (common usage: last reboot) |

## Key Use Cases
1. Audit recent logins
2. See reboot history
3. Investigate suspicious sessions
4. Correlate with auth logs

## Examples with Explanations
### Recent logins
```bash
last -n 20
```
Latest sessions including still-logged-in.

### Reboot history
```bash
last reboot | head
```
Quick uptime/reboot timeline.

### One user
```bash
last -a alice
```
Focus on a single account; `-a` shows host origin.

### Full time format
```bash
last -F -n 10
```
Easier correlation with log timestamps.

## Notes & Pitfalls
- Data comes from `/var/log/wtmp` (binary); rotation policies affect depth of history.

## Related Commands
- `who` / `w` — currently logged in
- `lastlog` — last login per account
- `journalctl` — detailed auth/service logs
- `faillog` / `pam` logs — failed attempts (distro-specific)

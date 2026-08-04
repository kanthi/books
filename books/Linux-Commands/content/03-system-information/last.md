# last

## Overview

`last` shows a history of logins, reboots, and runlevel changes from the `wtmp` accounting file (typically `/var/log/wtmp`). Use it after security incidents, to see when a machine rebooted, or who logged in from where. Companion: `lastb` (bad logins from `btmp`), `lastlog` (per-user last login).

## Syntax

```bash
last [options] [username...] [tty...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Display hostname in last column |
| `-d` | Translate IP to hostname |
| `-F` | Full timestamps |
| `-n N`, `-N` | Show N lines |
| `-R` | Suppress hostname field |
| `-i` | Show IP as numbers |
| `-x` | Include shutdown/runlevel entries |
| `-w` | Widen fields for long names |
| `-f file` | Alternate wtmp file |
| `-s` / `-t` | Since / until times (when supported) |

## Examples with Explanations

### Recent logins

```bash
last
last -n 20
last -a
last -i
last -F
```

### One user

```bash
last alice
last root
```

### Reboots and shutdowns

```bash
last reboot
last -x | head
who -b
uptime -s
```

### Bad logins

```bash
sudo lastb | head
sudo lastb -a
```

Requires permission to read `btmp`.

### Rotate awareness

```bash
last -f /var/log/wtmp.1
ls /var/log/wtmp*
```

After logrotate, older history lives in rotated files.

### SSH audit starter

```bash
last -ai | head -50
journalctl -u ssh -n 50
journalctl _COMM=sshd -n 50
```

## Notes / Pitfalls

- Missing/empty wtmp means no history (containers, stripped images, misconfigured logging).
- Hostnames from `-d` depend on DNS and can mislead; prefer `-i` for forensics.
- Entries can be incomplete if the machine crashed without clean logout (shows `crash` / `down` / still logged in).
- Not a full security log — pair with `journalctl`, auditd, cloud provider logs.
- Timezones: interpret with system TZ settings.

## 2026-relevant notes

- Many fleets centralize auth logs; local `last` is still valuable on a single host incident.
- systemd / logind sessions: also check `loginctl` and journal.
- Immutable hosts may reset wtmp on reboot depending on design — know your image.

## Related Commands

- `lastb` — failed logins
- `lastlog` — per-user last login table
- `who` / `w` — currently logged in
- `journalctl` — structured logs
- `utmpdump` — raw utmp/wtmp decode
- `aureport` — audit framework reports (if auditd)

## Additional Resources

- `man last`, `man wtmp`

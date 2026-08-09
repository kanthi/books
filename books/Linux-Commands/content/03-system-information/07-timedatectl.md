# timedatectl

## Overview

`timedatectl` views and changes the system clock, timezone, RTC settings, and NTP synchronization on **systemd** systems. Prefer it over ad-hoc `date -s` for persistent timezone and NTP policy. On Ubuntu Server, default NTP is often **systemd-timesyncd**; some hosts use **chrony** instead — enable one cleanly, not both fighting.

## Syntax

```bash
timedatectl [options] [command]
```

## Common Commands / Options

| Command / option | Description |
|------------------|-------------|
| `status` | Show time, TZ, NTP state (default) |
| `show` | Machine-readable properties |
| `list-timezones` | All zone names |
| `set-timezone Zone` | Set timezone (e.g. `UTC`, `America/New_York`) |
| `set-time 'YYYY-MM-DD HH:MM:SS'` | Set clock manually (disable NTP first if required) |
| `set-ntp true\|false` | Enable/disable NTP (systemd unit) |
| `set-local-rtc 0\|1` | RTC in UTC (0, recommended for Linux) or local |
| `-H host` / `--machine=` | Remote/container via systemd |
| `--no-ask-password` | Non-interactive privilege |

## Key Use Cases

1. First-boot timezone + NTP setup
2. Verify clock sync before Kerberos/TLS-sensitive work
3. Switch TZ for multi-region servers (prefer UTC on servers)
4. Diagnose “TLS not yet valid” / log timestamp skew

## Examples with Explanations

### Status

```bash
timedatectl
timedatectl status
```

Shows local time, universal time, RTC, timezone, and whether NTP is active/synchronized.

### Machine-readable

```bash
timedatectl show
timedatectl show -p Timezone -p NTP -p NTPSynchronized --value
```

Good for scripts and monitoring checks.

### List and set timezone

```bash
timedatectl list-timezones | grep -i america
timedatectl list-timezones | grep -i '^Asia/'
sudo timedatectl set-timezone UTC
sudo timedatectl set-timezone America/New_York
timedatectl
```

Server fleets usually standardize on **UTC**; set human TZ only when local wall time is required.

### Enable NTP (systemd-timesyncd path)

```bash
sudo timedatectl set-ntp true
timedatectl
systemctl status systemd-timesyncd --no-pager
# Ubuntu may use:
systemctl status systemd-timesyncd.service
```

`set-ntp true` lets systemd enable the appropriate time-sync unit.

### Chrony hosts

```bash
# If chrony is the chosen stack:
sudo apt install chrony
sudo systemctl enable --now chrony
# timedatectl should still report NTP synchronized when chrony steps/slews correctly
chronyc tracking
chronyc sources -v
timedatectl
```

Don’t leave timesyncd and chrony both active and conflicting — pick one source of truth.

### Manual time (maintenance / air-gap)

```bash
sudo timedatectl set-ntp false
sudo timedatectl set-time '2026-08-09 12:00:00'
# re-enable NTP when network is available:
sudo timedatectl set-ntp true
```

Manual set is a last resort; large steps can confuse databases and cert validation.

### RTC in UTC (recommended on Linux)

```bash
timedatectl | grep -i rtc
sudo timedatectl set-local-rtc 0
```

Dual-boot with Windows may fight over local vs UTC RTC — document the choice on shared hardware.

### Verify sync health

```bash
timedatectl | grep -iE 'ntp|time zone|synchronized'
# timesyncd:
timedatectl timesync-status 2>/dev/null || true
journalctl -u systemd-timesyncd -n 20 --no-pager
# chrony:
chronyc tracking 2>/dev/null || true
```

“System clock synchronized: yes” is the headline for TLS and distributed systems.

### date interaction

```bash
date
date -u
date --iso-8601=seconds
timedatectl
```

`date` formats the current clock; `timedatectl` manages policy (TZ/NTP/RTC).

## Understanding Output

Typical `timedatectl` status fields:

| Field | Meaning |
|-------|---------|
| Local time | Wall time in current TZ |
| Universal time | UTC |
| RTC time | Hardware clock reading |
| Time zone | IANA zone name + offset |
| System clock synchronized | Whether systemd believes sync is good |
| NTP service | active/inactive |
| RTC in local TZ | n = UTC (preferred on Linux-only) |

`timedatectl show` exposes properties like `Timezone=`, `NTP=`, `NTPSynchronized=`, `TimeUSec=`.

## Notes & Pitfalls

- Prefer NTP over permanent manual `set-time` on networked hosts.
- Containers often inherit host time and **cannot** change the host clock; TZ can still be set in-process via `TZ` env.
- Cloud images may already enforce UTC + timesync — cloud-init can reapply settings.
- Large backward clock jumps break `make`, systemd units, and DB leases — prefer slewing via NTP.
- Kerberos and TLS are intolerant of multi-minute skew.
- `set-timezone` does not rewrite historical log timestamps already written.
- Virtual hardware RTC quality varies; NTP remains mandatory for accuracy.

## Related Commands

- `date` — print/format time
- `hwclock` — read/set hardware clock directly
- `chronyc` / `chronyd` — chrony stack
- `ntpdate` — legacy one-shot (avoid on modern systemd; use chrony/timesyncd)
- `hostnamectl` — host identity companion on first boot
- `timedatectl timesync-status` — timesyncd detail when available

## Additional Resources

- `man timedatectl`
- `man systemd-timesyncd.service`
- `man chrony.conf` (when using chrony)

# anacron

## Overview

`anacron` runs periodic commands on machines that are **not on 24/7** — laptops, desktops, and intermittent VMs. Unlike `cron`, which expects the system to be up at a specific minute, anacron ensures daily/weekly/monthly jobs run when the machine is powered on after a missed window.

On many modern distros, anacron is integrated with **systemd timers** and `/etc/cron.{daily,weekly,monthly}` via `cron`/`anacron` packages.

## Syntax

```bash
anacron [options] [job]
anacron -T                     # test tab syntax (when supported)
```

## Common Options

| Option | Description |
|--------|-------------|
| `-s` | Serialize jobs; run sequentially |
| `-f` | Force run ignoring timestamps |
| `-n` | Run jobs now, ignore delays |
| `-d` | Debug to stderr; don’t background |
| `-q` | Quiet with `-d` |
| `-t file` | Use alternate anacrontab |
| `-S dir` | Spool directory for timestamps |
| `-u` | Update timestamps without running |

## Configuration

Primary table: `/etc/anacrontab`

Typical fields:

```text
period  delay  job-id  command
1       5      cron.daily    run-parts --report /etc/cron.daily
7       10     cron.weekly   run-parts --report /etc/cron.weekly
@monthly 15    cron.monthly  run-parts --report /etc/cron.monthly
```

Timestamps live under `/var/spool/anacron/`.

## Examples with Explanations

### Status / integration

```bash
cat /etc/anacrontab
ls /var/spool/anacron/
systemctl status anacron.service anacron.timer 2>/dev/null
systemctl list-timers | grep -i cron
```

### Force a run (careful)

```bash
sudo anacron -f -d
sudo anacron -n -d cron.daily
```

`-d` keeps output in the foreground for debugging.

### Update timestamps only

```bash
sudo anacron -u
```

Marks jobs as done without executing — use sparingly.

### Put a job in daily.d style

```bash
sudo install -m 755 /usr/local/sbin/backup-homes /etc/cron.daily/backup-homes
# anacron/cron.daily will pick it up on next daily pass
```

### Prefer systemd timer for new work

```bash
# example unit pair
# /etc/systemd/system/mybackup.service
# /etc/systemd/system/mybackup.timer
sudo systemctl enable --now mybackup.timer
systemctl list-timers
```

## Notes / Pitfalls

- Random **delay** field prevents thundering herds when many laptops resume together.
- Jobs must be safe to run after multi-day gaps (catch-up logic).
- Overlap: don’t also schedule the same heavy job at a fixed cron minute without coordination.
- Spool timestamps require writable `/var`; read-only root systems need alternate design.
- Logging often via syslog/journal — check `journalctl -u anacron`.

## 2026-relevant notes

- systemd timers with `Persistent=true` cover many anacron use cases on modern hosts.
- Still relevant for classic `/etc/cron.daily` ecosystems on Debian/Ubuntu desktops.
- Cloud fleets that auto-scale should use durable queues/schedulers, not host-local anacron alone.

## Related Commands

- `cron` / `crontab` — time-based schedules
- `systemd-run` / `.timer` units — modern scheduling
- `run-parts` — run scripts in a directory
- `journalctl` — logs
- `at` — one-shot future commands

## Additional Resources

- `man anacron`, `man anacrontab`

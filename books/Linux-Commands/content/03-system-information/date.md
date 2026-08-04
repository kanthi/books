# date

## Overview

`date` prints or sets the system date and time. Daily use is formatting timestamps for logs, filenames, and scripts. Setting the clock requires privileges and is usually better left to **NTP/`timedatectl`** on modern systems.

## Syntax

```bash
date [options] [+FORMAT]
date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]   # set (legacy)
```

## Common Options

| Option | Description |
|--------|-------------|
| `+FORMAT` | Output format string |
| `-u`, `--utc` | UTC |
| `-d STRING`, `--date=` | Display time described by STRING (not set) |
| `-f FILE` | Like `-d` for each line in FILE |
| `-s STRING`, `--set=` | Set time (privileged) |
| `-R` | RFC 5322 format |
| `-I[TIMESPEC]` | ISO 8601 (`date -Iseconds`) |
| `-r FILE` | Use file mtime |

## Useful format sequences

| Seq | Meaning |
|-----|---------|
| `%Y-%m-%d` | 2026-08-04 |
| `%H:%M:%S` | 14:05:09 |
| `%F` | Same as `%Y-%m-%d` |
| `%T` | Same as `%H:%M:%S` |
| `%s` | Epoch seconds |
| `%z` / `%Z` | Offset / timezone name |
| `%V` | ISO week |
| `%a` / `%A` | Weekday |

## Examples with Explanations

### Now

```bash
date
date -u
date -Iseconds
date +%F
date +%Y%m%d-%H%M%S
date +%s
```

### Convert / relative

```bash
date -d '2026-01-15 10:00'
date -d '2 days ago' +%F
date -d '@1700000000'
date -d 'next Monday'
```

### Filenames and logs

```bash
logfile="app-$(date +%Y%m%d).log"
echo "$(date -Is) started" >> "$logfile"
```

### File mtime

```bash
date -r /etc/hosts
stat -c %y /etc/hosts
```

### Timezone one-off

```bash
TZ=UTC date
TZ=America/New_York date
timedatectl
```

### Set clock (prefer NTP)

```bash
# last resort; prefer chrony/systemd-timesyncd
sudo date -s '2026-08-04 12:00:00'
sudo timedatectl set-time '2026-08-04 12:00:00'
sudo timedatectl set-ntp true
```

### GNU vs scripts

```bash
# portable-ish epoch:
date +%s
# ISO local:
date -Iseconds
```

## Notes / Pitfalls

- Setting time on production without NTP understanding breaks certs, logs, and Kerberos.
- Locale affects names (`%B`); use `LC_ALL=C` for stable parsing.
- macOS `date` flags differ; this book targets GNU/Linux.
- Leap seconds / monotonic clocks: for durations prefer `EPOCHREALTIME` or dedicated monotonic APIs in apps.
- Containers may use host time namespace.

## 2026-relevant notes

- Always enable NTP via `timedatectl` / chrony on servers.
- Log pipelines prefer UTC (`date -u -Iseconds`).
- For scheduling, pair with `systemd-run` / cron and explicit TZ.

## Related Commands

- `timedatectl` — timezone and NTP status
- `hwclock` — hardware clock
- `cal` — calendar
- `touch -d` — set file times
- `stat` — file timestamps

## Additional Resources

- `man date`, `man timedatectl`

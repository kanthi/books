# journalctl

## Overview

`journalctl` queries the **systemd journal** — structured logs from the kernel, services, and many applications. On journald systems it replaces a large share of traditional `/var/log/syslog` grepping while adding boot-aware filters and machine-readable output.

## Syntax

```bash
journalctl [options] [matches...]
```

Matches look like `FIELD=value` (e.g. `_SYSTEMD_UNIT=nginx.service`, `_PID=1234`, `PRIORITY=3`).

## Common Options

| Option | Description |
|--------|-------------|
| `-u UNIT` | Messages for unit (repeatable) |
| `-b` / `-b -1` / `-b ID` | Current / previous / specific boot |
| `-f` | Follow (like `tail -f`) |
| `-e` | Jump to end in pager |
| `-n N` | Last N entries |
| `-p PRIORITY` / `-p from..to` | Priority filter (`err`, `warning`, `0`–`7`) |
| `-S` / `-U` / `--since` / `--until` | Time window |
| `-o short-iso` / `json` / `json-pretty` / `cat` | Output format |
| `-k` | Kernel messages only |
| `-x` | Extra explanations when available |
| `-g REGEX` | Message regex filter (newer) |
| `--disk-usage` | On-disk journal size |
| `--vacuum-size=` / `--vacuum-time=` / `--vacuum-files=` | Reclaim space |
| `--no-pager` | stdout for scripts |
| `-r` | Reverse (newest first) |

## Key Use Cases

1. Debug a failed service  
2. Follow live logs while reproducing a bug  
3. Inspect the previous boot after a crash/reboot  
4. Export structured logs for `jq` / SIEM  

## Examples with Explanations

### Unit logs

```bash
journalctl -u ssh.service -n 50 --no-pager
journalctl -u nginx --since "1 hour ago"
journalctl -u nginx -u php8.3-fpm --since today
```

### Follow

```bash
journalctl -u myapp -f
```

### Previous boot / crash triage

```bash
journalctl --list-boots
journalctl -b -1 -p err..alert --no-pager
journalctl -b -1 -u kdump.service
```

### Kernel / dmesg-like

```bash
journalctl -k -b
journalctl -k --since "10 min ago"
```

### Time window

```bash
journalctl --since "2026-08-10 09:00:00" --until "2026-08-10 10:00:00"
journalctl --since -30m
```

### Priority

```bash
journalctl -p err -b
journalctl -p warning..crit -u myapp
```

### JSON for jq

```bash
journalctl -u nginx -o json -n 100 | jq -r '.MESSAGE'
journalctl -u nginx -o json-pretty -n 5
```

### Field matches

```bash
journalctl _COMM=sudo -n 20
journalctl _UID=1000 --since today | head
journalctl CODE_FILE=/usr/bin/something   # when apps set structured fields
```

### Disk usage and vacuum

```bash
journalctl --disk-usage
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=14d
```

Persistent journals grow until vacuum or system policy limits apply.

### Catalog / explain

```bash
journalctl -x -u NetworkManager -n 20
```

## Understanding Output

Default opens a pager. Each line includes timestamp, hostname, syslog identifier, PID, and message. Use `--no-pager` in scripts. Privileges: members of `systemd-journal` or `adm` (distro-dependent) can read more than their own user journals.

## Notes & Pitfalls

- Without persistent storage (`/var/log/journal`), logs may live only in volatile `/run/log/journal` and vanish on reboot.  
- Vacuum carefully on hosts that need long forensic retention.  
- Noisy units: rate-limit in the service or drop journal rate limits thoughtfully in `journald.conf`.  
- `grep` on pager output is inferior to `-u`/`-g`/field matches for large journals.

## Related Commands

- `systemctl` — service control and status  
- `dmesg` — kernel ring buffer  
- `logger` — write to journal/syslog  
- `jq` — parse JSON output  
- `last` / `lastb` — login history (not journal)  

## Additional Resources

- `man journalctl`  
- `man journald.conf`  
- `man systemd.journal-fields`

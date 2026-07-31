# journalctl

## Overview
`journalctl` queries the **systemd journal** — structured logs from the kernel, services, and many applications. It replaces much of traditional `/var/log/syslog` grepping on journald systems.

## Syntax
```bash
journalctl [options] [matches...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u UNIT` | Messages for unit |
| `-b` / `-b -1` | Current / previous boot |
| `-f` | Follow (like `tail -f`) |
| `-e` | Jump to end |
| `-n N` | Last N lines |
| `-p PRIORITY` | Priority threshold (e.g. `err`) |
| `-S` / `-U` | Since / until time |
| `-o json` / `json-pretty` | Machine-readable |
| `-k` | Kernel messages only |
| `-x` | Extra explanations when available |
| `--disk-usage` | Journal size on disk |
| `--vacuum-size=` / `--vacuum-time=` | Reclaim space |
| `-g REGEX` | Filter message regex (newer) |

## Key Use Cases
1. Debug a failed service  
2. Watch live logs while reproducing a bug  
3. Inspect previous boot after crash  
4. Export structured logs for processing  

## Examples with Explanations
### Unit logs
```bash
journalctl -u ssh.service -n 50 --no-pager
journalctl -u nginx --since "1 hour ago"
```

### Follow
```bash
journalctl -u myapp -f
```

### Previous boot
```bash
journalctl -b -1 -p err..alert
```

### Kernel / dmesg-like
```bash
journalctl -k -b
```

### Time window
```bash
journalctl --since "2026-07-31 09:00:00" --until "2026-07-31 10:00:00"
```

### Priority
```bash
journalctl -p err -b
```

### JSON for jq
```bash
journalctl -u nginx -o json-pretty -n 5
journalctl -u nginx -o json -n 100 | jq -r '.MESSAGE'
```

### Disk usage and vacuum
```bash
journalctl --disk-usage
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=14d
```

## Understanding Output
Default is a pager (`less`-like). Timestamps, hostname, syslog identifier, PID, and message are shown. Use `--no-pager` in scripts/CI.

## Common Usage Patterns
### Failed service triage
```bash
systemctl status myapp --no-pager
journalctl -u myapp -b --no-pager -n 100
```

### Boot list
```bash
journalctl --list-boots
```

## Notes & Pitfalls
- Persistent journals need `/var/log/journal` and proper config; otherwise logs may be volatile in `/run/log/journal`.  
- Access to other users’ journals may require membership in `systemd-journal` or `adm`.  
- Large journals: vacuum or rate-limit noisy units.  

## Related Commands
- `systemctl` — service control  
- `dmesg` — kernel ring buffer  
- `logger` — write to journal/syslog  
- `jq` — parse JSON output  

## Additional Resources
- `man journalctl`  
- `man journald.conf`

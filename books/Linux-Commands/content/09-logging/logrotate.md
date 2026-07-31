# logrotate

## Overview
`logrotate` rotates, compresses, and retires log files so they do not fill disks. Driven by cron or a systemd timer; config lives in `/etc/logrotate.conf` and `/etc/logrotate.d/*`.

## Syntax
```bash
logrotate [options] configfile
sudo logrotate -d /etc/logrotate.conf
sudo logrotate -f /etc/logrotate.d/rsyslog
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Debug (no changes) |
| `-f` | Force rotation |
| `-v` | Verbose |
| `-s statefile` | State file path |

## Common config directives
| Directive | Meaning |
|-----------|---------|
| `daily`/`weekly`/`monthly`/`size 100M` | When |
| `rotate N` | Keep N old logs |
| `compress` / `delaycompress` | gzip old |
| `missingok` / `notifempty` | Robustness |
| `create mode owner group` | New empty log |
| `copytruncate` | Copy then truncate (apps that keep FD open) |
| `postrotate … endscript` | Reload app after rotate |
| `dateext` | Use dates in filenames |
| `sharedscripts` | One postrotate for all files in block |

## Example snippet
```bash
/var/log/myapp/*.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    create 0640 myapp myapp
    sharedscripts
    postrotate
        systemctl reload myapp >/dev/null 2>&1 || true
    endscript
}
```

## Examples with Explanations
### Dry-run
```bash
sudo logrotate -d /etc/logrotate.conf
```

### Force one config
```bash
sudo logrotate -f -v /etc/logrotate.d/myapp
```

### See state
```bash
sudo cat /var/lib/logrotate/status | head
```

## Notes
- Prefer app-native reopening (SIGHUP/reload) over `copytruncate` when possible.  
- Journald logs are **not** managed by logrotate; use `journalctl --vacuum-*`.  
- After rotate, confirm app still writes to the live path.

## Related Commands
- `logger` / `journalctl`  
- `systemctl reload`  
- `df` / `du` — disk pressure

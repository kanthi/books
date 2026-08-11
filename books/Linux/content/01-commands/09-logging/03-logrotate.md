# logrotate

## Overview

`logrotate` rotates, compresses, and retires log files so they do not fill disks. On Ubuntu it is driven by a **systemd timer** or cron, reading `/etc/logrotate.conf` plus drop-ins in `/etc/logrotate.d/`. Application logs you add should get a file under `/etc/logrotate.d/`. Journald logs are **not** managed here — use `journalctl --vacuum-*` for the journal.

## Syntax

```bash
logrotate [options] configfile
sudo logrotate -d /etc/logrotate.conf
sudo logrotate -f /etc/logrotate.d/rsyslog
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d` | Debug/dry-run — no changes |
| `-f` | Force rotation even if not due |
| `-v` | Verbose |
| `-s statefile` | Alternate state file (default `/var/lib/logrotate/status`) |
| `--skip-state-cleanup` | Keep status entries for vanished logs (version-dependent) |

## Common config directives

| Directive | Meaning |
|-----------|---------|
| `daily` / `weekly` / `monthly` / `hourly` | Time-based rotation |
| `size 100M` / `maxsize 100M` | Size-based (see man for size vs maxsize) |
| `rotate N` | Keep N old logs |
| `compress` / `delaycompress` | gzip (delay: skip most recent rotated) |
| `missingok` | Don’t error if log absent |
| `notifempty` | Skip empty logs |
| `create mode owner group` | Create new empty log after rotate |
| `copytruncate` | Copy then truncate in place (apps that never reopen) |
| `dateext` / `dateformat` | Date-based suffixes |
| `sharedscripts` | Run `postrotate` once for the whole block |
| `postrotate` … `endscript` | Reload/signal app after rotate |
| `su user group` | Run as user when directories are restricted |
| `olddir` | Move rotated files elsewhere |
| `maxage days` | Remove rotated logs older than N days |

## Key Use Cases

1. Keep `/var/log` from filling root
2. Rotate custom application logs with reload hooks
3. Force rotation during an incident when a log explodes
4. Dry-run config after edits before production force

## Examples with Explanations

### Dry-run entire system config

```bash
sudo logrotate -d /etc/logrotate.conf
```

Shows which logs **would** rotate and why (or why not). No files changed. Always do this after editing drop-ins.

### Force one drop-in (verbose)

```bash
sudo logrotate -f -v /etc/logrotate.d/rsyslog
# or your app:
sudo logrotate -f -v /etc/logrotate.d/myapp
```

Use when testing a new stanza or recovering from a multi-GB log that should have rotated.

### Inspect state

```bash
sudo cat /var/lib/logrotate/status | head -50
sudo grep myapp /var/lib/logrotate/status
```

State tracks last rotation times; corrupted/stale state can skip or confuse schedules — know where it lives.

### Example application drop-in

```bash
# /etc/logrotate.d/myapp
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

After install:

```bash
sudo logrotate -d /etc/logrotate.d/myapp
sudo logrotate -f -v /etc/logrotate.d/myapp
ls -la /var/log/myapp/
```

### copytruncate when the app won’t reopen

```bash
/var/log/legacy/app.log {
    size 100M
    rotate 7
    copytruncate
    missingok
    compress
    delaycompress
}
```

`copytruncate` avoids needing a signal, but can race and drop a few lines. Prefer apps that reopen on `SIGHUP`/`systemctl reload` with `create` + postrotate.

### size-based emergency pattern

```bash
/var/log/myapp/debug.log {
    size 500M
    rotate 5
    compress
    missingok
    notifempty
    copytruncate
}
```

Helps when a debug flag left on would otherwise fill the disk overnight.

### When does it run? (Ubuntu)

```bash
systemctl list-timers | grep -i logrotate
systemctl status logrotate.timer logrotate.service
# classic cron path may still exist on some releases:
ls /etc/cron.daily/logrotate
```

Timers can delay runs if the machine was off (`Persistent=` semantics vary).

### Disk pressure triage with logs

```bash
df -h /var/log
sudo du -xh /var/log | sort -h | tail
sudo logrotate -f -v /etc/logrotate.conf
# journal is separate:
journalctl --disk-usage
sudo journalctl --vacuum-size=500M
```

## Understanding Output

`-d` / `-v` lines explain decisions: “log does not need rotating”, “log needs rotating”, compression steps, and postrotate execution. Failures often come from permissions (`su` needed), missing directories, or postrotate scripts exiting non-zero.

Exit code non-zero should be treated as config or script failure — check unit logs:

```bash
journalctl -u logrotate.service -n 50
```

## Notes & Pitfalls

- **Journald ≠ logrotate** — vacuum the journal separately.
- Prefer reload/reopen over `copytruncate` when the app supports it.
- After rotate, confirm the app still writes to the live path (not a deleted inode).
- `sharedscripts` + wildcards: postrotate runs once; without it, once per file.
- Permissions: log dirs owned by apps may need `su` in the stanza.
- Compressing huge logs can spike CPU/disk — `delaycompress` spreads pain.
- Don’t rotate active database files or non-log data with logrotate recipes.
- Test with `-d` in CI or staging before shipping drop-ins.

## Related Commands

- `logger` — write to syslog
- `journalctl` — systemd journal (vacuum, query)
- `systemctl reload` — reopen logs cleanly
- `df` / `du` — disk pressure
- `lsof` — deleted-but-open logs still holding space

## Additional Resources

- `man logrotate`
- `man logrotate.conf`
- `/etc/logrotate.conf` and `/etc/logrotate.d/*` on the host

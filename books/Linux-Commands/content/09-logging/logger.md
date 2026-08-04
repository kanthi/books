# logger

## Overview

`logger` writes messages to the system log from the shell or scripts. It is the command-line interface to the syslog/journal stack — useful for marking deploy steps, cron output, and ad-hoc audit notes that should land next to service logs.

On systemd systems, messages typically appear in the **journal** (`journalctl`) and may also be forwarded to classic syslog daemons.

## Syntax

```bash
logger [options] [message]
echo message | logger [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p priority` | Facility.level e.g. `user.notice`, `local0.warning` |
| `-t tag` | Tag (defaults often to user name) |
| `-i` | Include PID in the tag |
| `-s` | Also write to stderr |
| `-f file` | Log each line of file |
| `-n host` | Remote syslog host (when supported) |
| `-P port` | Remote port |
| `-u socket` | Log socket path |
| `--journald` | Send via journal fields (newer util-linux) |
| `-e` | Skip empty lines |

## Examples with Explanations

### Simple messages

```bash
logger "deploy started"
logger -t deploy -i "step 1 complete"
logger -p local0.info "backup ok"
```

### From scripts

```bash
#!/bin/bash
tag=mybackup
log() { logger -t "$tag" -p user.notice "$*"; }
log "starting"
# ...
log "finished"
```

### Pipe multi-line output

```bash
df -h | logger -t diskcheck
mycommand 2>&1 | logger -t mycommand -i
```

### Priority levels

```bash
logger -p user.debug "debug detail"
logger -p user.warning "watch this"
logger -p user.err "failed to mount backup"
```

Facility.level pairs control routing in rsyslog/syslog-ng; journal stores priority as well.

### View on systemd

```bash
logger -t demo "hello journal"
journalctl -t demo -n 5
journalctl -t demo -f
```

### stderr mirror

```bash
logger -s -t demo "visible in console and log"
```

### Structured-ish with journald (when supported)

```bash
logger --journald <<EOF
MESSAGE=deployment finished
PRIORITY=5
DEPLOY_ID=42
EOF
```

## Notes / Pitfalls

- Rate limiting may drop floods of messages (rsyslog/journald).
- Remote logging needs network syslog config; `-n` alone may be insufficient on hardened hosts.
- Don’t log secrets (tokens, passwords).
- Cron: prefer logging explicitly; cron mails can be unreliable.
- Priorities only help if collectors honor them.

## 2026-relevant notes

- Prefer `journalctl` for local investigation; ship logs with vector/fluent-bit/alloy for fleets.
- `systemd-cat` is an alternative that attaches stdout to the journal with unit-like metadata.
- For apps, native journal/syslog libraries beat wrapping everything in `logger`.

## Related Commands

- `journalctl` — query journal
- `systemd-cat` — pipe to journal
- `rsyslogd` / `syslog-ng` — classic daemons
- `dmesg` — kernel ring buffer
- `wall` — broadcast to ttys (not syslog)

## Additional Resources

- `man logger`

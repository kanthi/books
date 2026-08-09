# watch

## Overview

`watch` runs a command repeatedly, showing fullscreen output so you can see changes over time. Ideal for ad-hoc monitoring (`df`, `kubectl get`, `systemctl status`) without writing a loop. Not a metrics system — for long-term graphs use Prometheus/node_exporter or similar.

## Syntax

```bash
watch [options] COMMAND
watch [options] -- COMMAND
```

`COMMAND` is passed to `sh -c` by default, so shell features work inside the watched string.

## Common Options

| Option | Description |
|--------|-------------|
| `-n SECS`, `--interval SECS` | Seconds between runs (default 2; fractions OK on modern procps) |
| `-d`, `--differences` | Highlight differences between runs |
| `-d=permanent` | Keep highlighting changes persistently |
| `-t`, `--no-title` | Hide header (interval, host, command) |
| `-b`, `--beep` | Beep if command exits non-zero |
| `-e`, `--errexit` | Freeze screen on non-zero exit |
| `-g`, `--chgexit` | Exit when output changes |
| `-c`, `--color` | Interpret ANSI color sequences |
| `-x`, `--exec` | Pass command to `exec` instead of `sh -c` |
| `-p`, `--precise` | Attempt to run every interval accounting for command runtime |

## Key Use Cases

1. Watch disk, memory, or service state during an incident
2. Wait until a condition changes (`-g`) then continue a scripted workflow
3. Highlight diffs while configs or replica counts converge
4. Lightweight “dashboard” over SSH without extra tools

## Examples with Explanations

### Example: basic interval monitor

```bash
watch -n 1 df -h
```

Refresh disk usage every second.

### Example: highlight changes

```bash
watch -d free -h
watch -d 'ip -s link show eth0'
```

Changed characters flash between iterations — great for counters and free memory.

### Example: multi-command pipeline

```bash
watch -n 2 'ps aux --sort=-%cpu | head -n 15'
```

Quote the whole pipeline so the shell inside `watch` owns the pipe.

### Example: systemd / journal peek

```bash
watch -n 2 'systemctl --failed --no-pager'
watch -n 1 'systemctl is-active nginx; systemctl status nginx --no-pager | head -n 15'
```

Handy while restarting services.

### Example: exit when output changes

```bash
watch -g -n 1 'cat /var/run/myapp/ready'
echo "ready flag changed"
```

Blocks until the command’s output differs from the first run, then exits. Useful as a crude barrier in shell workflows.

### Example: stop on error

```bash
watch -e -n 5 './healthcheck.sh'
```

Freezes on first non-zero exit so you can read the failure output.

### Example: colors from modern CLIs

```bash
watch -c -n 2 'ls --color=always -l /srv/data'
```

Without `-c`, ANSI escapes may show as garbage.

### Example: precise interval

```bash
watch -p -n 5 'date +%T; ./poll.sh'
```

Tries to keep wall-clock cadence even when `poll.sh` takes a second or two (not a hard realtime guarantee).

### Example: exec mode (no shell)

```bash
watch -x -n 1 ping -c 1 1.1.1.1
```

Avoids `sh -c` — safer when you do not want shell expansion, but pipelines/globs will not work.

## Notes & Pitfalls

- Default shell is `sh -c`; quote carefully and avoid unescaped `$` that expand **before** `watch` runs (use single quotes for the outer command string).
- Long-running watched commands that exceed the interval will stack poorly without `-p` discipline; keep the inner command fast.
- `watch` clears the screen — redirect-friendly logging needs a different approach (`while sleep; do …; done >> log`).
- Exit with `Ctrl-C`.
- On minimal systems ensure `procps`/`procps-ng` is installed (Ubuntu has `watch` from that package).

## Related Commands

- `while sleep N; do …; done` — scriptable loop with logging
- `vmstat 1` / `iostat -xz 1` — specialized continuous metrics
- `journalctl -f` / `tail -f` — follow streams
- `systemd-run` / timers — scheduled work
- `timeout` — bound a single run

## Additional Resources

- `man watch`

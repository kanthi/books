# timeout

## Overview

`timeout` runs a command and sends a signal if it still runs after a duration. Use it to bound hung network tools, flaky tests, or “should never take this long” maintenance scripts. Default kill signal is **`TERM`**; you can escalate to **`KILL`** after a grace period.

## Syntax

```bash
timeout [options] DURATION COMMAND [ARG]...
```

## Duration format

| Form | Meaning |
|------|---------|
| `10` | 10 seconds |
| `10s` | 10 seconds |
| `5m` | 5 minutes |
| `2h` | 2 hours |
| `1d` | 1 day |
| `0` / unset special | See man page — `0` disables the timeout on GNU coreutils |

Floating point seconds are accepted (e.g. `0.5`).

## Common Options

| Option | Description |
|--------|-------------|
| `-s SIGNAL`, `--signal=SIGNAL` | Signal on timeout (default `TERM`) |
| `-k DURATION`, `--kill-after=DURATION` | After first signal, wait then send `KILL` |
| `-f`, `--foreground` | Do not run command in a separate group (foreground quirks) |
| `-p`, `--preserve-status` | Exit with the command’s status even on timeout |
| `-v`, `--verbose` | Diagnose signal sends |
| `--` | End of options (when command looks like a flag) |

## Exit status (GNU coreutils)

| Status | Meaning |
|--------|---------|
| `124` | Command timed out (default) |
| `125` | `timeout` itself failed |
| `126` | Command found but not invocable |
| `127` | Command not found |
| `137` | Often command killed by SIGKILL (128+9) depending on path |
| other | Exit status of `COMMAND` if it finished in time |

With `--preserve-status`, a timed-out command may return the status as if it received the signal (e.g. 128+signal) rather than 124 — check `man timeout` for your coreutils version.

## Safety

- Bound commands that talk to **production** carefully — abrupt TERM can leave partial migrations; prefer app-level deadlines when available.
- Always consider **`-k`** so wedged processes that ignore TERM do not hang your automation forever.
- `timeout` is not a substitute for proper service health checks and systemd `TimeoutStopSec=`.

## Key Use Cases

1. Cap flaky CI steps and network probes
2. Prevent hung `fsck`, `scp`, or package hooks from blocking unattended jobs
3. Force-fail long unit tests
4. Demo/debug with short lifetimes

## Examples with Explanations

### Example: basic time limit

```bash
timeout 10s ping -c 1000 1.1.1.1
```

Stops ping after 10 seconds even if count is not finished.

### Example: TERM then KILL grace period

```bash
timeout -k 5s 30s ./migrate.sh
```

At 30s send **TERM**; if still alive 5s later, send **KILL**. Default operator pattern for stubborn processes.

### Example: choose the first signal

```bash
timeout -s INT 20s ./app
timeout --signal=TERM -k 10s 2m ./app
```

INT mimics Ctrl-C; TERM is the usual graceful stop.

### Example: capture timeout in scripts

```bash
if timeout 1m ./backup.sh; then
  echo "backup ok"
else
  rc=$?
  if [ "$rc" -eq 124 ]; then
    echo "backup timed out" >&2
  else
    echo "backup failed rc=$rc" >&2
  fi
  exit "$rc"
fi
```

Treat 124 as a distinct failure mode in monitoring and retries.

### Example: verbose diagnosis

```bash
timeout -v -k 2s 5s sleep 60
```

Shows which signals were sent when.

### Example: network tool guardrails

```bash
timeout 15s curl -fsS https://example.com/health
timeout 5s dig +time=2 +tries=1 example.com
```

Keeps cron probes from stacking up when DNS or HTTP hangs.

### Example: command that starts with a dash

```bash
timeout 10s -- ./mytool --dangerous-flag
```

`--` prevents option eating by `timeout`.

### Example: foreground mode

```bash
timeout --foreground 30s vim file.txt
```

Sometimes needed for programs that expect to be session leaders or read the TTY specially; default separate process group is usually correct for daemons/scripts.

## Notes & Pitfalls

- Children that **double-fork** or reparent may outlive the timed command group depending on how they detach — design jobs not to daemonize if you need hard bounds.
- Pipeline gotcha: `timeout 5s cmd1 | cmd2` only times out `cmd1` unless you structure differently (`timeout 5s bash -c 'cmd1 | cmd2'`).
- systemd units have their own start/stop timeouts; combine thoughtfully.
- BusyBox `timeout` option sets are smaller — stick to common flags in portable scripts.

## Related Commands

- `kill` — manual signaling
- `timelimit` — alternative on some systems
- `systemd-run -p RuntimeMaxSec=` — cgroup-enforced limits
- `nice` / `ionice` — resource politeness without a deadline
- `nohup` — survive hangup (orthogonal concern)

## Additional Resources

- `man timeout`

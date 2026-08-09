# kill

## Overview

`kill` sends a signal to one or more processes by **PID**. Despite the name, the default signal is **`TERM` (15)** — a polite request to exit. Only escalate to **`KILL` (9)** after a graceful stop fails. Prefer `systemctl stop` / `systemctl reload` for units managed by systemd.

## Syntax

```bash
kill [options] PID...
kill -SIGNAL PID...
kill -s SIGNAL PID...
kill -l [signal]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-s SIGNAL`, `-SIGNAL` | Signal name or number (`TERM`, `HUP`, `9`, …) |
| `-l` | List signal names (or translate a number ↔ name) |
| `-n SIGNAL` | Same idea as `-s` on some implementations |
| `-p` (bash builtin only) | Print PID instead of signaling (shell-specific) |

Signals you will use constantly:

| Signal | Number | Typical meaning |
|--------|--------|-----------------|
| `TERM` | 15 | Graceful stop (**default**) |
| `HUP` | 1 | Hangup / often “reload config” |
| `INT` | 2 | Interrupt (like Ctrl-C) |
| `QUIT` | 3 | Quit with core (if allowed) |
| `KILL` | 9 | Force kill — **uncatchable** |
| `STOP` | 19 | Pause (uncatchable) |
| `CONT` | 18 | Resume after STOP |
| `USR1` / `USR2` | 10 / 12 | Application-defined |

## Safety

1. **Always verify the PID** before signaling: `ps -p PID -o pid,user,cmd` or `ps -fp PID`.
2. **TERM first, then wait, then KILL** — never jump to `-9` on production workers unless the process is wedged.
3. Wrong PID on a multi-tenant host can take down databases, SSH, or the wrong customer job.
4. You may only signal processes you own unless you are root.
5. Prefer **service managers** for supervised daemons: `systemctl stop UNIT`, not ad-hoc `kill` on random PIDs from `ps`.

## Key Use Cases

1. Stop a runaway user process after verifying the PID
2. Reload a daemon that documents `SIGHUP` handling
3. Force-kill a process stuck in userspace after TERM fails
4. Test whether a PID still exists (`kill -0`)

## Examples with Explanations

### Example: graceful stop (default TERM)

```bash
ps -fp 1234
kill 1234
# same as:
kill -TERM 1234
kill -15 1234
kill -s TERM 1234
```

Default signal is TERM. Confirm the process is the one you intend with `ps` first.

### Example: TERM, wait, then KILL

```bash
PID=1234
kill -TERM "$PID"
for i in 1 2 3 4 5; do
  kill -0 "$PID" 2>/dev/null || break
  sleep 1
done
if kill -0 "$PID" 2>/dev/null; then
  echo "still alive; forcing" >&2
  kill -KILL "$PID"
fi
```

`kill -0 PID` checks existence and permission **without** delivering a real signal. Use this pattern instead of blind `kill -9`.

### Example: force kill only when necessary

```bash
kill -KILL 1234
# or
kill -9 1234
```

KILL cannot be caught or cleaned up. File locks, temp files, and child reaping may be messy. Prefer TERM whenever the process still responds.

### Example: reload via HUP

```bash
kill -HUP "$(pidof nginx)"
# better for packaged services:
sudo systemctl reload nginx
```

Many classic daemons reload config on HUP. Prefer `systemctl reload` so systemd tracks state and uses the unit’s configured reload command.

### Example: signal by name via pgrep

```bash
kill $(pgrep -x myapp)
# often clearer:
pkill -x myapp
pkill -TERM -x myapp
```

Shell word-splitting on `$(pgrep …)` is fine for PIDs; still prefer exact match (`-x`) so you do not hit similarly named processes.

### Example: stop / continue (debug freeze)

```bash
kill -STOP 1234    # freeze
# inspect, attach debugger, etc.
kill -CONT 1234    # resume
```

STOP/CONT are useful for debugging or temporarily freezing a CPU hog. A STOP’d process will not exit until CONT (or KILL).

### Example: list signals

```bash
kill -l
kill -l 15         # → TERM (often)
kill -l TERM       # → 15
```

Handy when docs show only numbers or only names.

### Example: multiple PIDs

```bash
kill -TERM 1001 1002 1003
kill -TERM $(pgrep -u "$USER" -f 'worker.py')
```

One invocation can target many PIDs. Combine with careful `pgrep` filters (`-u`, `-f`, `-x`).

### Example: permission check without killing

```bash
if kill -0 1234 2>/dev/null; then
  echo "process exists and is signalable"
else
  echo "gone or not permitted"
fi
```

Exit status of `kill -0` is ideal for scripts that poll for death after TERM.

## Understanding Output

- Success is silent; failures print to stderr (`No such process`, `Operation not permitted`).
- Exit status non-zero if **any** PID failed (implementation details vary slightly for multi-PID).
- Bash has a `kill` **builtin** that may differ slightly from `/bin/kill` (util-linux); both understand standard signals.

## Notes & Pitfalls

- **Zombies** (`Z` state) ignore signals; kill the **parent** or fix whatever is not `wait()`ing.
- Processes in uninterruptible sleep (`D` state, often I/O) may not die until the wait ends — KILL does not magically fix stuck NFS or bad block devices.
- Killing PID **1** is a terrible idea; on systemd hosts it will refuse nonsense, but do not experiment.
- Job-control shells also understand `%1` job specs with the **builtin** `kill` — different from numeric PIDs.
- Containers: killing PID 1 inside a container usually stops the container; know your runtime’s restart policy.

## Related Commands

- `pkill` / `pgrep` — select and signal by name/pattern
- `killall` — signal by process name (GNU vs BSD differences)
- `systemctl` — stop/reload supervised services
- `timeout` — auto-signal a command after a duration
- `ps` / `pidof` — identify targets
- `fuser` — signal processes holding files or ports

## Additional Resources

- `man 1 kill`
- `man 7 signal`

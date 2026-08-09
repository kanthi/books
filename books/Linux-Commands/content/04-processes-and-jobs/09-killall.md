# killall

## Overview

`killall` sends a signal to all processes matching a **command name**. On Ubuntu it is the **psmisc** implementation (name match), not the ancient SysV “kill everything” binary. Prefer `pkill` when you need regex/full-command-line filters; use `killall` for simple exact-name mass signals. Prefer `systemctl` for managed services.

## Syntax

```bash
killall [options] name...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-s SIGNAL`, `-SIGNAL` | Signal to send (default `TERM`) |
| `-e`, `--exact` | Require exact name match (long names) |
| `-I`, `--ignore-case` | Case-insensitive name |
| `-i`, `--interactive` | Prompt before each kill |
| `-l`, `--list` | List known signal names |
| `-u USER`, `--user` | Only this user’s processes |
| `-v`, `--verbose` | Report what was signaled |
| `-w`, `--wait` | Wait until processes die |
| `-r`, `--regexp` | Interpret name as extended regex (psmisc) |
| `-n`, `--ns PID` | Match processes in same namespaces as PID |
| `-Z`, `--context` | SELinux context match (when relevant) |
| `-q`, `--quiet` | Suppress “no process found” complaint |

## Safety

- Name matching can still hit **more instances** than you expect (every `python3`, every `java`).
- Prefer **`TERM` first**; only use `-9` after a wait.
- Always narrow with **`-u`** on shared hosts.
- Interactive confirm (`-i`) is cheap insurance on production bastions.
- Do not confuse with Solaris/AIX/older docs where `killall` meant something more aggressive.

## Key Use Cases

1. Stop all instances of a user-space tool by binary name
2. Reload or terminate workers that are not under systemd
3. Interactive cleanup of leftover processes after a failed deploy
4. Wait until a named process set has exited before continuing a script

## Examples with Explanations

### Example: graceful stop by name

```bash
killall myapp
killall -TERM myapp
```

Sends TERM to every process whose comm/name matches `myapp`. Equivalent intent to `pkill -x myapp` in many cases.

### Example: TERM then KILL

```bash
killall -TERM myapp
sleep 3
killall -KILL myapp 2>/dev/null
```

Give the app time to flush and exit; force only stragglers. Redirect stderr if absence after TERM is expected success.

### Example: only your processes

```bash
killall -u "$USER" -TERM chrome
killall -u deploy -TERM 'node'
```

Critical on multi-user machines so you do not signal another user’s same-named binary.

### Example: interactive confirm

```bash
killall -i -TERM python3
```

Prompts per process — use when several interpreters are running and only some should die.

### Example: verbose + wait

```bash
killall -v -w myapp
echo "all myapp processes gone"
```

`-w` blocks until matching processes exit (or cannot be killed). Useful in stop scripts before releasing a lock or port.

### Example: HUP reload pattern

```bash
killall -HUP nginx
# preferred on Ubuntu for packaged nginx:
sudo systemctl reload nginx
```

HUP is conventional for reload; systemd still owns the proper lifecycle for units.

### Example: case-insensitive / regex

```bash
killall -I MyApp
killall -r 'worker-[0-9]+'
```

`-r` uses extended regular expressions (psmisc). Test with `pgrep` first when unsure.

### Example: list signals

```bash
killall -l
```

Same idea as `kill -l`.

### Example: dry reconnaissance first

```bash
pgrep -a myapp
ps -C myapp -o pid,user,cmd
killall -i -TERM myapp
```

Always inventory before mass signaling when the blast radius is unclear.

## Notes & Pitfalls

- **GNU/psmisc vs BSD**: FreeBSD `killall` options differ — scripts should stick to portable flags or use `pkill`.
- Matching is by process **name** (comm), not necessarily full path; long names may need `-e`.
- `killall python` will not match `python3` unless you name it correctly (or use regex).
- Exit status is non-zero when **no** process matched (unless quieted) — check that in scripts.
- Kernel threads and some system processes cannot be killed; errors are expected.
- Prefer `systemctl stop foo` over `killall foo` for daemons shipped as units.

## Related Commands

- `kill` — signal by PID
- `pkill` / `pgrep` — pattern-based select/signal
- `pidof` — simple name → PID list
- `systemctl` — supervised stop/reload
- `xkill` — GUI click-to-kill (desktop only)

## Additional Resources

- `man killall` (psmisc)
- `man 7 signal`

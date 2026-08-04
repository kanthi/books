# bg

## Overview

`bg` resumes a **stopped** job in the **background** so it continues running without occupying the terminal. It is part of interactive shell **job control** (bash/zsh), together with `fg`, `jobs`, `Ctrl-Z`, and `&`.

Job control is per-shell: background jobs are not the same as systemd services or `nohup` daemons.

## Syntax

```bash
bg [job_spec ...]
```

With no argument, resumes the current job (`%+`).

## Job specification

| Spec | Meaning |
|------|---------|
| `%n` | Job number n |
| `%string` | Job whose command begins with string |
| `%?string` | Job whose command contains string |
| `%%` or `%+` | Current job |
| `%-` | Previous job |

## Common Options

None significant — `bg` is a shell builtin. See `help bg`.

## Examples with Explanations

### Suspend then background

```bash
# start a long command in foreground
find / -xdev -name '*.log' 2>/dev/null
# press Ctrl-Z  → Stopped
bg
# continues in background
jobs -l
```

### Start in background directly

```bash
make -j$(nproc) &
jobs
```

`&` starts background immediately; `bg` is for jobs already stopped.

### Specific job

```bash
jobs
bg %1
bg %find
```

### Multiple jobs

```bash
bg %1 %2
```

### Typical workflow

```bash
gzip -k huge.img
# Ctrl-Z
bg
# continue using the shell
jobs -l
fg %1          # bring back if needed
```

### Disown / survive hangup

```bash
# after bg:
disown %1
# or start with:
nohup longcmd &
# or use tmux/systemd for real persistence
```

### Not for scripts by default

```bash
# non-interactive shells often have job control off
set -m              # monitor mode (enable job control) if needed
sleep 30 &
jobs
```

Prefer explicit background with `&` and `wait` in scripts rather than `bg`.

## Notes / Pitfalls

- Only works with **job control enabled** and jobs owned by this shell.
- Background jobs writing to the terminal can interleave messily — redirect stdout/stderr.
- `bg` on an already running background job is a no-op / error depending on shell.
- Closing the terminal may SIGHUP jobs unless `disown`/`nohup`/tmux/systemd.
- Don’t confuse with `systemd` `bg` — there is none; use units for services.

## 2026-relevant notes

- For anything important, prefer `tmux`/`systemd-run`/`nohup` over bare `bg`.
- Desktop environments may use their own session management; servers still rely on classic job control daily.
- Pipeline job control can be surprising — know whether the whole pipeline is one job.

## Related Commands

- `fg` — resume in foreground
- `jobs` — list jobs
- `Ctrl-Z` / `kill -STOP` — stop
- `disown` — detach from shell job table
- `nohup` — ignore hangup
- `tmux` / `screen` — persistent sessions
- `wait` — wait for background PIDs/jobs

## Additional Resources

- `help bg`, `man bash` (JOB CONTROL)

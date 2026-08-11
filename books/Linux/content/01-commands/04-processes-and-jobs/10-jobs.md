# jobs

## Overview

`jobs` lists **active jobs** of the current shell: running background tasks, stopped jobs, and their job IDs. Essential for job control with `fg`, `bg`, `kill %n`, and `wait`.

Jobs are not a system-wide process table — use `ps`/`pgrep` for that.

## Syntax

```bash
jobs [options] [job_spec ...]
```

## Common Options (bash)

| Option | Description |
|--------|-------------|
| `-l` | Include PIDs |
| `-p` | PIDs only |
| `-n` | Only jobs with status changes since last notification |
| `-r` | Running only |
| `-s` | Stopped only |
| `-x command` | Replace job specs in command with PIDs and run |

## Job states

| State | Meaning |
|-------|---------|
| Running | Executing in background |
| Stopped | Suspended (Ctrl-Z / SIGSTOP) |
| Done | Completed successfully |
| Exit N | Exited with status N |
| Terminated | Killed by signal |

## Examples with Explanations

### List jobs

```bash
sleep 300 &
sleep 400 &
jobs
jobs -l
jobs -p
jobs -r
jobs -s
```

### Act on a job

```bash
jobs -l
fg %1
bg %2
kill %1
kill -9 %2
```

### Status changes

```bash
jobs -n
```

Useful after many completions to see what finished.

### wait integration

```bash
longtask &
pid=$!
jobs -l
wait "$pid"
```

### Enable job control in scripts (rare)

```bash
set -m
sleep 5 &
jobs -l
wait
```

### disown removes from table

```bash
sleep 1000 &
jobs
disown
jobs          # empty regarding that job
# process may still run — check ps
```

## Notes / Pitfalls

- Empty `jobs` does not mean no processes exist — only no **shell jobs**.
- Job IDs are not PIDs; use `jobs -l` or `$!` for PIDs.
- Subshells have their own job tables: `( sleep 10 & jobs )`.
- Non-interactive shells often disable job control until `set -m`.
- Don’t use `jobs` for service supervision — use systemd.

## 2026-relevant notes

- Interactive terminal multiplexers reduced reliance on many concurrent jobs, but `%` job specs remain daily muscle memory.
- CI shells may not support job control the same way — use PIDs + `wait`.
- For parallel shell work, GNU `parallel` or `xargs -P` may be clearer than raw jobs.

## Related Commands

- `fg` / `bg` — resume jobs
- `kill %n` — signal jobs
- `wait` — wait for completion
- `disown` — remove from job table
- `ps` / `pgrep` — system-wide process view
- `set -m` — monitor mode

## Additional Resources

- `help jobs`, `man bash`

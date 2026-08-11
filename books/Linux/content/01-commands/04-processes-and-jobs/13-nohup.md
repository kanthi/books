# nohup

## Overview

`nohup` runs a command immune to **`SIGHUP`**, so it keeps running after you log out of a terminal session. It is a minimal “survive hangup” wrapper — not a full service manager. For interactive long-lived SSH work prefer **`tmux`/`screen`**; for production daemons prefer **`systemd`** (user or system units).

## Syntax

```bash
nohup COMMAND [ARGS]...
nohup COMMAND [ARGS]... &
```

## Common Options

| Option | Description |
|--------|-------------|
| `--help` | Usage |
| `--version` | Version |

`nohup` itself has almost no flags; behavior is about signals, redirection, and the shell background operator `&`.

## Behavior (what you actually care about)

- Ignores `SIGHUP` for the started command.
- If **stdout is a terminal**, output is appended to `./nohup.out` (or `$HOME/nohup.out` if the cwd is not writable).
- If you already redirect stdout/stderr, `nohup` does not create `nohup.out`.
- Exit status is that of `COMMAND`, or 127 if the command cannot be invoked.

## Key Use Cases

1. Kick off a one-off long job before disconnecting SSH (when you did not start tmux)
2. Quick background batch with a simple log file
3. Legacy scripts that expect `nohup` semantics

## Examples with Explanations

### Example: basic background job

```bash
nohup ./long-job.sh &
```

Starts the job, ignores hangup, backgrounds it. Output typically lands in `nohup.out` in the current directory.

### Example: explicit log file

```bash
nohup ./long-job.sh > /var/tmp/long-job.log 2>&1 &
echo $!
```

Always redirect in real use so logs do not scatter into surprise `nohup.out` files. `$!` is the background PID.

### Example: find and stop later

```bash
nohup python3 train.py --epochs 100 > train.log 2>&1 &
echo $! > train.pid

# later:
kill -TERM "$(cat train.pid)"
# wait, then kill -KILL if needed
```

Record the PID; do not rely on grepping vaguely for `python3`.

### Example: disown alternative (bash)

```bash
./long-job.sh > job.log 2>&1 &
disown
```

`disown` removes the job from the shell’s job table so logout does not send HUP to it. Different mechanism than `nohup`, similar operator goal.

### Example: combine with nice / ionice

```bash
nohup nice -n 19 ionice -c3 ./batch-compress.sh > batch.log 2>&1 &
```

Low CPU and idle I/O class — polite neighbor on shared hosts.

### Example: remote one-liner over SSH

```bash
ssh host 'nohup /opt/app/rebuild.sh > /tmp/rebuild.log 2>&1 &'
```

SSH can still race with job startup; for reliability prefer `tmux new -d` or a systemd unit.

### Example: check nohup.out

```bash
nohup seq 1 1000000 &
tail -f nohup.out
```

Demonstrates default output capture when no redirection is given.

## Safety

- `nohup` does **not** restart on crash, reboot, or OOM kill — not a supervisor.
- Writing `nohup.out` into a shared or production cwd can fill disks or leak sensitive prints.
- Background jobs may still receive other signals; only HUP is specially handled by `nohup`.
- Root + nohup + destructive scripts is still destructive after you disconnect.

## Notes & Pitfalls

- Prefer **`tmux new -s name`** for anything you might need to reattach to interactively.
- Prefer **`systemd-run --user`** or a real unit for recurring or critical jobs.
- Relative paths in the command resolve at start time; if you `cd` later in another shell, the job’s cwd is unchanged.
- `nohup.out` is **append** mode — old runs accumulate; rotate or redirect explicitly.
- Some environments use `setsid` or `ssh -f` patterns instead; know which layer owns the process.

## Related Commands

- `tmux` / `screen` — reattachable sessions
- `systemd-run` / `systemctl` — supervised execution
- `disown` — bash job-table detach
- `setsid` — new session
- `timeout` — bound runtime
- `nice` / `ionice` — resource politeness

## Additional Resources

- `man nohup`
- `man systemd-run`

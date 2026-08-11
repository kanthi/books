# nice

## Overview

`nice` starts a command with a modified **CPU niceness** — a soft priority bias for the scheduler. Higher nice means **more polite** (less CPU when others compete); lower (negative) nice means more aggressive. Range is typically **-20..19**, default **0**. Unprivileged users can only **increase** niceness. Use `renice` to change a running process; use `ionice` for disk I/O class.

## Syntax

```bash
nice [OPTION] [COMMAND [ARG]...]
nice -n ADJUSTMENT COMMAND [ARG]...
```

With no command, some implementations print the current niceness.

Related:

```bash
renice [-n] PRIORITY -p PID...
renice [-n] PRIORITY -u USER...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-n ADJ`, `--adjustment=ADJ` | Add ADJ to default nice (often written as absolute intent: `nice -n 10`) |
| `--help` / `--version` | Meta |

`renice` selection:

| Option | Description |
|--------|-------------|
| `-p PID` | Process ID(s) |
| `-g PGID` | Process group |
| `-u USER` | All of user’s processes |
| `-n PRIO` | Absolute nice value to set (util-linux style) |

## Safety

- Negative nice values need **root** (or `CAP_SYS_NICE`) — do not renice critical daemons downward without understanding latency impact.
- Nice is **not** a hard cap or cgroup limit; a niced process can still use 100% CPU when the machine is idle.
- For multi-tenant fairness prefer **cgroups / systemd resource controls** (`CPUWeight=`, `CPUQuota=`) over global renice.

## Key Use Cases

1. Run backups/compiles politely during business hours
2. Deprioritize a runaway batch without killing it
3. Slightly boost an interactive build only when policy allows
4. Inspect niceness during incident triage

## Examples with Explanations

### Example: start a polite batch job

```bash
nice -n 19 ./batch-compress.sh
nice -n 10 tar -czf /backup/home.tgz /home
```

`19` is maximum politeness on Linux. Good default for “finish eventually, don’t fight production”.

### Example: background + log

```bash
nice -n 15 ./reindex.sh > /var/tmp/reindex.log 2>&1 &
```

Combine with shell backgrounding; still not a supervisor.

### Example: renice a running PID

```bash
ps -o pid,ni,cmd -p 1234
renice -n 15 -p 1234
sudo renice -n -5 -p 1234
```

Ordinary users can raise nice (e.g. 0 → 15) on their own processes; lowering requires privilege.

### Example: renice all of a user’s jobs

```bash
sudo renice -n 10 -u builduser
```

Useful when a CI account is starving interactive sessions.

### Example: observe nice in ps / top

```bash
ps -eo pid,user,ni,pri,cmd --sort=ni | head
ps -o pid,ni,comm -p 1234
# top/htop: NI column; htop F7/F8 adjust interactively
```

`NI` is niceness; `PRI` is the kernel priority derived from scheduling policy and nice.

### Example: nice + ionice + nohup combo

```bash
nohup nice -n 19 ionice -c3 ./nightly-rsync.sh > /var/log/nightly-rsync.log 2>&1 &
```

CPU polite + idle I/O class + survive hangup — classic overnight job pattern.

### Example: systemd equivalent knobs

```bash
systemd-run --user --nice=15 ./batch.sh
# in a unit:
# Nice=15
# CPUWeight=50
```

Prefer unit settings for services you own long-term.

### Example: print current nice (when supported)

```bash
nice
```

Some systems print the shell’s current niceness if no command is given.

## Understanding Output

- `nice` itself is silent on success when launching a command.
- Failed renice prints permission or ESRCH errors.
- Inherited niceness: children typically inherit the parent’s nice value.

## Notes & Pitfalls

- Syntax confusion: old forms like `nice -10 cmd` mean adjustment **-10** on some Unixes; on GNU prefer **`nice -n 10 cmd`** explicitly.
- Realtime policies (`SCHED_FIFO` via `chrt`) override ordinary nice semantics — different tool.
- Containers may restrict `CAP_SYS_NICE`; negative renice fails even as “root” in a locked-down pod.
- Autogroup / CFS details can make nice effects less dramatic than expected on desktop kernels — still useful under contention.

## Related Commands

- `renice` — change running processes
- `ionice` — I/O scheduling class
- `chrt` — realtime/other scheduling policies
- `timeout` — bound wall time
- `systemctl` / cgroups — proper resource control
- `top` / `htop` / `ps` — observe `NI`

## Additional Resources

- `man nice`
- `man renice`
- `man sched(7)`

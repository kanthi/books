# ionice

## Overview

`ionice` sets or queries the **I/O scheduling class and priority** of a process (Linux CFQ/BFQ-oriented interface; behavior depends on the current I/O scheduler and kernel). Use it so bulk disk work (backups, `updatedb`, large `rsync`) yields to latency-sensitive services. Orthogonal to CPU `nice`.

## Syntax

```bash
ionice [options] -p PID...
ionice [options] COMMAND [ARG]...
ionice -p PID
```

## I/O classes

| Class | `-c` | Meaning |
|-------|------|---------|
| None | `0` | No class set / request default handling |
| Realtime | `1` | Highest access (requires privilege; can starve others) |
| Best-effort | `2` | Default class; priority 0–7 within class |
| Idle | `3` | Only when disk is idle — safest for bulk jobs |

Best-effort priority: **0** = highest within class, **7** = lowest (opposite intuition from CPU nice numbers — read twice).

## Common Options

| Option | Description |
|--------|-------------|
| `-c CLASS` | Class number or name (`idle`, `best-effort`, `realtime`) on newer util-linux |
| `-n PRIO` | Priority 0–7 within best-effort or realtime |
| `-p PID` | Act on existing PID (repeatable) |
| `-t` | Ignore failures (e.g. unsupported) — “try” |
| `-P PGID` | Process group (where supported) |
| `-u UID` | As user (where supported) |

## Safety

- **Realtime I/O (`-c1`)** can starve the system — avoid on production unless you know the storage stack and blast radius.
- Prefer **idle (`-c3`)** for overnight compaction, virus scans, and catalog updates.
- Capability/`CAP_SYS_ADMIN` or root may be required for realtime class; idle/best-effort for own processes is usually fine.
- On modern multi-queue SSDs with certain schedulers, ionice effects can be **weaker** than on classic CFQ HDDs — still good hygiene for HDDs and shared spindles.

## Key Use Cases

1. Start backups in the idle I/O class
2. Soften a live `rsync`/`tar` hurting databases
3. Query current I/O class of a suspect PID
4. Combine with `nice` for “be a good neighbor” batch windows

## Examples with Explanations

### Example: run command as idle I/O

```bash
ionice -c3 ./backup.sh
ionice -c idle ./backup.sh
```

Only issues disk I/O when the device is not busy with others — best default for bulk work.

### Example: best-effort low priority

```bash
ionice -c2 -n7 tar -czf /backup/data.tgz /data
```

Class best-effort, lowest priority level. Less extreme than idle; still polite.

### Example: change a running process

```bash
ionice -c3 -p 1234
ionice -c2 -n7 -p 1234
```

Apply without restarting. Verify with a query afterward.

### Example: query current setting

```bash
ionice -p 1234
# example output: none: prio 0
# or: idle
# or: best-effort: prio 4
```

Silent context for incident notes: “PID 1234 was idle class during the spike”.

### Example: nice + ionice together

```bash
nice -n 19 ionice -c3 rsync -a /data/ /mnt/backup/data/
```

CPU and disk both deprioritized. Standard pattern for shared hosts.

### Example: nohup overnight job

```bash
nohup nice -n 19 ionice -c3 \
  rsync -a --delete /srv/ /mnt/cold/srv/ \
  > /var/log/rsync-cold.log 2>&1 &
```

Survives logout, polite CPU/I/O, logged.

### Example: try without failing scripts

```bash
ionice -t -c3 ./portable-job.sh
```

`-t` ignores failures when ionice cannot set class (containers, odd kernels) so the job still runs.

### Example: avoid realtime unless justified

```bash
# dangerous on shared storage — shown for completeness only
# sudo ionice -c1 -n0 -p "$LATENCY_CRITICAL_PID"
```

Prefer storage QoS, cgroup `io.latency`/`IOWeight=`, and proper service isolation instead.

## Notes & Pitfalls

- **Not portable** to non-Linux; no-op or absent on macOS/BSD.
- Effect depends on **scheduler** (`mq-deadline`, `bfq`, `none` for NVMe, etc.). Check `/sys/block/*/queue/scheduler`.
- Children inherit I/O priority at fork time; later `ionice -p` on the parent does not always retarget already-spawned children — apply to the whole tree if needed.
- systemd: `IOSchedulingClass=` / `IOSchedulingPriority=` in units; often cleaner than wrappers.
- Do not confuse with `nice` (CPU) or `chrt` (CPU policy).

## Related Commands

- `nice` / `renice` — CPU niceness
- `chrt` — CPU scheduling policy
- `ionice` + `nohup` / `tmux` — long batch sessions
- `iostat` / `iotop` — observe disk pressure
- `systemctl` — unit-level I/O settings

## Additional Resources

- `man ionice`
- `man ioprio_set` (syscall background)

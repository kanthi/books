# uptime

## Overview

`uptime` shows how long the system has been running, how many users are logged in, and the **load average** (1, 5, and 15 minutes). It is a quick health snapshot before diving into `top`/`htop`/`vmstat`.

Load average is the average number of runnable **plus** uninterruptible (disk sleep) tasks — not a pure “CPU %” meter.

## Syntax

```bash
uptime [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p`, `--pretty` | Pretty duration only |
| `-s`, `--since` | System up since timestamp |
| `-h`, `--help` | Help |
| `-V` | Version |

## Examples with Explanations

### Default

```bash
uptime
# 10:15:02 up 21 days,  4:03,  3 users,  load average: 0.08, 0.12, 0.09
```

### Pretty / since

```bash
uptime -p
uptime -s
```

### Interpret load vs CPUs

```bash
uptime
nproc
lscpu | grep '^CPU(s):'
# rough rule of thumb: load near nproc ≈ busy; much higher may mean saturation
```

### Watch over time

```bash
watch -n1 uptime
```

### Scripts

```bash
load=$(awk '{print $1}' /proc/loadavg)
echo "1-minute load: $load"
# /proc/loadavg is the source of truth
cat /proc/loadavg
```

### Correlate with other tools

```bash
uptime
who
w
top -bn1 | head
```

### Containers

```bash
uptime
# may reflect host uptime depending on visibility of /proc
```

## Understanding load average

| Observation | Possible meaning |
|-------------|------------------|
| Low load, high latency | Network/app issues, not CPU |
| Load ≫ nproc, CPU idle% high | I/O wait / uninterruptible tasks |
| Load ≈ runnable tasks | CPU contention |
| Sudden load spikes | Cron storms, backups, build jobs |

Use `vmstat 1`, `iostat -xz 1`, `ps`, `pidstat` for root cause.

## Notes / Pitfalls

- Load is not “percent CPU”; a 64-core host can show load 20 and still be fine.
- Suspend-to-RAM / cloud live migration can make “up” time less intuitive.
- User count is from utmp; containers/ssh multiplexing may look odd.
- Don’t alert only on load without CPU, memory, and I/O context.

## 2026-relevant notes

- For long-term trends use Prometheus node exporter / `sar` rather than one-off `uptime`.
- Latency-sensitive systems care more about p99 and steal time (VMs) than raw load.
- `systemd-analyze` helps boot time; `uptime -s` shows when the current boot began.

## Related Commands

- `w` / `who` — who is logged in
- `top` / `htop` / `btop` — live process view
- `vmstat` / `iostat` — run queue vs block I/O
- `nproc` / `lscpu` — CPU count
- `cat /proc/loadavg` — raw values
- `sar` — historical load

## Additional Resources

- `man uptime`, `man 5 proc` (`/proc/loadavg`)

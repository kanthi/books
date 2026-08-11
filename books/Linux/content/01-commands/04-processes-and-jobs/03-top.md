# top

## Overview

`top` is the classic interactive process monitor: CPU, memory, and a live-sorted process table. It is installed almost everywhere, so it is the default triage tool when `htop`/`btop` are not present. For scripts and snapshots, prefer `ps`; for friendlier interactive use, install `htop`.

## Syntax

```bash
top [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d SECS` | Delay between refreshes (fractional OK) |
| `-n COUNT` | Exit after COUNT iterations (batch-friendly) |
| `-b` | Batch mode (non-interactive; good for logs) |
| `-p PID`, `-p PID1,PID2` | Watch only these PIDs |
| `-u USER` / `-U USER` | Filter by effective / any user id |
| `-H` | Show threads |
| `-o FIELD` | Sort by field (e.g. `%CPU`, `%MEM`) |
| `-c` | Toggle command line vs name (often available as interactive `c`) |
| `-w` | Wide output (batch) |

## Interactive keys (procps-ng)

| Key | Action |
|-----|--------|
| `h` / `?` | Help |
| `q` | Quit |
| `Space` / `Enter` | Refresh now |
| `d` / `s` | Change delay |
| `P` | Sort by CPU |
| `M` | Sort by memory |
| `T` | Sort by time |
| `N` | Sort by PID |
| `k` | Kill (prompt for PID and signal — **TERM default**) |
| `r` | Renice |
| `u` | Filter user |
| `c` | Command line vs basename |
| `V` | Forest / tree view (when supported) |
| `H` | Toggle threads |
| `1` | Expand / collapse per-CPU lines |
| `f` / `F` | Field management |
| `W` | Write config (`~/.config/procps/toprc` or `~/.toprc`) |

## Key Use Cases

1. Live “who is burning CPU/RAM right now”
2. Quick renice or kill during an incident
3. Capture a few samples in batch for a ticket
4. Per-CPU and load-average glance during overload

## Examples with Explanations

### Example: interactive default

```bash
top
```

Header shows uptime, load average, task counts, CPU breakdown, and memory. Process list is typically sorted by `%CPU`.

### Example: refresh every two seconds

```bash
top -d 2
```

Slower refresh reduces overhead on already-loaded systems.

### Example: single-user focus

```bash
top -u www-data
```

Limits noise on multi-tenant or app servers.

### Example: watch specific PIDs

```bash
top -p 1,1234,$(pgrep -d, -x nginx)
```

Useful when you already know the suspects from `ps`/`pgrep`.

### Example: batch sample for logs / tickets

```bash
top -b -n 3 -d 1 > /tmp/top-snapshot.txt
top -b -n 1 -o %MEM | head -n 30
```

`-b` makes output non-interactive and redirectable. Great for attaching evidence to an incident note.

### Example: sort by memory from the CLI

```bash
top -o %MEM
```

Start already sorted by resident memory pressure.

### Example: threads view

```bash
top -H -p "$(pgrep -d, -x java)"
```

Each thread appears as a row — helpful for multi-threaded runtimes.

### Example: kill from inside top

Press `k`, enter PID, accept default signal **15 (TERM)** unless you have already tried graceful stop. Escalate to 9 only if needed.

### Example: one-shot CPU leaders without staying in top

```bash
ps aux --sort=-%cpu | head -n 15
```

When you only need a snapshot, `ps` is lighter and script-friendlier.

## Understanding Output

**Header**

- **load average** — 1/5/15 minute runnable+uninterruptible averages (not “percent CPU”)
- **Cpu(s)** — `%us` user, `%sy` system, `%id` idle, `%wa` I/O wait, `%st` steal (VMs)
- **MiB Mem / Swap** — total, free, used, buff/cache (wording varies by procps version)

**Process columns (typical)**

| Column | Meaning |
|--------|---------|
| `PID` | Process ID |
| `USER` | Effective user |
| `PR` / `NI` | Priority / nice |
| `VIRT` / `RES` / `SHR` | Virtual / resident / shared memory |
| `S` | State (`R` run, `S` sleep, `D` disk sleep, `Z` zombie, `T` stopped) |
| `%CPU` / `%MEM` | Share of CPU / physical memory |
| `TIME+` | Cumulative CPU time |
| `COMMAND` | Name or full command |

On multi-core hosts, `%CPU` can exceed 100% for multi-threaded processes.

## Notes & Pitfalls

- `top` is **live**; do not parse interactive mode in scripts — use `-b` or `ps`.
- High `%wa` points to storage/I/O, not always “need more CPU”.
- High `%st` (steal) means the hypervisor is scheduling other VMs — look outside the guest.
- Memory: `buff/cache` is usually reclaimable; “free” alone is a poor metric — check available if shown.
- Killing from `top` still needs the same discipline as `kill`: TERM before KILL.
- Config saved with `W` can surprise you later if sort/fields change.

## Related Commands

- `htop` / `btop` — modern interactive monitors
- `ps` — snapshots and scripting
- `uptime` / `vmstat` / `mpstat` — load and CPU breakdown
- `pidstat` — per-process rates over time
- `free` — memory summary

## Additional Resources

- `man top`
- `man procps`

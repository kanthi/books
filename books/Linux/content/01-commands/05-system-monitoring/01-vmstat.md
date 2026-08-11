# vmstat

## Overview

`vmstat` reports virtual memory, process run/block queues, CPU, and I/O counters in a compact table. Ideal for a quick terminal loop that answers: **CPU-bound, RAM pressure, or disk wait?** Prefer sample mode (`delay count`) over a single line — the first line is often averages since boot.

## Syntax

```bash
vmstat [options] [delay [count]]
```

## Common Options

| Option | Description |
|--------|-------------|
| `delay count` | Sample every *delay* seconds, *count* times |
| `-w` | Wide columns (avoid truncated fields) |
| `-S k\|K\|m\|M` | Unit scaling for memory fields |
| `-a` | Active/inactive memory instead of buff/cache split detail |
| `-s` | One-shot event counter summary |
| `-d` | Disk statistics |
| `-D` | Disk summary totals |
| `-t` | Timestamp each sample line |
| `-n` | Header once (not every screenful) |
| `-f` | Fork count since boot |

Install note: `vmstat` is from **procps** (preinstalled on Ubuntu). Disk/historical depth may still push you to **sysstat** (`iostat`, `sar`).

## Key Use Cases

1. Live “why is it slow?” triage loop
2. Detect swap thrash (`si`/`so`)
3. Spot I/O wait vs CPU user/system
4. VM steal time (`st`) on cloud guests

## Examples with Explanations

### Live sample (default triage)

```bash
vmstat 1 10
vmstat -w 1 5
```

One-second samples, ten lines (or five wide). **Ignore the first data line** when using a delay — it is often since-boot averages; subsequent lines are interval deltas.

### Timestamped capture for logs

```bash
vmstat -t 2 30 | tee /tmp/vmstat.out
```

Useful during an incident window you will review later.

### Memory summary counters

```bash
vmstat -s
vmstat -s -S M
```

Cumulative counters (forks, pages paged in/out, etc.) — good for a snapshot, not a live rate loop.

### Disk stats mode

```bash
vmstat -d 1 5
```

Per-disk reads/writes. For modern extended fields (`await`, `%util`), prefer `iostat -xz`.

### Active / inactive memory view

```bash
vmstat -a 1 5
```

Highlights reclaimable cache vs active pages when diagnosing memory pressure.

### Correlate with siblings

```bash
vmstat 1 5
iostat -xz 1 5
mpstat -P ALL 1 5
free -h
```

vmstat for system pulse; iostat for which disk; mpstat for per-CPU imbalance; free for human memory totals.

## Understanding Output

Classic columns (names vary slightly by version/width):

| Area | Fields | Operator hints |
|------|--------|----------------|
| Procs | `r`, `b` | `r` > CPU count → runnable contention; `b` blocked (often I/O) |
| Memory | `swpd`, `free`, `buff`, `cache` | Rising `swpd` + low free → pressure (also check `free -h`) |
| Swap | `si`, `so` | Sustained non-zero swap in/out → RAM shortage / thrash |
| IO | `bi`, `bo` | Blocks in/out (not full disk latency picture) |
| System | `in`, `cs` | Interrupts, context switches (high `cs` can mean chatty scheduling) |
| CPU | `us`, `sy`, `id`, `wa`, `st` | `%` of time: user, kernel, idle, **I/O wait**, **steal** (hypervisor) |

**Pattern cheat sheet:**

| Pattern | Likely story | Next tool |
|---------|--------------|-----------|
| High `r`, high `us`/`sy`, low `id` | CPU bound | `mpstat -P ALL`, `pidstat`/`top` |
| High `b` or `wa` | I/O bound | `iostat -xz`, `iotop` |
| Continuous `si`/`so` | Memory pressure | `free -h`, `ps` RSS, reduce cache pressure |
| High `st` | Hypervisor contention / undersized VM | host metrics, resize instance |
| High `cs` with low work | Possible scheduling noise | app profiling, `perf` |

Units: without `-S`, memory fields are often KiB pages-related scaling depending on build — use `-w` and `-S M` when comparing to `free -h`.

## Notes & Pitfalls

- **First line with delay** is historically since-boot — always take interval lines for “now”.
- `wa` means CPUs idle waiting on I/O, not “disk % busy”; a single slow device can elevate `wa`.
- `free` memory near zero can still be healthy if cache is reclaimable — watch `si`/`so` and application latency.
- Containers/cgroups: host `vmstat` sees the host; inside a container you still often see host-wide stats unless using cgroup-aware tools.
- Very short intervals (sub-second) add noise; 1s is a good default.

## Related Commands

- `iostat` — per-device I/O rates and `%util`
- `mpstat` — per-CPU breakdown
- `free -h` — memory snapshot
- `top` / `htop` / `pidstat` — per-process
- `sar` — historical sysstat data
- `uptime` — load averages only

## Additional Resources

- `man vmstat`
- `man free`

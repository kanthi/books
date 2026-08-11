# mpstat

## Overview

`mpstat` (sysstat) reports **CPU utilization**, optionally **per logical CPU**, so you can see single-thread bottlenecks, softirq load, and steal time on individual cores. Aggregate tools (`vmstat`, `uptime`) hide imbalance; `mpstat -P ALL` reveals it. Install: `sudo apt install sysstat`.

## Syntax

```bash
mpstat [options] [interval [count]]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-P ALL` | Each CPU plus `all` average row |
| `-P 0,2` | Specific CPU indices |
| `-u` | Utilization report (default) |
| `-I SUM\|CPU\|SCPU\|ALL` | Interrupt statistics |
| `-A` | Wide set of reports |
| `-o JSON` | JSON output (newer sysstat) |
| `-n` | Numeric only where applicable |
| `-T` | Topology-aware presentation (version-dependent) |

## Key Use Cases

1. Detect single-core saturation (one CPU 100%, others idle)
2. Softirq / network stack pressure (`%soft`)
3. Hypervisor steal (`%steal` / `%st`) per CPU
4. Interrupt distribution imbalances

## Examples with Explanations

### Average CPU samples

```bash
mpstat 1 5
```

Whole-system average every second — similar role to the CPU part of `vmstat`, with clearer labels.

### Per-CPU breakdown (primary triage)

```bash
mpstat -P ALL 1 5
mpstat -P ALL -u 1 3
```

Look for one or few CPUs pinned at high `%usr` while others idle → single-threaded or poorly parallelized work.

### Specific cores

```bash
mpstat -P 0,1 1 5
```

Useful when pinning (taskset/cgroups) or NUMA-aware debugging.

### Interrupts

```bash
mpstat -I SUM 1 3
mpstat -I CPU 1 3
mpstat -I SCPU 1 3
```

`SUM` totals; `CPU` / `SCPU` help when hunting IRQ imbalance or softirq storms (pair with `grep` in `/proc/interrupts`).

### JSON for tooling

```bash
mpstat -P ALL -o JSON 1 1 | jq .
```

### Pair with process CPU

```bash
mpstat -P ALL 1 5
pidstat -u 1 5
# top, then press 1 for per-CPU
```

mpstat shows **where** CPUs burn; pidstat/top show **who**.

## Understanding Output

Common utilization fields:

| Field | Meaning |
|-------|---------|
| `%usr` | User-space applications |
| `%nice` | User-space nice’d |
| `%sys` | Kernel |
| `%iowait` | Idle waiting for I/O |
| `%irq` / `%soft` | Hard / soft interrupts |
| `%steal` | Time stolen by hypervisor |
| `%guest` | Running guest VMs (host) |
| `%idle` | Idle not waiting on I/O |

**Patterns:**

| Observation | Likely story |
|-------------|--------------|
| One CPU `%usr`≈100, others idle | Single-thread bottleneck / GIL / hot lock |
| All CPUs high `%usr` | Healthy parallel load or capacity shortfall |
| High `%soft` on few CPUs | Network/softirq concentration — RSS/RPS/IRQ affinity |
| High `%steal` | Noisy neighbor or oversubscribed VM |
| High `%iowait` | Storage latency (confirm with `iostat -xz`) |
| High `%sys` | Kernel-heavy workload, syscalls, networking, virtualization |

First sample without care about “since boot” applies less than iostat, but interval mode is still the right way to watch live change.

## Notes & Pitfalls

- Install sysstat if missing: `sudo apt install sysstat`.
- CPU numbering is logical CPUs (includes SMT/hyperthreads).
- Inside containers you may still see host CPUs depending on visibility; cgroup limits need `cpuset`/`cpu` controllers and specialized tools.
- Balancing IRQs is a separate operational topic (`/proc/irq`, `irqbalance`).
- `%iowait` can look “high” on mostly-idle systems with occasional slow I/O — correlate with latency SLOs, not only percentages.

## Related Commands

- `vmstat` — compact aggregate loop
- `sar -P ALL` — historical per-CPU
- `top` (key `1`) / `htop` — interactive per-CPU
- `pidstat -u` — per-process CPU
- `perf top` — see hot kernel/user symbols
- `nproc` / `lscpu` — how many CPUs exist

## Additional Resources

- `man mpstat`
- `man pidstat`

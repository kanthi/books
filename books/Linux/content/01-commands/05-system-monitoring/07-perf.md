# perf

## Overview

`perf` is Linux’s primary performance analysis suite. It samples hardware performance counters, software events, and kernel tracepoints to show *where* CPU time goes—functions, shared libraries, kernel paths—not just which process is “busy” in `top`.

```bash
# typical packages
sudo apt install linux-perf        # Debian/Ubuntu (name varies by kernel)
sudo dnf install perf
# ensure matching kernel headers/debug symbols for readable stacks when possible
```

## Syntax

```bash
perf [subcommand] [options] [--] [command]
```

## Common Subcommands

| Subcommand | Description |
|------------|-------------|
| `stat` | Aggregate counters for a command or system-wide |
| `record` | Sample events → `perf.data` |
| `report` | Interactive/text report from `perf.data` |
| `top` | Live function-level top |
| `script` | Dump raw samples (for flame graphs, custom tools) |
| `list` | List available events |
| `annotate` | Source/asm annotation |
| `probe` | Dynamic probes (advanced) |

## Common Options (record / stat)

| Option | Description |
|--------|-------------|
| `-e EVENT` | Event(s): `cycles`, `instructions`, `cache-misses`, … |
| `-g` / `--call-graph` | Call graphs (`fp`, `dwarf`, `lbr` depending on arch) |
| `-p PID` / `-t TID` | Attach to process/thread |
| `-a` | System-wide |
| `-F freq` | Sample frequency |
| `-o file` | Output file (default `perf.data`) |

## Key Use Cases

1. Find hot functions in user or kernel space
2. Measure IPC, cache misses, branch misses
3. System-wide profiling under load
4. Generate data for flame graphs

## Examples with Explanations

### High-level counters for one command

```bash
perf stat ./my_program
perf stat -e cycles,instructions,cache-misses,branch-misses ./my_program
```

`instructions` / `cycles` → rough IPC. High cache-miss rates often explain “CPU busy but slow” workloads.

### Live profiling

```bash
sudo perf top
sudo perf top -p $(pgrep -n myapp)
```

Like `top`, but for symbols. Needs root or `kernel.perf_event_paranoid` relaxed appropriately.

### Record + report workflow

```bash
perf record -g ./my_program
perf report
# or
perf record -F 99 -g -p $(pgrep -n myapp) -- sleep 30
perf report --stdio | less
```

`-g` collects call graphs so you see callers, not only leaf functions.

### System-wide snapshot

```bash
sudo perf record -a -g -- sleep 10
sudo perf report
```

### One-liner recipes

```bash
# Why is this box busy?
sudo perf top -g

# Count context switches / migrations during a run
perf stat -e context-switches,cpu-migrations,page-faults ./server

# Dump samples for external flamegraph tooling
perf script > out.perf
```

### Paranoid settings (understand before changing)

```bash
sysctl kernel.perf_event_paranoid
# -1: least restricted; higher values limit unprivileged use
# Prefer temporary, documented changes over permanent wide-open settings
```

## Notes & Pitfalls

- **Symbols**: stripped binaries show hex addresses. Install debuginfo / build with frame pointers or use DWARF call graphs (`--call-graph dwarf`, higher overhead).
- **Overhead**: high-frequency sampling and DWARF unwind cost CPU and disk.
- **Containers**: host `perf` can profile containers with care; cgroup modes and symbol paths complicate analysis.
- **Permissions**: modern kernels gate unprivileged `perf`; don’t casually set paranoid to `-1` on multi-tenant hosts.
- `perf.data` is bulky—delete or compress after analysis.

## 2026-relevant notes

- Prefer **frame pointers** (`-fno-omit-frame-pointer` / modern defaults on some stacks) or **ORC/DWARF** unwind as appropriate for your distro/arch.
- Pair with **`bpftrace`**, **`bcc`**, and **`pidstat`/`perf stat`** for layered diagnosis: counters → samples → targeted traces.
- For continuous profiling in production, evaluate eBPF-based agents; use classic `perf` for deep dives and offline `perf report`.

## Comparison to alternatives

| Tool | Role |
|------|------|
| `perf` | Sampling + counters, deep Linux integration |
| `strace` | Syscall trace (different question) |
| `top`/`htop`/`btop` | Process-level overview |
| `bpftrace` | Ad-hoc kernel/user probes |

## Related Commands

- `strace` — syscalls
- `top` / `htop` / `btop` — process monitors
- `vmstat` / `iostat` / `mpstat` — subsystem stats
- `sysctl` — kernel knobs including perf policy

## Additional Resources

- `man perf` and `man perf-record`
- Kernel `tools/perf` documentation
- Brendan Gregg’s Linux performance materials (flame graphs, methodology)

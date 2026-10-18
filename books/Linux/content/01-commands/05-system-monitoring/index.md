---
title: Intro
---

# Intro

Measure subsystem health over time and debug *why* a host is slow or stuck: virtual memory, disks, CPUs, open files, and syscall/library traces.

## Commands in this part

| Command | Role |
|---------|------|
| `vmstat` | vmstat reports virtual memory, process run/block queues, CPU, and I/O counters in a compact table. |
| `iostat` | iostat (from the sysstat package) reports CPU utilization and per-device I/O rates, queue depth, await, and utilization. |
| `mpstat` | mpstat (sysstat) reports CPU utilization, optionally per logical CPU, so you can see single-thread bottlenecks,… |
| `sar` | sar (System Activity Reporter, sysstat) prints live and historical metrics: CPU, memory, load, disk, network, and more. |
| `lsof` | lsof lists open files. |
| `strace` | strace traces system calls and signals for a process. |
| `perf` | perf is Linux’s primary performance analysis suite. |
| `btop` | btop is a modern, interactive resource monitor with a polished TUI: CPU (often per-core with clocks/temps when… |
| `ltrace` | ltrace intercepts and prints dynamic library calls of a process (similar to how strace prints syscalls). |
| `pmap` | pmap prints a process's memory map (size, RSS, dirty per mapping); the first step in hunting native leaks that heap profilers miss. |
| THP (`/sys/kernel/mm/transparent_hugepage`) | Transparent Huge Pages: read the policy, find who holds 2 MiB pages (`AnonHugePages`), and opt in or out with `madvise`/`prctl`. |
| PSI (`/proc/pressure`, cgroup `*.pressure`) | Pressure Stall Information: share of time tasks are stalled on CPU, memory or I/O — `some` vs `full`, averages and triggers. |


## Suggested starting points

1. Load vs I/O vs CPU: `vmstat`, `iostat`, `mpstat`, `sar`.
2. Who holds a file or port: `lsof`.
3. Why a process fails: `strace` (syscalls), `ltrace` (library calls).
4. Hotspots: `perf` (and interactive `btop` for a dashboard).
5. RSS keeps growing: `pmap` (which mapping?), then `strace`/`bpftrace` and `gdb` (who maps it?).
6. RSS jumps or latency spikes after a THP policy change: Transparent Huge Pages (`AnonHugePages`, `/proc/vmstat` `thp_*`, `compact_stall`).
7. Latency without obvious saturation: `/proc/pressure/*` and the service cgroup's `*.pressure` (`some` vs `full`).

## Related parts

- Processes and jobs — PIDs and signals
- Storage and filesystems — disk health and space
- Networking — `ss`/`tcpdump` for network-bound issues

Continue with the individual command pages in this part.

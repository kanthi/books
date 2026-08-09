# free

## Overview

`free` summarizes system memory usage: physical RAM and swap. Output comes from `/proc/meminfo`. Modern `free` includes an **available** estimate (memory reclaimable without swapping) that is more useful than the old “free only” column for deciding if a host is under memory pressure.

## Syntax

```bash
free [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-h`, `--human` | Human-readable units |
| `-b` / `-k` / `-m` / `-g` | Bytes / KiB / MiB / GiB |
| `-t` | Total line |
| `-s N` | Refresh every N seconds |
| `-c N` | Repeat N times (with `-s`) |
| `-w` | Wide output (separate buffers/cache on older styles) |
| `-v` | Version |
| `--si` | Powers of 1000 instead of 1024 |

## Examples with Explanations

### Everyday

```bash
free -h
free -m
free -h -t
```

### Watch live

```bash
free -h -s 2
watch -n1 free -h
```

### Scripts

```bash
free -b | awk '/^Mem:/ {print $2, $7}'   # total, available (column positions can shift — verify)
# safer parse of meminfo:
awk '/MemAvailable:/ {print $2}' /proc/meminfo
```

### Interpret with pressure tools

```bash
free -h
cat /proc/pressure/memory 2>/dev/null    # PSI on modern kernels
vmstat 1 5
swapon --show
```

### Containers / cgroups

```bash
free -h
# may show host memory unless constrained views; check cgroup limits:
cat /sys/fs/cgroup/memory.max 2>/dev/null
cat /sys/fs/cgroup/memory.current 2>/dev/null
```

## Understanding the columns

Typical modern output:

```text
              total        used        free      shared  buff/cache   available
Mem:           ...
Swap:          ...
```

| Field | Meaning |
|-------|---------|
| total | Installed / visible memory |
| used | In use (implementation-defined accounting) |
| free | Completely unused |
| shared | tmpfs / shared memory estimate |
| buff/cache | Kernel buffers and page cache |
| available | Estimate of memory available for new workloads |

**Linux uses free RAM for cache** — low “free” with high “available” is often healthy.

## Notes / Pitfalls

- Do not panic solely because `free` is low; watch **available**, reclaim, PSI, and OOM logs.
- Swap usage can be normal for infrequently touched pages; heavy swap I/O is the problem.
- Column layout changed over the years — verify before parsing.
- Huge pages, zswap, and compressed RAM affect interpretation.
- VMs: balloon drivers and host overcommit complicate the picture.

## 2026-relevant notes

- Prefer **PSI** (`/proc/pressure`) and metrics backends for production memory SLOs.
- `systemd-cgtop` and cgroup v2 memory stats matter more than host `free` inside dense multi-service hosts.
- OOM: `journalctl -k | grep -i oom` / `dmesg` for killer events.

## Related Commands

- `vmstat` — memory + runqueue + io
- `top` / `htop` / `btop` — per-process memory
- `swapon` / `swapoff` — swap devices
- `cat /proc/meminfo` — raw counters
- `smem` — proportional set size (if installed)
- `slabtop` — kernel slab usage

## Additional Resources

- `man free`, `man proc`

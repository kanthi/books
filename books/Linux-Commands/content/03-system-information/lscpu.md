# lscpu

## Overview

`lscpu` displays CPU architecture information from sysfs and `/proc/cpuinfo`: sockets, cores, threads, model name, caches, virtualization flags, NUMA layout, and vulnerabilities mitigations summary. Use it before tuning parallelism, interpreting load averages, or choosing binary architectures.

## Syntax

```bash
lscpu [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` / `-b` / `-c` | Online/offline CPU filtering variants |
| `-e` | Extended parsable table of CPUs |
| `-p` | Parseable (key,value or CSV-like) |
| `-J` | JSON output (newer util-linux) |
| `-x` | Hex masks |
| `-y` | Physical instead of logical in some fields |
| `-s` | Sysroot for inspection |
| `-B` | Byte sizes raw |

## Examples with Explanations

### Overview

```bash
lscpu
```

### Parseable / JSON

```bash
lscpu -p
lscpu -J | jq .
lscpu -e=cpu,node,socket,core,online
```

### Core counts for scripts

```bash
nproc
lscpu | awk -F: '/^CPU\(s\):/ {gsub(/ /,"",$2); print $2}'
# prefer:
nproc --all
getconf _NPROCESSORS_ONLN
```

### Virtualization and flags

```bash
lscpu | grep -E 'Virtualization|Hypervisor|Flags|Model name|Thread|Core|Socket'
grep -m1 flags /proc/cpuinfo
```

Look for `vmx` (Intel) / `svm` (AMD) for hardware virtualization; `ht` for hyperthreading.

### NUMA

```bash
lscpu | grep -i numa
numactl -H 2>/dev/null
ls /sys/devices/system/node
```

### Security mitigations summary

```bash
lscpu | sed -n '/Vulnerabilities:/,$p'
# detailed:
grep . /sys/devices/system/cpu/vulnerabilities/*
```

### Containers

```bash
lscpu
nproc
# CPU affinity may be constrained by cpuset cgroup
cat /sys/fs/cgroup/cpuset.cpus.effective 2>/dev/null
```

## Notes / Pitfalls

- `CPU(s)` counts logical CPUs (hardware threads), not physical cores.
- Hypervisors can present fake topology; verify when licensing by socket/core.
- Offline CPUs and hotplug change counts — re-run after changes.
- Flags strings are long; pipe to `grep` for specific features (`avx2`, `aes`, …).
- Don’t use load average without knowing logical CPU count.

## 2026-relevant notes

- ARM (`aarch64`) and RISC-V hosts are common; scripts must not assume `x86_64`.
- JSON output helps inventory agents.
- Mitigations still affect performance; compare with workload benchmarks, not only flag presence.

## Related Commands

- `nproc` — online processor count
- `lshw -class processor` — alternate inventory
- `cat /proc/cpuinfo` — per-cpu raw
- `numactl` — NUMA policy
- `taskset` — CPU affinity
- `tuned` / power profiles — CPU governors

## Additional Resources

- `man lscpu`

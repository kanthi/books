---
title: "taskset"
author:
  - name: "K19G"
  - name: "grok-bot"
---

## Overview

**Thesis:** the scheduler is usually better at placing work than you are. `taskset` is for the cases where it is not: keeping a noisy batch job off the CPUs a latency-sensitive service needs, reproducing a benchmark without migrations, or proving that a "slow" program is really just sharing a CPU. `taskset` (util-linux) reads and sets a task's **CPU affinity**, the set of CPUs the kernel is *allowed* to run it on, through `sched_getaffinity(2)` / `sched_setaffinity(2)`.

Typical operator jobs:

- Start a benchmark or build on fixed CPUs so the results can be repeated.
- Move a running batch process off the CPUs a database or packet path uses.
- Check *where* a process may run when it is slower than expected.
- Shrink a process's view of the machine so it sizes its thread pool smaller.

```bash
# Debian/Ubuntu/Fedora: part of util-linux, installed by default
taskset --version
nproc --all
```

```text
taskset from util-linux 2.41.5
8
```

All outputs below come from an 8-vCPU Debian 13 VM (kernel 6.12, no SMT siblings). Your CPU numbers and timings will differ.

## Mental model

```text
 cgroup cpuset (AllowedCPUs=)  ── hard ceiling, set by the admin/systemd/container runtime
          │  ∩
 task affinity mask             ── per THREAD, set by sched_setaffinity / taskset
          │
          ▼
 scheduler picks a CPU from the intersection; inherited by fork() and new threads
```

| Fact | Consequence |
|------|-------------|
| Affinity is a **per-thread** attribute | `taskset -p PID` changes only the thread whose TID equals PID (the main thread). Use `-a` for all threads |
| Children and new threads **inherit** the mask | `taskset -c 3 make -j` keeps the whole build on CPU 3, which is probably not what you meant |
| It is a **permission**, not a reservation | Pinning A to CPU 2 does not keep B off CPU 2. Exclusivity needs cpusets or `isolcpus=` |
| Any process may **widen** its own mask again | `taskset` is a placement tool, not a security or quota boundary. Use cgroups for that |
| The effective set is the mask **∩ cpuset** | Inside a container or a systemd unit with `AllowedCPUs=`, CPUs outside the cpuset are not reachable |

## Syntax

```bash
taskset [options] MASK COMMAND [ARG...]     # launch with a hex mask
taskset [options] -c LIST COMMAND [ARG...]  # launch with a CPU list
taskset [options] -p [MASK] PID             # read (no MASK) or set an existing PID
taskset [options] -cp [LIST] PID            # same, with a list; -p and -c grouped
```

| Option | Meaning |
|--------|---------|
| `-c`, `--cpu-list` | Read/write a **list** (`0,5,8-11`, stride `0-10:2`) instead of a hex mask |
| `-p`, `--pid` | Operate on an existing PID instead of launching a command |
| `-a`, `--all-tasks` | With `-p`: apply to **every thread** of PID (all of `/proc/PID/task/*`) |

Mask form: `0x1` = CPU 0, `0x5` = CPUs 0 and 2, `ff` = CPUs 0–7. On large machines the kernel prints masks as comma-separated 32-bit groups (`ffffffff,ffffffff`). Prefer `-c` lists in anything a human will read.

Exit status: `0` on success, `1` on failure (bad PID, invalid mask, no permission). When launching, `taskset` `exec`s the command, so the status you see is the command's own.

## Safety

- **Changing someone else's process needs `CAP_SYS_NICE`.** You can always change your own processes and read anyone's. Do not "fix" a system daemon with `sudo taskset -p`. Set `CPUAffinity=` in its unit so the change survives a restart and is visible in config review.
- **Pinning a multi-threaded service to fewer CPUs than it has busy threads** turns a capacity problem into a latency problem. Measure before and after.
- **Never pin a production process to CPU 0 by habit.** CPU 0 often takes more housekeeping (timers, some IRQs) than the others.

## Examples with Explanations

### 1. Read and set: masks, lists, strides

```bash
taskset -p $$                    # mask form
taskset -cp $$                   # list form
taskset -c 0-7:2 grep Cpus_allowed_list /proc/self/status
taskset 0x5     grep Cpus_allowed_list /proc/self/status
```

```text
pid 257922's current affinity mask: ff
pid 257922's current affinity list: 0-7
Cpus_allowed_list:	0,2,4,6
Cpus_allowed_list:	0,2
```

`/proc/PID/status` (`Cpus_allowed_list`) is the kernel's own view and needs no tool. With util-linux 2.41, `taskset -p 0` is **bad usage** (pid 0 is accepted from 2.42 on). Use `$$` in scripts that must run on both.

### 2. Change a running process

```bash
sleep 30 & P=$!
taskset -cp 1,3 $P
taskset -cp $P
ps -o pid,psr,comm -p $P        # PSR = CPU it last ran on
```

```text
pid 258147's current affinity list: 0-7
pid 258147's new affinity list: 1,3
pid 258147's current affinity list: 1,3
    PID PSR COMMAND
 258147   1 sleep
```

The man page guarantees that when `taskset` returns, the task has been moved to a legal CPU. You do not need to wait for it to drift there.

### 3. See contention instead of guessing

```python
# file: burn.py — a fixed amount of pure-CPU work; prints wall time and the CPU it finished on
import os, time

t0 = time.perf_counter()
n = 0
for i in range(30_000_000):
    n += i & 7
with open("/proc/self/stat") as f:
    cpu = f.read().rsplit(")", 1)[1].split()[36]   # field 39: "processor", CPU last run on
print(f"pid {os.getpid()} cpu {cpu} wall {time.perf_counter() - t0:.2f}s")
```

```bash
#!/usr/bin/env bash
# file: contention.sh — same work, three placements
set -u
echo "--- one copy, pinned to CPU 0"
taskset -c 0 python3 burn.py
echo "--- two copies, both pinned to CPU 0"
taskset -c 0 python3 burn.py & taskset -c 0 python3 burn.py & wait
echo "--- two copies, CPU 0 and CPU 1"
taskset -c 0 python3 burn.py & taskset -c 1 python3 burn.py & wait
```

```bash
chmod +x contention.sh && ./contention.sh
```

```text
--- one copy, pinned to CPU 0
pid 259467 cpu 0 wall 1.85s
--- two copies, both pinned to CPU 0
pid 259475 cpu 0 wall 3.87s
pid 259474 cpu 0 wall 3.92s
--- two copies, CPU 0 and CPU 1
pid 259494 cpu 1 wall 1.77s
pid 259493 cpu 0 wall 1.90s
```

Two CPU-bound tasks on one CPU each take about **twice** as long, because the fair scheduler splits the CPU between them. Spread across two CPUs, each runs at full speed. This is the cheapest way to prove, or rule out, the theory that "it's slow because something else is on that core". On a VM, expect the occasional slow run when the hypervisor shares the physical core. Repeat a run before believing it.

### 4. Pin a whole build or benchmark

```make
# file: Makefile — each target reports which CPUs its recipe shell may use
all: a b c d
a b c d:
	@echo "$@: $$(grep Cpus_allowed_list /proc/self/status | cut -f2)"
```

```bash
taskset -c 4-7 make -j4
```

```text
b: 4-7
a: 4-7
d: 4-7
c: 4-7
```

Inheritance is the feature here. One `taskset` at the top covers `make` and every shell and compiler it forks. The same pattern (`taskset -c 2 ./bench …`) keeps a benchmark from migrating between runs, so you compare like with like.

### 5. Make the program see fewer CPUs

```bash
taskset -c 0-3 nproc
taskset -c 0-3 nproc --all
taskset -c 0-1 python3 -c "import os; print('cpu_count', os.cpu_count(), '| process_cpu_count', os.process_cpu_count())"
```

```text
4
8
cpu_count 8 | process_cpu_count 2
```

`nproc` honours affinity, and `nproc --all` does not. Runtimes differ. Python 3.13's `os.process_cpu_count()` follows the mask (and is what `concurrent.futures` now uses by default), while `os.cpu_count()` still reports the whole machine. A program that sizes its pool from the machine total will start 8 workers on 2 CPUs. Check which call your software uses before trusting `taskset` to shrink it.

## The trap

`taskset -p` changes **one thread**. Most real services are multi-threaded, and their worker threads already exist when you run it.

```python
# file: threads.py — a process with a main thread and three worker threads that just wait
import os, threading, time

stop = threading.Event()
for i in range(3):
    threading.Thread(target=stop.wait, name=f"worker-{i}").start()
print(os.getpid(), flush=True)
time.sleep(60)
stop.set()
```

```bash
#!/usr/bin/env bash
# file: show-tasks.sh — print every thread of PID $1 with its allowed-CPU list
for t in /proc/"$1"/task/*; do
  printf '%-8s %-10s %s\n' "${t##*/}" "$(cat "$t"/comm)" "$(awk '/Cpus_allowed_list/ {print $2}' "$t"/status)"
done
```

```bash
chmod +x show-tasks.sh
python3 threads.py > pid.txt & sleep 0.5; P=$(cat pid.txt)
taskset -cp 2 $P;  ./show-tasks.sh $P
taskset -acp 2 $P; ./show-tasks.sh $P
```

```text
pid 258915's current affinity list: 0-7
pid 258915's new affinity list: 2
258915   python3    2
258917   python3    0-7
258918   python3    0-7
258919   python3    0-7
pid 258915's current affinity list: 2
pid 258915's new affinity list: 2
pid 258917's current affinity list: 0-7
pid 258917's new affinity list: 2
pid 258918's current affinity list: 0-7
pid 258918's new affinity list: 2
pid 258919's current affinity list: 0-7
pid 258919's new affinity list: 2
258915   python3    2
258917   python3    2
258918   python3    2
258919   python3    2
```

After plain `-p`, `taskset -cp $P` reports "2", and the three workers doing the actual work are still free to run anywhere. **Fix:** use `-a` for running processes. Better still, set affinity *before* the process starts (`taskset -c … cmd`, or `CPUAffinity=` in a systemd unit), so every thread inherits it. `-a` only covers threads that exist now. A thread pool that spawns new threads later inherits from whichever thread created it, and that is usually fine once all threads are pinned.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| Partly-invalid list | `taskset -c 0,99 cmd` succeeds and quietly runs on CPU 0 only. Only an **entirely** invalid set fails: `taskset -c 99 true` → `failed to set pid …'s affinity: Invalid argument` (exit `1`). Check the result with `taskset -cp` |
| `-c` after `-p` | Write `-cp LIST PID` (or `-p -c`). The list must come right before the PID |
| Pinning ≠ isolation | Other tasks and IRQs still use "your" CPU. For exclusivity use cpusets (`AllowedCPUs=` on the other slices) or `isolcpus=`/`nohz_full=` on the kernel command line |
| A process widens its own mask | `taskset -c 0 taskset -c 0-7 grep Cpus_allowed_list /proc/self/status` prints `0-7`. Enforce limits with cgroups, not affinity |
| Container/systemd cpuset | Lists outside the cpuset fail with `Invalid argument`. Read `/sys/fs/cgroup/cpuset.cpus.effective` to see what you actually have |
| CPU numbering vs topology | On SMT machines, CPUs *n* and *n+k* may be siblings sharing one core. Check `lscpu -e` or `/sys/devices/system/cpu/cpu*/topology/thread_siblings_list` before "spreading" work |
| NUMA | Affinity says nothing about where memory comes from. Use `numactl --cpunodebind --membind` when locality matters |
| `taskset -p 0` | Bad usage on util-linux ≤ 2.41; accepted from 2.42. Use `$$` |

## The boring rule

> Don't pin by default. When you do, pin **at launch** (`taskset -c LIST cmd`, or `CPUAffinity=` in the unit), pin **all threads** (`-a`) if you must change a running process, check the result in `/proc/PID/task/*/status`, and use cpusets, not affinity, when the goal is to keep other work *off* those CPUs.

## Related Commands

| Command | Role |
|---------|------|
| `nice`, `renice` | Weight within the normal scheduling class, without restricting CPUs |
| `chrt` | Scheduling policy (`SCHED_OTHER`/`BATCH`/`IDLE`/`FIFO`/`RR`/`DEADLINE`) |
| `lscpu -e` | CPU, core, socket and NUMA-node numbering, needed before choosing a list |
| `numactl` | CPU **and memory** placement on NUMA machines |
| `systemd-run -p CPUAffinity=… -p AllowedCPUs=…` | Affinity or a cpuset for a transient unit |
| `ps -o pid,psr,comm`, `top` (field `P`) | Which CPU a task last ran on |
| `mpstat -P ALL 1` | Per-CPU utilisation, to confirm the placement |

## Try this

1. Run `contention.sh`, then add a third `burn.py` pinned to CPU 0 and predict the wall time before you look.
2. Start `threads.py`, pin it with plain `-p`, and inspect it with `show-tasks.sh`. Then re-pin it with `-a` and compare.
3. Launch `taskset -c 0-1 python3 -c 'import concurrent.futures as f; print(f.ProcessPoolExecutor()._max_workers)'` and explain the number.
4. Write a systemd drop-in with `CPUAffinity=2-3` for a test service, restart it, and confirm every thread's `Cpus_allowed_list`.
5. Prove that pinning is not isolation: pin one `burn.py` to CPU 3, run an unpinned `burn.py` loop alongside it, and watch `mpstat -P 3 1`.

## Sources

- [taskset(1)](https://man7.org/linux/man-pages/man1/taskset.1.html): util-linux manual (mask and list syntax, strides, `-a`, PERMISSIONS, the "scheduled to a legal CPU" guarantee)
- [sched_setaffinity(2)](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html): per-thread semantics, inheritance across `fork`, `EINVAL` when no CPU in the mask is permitted, `CAP_SYS_NICE`
- [cpuset(7)](https://man7.org/linux/man-pages/man7/cpuset.7.html) and the kernel's [cgroup v2 cpuset documentation](https://docs.kernel.org/admin-guide/cgroup-v2.html#cpuset): how cpusets bound affinity
- [systemd.exec(5) `CPUAffinity=`](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html) and [systemd.resource-control(5) `AllowedCPUs=`](https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html)
- [util-linux v2.42 release notes](https://www.kernel.org/pub/linux/utils/util-linux/v2.42/v2.42-ReleaseNotes) (taskset accepts pid 0)
- [Python `os.process_cpu_count()`](https://docs.python.org/3/library/os.html#os.process_cpu_count) (3.13+)

---
title: "sched_ext sub-schedulers: lending CPUs from a BPF root"
author:
  - name: "K19G"
  - name: "grok-bot"
---

## Overview

**Thesis:** `taskset` and cpusets tell the *fair* scheduler where a thread may run. **sched_ext** lets a BPF program *be* the scheduler. On the Linux **7.3**-era sched_ext work, a **root** BPF scheduler can hand a cgroup subtree to a nested **sub-scheduler** and **lend CPUs** with revocable, capability-based grants — so the child fully owns enqueue, dispatch, and preemption on those CPUs until the parent takes them back. This chapter is the operator/mental-model view: what shows up in sysfs, how grants differ from affinity masks, and what to read in `Documentation/scheduler/sched-ext.rst` and the for-7.3 pull summary. No BPF programs are loaded here (that needs privileges and a configured kernel); we stay on primary docs and observable interfaces.

Typical reasons to care:

- Run a latency-tuned BPF policy for one service cgroup without replacing the whole machine's scheduler.
- Understand why a nested scx scheduler starts with **zero** CPUs until the parent grants some.
- Debug "tasks stuck / rescue execution" when grants and affinity disagree.

```bash
# Read-only probes — safe on any modern host; values vary
uname -r
test -d /sys/kernel/sched_ext && echo 'sched_ext sysfs present' || echo 'sched_ext sysfs absent'
```

On a kernel built without `CONFIG_SCHED_CLASS_EXT`, the directory is simply missing. That is expected.

## Mental model

```text
                 root BPF scheduler (owns all caps on all CPUs)
                           │
           scx_bpf_sub_grant(cgroup, cmask, caps)
                           │
                           ▼
              sub-scheduler on a cgroup subtree
         (enqueue / preempt / cpufreq caps only where granted)
                           │
           scx_bpf_sub_revoke(...)  → tasks requeued with SCX_TASK_REENQ_CAP
```

| Idea | Meaning |
|------|---------|
| **Root** | Attached BPF scheduler that starts with every capability on every CPU id (cid) |
| **Sub-scheduler** | Another `scx_sched` attached under a cgroup; initially **no** CPU access |
| **Grant / revoke** | Parent hands a **subset** of its caps on selected CPUs; child never exceeds parent |
| **Caps (per CPU)** | Roughly: place on idle CPU, enqueue into that CPU's DSQ, preempt others, influence frequency — enforced on every path that touches a CPU |
| **Dispatch vs enqueue** | Earlier sub-sched support could recurse dispatch with `scx_bpf_sub_dispatch()`; 7.3-era work makes **enqueue** capability-based state too, so parents can partition CPUs |

Affinity (`taskset`) still intersects: a task pinned off every granted CPU has nowhere legal to run. The 7.3 series adds **rescue execution** — a small bandwidth budget so such tasks are not left runnable-forever until the watchdog kills the whole BPF scheduler.

### How this differs from `taskset`

| Tool | What it constrains |
|------|-------------------|
| `taskset` / `sched_setaffinity` | Which CPUs the *fair* (or current) class may pick for a thread |
| cgroup cpuset | Hard ceiling for a group |
| sched_ext sub-grants | Which CPUs a *nested BPF scheduler* may use for its tasks' enqueue/preempt paths |

You can combine them; grants do not replace cpusets.

## Worked examples (docs-faithful)

### Case 1: Is sched_ext alive?

From `Documentation/scheduler/sched-ext.rst`:

```bash
cat /sys/kernel/sched_ext/state          # enabled | disabled | …
cat /sys/kernel/sched_ext/root/ops       # name of loaded root ops, if any
cat /sys/kernel/sched_ext/enable_seq     # monotonically increasing load count
```

Illustrative shape when a simple example scheduler is running (from the kernel doc):

```text
# cat /sys/kernel/sched_ext/state
enabled
# cat /sys/kernel/sched_ext/root/ops
simple
```

Event counters live under the scheduler kobject, e.g. `/sys/kernel/sched_ext/root/events` (`SCX_EV_*` lines). Sub-scheduler bypass events (such as `SCX_EV_SUB_BYPASS_DISPATCH`) are part of the diagnostic surface when hierarchy misbehaves.

### Case 2: Lending CPUs (capability grant story)

From the sched_ext/for-7.3 patchset and LWN coverage of sub-scheduler enqueue support:

1. Sub-scheduler attaches under a cgroup → **no** CPUs yet.
2. Root (or parent) calls **`scx_bpf_sub_grant`** with the child's cgroup id and a CPU mask (and capability bits).
3. Child learns via ops such as **`sub_caps_updated` / `sub_ecaps_updated`**; idle CPUs may get an **`update_idle`** re-notification so the child can use them immediately.
4. Parent calls **`scx_bpf_sub_revoke`** → tasks on those CPUs are pulled and re-enqueued to the child with **`SCX_TASK_REENQ_CAP`** so it must pick a still-allowed CPU.

```text
Example (conceptual, not a runnable bpftrace script):

  root R: grant cids 8–15 to child A  →  A may enqueue/preempt only there
  A:      grant cids 8–11 to child B  →  B's set ⊆ A's set ⊆ R's set
  R:      revoke cid 11 from A        →  cascades; tasks requeued
```

The example scheduler **`scx_qmap`** in the 7.3 pull is cited as demonstrating full hierarchical sub-scheduling once the series lands.

### Case 3: Partial switch vs whole-machine takeover

Kernel doc flags:

| `ops->flags` | Effect |
|--------------|--------|
| default (no partial) | `SCHED_NORMAL` / `BATCH` / `IDLE` / `EXT` tasks go through sched_ext when loaded |
| `SCX_OPS_SWITCH_PARTIAL` | Only `SCHED_EXT` policy tasks use the BPF scheduler; fair class keeps the rest |

Abort paths: terminate the scheduler binary, `SysRq-S`, or internal errors (including stalled runnable tasks) → revert to fair-class.

## The trap

- Assuming a nested scheduler can "see" all CPUs because the machine has them — **grants start empty**.
- Using only dispatch-time recursion and expecting enqueue isolation — without capability state, children could still insert into local DSQs they should not own (the problem the 7.3 enqueue work fixes).
- Pinning tasks with `taskset` onto CPUs their sub-scheduler was never granted — you need rescue/fallback behavior or you look like a hung BPF scheduler.
- Loading random out-of-tree BPF schedulers on production without a revert plan (`SysRq-S`, fair-class fallback).

## The boring rule

Treat the root sched_ext program as the **owner of CPU capabilities**; lend with grant/revoke; keep cgroup boundaries and affinity consistent with those grants; watch `/sys/kernel/sched_ext/` before you blame the fair scheduler.

## Try this

1. On a lab kernel with `CONFIG_SCHED_CLASS_EXT=y`, read `Documentation/scheduler/sched-ext.rst` and the `tools/sched_ext` examples (`scx_simple`, `scx_qmap`).
2. Compare `cat /sys/kernel/sched_ext/state` before and after starting/stopping an example scheduler (requires privileges — do this only on machines you administer).
3. Read the sched_ext-for-7.3 pull summary (lore.kernel.org / kernel.org git) for grant/revoke and rescue execution.
4. Related userspace: revisit `taskset` and cpusets in this part — they constrain *tasks*; sub-grants constrain *which BPF scheduler may place them*.

## Sources

- Linux kernel: `Documentation/scheduler/sched-ext.rst` (Extensible Scheduler Class)
- `[GIT PULL] sched_ext: Changes for v7.3` — hierarchical sub-scheduling / CPU delegation summary
- Patchset: *sched_ext: Capability-based CPU delegation for sub-schedulers* (sched_ext/for-7.3)
- LWN: *Sched-ext: enqueue() for sub-schedulers and proxy-execution support* (<https://lwn.net/Articles/1082717/>)

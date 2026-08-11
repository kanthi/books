# iostat

## Overview

`iostat` (from the **sysstat** package) reports CPU utilization and **per-device** I/O rates, queue depth, await, and utilization. Use it to find busy disks, confirm I/O-wait hypotheses from `vmstat`/`top`, and compare devices under load. Install on Ubuntu with `sudo apt install sysstat`.

## Syntax

```bash
iostat [options] [interval [count]]
iostat [options] [interval [count]] [device...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-x` | Extended device stats (`%util`, `await`, `aqu-sz`, …) |
| `-z` | Omit idle devices |
| `-y` | Omit the first since-boot report when using intervals |
| `-d` / `-c` | Devices only / CPU only |
| `-h` | Human-readable where supported |
| `-k` / `-m` | KB/s or MB/s units |
| `-p` | Include partitions |
| `-t` | Timestamps |
| `-N` | Map device-mapper names to prettier LV names |
| `-j ID UUID` … | Display persistent device identifiers (version-dependent) |

## Key Use Cases

1. Live disk saturation checks (`%util`, `await`)
2. Confirm which device backs high `wa` in vmstat/top
3. Partition-level I/O (`-p`) during noisy-neighbor hunts
4. Scripted samples during load tests

## Examples with Explanations

### Extended live samples (default incident command)

```bash
iostat -xz 1 5
iostat -xyz 1 10
```

`-x` extended fields, `-z` hide idle noise, interval 1s. Prefer `-y` (or ignore first report) so you are not reading since-boot averages.

### Skip since-boot line explicitly

```bash
iostat -xyz 1 5
# first sample after -y is the first real interval
```

### One device (NVMe / disk)

```bash
iostat -xz 1 5 nvme0n1
iostat -xz 1 5 sda
```

Focus when you already know the hot device from `lsblk`.

### CPU only vs devices only

```bash
iostat -c 1 5
iostat -d -xz 1 5
```

### Partitions and mapper names

```bash
iostat -xzp 1 3
iostat -xzN 1 3
```

`-p` splits partitions; `-N` helps on LVM hosts.

### Timestamped capture

```bash
iostat -txz 1 30 | tee /tmp/iostat.out
```

### Pair with process-level I/O

```bash
iostat -xz 1 5
# if installed:
sudo iotop -oPa
pidstat -d 1 5
```

iostat shows **devices**; iotop/pidstat show **who** is writing.

## Understanding Output

CPU section resembles other sysstat tools (`%user`, `%system`, `%iowait`, `%idle`, `%steal`).

Extended device fields (names can vary slightly by sysstat version):

| Field | Meaning |
|-------|---------|
| `r/s` `w/s` | Read/write requests completed per second |
| `rkB/s` `wkB/s` (or `rMB/s`) | Throughput |
| `rrqm/s` `wrqm/s` | Merged requests (elevator/scheduler merging) |
| `await` | Average time (ms) for requests (queue + service) |
| `aqu-sz` | Average queue length |
| `rareq-sz` `wareq-sz` | Average request size |
| `%util` | Share of time the device had outstanding I/O (~saturation signal for simple devices) |

**How to read it under fire:**

| Signal | Interpretation |
|--------|----------------|
| `%util` ~ 100% and high `await` | Device saturated or slow |
| High `await`, modest `%util` | Latency issue (storage tier, queueing elsewhere, NFS) |
| High `w/s` + rising `aqu-sz` | Write burst / flush pressure |
| Only one partition hot | Noisy tenant or log volume on that part |
| `%iowait` high on CPU block | CPUs waiting on I/O — align with device rows |

**Caveats:** on RAID, multipath, and NVMe with deep queues, `%util` is not a perfect “percent busy” for modern parallel devices — still useful, but combine with `await` and application latency.

## Notes & Pitfalls

- Package: `sudo apt install sysstat` if command missing.
- Without interval, or the first line of interval mode, stats are often **since boot** — use intervals + `-y`.
- Device names from `lsblk`; cloud reattach can rename `sdX`.
- NFS latency does not show as a local block device — check client `mount` stats / server side.
- Containers: host-level iostat unless you instrument the host.

## Related Commands

- `vmstat` — system-level bi/bo and `wa`
- `iotop` — per-process I/O (if installed)
- `pidstat -d` — per-process disk stats (sysstat)
- `lsblk` — map names to mounts
- `sar -d` — historical disk from sysstat logs
- `nfsiostat` — NFS-specific (nfs-common)

## Additional Resources

- `man iostat`
- `man pidstat`

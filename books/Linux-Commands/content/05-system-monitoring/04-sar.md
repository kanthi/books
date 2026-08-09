# sar

## Overview

`sar` (System Activity Reporter, **sysstat**) prints **live and historical** metrics: CPU, memory, load, disk, network, and more. Live mode is like specialized siblings (`mpstat`, `iostat`); historical mode reads daily binary logs written by `sadc` via cron or systemd timers. On Ubuntu, collection is **off until enabled**.

## Syntax

```bash
sar [options] [interval [count]]
sar [options] -f /var/log/sysstat/saDD
sar [options] -s HH:MM:SS -e HH:MM:SS
```

## Common Options

| Option | Description |
|--------|-------------|
| `-u` | CPU utilization (default) |
| `-r` | Memory utilization |
| `-q` | Load average / run queue |
| `-b` | I/O transfer rates |
| `-d` | Per-block device |
| `-n DEV\|EDEV\|TCP\|SOCK\|…` | Network statistics |
| `-P ALL` | Per-CPU |
| `-s` / `-e` | Start / end time for historical |
| `-f file` | Read a specific saDD data file |
| `-A` | Nearly all reports |
| `-o file` | Write binary samples (advanced) |
| `-f` + date | Files under `/var/log/sysstat/` (`sa07` = day 07) |

## Key Use Cases

1. Live sampling during an incident (same family as mpstat/iostat)
2. “What happened at 09:15 yesterday?” from sa logs
3. Capacity trends when full Prometheus stack is overkill
4. Correlate CPU/mem/net windows after outages

## Examples with Explanations

### Live CPU samples

```bash
sar -u 1 5
sar -u ALL 1 5
```

### Memory and load

```bash
sar -r 1 5
sar -q 1 5
sar -r -q 1 5
```

### Disk and I/O rates

```bash
sar -b 1 5
sar -d 1 5
```

### Network devices

```bash
sar -n DEV 1 5
sar -n EDEV 1 5    # errors/drops
sar -n TCP,ETCP 1 5
```

### Per-CPU history of “now”

```bash
sar -P ALL 1 3
```

### Today’s history (collection must be enabled)

```bash
sar -u
sar -r
sar -q
ls -la /var/log/sysstat/
```

Without data files, sar only works in live interval mode or errors on historical queries.

### Slice a time window

```bash
sar -u -s 09:00:00 -e 10:00:00
sar -r -s 09:00:00 -e 10:00:00
sar -n DEV -s 09:00:00 -e 10:00:00
```

### Read another day’s file

```bash
# Day-of-month file name (locale/sysstat config can vary)
sudo ls /var/log/sysstat/
sar -u -f /var/log/sysstat/sa08
sar -r -f /var/log/sysstat/sa08 -s 14:00:00 -e 15:00:00
```

### Enable collection on Ubuntu (sketch)

```bash
sudo apt install sysstat
# Debian/Ubuntu: enable data collector
sudo sed -i 's/^ENABLED=.*/ENABLED="true"/' /etc/default/sysstat
sudo systemctl enable --now sysstat
# timers: sysstat-collect.timer / sysstat-summary.timer (names may vary by release)
systemctl list-timers | grep -i sysstat
ls /var/log/sysstat/
```

Confirm files appear under `/var/log/sysstat/` after the next collect interval (often ~10 minutes).

### Incident bundle

```bash
sar -u 1 5
sar -r 1 5
sar -q 1 5
sar -n DEV 1 5
# if history enabled:
sar -u -s 11:00:00 -e 12:00:00
```

## Understanding Output

Output is tabular with a timestamp column in historical mode. Field meanings align with other sysstat tools:

| Report | Useful fields |
|--------|----------------|
| `-u` | `%user`, `%system`, `%iowait`, `%steal`, `%idle` |
| `-r` | `kbmemfree`, `kbavail`, `%memused`, `kbcached`, `%swpused` |
| `-q` | `runq-sz`, `plist-sz`, `ldavg-1/5/15` |
| `-d` | `tps`, `rkB/s`, `wkB/s`, `await`, `%util` (version-dependent) |
| `-n DEV` | `rxkB/s`, `txkB/s`, `rxpck/s`, `txpck/s` |

**Reading historical rows:** averages between sample points (e.g. every 10 minutes) smooth spikes — a 30-second outage may barely move a 10-minute bucket. For micro-incidents, live 1s tools win; sar history wins for longer windows.

## Notes & Pitfalls

- **Ubuntu default:** package installed ≠ collection enabled — set `ENABLED="true"` and start sysstat timers.
- Data retention/rotation is configured under `/etc/sysstat/` and logrotate — don’t assume months of history.
- Timezone of timestamps follows system clock — wrong TZ confuses windows (`timedatectl`).
- Binary sa files are not plain text; always use `sar -f`.
- Modern long-term monitoring is often Prometheus/node_exporter/Grafana; sar remains excellent for local/air-gapped hosts.
- Permissions: reading some logs may need root depending on directory mode.

## Related Commands

- `vmstat` / `iostat` / `mpstat` — live siblings
- `pidstat` — per-process over intervals
- `journalctl` — logs, not metrics
- `prometheus` / `node_exporter` — long-term modern stacks
- `dstat` / `atop` — alternative live dashboards (if installed)

## Additional Resources

- `man sar`
- `man sadc`
- `/usr/share/doc/sysstat/` on package install

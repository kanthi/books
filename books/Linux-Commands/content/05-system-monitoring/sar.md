# sar

## Overview
`sar` (System Activity Reporter, sysstat) prints **historical and live** metrics: CPU, memory, disk, network, load. Data is collected by `sysstat`/`sadc` cron or systemd timers when enabled.

## Syntax
```bash
sar [options] [interval [count]]
sar [options] -f /var/log/sysstat/saDD
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u` | CPU (default) |
| `-r` | Memory |
| `-q` | Load / run queue |
| `-b` | I/O rates |
| `-d` | Per-block device |
| `-n DEV\|TCP\|…` | Network |
| `-s` / `-e` | Start/end time |
| `-f file` | Read data file |
| `-A` | Almost all |

## Examples with Explanations
### Live CPU samples
```bash
sar -u 1 5
```

### Memory / load
```bash
sar -r 1 5
sar -q 1 5
```

### Network devices
```bash
sar -n DEV 1 5
```

### Today’s history (if collected)
```bash
sar -u
sar -r -s 09:00:00 -e 10:00:00
ls /var/log/sysstat/
```

### Enable collection (Ubuntu sketch)
```bash
sudo apt install sysstat
# set ENABLED="true" in /etc/default/sysstat (Debian/Ubuntu)
sudo systemctl enable --now sysstat
```

## Related Commands
- `vmstat` / `iostat` / `mpstat` — live siblings  
- `journalctl` — logs, not metrics  
- `prometheus`/`node_exporter` — long-term modern stacks

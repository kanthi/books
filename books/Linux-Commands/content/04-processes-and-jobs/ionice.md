# ionice

## Overview
`ionice` sets or shows **I/O scheduling class and priority** for a process (CFQ/BFQ era semantics; effect varies by scheduler and kernel).

## Syntax
```bash
ionice [options] command
ionice [options] -p PID
```

## Classes
| Class | `-c` | Meaning |
|-------|------|---------|
| None | 0 | Default |
| Realtime | 1 | Highest (careful; root) |
| Best-effort | 2 | Normal (priority 0–7) |
| Idle | 3 | Only when disk idle |

## Examples with Explanations
```bash
ionice -c3 ./heavy-backup.sh          # idle class
ionice -c2 -n7 tar -czf out.tgz big/  # best-effort low prio
ionice -p 1234                        # show
sudo ionice -c2 -n0 -p 1234           # raise I/O prio
```

## Combined with nice
```bash
nice -n 19 ionice -c3 rsync -a /data/ /mnt/backup/
```

## Related Commands
- `nice` / `renice` — CPU  
- `iostat` / `iotop` — observe I/O  
- `systemd-run -p IOSchedulingClass=`

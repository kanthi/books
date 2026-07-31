# top

## Overview
`top` provides a real-time, interactive view of system load and processes. Use it for live triage; use `ps` for snapshots and scripting, `htop` for a friendlier UI when installed.

## Syntax
```bash
top [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Batch mode (non-interactive) |
| `-n N` | Number of iterations |
| `-d secs` | Delay between updates |
| `-p PID` | Watch specific PIDs |
| `-u user` | Only user’s processes |
| `-H` | Threads |
| `-o field` | Sort field (GNU) |

## Interactive keys (defaults)
| Key | Action |
|-----|--------|
| `h` | Help |
| `q` | Quit |
| `P`/`M`/`T` | Sort CPU / mem / time |
| `k` | Kill PID |
| `r` | Renice |
| `f` | Fields |
| `1` | Per-CPU breakdown |
| `W` | Save config |

## Examples with Explanations
### Interactive
```bash
top
```

### Batch snapshot for logs
```bash
top -b -n 1 | head -n 30
```

### One user
```bash
top -u deploy
```

### Specific PID
```bash
top -p 1,$$
```

## Understanding Output
Load averages, task counts, CPU states (`us`/`sy`/`id`/`wa`/`st`), memory/swap summary, then process table. High `wa` suggests I/O wait; high `st` suggests hypervisor steal.

## Related Commands
- `htop` / `btop` — improved UIs  
- `ps` — snapshots  
- `vmstat` / `iostat` — subsystem stats  
- `pidstat` — per-process over time

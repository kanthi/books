# kill

## Overview
`kill` sends a signal to a process by PID. Despite the name, the default signal is `TERM` (15), which requests graceful shutdown; `KILL` (9) forces termination and cannot be caught.

## Syntax
```bash
kill [options] PID...
kill -SIGNAL PID...
kill -s SIGNAL PID...
```

## Common Signals
| Signal | Number | Typical meaning |
|--------|--------|-----------------|
| `TERM` | 15 | Graceful stop (default) |
| `HUP` | 1 | Reload/hangup |
| `INT` | 2 | Interrupt (Ctrl-C) |
| `KILL` | 9 | Force kill (uncatchable) |
| `STOP`/`CONT` | 19/18 | Pause / resume |
| `USR1`/`USR2` | 10/12 | App-defined |

## Safety
Escalate: `TERM` → wait → `KILL`. Prefer `systemctl stop` for managed services. Wrong PID is catastrophic on shared systems — verify with `ps -p PID`.

## Examples with Explanations
### Graceful then force
```bash
kill 1234
sleep 2
kill -0 1234 2>/dev/null && kill -9 1234
```
`kill -0` tests existence/permission without signaling.

### By name (via pgrep)
```bash
kill $(pgrep -x myapp)
pkill -x myapp
```

### Reload
```bash
kill -HUP $(pidof nginx)
# better: systemctl reload nginx
```

### List signals
```bash
kill -l
```

## Related Commands
- `pkill` / `pgrep` — by name  
- `killall` — by name (syntax varies BSD/GNU)  
- `systemctl` — supervised units  
- `timeout` — auto-kill long commands

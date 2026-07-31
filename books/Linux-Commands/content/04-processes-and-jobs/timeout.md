# timeout

## Overview
`timeout` runs a command with a deadline; if it overruns, it sends a signal (default **TERM**, then optional **KILL**). Essential in scripts and CI.

## Syntax
```bash
timeout [options] duration command [args...]
```

Duration: `10s`, `5m`, `1h`, or bare seconds.

## Common Options
| Option | Description |
|--------|-------------|
| `-s SIG` / `--signal` | Signal on timeout (default TERM) |
| `-k duration` | Send KILL this long after first signal |
| `-v` | Verbose when timing out |
| `--preserve-status` | Exit with command’s status even on timeout |
| `--foreground` | Allow command to use TTY better |

## Exit status
| Code | Meaning |
|------|---------|
| 124 | Timed out (default) |
| 125 | `timeout` itself failed |
| 126/127 | Command not executable / not found |
| else | Command’s exit status |

## Examples with Explanations
```bash
timeout 10s curl -fsS https://example.com/
timeout 30s make test
timeout -k 5s 60s ./flaky-server-start
timeout -s KILL 5s sleep 60
```

### In scripts
```bash
if ! timeout 15s ./healthcheck.sh; then
  echo "healthcheck failed or timed out" >&2
  exit 1
fi
```

## Related Commands
- `timelimit` — similar tools  
- `systemd-run -p RuntimeMaxSec=`  
- `curl --max-time` — HTTP-level

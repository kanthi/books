# watch

## Overview
`watch` re-executes a command periodically and shows full-screen output — a live dashboard for one-liners.

## Syntax
```bash
watch [options] command
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n secs` | Interval (default 2; fractional often allowed) |
| `-d` | Highlight differences |
| `-e` | Exit on error |
| `-g` | Exit on output change |
| `-t` | Hide header |
| `-c` | Interpret color codes |
| `-x` | Pass to `sh -c` carefully (see man) |

## Examples with Explanations
```bash
watch -n 1 'df -h /'
watch -d -n 1 'ss -lntp | head'
watch -n 0.5 free -h
watch -n 2 'kubectl get pods'    # if using k8s
```

### Exit when something appears
```bash
watch -g -n 1 'ss -lntp | grep :8080'
```

## Notes
- Quote complex commands so the shell does not expand too early.  
- For logs, prefer `journalctl -f` / `tail -F`.  
- High frequency can be expensive (e.g. heavy SQL each second).

## Related Commands
- `top` / `htop` — process focused  
- `vmstat 1` — built-in interval tools  
- `while sleep; do …; done` — custom loops

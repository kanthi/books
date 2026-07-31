# date

## Overview
`date` prints or sets the system date/time and formats timestamps. For timezone/NTP management prefer `timedatectl`.

## Syntax
```bash
date [options] [+format]
date [-u] [-d timestr] [+format]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u` | UTC |
| `-d STR` / `--date=` | Parse string instead of now |
| `-f file` | Read dates from file |
| `-I[timespec]` | ISO-8601 |
| `-R` | RFC-5322 |
| `-s` | Set system time (needs root; prefer timedatectl) |

## Format snippets
| Spec | Meaning |
|------|---------|
| `%Y-%m-%d` | 2026-07-31 |
| `%F` | same as above |
| `%T` / `%H:%M:%S` | time |
| `%s` | epoch seconds |
| `%z` | offset |

## Examples with Explanations
```bash
date
date -u
date +%Y-%m-%d
date +%F_%H%M%S
date -Iseconds
date -d 'yesterday' +%F
date -d 'next Mon' +%F
date -d @1700000000
date -d '2 hours ago' +%T
```

### Filenames / logs
```bash
logfile="/var/log/myapp-$(date +%F).log"
```

### Epoch math
```bash
date +%s
date -d @$(( $(date +%s) + 3600 ))
```

## Related Commands
- `timedatectl` — zone/NTP  
- `hwclock` — RTC  
- `touch -d` — file times

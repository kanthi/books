# host

## Overview
`host` is a simple DNS lookup utility. Faster to type than `dig` for everyday A/AAAA/MX checks; use `dig` when you need full message sections or uncommon record types.

## Syntax
```bash
host [options] name [server]
host [options] IP
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t type` | Record type (`A`, `AAAA`, `MX`, `TXT`, `NS`, `CNAME`, `SOA`, …) |
| `-a` | All records (ANY — often blocked) |
| `-v` | Verbose |
| `-W secs` | Wait |
| `-R n` | Retries |
| `-C` | SOA for zone check style queries |

## Examples with Explanations
```bash
host example.com
host -t MX example.com
host -t TXT example.com
host -t AAAA example.com
host 1.1.1.1
host example.com 8.8.8.8
host -v example.com
```

### Script snippet
```bash
if host -W 2 example.com >/dev/null; then echo ok; fi
```

## Related Commands
- `dig` — detailed queries  
- `nslookup` — interactive legacy  
- `resolvectl query` — systemd-resolved  
- `getent hosts` — NSS path

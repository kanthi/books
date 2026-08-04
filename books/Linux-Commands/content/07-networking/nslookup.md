# nslookup

## Overview

`nslookup` queries DNS name servers interactively or non-interactively. It remains common in legacy docs and Windows cross-training, but on modern Linux **`dig`**, **`host`**, **`doggo`**, and **`resolvectl query`** are usually better choices for clarity and scripting.

## Syntax

```bash
nslookup [options] [name | -] [server]
```

## Common Options / Directives

| Option / interactive | Description |
|----------------------|-------------|
| `-type=a` / `type=a` | A record |
| `-type=aaaa` | AAAA |
| `-type=mx` | MX |
| `-type=ns` | NS |
| `-type=soa` | SOA |
| `-type=txt` | TXT |
| `-type=ptr` | PTR |
| `-type=cname` | CNAME |
| `-debug` | Debug |
| `-port=N` | Server port |
| `-timeout=N` | Timeout |
| `server ADDR` | Interactive: change server |
| `set type=mx` | Interactive type |

## Key Use Cases

1. Quick interactive DNS checks
2. Following older runbooks
3. Comparing answers from a specific server

## Examples with Explanations

### Non-interactive

```bash
nslookup example.com
nslookup -type=mx example.com
nslookup -type=ns example.com
nslookup example.com 1.1.1.1
nslookup 1.1.1.1
```

### Interactive

```bash
nslookup
> server 8.8.8.8
> set type=txt
> example.com
> exit
```

### Prefer modern equivalents

```bash
dig +short example.com
dig example.com MX
host -t MX example.com
resolvectl query example.com
doggo example.com MX
```

### One-liner recipes

```bash
# Script-friendly? Prefer dig:
dig +short example.com @1.1.1.1

# nslookup parsing is brittle; avoid in automation
```

## Notes & Pitfalls

- Output format varies; **don’t parse nslookup in scripts**.
- Interactive defaults can confuse (search lists, types).
- Package: `dnsutils` / `bind-utils` / `bind9-dnsutils`.
- ANY queries may fail on public resolvers.

## 2026-relevant notes

| Goal | Prefer |
|------|--------|
| Detail | `dig` |
| Short human | `host` / `doggo` |
| Host stub | `resolvectl` |
| DoH/DoT | `doggo` |
| Legacy interactive | `nslookup` |

## Related Commands

- `dig` — preferred detailed client
- `host` — simple lookups
- `doggo` — modern UX
- `resolvectl` — systemd-resolved

## Additional Resources

- `man nslookup`

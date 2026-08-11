# dig

## Overview
`dig` (Domain Information Groper) queries DNS servers and prints detailed answers. It is the preferred CLI for debugging resolution on Ubuntu/Debian (package `dnsutils` / `bind9-dnsutils`). Use it to inspect A/AAAA/MX/TXT/NS/CNAME records, compare resolvers, and validate changes after DNS edits.

## Syntax
```bash
dig [@server] [name] [type] [options]
dig [options] name type
```
Default type is `A`. If `@server` is omitted, dig uses the system resolver configuration (often `systemd-resolved` stub on Ubuntu).

## Common Options
| Option | Description |
|--------|-------------|
| `@server` | Query this nameserver (IP or hostname) |
| `-t type` / positional `type` | Record type: `A`, `AAAA`, `MX`, `TXT`, `NS`, `CNAME`, `SOA`, `ANY` (limited), … |
| `+short` | Minimal answer only |
| `+noall +answer` | Show answer section only (structured) |
| `+trace` | Iterative resolve from root hints |
| `+dnssec` | Request DNSSEC records |
| `+tcp` | Use TCP instead of UDP |
| `+time=T` | Timeout seconds |
| `+tries=N` | Number of tries |
| `-p port` | Nameserver port (default 53) |
| `-x addr` | Reverse lookup (PTR) convenience |
| `-4` / `-6` | Transport IPv4 / IPv6 only |
| `+subnet=…` | EDNS client subnet (advanced) |

## Examples with Explanations
### Basic A record
```bash
dig example.com
dig example.com A
```

### Short output for scripts
```bash
dig +short example.com
dig +short example.com AAAA
```

### Query a specific resolver
```bash
dig @1.1.1.1 example.com
dig @8.8.8.8 example.com AAAA
dig @127.0.0.53 example.com   # systemd-resolved stub on many Ubuntu hosts
```
Comparing `@1.1.1.1` vs system resolver isolates “DNS server cache/policy” vs “local stub” issues.

### MX and TXT
```bash
dig example.com MX +short
dig example.com TXT +short
```

### NS and SOA (delegation / zone authority)
```bash
dig example.com NS +short
dig example.com SOA
```

### Reverse DNS (PTR)
```bash
dig -x 1.1.1.1 +short
# equivalent idea:
dig 1.1.1.1.in-addr.arpa PTR +short
```

### Answer section only (readable)
```bash
dig +noall +answer example.com A
dig +noall +answer www.example.com
```

### Trace from the root (find where delegation breaks)
```bash
dig +trace example.com
```
Shows root → TLD → authoritative path. Heavy but excellent when “some resolvers see X, others Y.”

### Follow CNAME manually
```bash
dig www.example.com +short
dig +noall +answer www.example.com
```
If you get a CNAME, dig again on the target name for the final A/AAAA.

### TCP query (firewall / large answers)
```bash
dig +tcp example.com TXT
```

### Non-standard port (lab DNS)
```bash
dig @127.0.0.1 -p 5353 test.lab A
```

### Batch mode
```bash
dig -f names.txt +short
```
`names.txt` lists one name per line.

### Check mail-related records quickly
```bash
dig example.com MX +short
dig example.com TXT +short | grep -i spf
dig _dmarc.example.com TXT +short
```

## Understanding Output
Default output sections:
- **HEADER** — opcode, status (`NOERROR`, `NXDOMAIN`, `SERVFAIL`, `REFUSED`), flags (`aa` authoritative, `rd` recursion desired, `ra` recursion available).
- **QUESTION** — what you asked.
- **ANSWER** — records for the name.
- **AUTHORITY** — NS/SOA when relevant.
- **ADDITIONAL** — glue / extras.
- **Query time / SERVER / WHEN / MSG SIZE** — which server answered and how fast.

Status guide:
| Status | Meaning |
|--------|---------|
| `NOERROR` | Query ok (answer may still be empty for that type) |
| `NXDOMAIN` | Name does not exist |
| `SERVFAIL` | Resolver failure (upstream, DNSSEC, timeout) |
| `REFUSED` | Server refused the query |

## Notes & Pitfalls
- Ubuntu’s `127.0.0.53` is often a **stub** — it forwards to real resolvers. Debugging “wrong answer” may need `@` the upstream (`resolvectl status`) or a public resolver.
- `ANY` is deprecated/restricted on many public resolvers; query specific types instead.
- TTL in answers is **remaining** TTL from that resolver’s cache, not necessarily the zone’s configured TTL.
- Split-horizon DNS returns different answers by client network; VPN on/off can change results.
- `dig` success does not mean your application uses the same resolver path — check `resolvectl`, `/etc/nsswitch.conf`, and app-specific DNS settings.
- For quick human checks, `host` is shorter; for operators, `dig` is the right default.

## Related Commands
- `host` — shorter DNS lookups
- `nslookup` — interactive/legacy style lookups
- `resolvectl query` — systemd-resolved view on Ubuntu
- `doggo` / `drill` — alternative dig-like tools if installed
- `whois` — registration data (not live DNS answers)

## Additional Resources
- `man dig`
- `man resolvectl` (Ubuntu resolver integration)

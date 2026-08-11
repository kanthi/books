# host

## Overview

`host` is a simple DNS lookup utility from BIND tools. It is faster to type than `dig` for everyday A/AAAA/MX checks. Use **`dig`** (or **`drill`**) when you need full message sections, DNSSEC detail, or uncommon query flags; use **`resolvectl query`** when you care what *this machine’s* stub resolver returns.

## Syntax

```bash
host [options] name [server]
host [options] IP
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t type` | Record type: `A`, `AAAA`, `MX`, `TXT`, `NS`, `CNAME`, `SOA`, `SRV`, … |
| `-a` | Equivalent to `-v -t ANY` (ANY often blocked) |
| `-v` | Verbose |
| `-W secs` | Wait timeout |
| `-R n` | Number of retries |
| `-C` | Query SOA records for zone name server check style |
| `-4` / `-6` | Force IPv4/IPv6 transport to the nameserver |
| `-r` | Non-recursive query |

## Key Use Cases

1. Quick “does this name resolve?”
2. MX / TXT / NS checks without dig verbosity
3. Reverse lookup of an IP
4. Point queries at a specific nameserver

## Examples with Explanations

### Forward lookup

```bash
host example.com
host -t A example.com
host -t AAAA example.com
```

Default output lists addresses and sometimes other associated data depending on version and response.

### Mail and text records

```bash
host -t MX example.com
host -t TXT example.com
host -t NS example.com
host -t SOA example.com
```

### Reverse DNS

```bash
host 1.1.1.1
host 8.8.8.8
```

PTR for the reverse zone; empty/no PTR is common for ephemeral cloud IPs.

### Query a specific server

```bash
host example.com 1.1.1.1
host example.com 8.8.8.8
host example.com 127.0.0.53
```

Compare public DNS vs local systemd-resolved stub.

### Verbose and script-friendly

```bash
host -v example.com
if host -W 2 example.com >/dev/null 2>&1; then echo ok; else echo fail; fi
```

### One-liner recipes

```bash
# Extract first IPv4-looking answer (fragile but handy)
host -t A example.com | awk '/has address/ {print $4; exit}'

# MX hosts only
host -t MX example.com | awk '{print $NF}'

# Spot split-horizon DNS
diff <(host example.com 1.1.1.1) <(host example.com 127.0.0.53) || true
```

## Notes & Pitfalls

- **ANY** (`-a`) is widely restricted on public resolvers—query explicit types.
- Output format is **not as stable as dig + short** for parsing; prefer `dig +short` or `doggo --json` in automation.
- **Search domains** from resolv.conf can make short names resolve differently than FQDNs.
- `host` may not be installed on minimal images (`bind-utils` / `dnsutils` / `bind9-host` packages).

## 2026-relevant notes

- Prefer **`dig +short`**, **`doggo`**, or **`resolvectl query`** for modern workflows; keep `host` for muscle memory and quick checks.
- Encrypted DNS is usually configured under resolved/NetworkManager—not via `host` flags. To test DoH, use `doggo` or a DoH-aware client.
- `drill` (ldns) is a good dig-like alternative on some distros.

## Comparison to alternatives

| Tool | When to use |
|------|-------------|
| `host` | Short interactive answers |
| `dig` | Full protocol control |
| `doggo` | UX + DoH/DoT |
| `nslookup` | Legacy interactive only |
| `getent hosts` | NSS (files + DNS + others) |

## Related Commands

- `dig` — detailed DNS
- `nslookup` — legacy
- `resolvectl` — systemd-resolved
- `doggo` — modern CLI
- `getent hosts` — NSS

## Additional Resources

- `man host`
- BIND documentation for the host utility

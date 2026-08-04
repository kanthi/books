# doggo

## Overview

`doggo` is a modern command-line **DNS client** with colorful, human-friendly output. It is an optional alternative to `dig`/`host`/`nslookup` for interactive queries. Install separately (Go binary / distro package where available). Keep `dig` for portable scripts and ubiquitous server availability.

## Syntax

```bash
doggo [query options] NAME [TYPE]
doggo [NAME] @SERVER
```

Exact flags evolve — always check `doggo --help` for your version.

## Common Options (typical)

| Option | Description |
|--------|-------------|
| `NAME` | Domain name to query |
| `TYPE` | Record type (`A`, `AAAA`, `MX`, `TXT`, `NS`, …) |
| `@server` | Nameserver to query |
| `-n` / `--nameserver` | Nameserver |
| `--strategy` | e.g. random/round-robin among servers |
| `--time` | Show query time |
| `--json` | JSON output (if supported) |
| `--short` | Short answers |
| `-4` / `-6` | Transport family |
| `--tls` / `--https` / `--quic` | DoT/DoH/DoQ style transports when supported |

## Examples with Explanations

### Basic queries

```bash
doggo example.com
doggo example.com A
doggo example.com AAAA
doggo example.com MX
doggo example.com TXT
```

### Choose resolver

```bash
doggo example.com @1.1.1.1
doggo example.com @8.8.8.8
doggo example.com @127.0.0.53          # systemd-resolved stub
```

### Reverse / other types

```bash
doggo 1.1.1.1 PTR
doggo example.com NS
doggo example.com SOA
doggo _http._tcp.example.com SRV
```

### Compare with dig

```bash
dig +short example.com A
doggo example.com A
resolvectl query example.com
```

### Scripting

```bash
# prefer dig for stable scripting
dig +short example.com A
# doggo if JSON mode available for humans/tools
doggo example.com --json 2>/dev/null | jq .
```

### Encrypted DNS (when built-in)

```bash
doggo example.com --tls @1.1.1.1
doggo example.com --https @https://cloudflare-dns.com/dns-query
```

Feature support depends on build.

## Notes / Pitfalls

- Not preinstalled on servers — document `dig` equivalents in runbooks.
- Pretty colors can break pipes — use short/JSON/plain modes.
- System stub resolvers (`127.0.0.53`) may differ from public resolvers — test both when debugging.
- DNSSEC/validation visibility differs by tool; confirm with `dig +dnssec` when needed.
- DoH/DoT may be blocked on corporate networks.

## 2026-relevant notes

- Encrypted DNS and modern transports are the interesting differentiator vs classic `dig`.
- For fleet automation, stick to `dig`/`resolvectl`/`getent hosts`.
- Pair with `mtr`/`curl -v` when debugging full user-visible path issues.

## Related Commands

- `dig` — standard Swiss-army DNS tool
- `host` / `nslookup` — simpler classic clients
- `resolvectl` — systemd-resolved
- `getent hosts` — NSS lookup path
- `drill` — another dig-like client (ldns)

## Additional Resources

- `doggo --help`
- project docs (mr-karan/doggo)

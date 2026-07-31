# doggo

## Overview
`doggo` is a modern, human-readable DNS lookup client for CLI users. It supports DNS-over-HTTPS (DoH), DNS-over-TLS (DoT), IPv4/IPv6 querying, and JSON output formatting.

## Syntax
```bash
doggo [query] [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `@server` | Specify DNS resolver (e.g. `@1.1.1.1` or `https://dns.google/dns-query`) |
| `--type TYPE`, `-t` | Specify record type (`A`, `AAAA`, `MX`, `TXT`, `NS`, `CNAME`) |
| `--json` | Format DNS lookup results as JSON output |
| `--short` | Output answer payload values only |

## Key Use Cases
1. Inspecting DNS records with clean, formatted terminal tables.
2. Querying encrypted DNS resolvers via DNS-over-HTTPS / DNS-over-TLS.
3. Parsing DNS output programmatically via `--json`.

## Examples with Explanations
### Example 1: Basic MX & A Record Query
```bash
doggo example.com MX
```
Queries MX records for `example.com` with a colorized response table.

### Example 2: Querying via DNS-over-HTTPS
```bash
doggo example.com @https://cloudflare-dns.com/dns-query
```
Performs a secure DoH query against Cloudflare DNS.

## Related Commands
- `dig` - Traditional DNS lookup utility
- `nslookup` - Legacy DNS query tool
- `host` - Simple DNS lookup utility

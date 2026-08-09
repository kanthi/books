# resolvectl

## Overview

`resolvectl` manages and queries **systemd-resolved**: DNS servers, search/route domains, LLMNR/mDNS, DNSSEC/DoT status, and the DNS cache. It replaces the older `systemd-resolve` command name on current systems. Use it to answer “what DNS is *this host* actually using?”—which can differ from public `dig @8.8.8.8` results.

## Syntax

```bash
resolvectl [options] command [argument...]
```

## Common Commands

| Command | Description |
|---------|-------------|
| `status` | Global + per-link resolver status |
| `query NAME` | Resolve name via resolved |
| `query -t TYPE NAME` | Specific record type |
| `flush-caches` | Drop DNS cache |
| `reset-server-features` | Reset learned server features |
| `dns [LINK [SERVER…]]` | Show/set DNS servers for a link |
| `domain [LINK [DOMAIN…]]` | Search/routing domains |
| `default-route [LINK BOOL]` | Whether link is default DNS route |
| `statistics` | Cache statistics |
| `log-level [LEVEL]` | Debug resolved |
| `monitor` | Stream resolution events (if available) |

## Key Use Cases

1. Debug DNS on NetworkManager / netplan / systemd-networkd hosts
2. See split-DNS (VPN vs LAN) per interface
3. Flush stale cache after record changes
4. Confirm stub listener `127.0.0.53`

## Examples with Explanations

### Status and query

```bash
resolvectl status
resolvectl query example.com
resolvectl query -t MX example.com
resolvectl query -t AAAA example.com
```

### Cache

```bash
sudo resolvectl flush-caches
resolvectl statistics
```

### Per-link DNS

```bash
resolvectl dns
resolvectl dns eth0
resolvectl domain
ip -br link    # correlate interface names
```

### One-liner recipes

```bash
# Compare stub vs public
resolvectl query example.com
dig +short example.com @1.1.1.1

# After VPN connect
resolvectl status | sed -n '1,80p'
resolvectl flush-caches

# Show current DNS from resolv.conf angle
cat /etc/resolv.conf
# often points to 127.0.0.53 when resolved is active
```

## Notes & Pitfalls

- If **resolved is disabled**, `resolvectl` fails—use `dig` against real nameservers in `/etc/resolv.conf`.
- Setting DNS with `resolvectl dns LINK …` may be **transient**; persistent config belongs in netplan, NetworkManager, or `.network` files.
- Ubuntu netplan frequently uses resolved’s stub; editing `/etc/resolv.conf` by hand is the wrong long-term fix when it’s a symlink.
- LLMNR/mDNS noise on home LANs can surprise; status shows whether enabled.

## 2026-relevant notes

- **DNS-over-TLS** may be configured via resolved (`DNSOverTLS=`)—check status for “DNS-over-TLS: yes/no”.
- Prefer `resolvectl` + `nmcli` over legacy `nm-tool`.
- Containers may not run resolved; DNS is often injected by the runtime (`/etc/resolv.conf` with cluster DNS).

## Related Commands

- `dig` / `host` / `doggo` — query arbitrary servers
- `nmcli` — NetworkManager DNS
- `networkctl` — systemd-networkd
- `systemd-resolve` — old name (compat)

## Additional Resources

- `man resolvectl`, `man systemd-resolved.service`
- freedesktop systemd resolved docs

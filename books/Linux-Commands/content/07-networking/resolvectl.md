# resolvectl

## Overview
`resolvectl` manages and queries `systemd-resolved`: DNS servers, domains, LLMNR/mDNS, and per-link DNS. Replaces older `systemd-resolve` naming on modern systems.

## Syntax
```bash
resolvectl [options] command [argument...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `status` | Global and per-link resolver status |
| `query NAME` | Resolve a name |
| `flush-caches` | Drop DNS cache |
| `dns [LINK [SERVER...]]` | Show/set DNS servers for a link |
| `domain [LINK [DOMAIN...]]` | Search/route domains |
| `statistics` | Cache stats |

## Key Use Cases
1. Debug DNS on systemd systems
2. See which servers a link uses
3. Flush bad cache entries
4. Query records without dig

## Examples with Explanations
### Resolver status
```bash
resolvectl status
```
Shows default route DNS and link-specific config.

### Query
```bash
resolvectl query example.com
resolvectl query -t MX example.com
```
Quick lookups via resolved.

### Flush cache
```bash
sudo resolvectl flush-caches
```
After DNS changes or poisoning suspicion.

### Per-interface DNS
```bash
resolvectl dns
resolvectl dns eth0
```
Confirm VPN vs LAN DNS split.

## Notes & Pitfalls
- If resolved is disabled, use `dig` against `/etc/resolv.conf` nameservers directly.
- On some Ubuntu netplan setups, resolved is the default stub listener on `127.0.0.53`.

## Related Commands
- `dig` / `host` — classic DNS tools
- `nmcli` — NetworkManager DNS
- `systemd-resolved` docs — daemon behind the CLI

# traceroute / traceroute6

## Overview
`traceroute` maps the IP path toward a destination by sending packets with increasing TTL and reading ICMP time-exceeded replies. Useful for locating where latency or loss begins.

## Syntax
```bash
traceroute [options] host
traceroute6 [options] host
# Ubuntu often ships `traceroute` or `tracepath` / `mtr`
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | No DNS reverse lookups |
| `-w wait` | Per-probe timeout |
| `-q n` | Probes per hop |
| `-m max` | Max hops |
| `-I` | ICMP probes (vs UDP default on some builds) |
| `-T` | TCP probes (firewall-friendly sometimes) |
| `-p port` | Base port |

## Examples with Explanations
```bash
traceroute example.com
traceroute -n 1.1.1.1
traceroute -T -p 443 example.com
traceroute6 -n ipv6.google.com
```

### Friendlier alternatives
```bash
tracepath example.com      # often no root
mtr -rwzc 50 example.com   # live + report (install mtr)
```

## Notes
- Firewalls may drop probes → `* * *` hops.  
- Not all hops respond; interpret carefully.  
- Cloud networks may hide internal topology.

## Related Commands
- `ping` — reachability/latency to end host  
- `mtr` — continuous traceroute  
- `ip route get` — local routing decision  
- `dig` — ensure name resolves first

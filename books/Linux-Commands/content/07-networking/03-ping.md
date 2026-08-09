# ping

## Overview
`ping` sends ICMP Echo Request packets and reports whether a host answers with Echo Reply, plus round-trip time (RTT). It is the first tool for “is this address reachable?” and a quick signal for loss and latency. On Ubuntu, `ping` comes from `iputils-ping` and needs appropriate capabilities (usually installed setuid or with `cap_net_raw`) to open raw ICMP sockets.

## Syntax
```bash
ping [OPTIONS] DESTINATION
ping -c COUNT [OPTIONS] DESTINATION
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c count` | Stop after `count` replies (script-friendly) |
| `-i interval` | Seconds between packets (default 1) |
| `-W timeout` | Seconds to wait for a reply |
| `-w deadline` | Exit after this many seconds regardless |
| `-s size` | Payload size in bytes |
| `-M do` | Path MTU discovery: prohibit fragmentation |
| `-4` / `-6` | Force IPv4 / IPv6 |
| `-n` | Numeric output (skip reverse DNS) |
| `-q` | Quiet (summary only) |
| `-v` | Verbose |
| `-I device` | Bind to interface or source address |
| `-t ttl` | Set IP TTL |

## Safety
- Flooding (`-f`, if permitted) or very low intervals can look like abuse and may be rate-limited by networks. Prefer `-c` and sensible `-i` on production paths.
- “Ping works” ≠ “application works.” ICMP may be filtered while TCP 443 is fine, and the reverse can also happen.
- Do not rely on ping alone for SLOs; use service health checks.

## Examples with Explanations
### Basic connectivity (4 probes)
```bash
ping -c 4 1.1.1.1
ping -c 4 example.com
```

### Numeric only (faster, no rDNS noise)
```bash
ping -n -c 4 8.8.8.8
```

### IPv6
```bash
ping -6 -c 4 2606:4700:4700::1111
# or:
ping6 -c 4 example.com
```

### Quiet summary for scripts
```bash
if ping -c 3 -W 2 -q gateway.local >/dev/null; then
  echo reachable
else
  echo unreachable
fi
```

### Deadline: fail fast in automation
```bash
ping -c 5 -w 6 -q 203.0.113.1
echo exit:$?
```
`-w` caps total runtime so a black hole does not hang a script.

### Larger payload (rough MTU / fragmentation check)
```bash
ping -c 3 -s 1472 -M do 1.1.1.1
```
`1472` payload + 28 bytes IP/ICMP headers ≈ 1500-byte Ethernet frame. If this fails with “message too long” but small pings work, look at MTU/PMTUD issues (VPNs, tunnels).

### Source from a specific interface
```bash
ping -c 4 -I eth0 10.0.0.1
ping -c 4 -I 192.0.2.10 10.0.0.1
```
Useful on multi-homed hosts and VPN boxes.

### Faster sampling (still polite)
```bash
ping -c 20 -i 0.2 10.0.0.1
```
Requires privileges for intervals &lt; 0.2s on many systems; stay reasonable on shared networks.

### Compare loss to a hop vs destination
```bash
ping -c 50 -q 10.0.0.1   # gateway
ping -c 50 -q 1.1.1.1    # internet
```
High loss only to the far end suggests a path problem beyond the LAN.

## Understanding Output
Typical line:
```text
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=12.3 ms
```
- **icmp_seq** — sequence number; gaps imply loss (or reordering).
- **ttl** — remaining hop budget; lower often means more hops (not a strict hop count).
- **time** — RTT.

Summary:
```text
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 11.2/12.5/14.1/1.1 ms
```
- **mdev** — mean deviation (jitter-ish signal).
- Exit status: `0` if enough replies received (see man page for exact rules with `-c`/`-w`), non-zero on total failure.

## Notes & Pitfalls
- Many cloud security groups and enterprise firewalls **drop ICMP**. Unreachable ping does not prove the host is down — try `curl -I`, `nc -vz host 443`, or `mtr`.
- Name resolution failures look like ping failures; test with a raw IP too.
- Container and network-namespace environments may lack permission to ping; error messages about “Operation not permitted” point at capabilities, not routing.
- Do not confuse `ping` host reachability with DNS: always note whether you used a name or an IP.
- For continuous path quality, `mtr` or `smokeping`-style tools beat a single short ping.

## Related Commands
- `mtr` / `mtr --report` — live traceroute + loss per hop
- `traceroute` / `tracepath` — path discovery
- `ss` / `ip route` — local sockets and routes
- `curl -I` / `nc -vz` — application-layer reachability
- `resolvectl query` / `dig` — name resolution checks

## Additional Resources
- `man ping`
- `man ip-route` (when replies fail but the host seems local)

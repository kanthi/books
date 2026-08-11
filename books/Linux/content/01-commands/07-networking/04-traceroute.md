# traceroute

## Overview
`traceroute` maps the path packets take toward a destination by sending probes with increasing TTL and reading ICMP “Time Exceeded” messages from intermediate hops. Use it to find where latency jumps or where the path dies. On Ubuntu, install with `sudo apt install traceroute`. Related tools: `tracepath` (often installed by default), and `mtr` (continuous combined ping+trace).

## Syntax
```bash
traceroute [options] host
traceroute -n -m 20 host
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Numeric IPs only (no reverse DNS — faster, cleaner) |
| `-m max_ttl` | Max hops (default often 30) |
| `-q nqueries` | Probes per hop (default 3) |
| `-w wait` | Wait seconds per probe |
| `-I` | ICMP echo probes (may work when UDP is filtered) |
| `-T` | TCP SYN probes (often best through firewalls) |
| `-U` | UDP probes (classic default on many Linux builds) |
| `-p port` | Base port (UDP) or destination port (TCP with `-T`) |
| `-f first_ttl` | Start at this TTL |
| `-4` / `-6` | IPv4 / IPv6 |
| `-i iface` | Outgoing interface |
| `-s src` | Source address |

## Safety
- Traceroute is generally benign but generates many probes; do not hammer production paths in tight loops.
- Some providers rate-limit or deprioritize traceroute-related ICMP; interpret stars (`* * *`) carefully.
- TCP traceroute to sensitive ports may look like a scan — prefer known service ports you own (e.g. 443) and authorized targets.

## Examples with Explanations
### Basic path
```bash
traceroute example.com
traceroute -n 1.1.1.1
```

### ICMP mode (when UDP probes are blocked)
```bash
sudo traceroute -I -n example.com
```
May require root for raw ICMP.

### TCP traceroute to HTTPS (firewall-friendly)
```bash
sudo traceroute -T -p 443 -n example.com
```
Probes look more like real client traffic to port 443; excellent for “UDP traceroute dies but the site loads” cases.

### Limit hop count and speed up failure
```bash
traceroute -n -m 15 -w 2 -q 1 203.0.113.50
```
`-q 1` one probe per hop; `-w 2` shorter wait — noisier stats but faster.

### IPv6 path
```bash
traceroute -6 -n example.com
```

### Compare UDP vs TCP vs ICMP
```bash
traceroute -n example.com
sudo traceroute -I -n example.com
sudo traceroute -T -p 443 -n example.com
```
Different probe types can take different paths or be filtered differently — note which method matches user traffic.

### Start mid-path (skip nearby hops)
```bash
traceroute -n -f 5 example.com
```

### Use a specific source address (multi-homed)
```bash
sudo traceroute -n -s 192.0.2.10 example.com
```

## Understanding Output
Classic lines:
```text
 1  192.168.1.1  1.2 ms  1.1 ms  1.3 ms
 2  10.0.0.1     5.0 ms  4.8 ms  5.1 ms
 3  * * *
 4  203.0.113.1  20.2 ms  19.8 ms  20.5 ms
```
- Column 1 — hop number (TTL).
- Address — router that returned ICMP time exceeded (or final destination).
- Three times — RTTs for each probe (`-q`).
- `* * *` — no reply within timeout (filtering, loss, or rate-limit) — **not always a failure of the path**.

Notes on interpretation:
- Latency often rises gradually; a sudden jump may mark a long-haul or congested link.
- Asymmetric routing means the return path may differ; RTT includes both directions.
- The last hop should be the destination answering the probe type; some hosts never respond to traceroute probes yet still serve TCP apps.

## Notes & Pitfalls
- **Stars in the middle do not prove breakage** if later hops respond. Many routers simply do not generate TTL-exceeded for your probe type.
- Stars at the **end** with a working website often mean the destination ignores traceroute probes; test with `curl`/`nc -vz` too.
- Corporate firewalls may allow TCP/443 but drop UDP traceroute — use `-T -p 443`.
- Reverse DNS (`-n` off) slows output and can mislead if PTR records are wrong; prefer `-n` for ops work.
- `tracepath` is a lighter alternative that does not always need root and focuses on PMTU; `mtr --report` is better for ongoing loss per hop.
- ECMP / anycast can make successive runs show different hop addresses — capture multiple runs before concluding.

## Related Commands
- `mtr` / `mtr --report` — continuous per-hop loss and latency
- `tracepath` — simple path / PMTU discovery
- `ping` — end-to-end reachability and RTT
- `ip route get ADDR` — which local route/next-hop would be used
- `dig` + `curl` — confirm name and application path independently

## Additional Resources
- `man traceroute`
- `man mtr`
- `man tracepath`

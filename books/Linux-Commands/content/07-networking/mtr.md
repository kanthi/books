# mtr

## Overview
`mtr` (My Traceroute) combines the functionality of `traceroute` and `ping` into a single network diagnostic tool. It probes routers along the network path continuously and updates real-time statistics on packet loss and latency.

## Syntax
```bash
mtr [options] HOSTNAME
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c`, `--report-cycles COUNT` | Set the number of pings sent to generate a report |
| `-r`, `--report` | Output report mode (non-interactive) |
| `-n`, `--no-dns` | Display IP addresses without resolving reverse DNS |
| `-w`, `--report-wide` | Format report for wide output without truncating hostnames |
| `-T`, `--tcp` | Use TCP SYN packets instead of ICMP echo requests |
| `-P`, `--port PORT` | Specify target port number when using TCP or UDP probes |

## Key Use Cases
1. Diagnosing inter-hop latency spikes and packet drop locations.
2. Generating network health reports for remote endpoints.
3. Testing firewall connectivity to specific ports along a route (`-T -P`).

## Examples with Explanations
### Example 1: Non-interactive Report Mode
```bash
mtr --report -c 10 example.com
```
Sends 10 ping probes to `example.com` across all network hops and outputs a consolidated summary report.

### Example 2: Testing TCP Port Reachability
```bash
mtr -T -P 443 --no-dns example.com
```
Traces the route to `example.com` on TCP port 443 (HTTPS) using raw IP addresses.

## Related Commands
- `ping` - Test reachability of a single network host
- `traceroute` - Trace path to network host
- `ss` - Socket statistics utility

# mtr

## Overview

`mtr` (My Traceroute) combines continuous **ping** and **traceroute**: it probes each hop on the path and updates loss and latency statistics in real time. Use it when intermittent packet loss or a “bad hop” is suspected—not just for a one-shot path dump.

```bash
# Debian/Ubuntu / RHEL-family (package name is usually mtr or mtr-tiny)
sudo apt install mtr-tiny   # or: mtr
sudo dnf install mtr
```

## Syntax

```bash
mtr [options] HOSTNAME|IP
```

## Common Options

| Option | Description |
|--------|-------------|
| `-r`, `--report` | Non-interactive report then exit |
| `-c N`, `--report-cycles N` | Probes per hop in report mode |
| `-n`, `--no-dns` | Skip reverse DNS (faster, clearer) |
| `-w`, `--report-wide` | Wide hostnames in reports |
| `-4` / `-6` | Force IPv4 or IPv6 |
| `-T`, `--tcp` | TCP SYN probes instead of ICMP |
| `-u`, `--udp` | UDP probes |
| `-P PORT`, `--port PORT` | Target port for TCP/UDP |
| `-i SECS` | Interval between probes |
| `-m MAX` | Max hops (TTL) |
| `-b` | Show both hostname and IP |
| `-z` | Show AS numbers (if available) |
| `-s SIZE` | Packet size |
| `-e` | Show MPLS labels when present |

## Key Use Cases

1. Locate which hop introduces latency or loss
2. Generate shareable path reports for NOC tickets
3. Test path to a specific TCP port (HTTPS 443, etc.)
4. Compare IPv4 vs IPv6 paths

## Examples with Explanations

### Interactive session

```bash
mtr example.com
mtr -n example.com
```

Interactive UI refreshes hop stats until you quit (`q`). `-n` avoids slow or broken PTR lookups.

### Non-interactive report (scripts & tickets)

```bash
mtr --report -c 20 -n example.com
mtr -rwc 50 example.com
```

`--report` runs N cycles and prints a table—ideal for pasting into chat or logs.

### TCP path to HTTPS

```bash
mtr -T -P 443 -n example.com
mtr -T -P 22 -n bastion.example.com
```

ICMP is often rate-limited or deprioritized; TCP probes better match real application traffic when firewalls allow them.

### IPv6 and dual-stack

```bash
mtr -6 -n example.com
mtr -4 -n example.com
```

Different address families can take completely different transit.

### One-liner recipes

```bash
# Quick 10-cycle report to clipboard-friendly text
mtr -rwc 10 -n 1.1.1.1

# Compare two destinations
for h in 1.1.1.1 8.8.8.8; do echo "=== $h ==="; mtr -rwc 15 -n "$h"; done

# Watch path while changing VPN/Wi-Fi (interactive)
mtr -n vpn-endpoint.example.com
```

### Interpreting loss (important)

- **Loss only on intermediate hops** but 0% at the destination often means the hop rate-limits ICMP replies—not necessarily real path loss.
- **Loss that grows and stays high through later hops including destination** usually indicates a real problem on or before that hop.
- Spike latency on one hop that recovers downstream can be ICMP deprioritization.

## Understanding Output

Typical columns:

| Field | Meaning |
|-------|---------|
| Host | Hop address / name |
| Loss% | Probe loss to that hop |
| Snt | Probes sent |
| Last / Avg / Best / Wrst | RTT samples (ms) |
| StDev | Jitter-ish spread |

## Notes & Pitfalls

- **Root/capabilities**: some probe types need elevated privileges; distro packages may install a setcap binary.
- **Firewalls**: corporate networks may drop traceroute-style probes; try `-T -P 443`.
- **Containers / cloud**: path may terminate at hypervisor or LB; don’t expect full Internet-style hops inside VPC only.
- Prefer **`mtr` over pure `traceroute` + `ping`** for intermittent issues.

## 2026-relevant notes

- Cloud anycast and CGNAT make hop lists noisier; combine with `curl -w '%{time_connect}\n'`, `ss`, and provider path tools.
- For continuous SLOs, export `mtr --report` from a cron/systemd timer rather than relying on ad-hoc interactive sessions.
- `mtr-tiny` on Debian omits some extras but is fine for servers.

## Comparison to alternatives

| Tool | Role |
|------|------|
| `mtr` | Continuous hop stats |
| `traceroute` / `tracepath` | One-shot path |
| `ping` | Single-host RTT/loss |
| `npiping` / `smokeping` | Long-term historical |

## Related Commands

- `ping` — single-host reachability
- `traceroute` / `tracepath` — path discovery
- `ss` — local sockets
- `dig` / `host` — name resolution before tracing

## Additional Resources

- `man mtr`
- Path diagnosis guides from major cloud and CDN providers

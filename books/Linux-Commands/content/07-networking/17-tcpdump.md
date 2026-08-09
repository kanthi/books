# tcpdump

## Overview
`tcpdump` captures and displays packets on a network interface. It is the classic CLI packet sniffer for verifying traffic, debugging firewalls, and confirming “did this SYN leave the box?” On Ubuntu, install with `sudo apt install tcpdump`. Captures usually need root or `cap_net_raw` / `cap_net_admin`.

## Syntax
```bash
sudo tcpdump [OPTIONS] [expression]
sudo tcpdump -i IFACE -nn -s0 -w file.pcap 'filter'
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i iface` | Interface (`any` for all, where supported) |
| `-n` | Don't resolve hostnames |
| `-nn` | Don't resolve hostnames or ports |
| `-v` / `-vv` | More packet detail |
| `-c N` | Exit after N packets |
| `-s snaplen` | Capture snap length (`0` or `65535` = full packet) |
| `-w file` | Write raw packets to pcap file |
| `-r file` | Read packets from pcap file |
| `-A` | ASCII payload |
| `-X` / `-XX` | Hex + ASCII |
| `-q` | Quieter output |
| `-e` | Link-level header (MAC) |
| `-ttt` | Delta time between packets |
| `-Z user` | Drop privileges to user after opening capture |
| `--immediate-mode` | Lower latency display (when supported) |

## Safety
- Packet captures can include **credentials, cookies, and PII**. Restrict pcap file permissions (`chmod 600`) and delete when done.
- Capturing on production can add load; prefer tight BPF filters and `-c` limits.
- Legal/policy: only capture networks you are authorized to monitor.
- Do not publish pcaps from customer environments.

## Filter expressions (BPF) essentials
Filters use libpcap syntax (same family as Wireshark capture filters):

| Expression | Matches |
|------------|---------|
| `host 1.2.3.4` | Traffic to/from host |
| `net 10.0.0.0/8` | Network |
| `port 443` | TCP or UDP port |
| `tcp port 22` | SSH |
| `src` / `dst` | Direction qualifier |
| `icmp` | ICMP |
| `tcp[tcpflags] & tcp-syn != 0` | SYN packets |
| `and` / `or` / `not` | Boolean |

## Examples with Explanations
### See anything on default route interface
```bash
ip route show default
sudo tcpdump -i eth0 -nn -c 20
```

### HTTPS-related traffic for one host
```bash
sudo tcpdump -i any -nn 'host 203.0.113.10 and port 443'
```

### DNS queries and responses
```bash
sudo tcpdump -i any -nn port 53
```

### Only SYN packets (connection attempts)
```bash
sudo tcpdump -i any -nn 'tcp[tcpflags] & (tcp-syn) != 0 and tcp[tcpflags] & (tcp-ack) == 0'
```

### Capture full packets to file for Wireshark
```bash
sudo tcpdump -i eth0 -nn -s0 -w /tmp/trace.pcap 'port 5432'
# later, as yourself:
sudo chown "$USER":"$USER" /tmp/trace.pcap
chmod 600 /tmp/trace.pcap
wireshark /tmp/trace.pcap   # or tcpdump -r
```

### Read a pcap back in the terminal
```bash
tcpdump -nn -r /tmp/trace.pcap | less
tcpdump -nn -A -r /tmp/trace.pcap 'port 80'
```

### HTTP cleartext headers (lab only)
```bash
sudo tcpdump -i any -nn -A 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```
Prefer `-w` + Wireshark for serious HTTP analysis. TLS on 443 will not show HTTP headers in cleartext.

### ICMP (ping) traffic
```bash
sudo tcpdump -i any -nn icmp
```

### Traffic involving a local port (e.g. reverse proxy)
```bash
sudo tcpdump -i any -nn 'port 8080'
```

### Limit and timestamp deltas
```bash
sudo tcpdump -i eth0 -nn -c 50 -ttt host 10.0.0.5
```

### Exclude SSH so your session does not flood the capture
```bash
sudo tcpdump -i eth0 -nn "not port 22"
```
When capturing over SSH, your interactive session traffic will otherwise dominate the output.

## Understanding Output
Example TCP line:
```text
12:01:02.123456 IP 10.0.0.5.54321 > 10.0.0.10.443: Flags [S], seq 123, win 64240, options [...], length 0
```
- Addresses are `ip.port` with `-nn`.
- **Flags**: `S` SYN, `F` FIN, `P` PSH, `R` RST, `.` ACK only.
- **length** — payload length (0 for pure handshake packets).

If you see SYNs with no SYN-ACK, the peer or a middlebox is dropping or blackholing the connection. If SYN-ACK returns but app fails, debug above TCP (TLS, HTTP, app).

## Notes & Pitfalls
- Without `-s0`/`-s 65535`, snaplen may truncate payloads (headers usually still visible).
- Interface `any` is convenient but may not show link-layer MACs the same way as a real NIC; use a specific iface for L2 issues.
- Offloading/TSO can make on-wire sizes look odd in captures; remember NIC offload when diagnosing MSS/MTU.
- Filters are **capture** filters (BPF), not Wireshark display filters. Syntax differs from Wireshark GUI search.
- Containers: capture in the correct network namespace (`ip netns exec`, or from the host veth) or you will see nothing useful.
- Prefer writing to pcap (`-w`) for anything beyond a quick glance; live `-A` scrolls too fast and loses context.

## Related Commands
- `wireshark` / `tshark` — GUI / CLI deeper analysis
- `ss -tnp` — which processes own sockets
- `iptables` / `nft` / `ufw` — firewall rules that drop traffic
- `nmap` — active port discovery (different from capture)
- `curl -v` / `openssl s_client` — application-level TLS/HTTP debug

## Additional Resources
- `man tcpdump`
- `man pcap-filter` — full BPF expression reference

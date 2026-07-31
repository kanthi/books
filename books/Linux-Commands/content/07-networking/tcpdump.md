# tcpdump

## Overview
`tcpdump` captures and displays packets on a network interface. Essential for low-level connectivity debugging when `ping`/`curl` are not enough.

## Syntax
```bash
tcpdump [options] [expression]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i iface` | Interface (`any` for all) |
| `-n` | No name resolution |
| `-nn` | No host or port names |
| `-v`/`-vv` | Verbosity |
| `-c N` | Exit after N packets |
| `-w file` | Write pcap |
| `-r file` | Read pcap |
| `-A`/`-X` | ASCII / hex+ASCII payload |
| `-s 0` | Snap length full packet |

## Safety
Captures can include secrets (HTTP cookies, credentials). Restrict with filters; store pcaps securely; use only on networks you are authorized to monitor.

## Examples with Explanations
### Basic on interface
```bash
sudo tcpdump -i eth0 -nn
```

### Port filters
```bash
sudo tcpdump -i eth0 -nn port 22
sudo tcpdump -nn host 1.1.1.1 and tcp port 443
```

### Write pcap for Wireshark
```bash
sudo tcpdump -i eth0 -nn -w /tmp/cap.pcap port 53
# copy off and open in Wireshark
```

### HTTP-ish ASCII (unencrypted)
```bash
sudo tcpdump -i eth0 -A -s 0 'tcp port 80 and (((ip[2:2]-((ip[0]&0xf)<<2))-((tcp[12]&0xf0)>>2)) != 0)'
```

### Count then stop
```bash
sudo tcpdump -i any -nn -c 20 icmp
```

## Related Commands
- `ss` — socket owners  
- `wireshark` / `tshark` — GUI/CLI analysis  
- `nmap` — active scanning  
- `iptables`/`nft`/`ufw` — firewall

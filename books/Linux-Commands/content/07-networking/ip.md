# ip

## Overview
`ip` (from **iproute2**) configures and displays interfaces, addresses, routes, neighbors, rules, and tunnels. It replaces legacy `ifconfig`/`route`/`arp` for modern Linux networking.

## Syntax
```bash
ip [OPTIONS] OBJECT COMMAND
ip -h                    # help
ip OBJECT help           # object-specific help
```

Common objects: `link`, `address` (`addr`), `route`, `neigh`, `rule`, `netns`, `xfrm`.

## Common Options
| Option | Description |
|--------|-------------|
| `-4` / `-6` | IPv4 / IPv6 only |
| `-s` | Statistics (can repeat for more detail) |
| `-d` | Extra detail |
| `-br` | Brief columnar output |
| `-c` | Color |
| `-o` | One-line output |
| `-j` / `-p` | JSON / pretty JSON (newer iproute2) |

## Key Use Cases
1. Inspect and set addresses  
2. Bring links up/down, set MTU/MAC  
3. Manage default and static routes  
4. Debug neighbor (ARP/ND) tables  
5. Work with network namespaces  

## Safety
Address and route changes can drop your SSH session. Prefer a **console/IPMI** session or a scripted rollback when changing the only default route. On Ubuntu servers, prefer **netplan** or **NetworkManager** for persistent config; use `ip` for live debug.

## Examples with Explanations
### Brief overview
```bash
ip -br link
ip -br addr
ip route
```
Fast “what interfaces, what IPs, what default route?”.

### Full address list
```bash
ip addr show
ip -4 addr show dev eth0
```

### Bring link up/down
```bash
sudo ip link set dev eth0 up
sudo ip link set dev eth0 down
```

### Add/remove an address
```bash
sudo ip addr add 192.168.1.50/24 dev eth0
sudo ip addr del 192.168.1.50/24 dev eth0
```
Prefix length is required. Secondary addresses are normal on multi-homed hosts.

### Default route
```bash
sudo ip route add default via 192.168.1.1 dev eth0
sudo ip route replace default via 192.168.1.1 dev eth0
ip route get 1.1.1.1
```
`route get` shows which path the kernel would use.

### Static route
```bash
sudo ip route add 10.0.0.0/8 via 192.168.1.254
sudo ip route del 10.0.0.0/8
```

### Neighbor table (ARP)
```bash
ip neigh show
sudo ip neigh flush dev eth0
```

### Statistics
```bash
ip -s link show eth0
ip -s -s link show eth0   # more error detail
```

### Network namespace (quick)
```bash
sudo ip netns add lab
sudo ip netns exec lab ip link
sudo ip netns delete lab
```

## Understanding Output
- `UP`/`LOWER_UP` on links: admin up vs carrier present  
- `inet` / `inet6` lines: addresses and scopes (`global`, `link`)  
- `proto kernel` vs `proto static` / `dhcp` on routes: origin of the route  

## Common Usage Patterns
### Live IP on a server you did not configure
```bash
ip -br a; ip r; resolvectl status 2>/dev/null || cat /etc/resolv.conf
```

### Flush all IPv4 addresses on a NIC (careful)
```bash
sudo ip -4 addr flush dev eth0
```

## Notes & Pitfalls
- Changes with `ip` are **not durable** across reboot unless persisted by netplan/NM/scripts.  
- Interface names may be predictable (`enp3s0`) not `eth0`.  
- Policy routing uses `ip rule` + multiple tables — advanced; see `man ip-rule`.  

## Related Commands
- `nmcli` — NetworkManager CLI  
- `resolvectl` — DNS via systemd-resolved  
- `ss` — sockets  
- `ping` / `traceroute` — path checks  
- `ifconfig` — legacy; prefer `ip`  

## Additional Resources
- `man ip`, `man ip-link`, `man ip-route`  
- iproute2 documentation

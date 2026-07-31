# iptables

## Overview
`iptables` configures IPv4 packet filtering/NAT via **netfilter**. Many modern distros (Ubuntu 22.04+) use **nftables** underneath (`iptables-nft` compatibility). Prefer **`ufw`** or **`nft`** for new designs; still know `iptables` for legacy hosts and debugging.

## Syntax
```bash
iptables [-t table] command chain [rule...]
iptables-save / iptables-restore
```

## Tables & common chains
| Table | Chains | Role |
|-------|--------|------|
| `filter` (default) | INPUT, FORWARD, OUTPUT | Allow/deny |
| `nat` | PREROUTING, POSTROUTING, OUTPUT | DNAT/SNAT/MASQUERADE |
| `mangle` | * | TTL/mark rewrite |
| `raw` | PREROUTING, OUTPUT | Conntrack exceptions |

Targets: `ACCEPT`, `DROP`, `REJECT`, `LOG`, `RETURN`, …

## Common Options
| Option | Description |
|--------|-------------|
| `-A`/`-I`/`-D` | Append / insert / delete |
| `-L -n -v` | List numeric verbose |
| `-F` | Flush chain |
| `-P chain target` | Default policy |
| `-s`/`-d` | Source/dest |
| `-p tcp/udp/icmp` | Protocol |
| `--dport`/`--sport` | Ports (with `-m tcp`) |
| `-i`/`-o` | In/out interface |
| `-m conntrack --ctstate` | State match |
| `-j` | Target |

## Safety
**Remote lockout risk:** open SSH before default DROP. Use console access when changing INPUT policy. Persist rules (`iptables-save`, distro-specific services) or they vanish on reboot.

## Examples with Explanations
### List
```bash
sudo iptables -L -n -v
sudo iptables -t nat -L -n -v
```

### Allow SSH, HTTP; default drop (sketch)
```bash
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
# OUTPUT often left ACCEPT
```

### NAT masquerade (router)
```bash
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

### Save (Debian/Ubuntu example)
```bash
sudo apt install iptables-persistent
sudo netfilter-persistent save
# or: sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

### Prefer UFW on Ubuntu
```bash
sudo ufw allow OpenSSH
sudo ufw allow 80,443/tcp
sudo ufw enable
```

## Notes
- IPv6 uses `ip6tables`.  
- Docker injects its own chains — order interactions carefully.  
- `nft list ruleset` shows backend on nft systems.

## Related Commands
- `ufw` — Ubuntu host firewall  
- `nft` — nftables CLI  
- `ss -lntp` — listeners  
- `tcpdump` — packet proof

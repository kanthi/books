# iptables

## Overview
The `iptables` command is a user-space utility for configuring Linux kernel firewall rules. It controls network packet filtering, NAT, and packet mangling through the netfilter framework.

## Syntax
```bash
iptables [options] -t table -A chain rule-specification
iptables [options] -t table -D chain rule-specification
iptables [options] -t table -L [chain]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-A chain` | Append rule to chain |
| `-D chain` | Delete rule from chain |
| `-I chain` | Insert rule in chain |
| `-L` | List rules |
| `-F` | Flush all rules |
| `-P chain target` | Set default policy |
| `-t table` | Specify table |
| `-j target` | Jump to target |
| `-p protocol` | Protocol (tcp, udp, icmp) |
| `-s source` | Source address |
| `-d destination` | Destination address |
| `--dport port` | Destination port |
| `--sport port` | Source port |
| `-i interface` | Input interface |
| `-o interface` | Output interface |

## Tables
| Table | Purpose |
|-------|---------|
| `filter` | Packet filtering (default) |
| `nat` | Network Address Translation |
| `mangle` | Packet alteration |
| `raw` | Connection tracking exemption |

## Chains
| Chain | Description |
|-------|-------------|
| `INPUT` | Incoming packets |
| `OUTPUT` | Outgoing packets |
| `FORWARD` | Forwarded packets |
| `PREROUTING` | Before routing decision |
| `POSTROUTING` | After routing decision |

## Key Use Cases
1. Firewall configuration
2. Network security
3. Port blocking/allowing
4. NAT configuration
5. Traffic filtering

## Examples with Explanations
### Example 1: List Current Rules
```bash
iptables -L -n -v
```
Shows all rules with packet counts and no DNS resolution

### Example 2: Allow SSH
```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```
Allows incoming SSH connections on port 22

### Example 3: Block IP Address
```bash
iptables -A INPUT -s 192.168.1.100 -j DROP
```
Blocks all traffic from specific IP address

### Example 4: Allow HTTP and HTTPS
```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```
Allows web traffic on ports 80 and 443

## Basic Firewall Setup
1. Set default policies:
   ```bash
   iptables -P INPUT DROP
   iptables -P FORWARD DROP
   iptables -P OUTPUT ACCEPT
   ```
2. Allow loopback:
   ```bash
   iptables -A INPUT -i lo -j ACCEPT
   iptables -A OUTPUT -o lo -j ACCEPT
   ```
3. Allow established connections:
   ```bash
   iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
   ```

## Common Rules
1. Allow ping:
   ```bash
   iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
   ```
2. Allow specific subnet:
   ```bash
   iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
   ```
3. Rate limiting:
   ```bash
   iptables -A INPUT -p tcp --dport 22 -m limit --limit 3/min -j ACCEPT
   ```

## NAT Configuration
1. SNAT (Source NAT):
   ```bash
   iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 203.0.113.1
   ```
2. DNAT (Destination NAT):
   ```bash
   iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.10:8080
   ```
3. Masquerading:
   ```bash
   iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
   ```

## Port Forwarding
1. Forward external port to internal:
   ```bash
   iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.10:80
   iptables -A FORWARD -p tcp -d 192.168.1.10 --dport 80 -j ACCEPT
   ```

## Advanced Filtering
1. Connection tracking:
   ```bash
   iptables -A INPUT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
   ```
2. Time-based rules:
   ```bash
   iptables -A INPUT -p tcp --dport 80 -m time --timestart 09:00 --timestop 17:00 -j ACCEPT
   ```
3. String matching:
   ```bash
   iptables -A INPUT -p tcp --dport 80 -m string --string "malware" -j DROP
   ```

## Performance Analysis
- Kernel-level filtering (fast)
- Rules processed sequentially
- First match wins
- Can impact network performance
- Optimize rule order

## Related Commands
- `ip6tables` - IPv6 firewall
- `ufw` - Uncomplicated Firewall
- `firewalld` - Dynamic firewall
- `nftables` - Modern replacement
- `netstat` - Network connections

## Best Practices
1. Always have a backup plan
2. Test rules before applying
3. Use specific rules over general ones
4. Document your rules
5. Regular rule auditing

## Rule Management
1. Save rules:
   ```bash
   iptables-save > /etc/iptables/rules.v4
   ```
2. Restore rules:
   ```bash
   iptables-restore < /etc/iptables/rules.v4
   ```
3. Delete specific rule:
   ```bash
   iptables -D INPUT 3  # Delete rule number 3
   ```

## Logging
1. Log dropped packets:
   ```bash
   iptables -A INPUT -j LOG --log-prefix "DROPPED: "
   iptables -A INPUT -j DROP
   ```
2. Log specific traffic:
   ```bash
   iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix "SSH: "
   ```

## Scripting Applications
1. Firewall script:
   ```bash
   #!/bin/bash
   # Flush existing rules
   iptables -F
   iptables -X

   # Set default policies
   iptables -P INPUT DROP
   iptables -P FORWARD DROP
   iptables -P OUTPUT ACCEPT

   # Allow loopback
   iptables -A INPUT -i lo -j ACCEPT

   # Allow established connections
   iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

   # Allow SSH
   iptables -A INPUT -p tcp --dport 22 -j ACCEPT

   # Save rules
   iptables-save > /etc/iptables/rules.v4
   ```

## Security Applications
1. DDoS protection:
   ```bash
   iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
   ```
2. Block port scanning:
   ```bash
   iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
   iptables -A INPUT -m recent --name portscan --set -j LOG --log-prefix "Portscan: "
   ```

## Troubleshooting
1. Check rule syntax before applying
2. Use -v for verbose output
3. Test connectivity after changes
4. Keep backup of working rules
5. Use logging for debugging

## Integration Examples
1. With fail2ban:
   ```bash
   # fail2ban creates iptables rules automatically
   fail2ban-client status sshd
   ```
2. With monitoring:
   ```bash
   # Monitor dropped packets
   iptables -L -n -v | grep DROP
   ```

## Common Mistakes
1. Locking yourself out via SSH
2. Wrong rule order
3. Forgetting to save rules
4. Not testing rules
5. Overly permissive rules

## Migration to nftables
Modern systems use nftables:
```bash
# Translate iptables rules
iptables-translate -A INPUT -p tcp --dport 22 -j ACCEPT
```

## Backup and Recovery
1. Backup current rules:
   ```bash
   iptables-save > iptables-backup-$(date +%Y%m%d).rules
   ```
2. Emergency reset:
   ```bash
   iptables -P INPUT ACCEPT
   iptables -P FORWARD ACCEPT
   iptables -P OUTPUT ACCEPT
   iptables -F
   ```

## Performance Optimization
1. Put most common rules first
2. Use specific matches
3. Avoid unnecessary logging
4. Use connection tracking efficiently
5. Consider rule consolidation
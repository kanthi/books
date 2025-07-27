# ip

## Overview
The `ip` command shows and manipulates routing, devices, policy routing, and tunnels. It's a powerful tool for configuring network interfaces and routing.

## Syntax
```bash
ip [options] OBJECT {COMMAND | help}
```

## Common Objects
| Object | Description |
|--------|-------------|
| `link` | Network devices |
| `address` | Protocol addresses |
| `route` | Routing table entries |
| `neigh` | ARP or NDISC cache |
| `tunnel` | Tunnel over IP |
| `maddr` | Multicast addresses |
| `rule` | Routing policy |
| `netns` | Network namespaces |

## Common Options
| Option | Description |
|--------|-------------|
| `-4` | IPv4 only |
| `-6` | IPv6 only |
| `-s` | Statistics |
| `-d` | Details |
| `-h` | Human readable |
| `-br` | Brief output |
| `-c` | Color output |
| `-o` | Output format |

## Key Use Cases
1. Network configuration
2. Interface management
3. Routing setup
4. Address assignment
5. Network troubleshooting

## Examples with Explanations
### Example 1: Show Interfaces
```bash
ip link show
```
Display network interfaces

### Example 2: IP Addresses
```bash
ip addr show
```
Show IP addresses

### Example 3: Routing Table
```bash
ip route show
```
Display routing table

## Common Commands
1. Link operations:
   ```bash
   ip link set dev eth0 up
   ip link set dev eth0 down
   ```

2. Address management:
   ```bash
   ip addr add 192.168.1.10/24 dev eth0
   ip addr del 192.168.1.10/24 dev eth0
   ```

3. Route management:
   ```bash
   ip route add default via 192.168.1.1
   ip route del default
   ```

## Performance Analysis
- Interface statistics
- Routing efficiency
- Address configuration
- Network namespace impact
- Protocol overhead

## Related Commands
- `ifconfig` - Configure interface
- `route` - Show/manipulate route
- `netstat` - Network statistics
- `ss` - Socket statistics
- `arp` - Address resolution

## Additional Resources
- [IP Command Guide](https://man7.org/linux/man-pages/man8/ip.8.html)
- [Network Configuration](https://www.tecmint.com/ip-command-examples/)
- [Linux Networking](https://www.cyberciti.biz/faq/linux-ip-command-examples/)

## Best Practices
1. Document changes
2. Backup configurations
3. Test changes
4. Monitor impact
5. Security awareness

## Troubleshooting
1. Interface status
2. Address conflicts
3. Routing issues
4. DNS problems
5. Network connectivity

## Advanced Features
1. Network namespaces
2. Policy routing
3. Tunneling
4. VLANs
5. Multicast

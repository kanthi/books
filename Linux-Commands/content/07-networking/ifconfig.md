# ifconfig

## Overview
The `ifconfig` (interface configuration) command is used to configure, control, and query network interface parameters. While newer systems prefer the `ip` command, `ifconfig` is still widely used for network interface management.

## Syntax
```bash
ifconfig [interface] [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `up` | Activate interface |
| `down` | Deactivate interface |
| `netmask addr` | Set netmask address |
| `broadcast addr` | Set broadcast address |
| `-a` | Display all interfaces |
| `mtu N` | Set MTU size |
| `metric N` | Set interface metric |
| `promisc` | Set/clear promiscuous mode |

## Key Use Cases
1. Configure network interfaces
2. View network interface status
3. Enable/disable interfaces
4. Set IP addresses
5. Troubleshoot network issues

## Examples with Explanations
### Example 1: View All Interfaces
```bash
ifconfig -a
```
Shows all network interfaces, including inactive ones

### Example 2: Configure IP Address
```bash
ifconfig eth0 192.168.1.100 netmask 255.255.255.0
```
Sets IP address and netmask for eth0

### Example 3: Enable/Disable Interface
```bash
ifconfig eth0 up
ifconfig eth0 down
```
Activates/deactivates the eth0 interface

## Understanding Output
Standard output fields:
- Interface name
- Link status (UP/DOWN)
- Hardware address (MAC)
- IP address
- Broadcast address
- Netmask
- MTU size
- RX/TX statistics

## Common Usage Patterns
1. Check interface status:
   ```bash
   ifconfig eth0
   ```
2. Set temporary IP:
   ```bash
   ifconfig eth0 192.168.1.100
   ```
3. Enable promiscuous mode:
   ```bash
   ifconfig eth0 promisc
   ```

## Performance Analysis
- No real-time monitoring
- Static configuration tool
- Consider using `ip` command
- Check interface statistics
- Monitor packet errors

## Related Commands
- `ip` - Show/manipulate routing, devices, policy routing
- `route` - Show/manipulate IP routing table
- `netstat` - Network statistics
- `ethtool` - Query/control network drivers
- `iwconfig` - Configure wireless interfaces

## Additional Resources
- [Linux ifconfig manual](https://man7.org/linux/man-pages/man8/ifconfig.8.html)
- [Network Configuration Guide](https://www.tecmint.com/ifconfig-command-examples/)
- [IP Command vs ifconfig](https://www.tecmint.com/ip-command-vs-ifconfig/)

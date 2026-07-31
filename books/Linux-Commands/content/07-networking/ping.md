# ping

## Overview
`ping` sends ICMP echo requests to test reachability and round-trip time. First tool for “is the host up / is the network path alive?”.

## Syntax
```bash
ping [options] destination
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c N` | Count then exit |
| `-i sec` | Interval |
| `-W sec` | Wait for reply |
| `-w sec` | Overall deadline |
| `-s size` | Payload size |
| `-M do` | DF bit (PMTU probe) |
| `-4` / `-6` | Force family |
| `-n` | No reverse DNS |
| `-q` | Quiet summary |

## Examples with Explanations
```bash
ping -c 4 1.1.1.1
ping -c 4 example.com
ping -c 10 -i 0.2 192.168.1.1
ping -c 3 -W 1 10.0.0.1
ping -6 -c 4 2606:4700:4700::1111
ping -M do -s 1472 example.com    # DF PMTU experiments
```

### Script-friendly
```bash
if ping -c 1 -W 2 gateway >/dev/null; then echo up; else echo down; fi
```

## Notes
- ICMP may be blocked while TCP works — try `curl`/`nc` too.  
- Privileges: unprivileged ping works on modern Linux via socket flags; very low intervals may need root.  
- High packet size tests fragmentation/PMTU issues.

## Related Commands
- `traceroute` / `mtr`  
- `ip route get`  
- `ss` / `curl`  
- `ping6` — older alias

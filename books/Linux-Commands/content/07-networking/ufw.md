# ufw

## Overview
`ufw` (Uncomplicated Firewall) is Ubuntu’s friendly frontend to netfilter. It is suitable for host firewalls on workstations and small servers when you want readable allow/deny rules without writing raw `iptables`/`nft` by hand.

## Syntax
```bash
ufw [--dry-run] [commands]
```

## Common Options
| Option | Description |
|--------|-------------|
| `enable / disable` | Start or stop the firewall |
| `status [verbose|numbered]` | Show rules |
| `allow / deny / reject` | Add rules |
| `delete` | Remove by rule or number |
| `reload` | Reload rules |
| `reset` | Wipe rules (careful) |
| `logging on|off|low|medium|high` | Log verbosity |

## Key Use Cases
1. Lock down a VPS
2. Allow SSH before enabling
3. Open app ports (HTTP/HTTPS)
4. Limit brute-force with rate limiting

## Safety
**Remote sessions:** always add an allow for your admin access path before `ufw enable`. Prefer `--dry-run` when experimenting. `ufw reset` clears policy — know your recovery path (console/IPMI).

## Examples with Explanations
### Safe first-time enable (SSH first)
```bash
sudo ufw allow OpenSSH
# or: sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw status verbose
```
Never enable on a remote host without an SSH allow — you can lock yourself out.

### Allow web traffic
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```
Classic public web ports.

### Allow from a management subnet only
```bash
sudo ufw allow from 10.0.0.0/8 to any port 22 proto tcp
```
Restrict SSH to private space when applicable.

### Application profiles
```bash
sudo ufw app list
sudo ufw allow "Nginx Full"
```
Profiles ship with packages and map ports by name.

### Delete by number
```bash
sudo ufw status numbered
sudo ufw delete 3
```
Numbered mode avoids mistakes on similar rules.

### Rate-limit SSH
```bash
sudo ufw limit 22/tcp
```
Denies excessive connection attempts (simple brute-force mitigation).

## Notes & Pitfalls
- Default incoming policy after enable is usually deny; outgoing allow.
- Docker and some CNI setups bypass or complicate UFW — verify real exposure with `ss` and cloud security groups.
- Cloud VMs often have an *additional* security group/NSG outside the guest firewall.

## Related Commands
- `iptables` / `nft` — lower-level netfilter
- `ss -lntp` — see what is listening before opening ports
- `journalctl` — firewall / kernel log correlation

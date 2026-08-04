# ufw

## Overview

`ufw` (Uncomplicated Firewall) is Ubuntu’s friendly frontend to netfilter. It suits host firewalls on workstations and small servers when you want readable allow/deny rules without writing raw `iptables`/`nft` by hand. Under the hood current Ubuntu generations use nftables via ufw—you still manage policy with `ufw` commands.

## Syntax

```bash
ufw [--dry-run] [commands]
```

## Common Commands

| Command | Description |
|---------|-------------|
| `enable` / `disable` | Start/stop firewall |
| `status [verbose\|numbered]` | Show rules |
| `allow` / `deny` / `reject` | Add rules |
| `limit` | Rate-limit (anti brute-force) |
| `delete` | Remove by rule or number |
| `insert` | Insert at position |
| `reload` | Reload |
| `reset` | Wipe rules (**careful**) |
| `logging on\|off\|low\|medium\|high` | Logging |
| `app list` / `app info` | Application profiles |

## Key Use Cases

1. Lock down a VPS
2. Allow SSH before enabling
3. Open HTTP/HTTPS
4. Limit SSH brute-force noise

## Safety

**Remote sessions:** always allow admin access **before** `ufw enable`. Prefer `--dry-run`. Know console/IPMI/serial recovery. Cloud security groups are a second layer outside the guest.

## Examples with Explanations

### Safe first enable

```bash
sudo ufw allow OpenSSH
# or: sudo ufw allow 22/tcp
sudo ufw --dry-run enable
sudo ufw enable
sudo ufw status verbose
```

### Web and custom ports

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp comment 'app'
```

### From management network only

```bash
sudo ufw allow from 10.0.0.0/8 to any port 22 proto tcp
sudo ufw allow from 203.0.113.10 to any port 5432 proto tcp
```

### App profiles

```bash
sudo ufw app list
sudo ufw allow 'Nginx Full'
sudo ufw app info 'OpenSSH'
```

### Numbered delete / limit

```bash
sudo ufw status numbered
sudo ufw delete 3
sudo ufw limit 22/tcp
```

### One-liner recipes

```bash
# Default policies (review before enable)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Show everything
sudo ufw status verbose

# Disable quickly
sudo ufw disable
```

## Notes & Pitfalls

- Default after enable: usually **deny incoming**, allow outgoing.
- **Docker** and some CNI setups publish ports in ways that bypass or confuse UFW—verify with `ss -lntp` and cloud SG.
- IPv6 rules: ensure `IPV6=yes` in `/etc/default/ufw` when dual-stack.
- `ufw reset` clears policy—have out-of-band access.

## 2026-relevant notes

- Prefer **nftables**-aware mental model; `iptables-save` may show compatibility layers.
- On multi-host production, network policy often lives in cloud SG + service mesh; UFW is still fine per-VM hardening.
- RHEL-family often uses `firewalld` instead—different tool, same need to allow SSH first.

## Related Commands

- `iptables` / `nft` — lower level
- `ss -lntp` — listeners before opening ports
- `journalctl` — firewall-related logs
- `fail2ban` — complementary brute-force mitigation

## Additional Resources

- `man ufw`, `/usr/share/doc/ufw/`
- Ubuntu server guide firewall chapter

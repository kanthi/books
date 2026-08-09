# nft

## Overview

`nft` is the userspace CLI for **nftables**, the modern Linux packet-filtering framework that replaces legacy `iptables` backend plumbing on current Ubuntu releases. Use it when you need structured rulesets, sets/maps, or to inspect what `ufw`/`iptables-nft` installed. For simple host firewalls on Ubuntu, **`ufw` remains the friendly default**; use `nft` for visibility, advanced policy, and routers/firewalls you own end-to-end.

## Syntax

```bash
nft [options] commands
nft -f ruleset.nft
nft list ruleset
```

## Common Commands

| Command | Description |
|---------|-------------|
| `list ruleset` | Dump whole configuration |
| `list tables` | Tables only |
| `list table inet filter` | One table |
| `list chain inet filter input` | One chain |
| `add table inet filter` | Create table (family `ip`/`ip6`/`inet`/`netdev`/…) |
| `add chain …` | Create chain (with hooks for base chains) |
| `add rule …` | Append rule |
| `insert rule …` | Insert at position |
| `delete rule … handle N` | Delete by handle |
| `flush ruleset` | **Wipe all** nft rules |
| `flush table …` / `flush chain …` | Narrow flush |
| `-a` / `-n` | Show handles / numeric |
| `-j` | JSON output (tooling) |
| `-c` | Check mode (with `-f`) |
| `-f file` | Load from file |

Family **`inet`** covers IPv4+IPv6 in one table — preferred for new dual-stack host filters.

## Safety

**Remote lockout risk is identical to iptables.** Always ensure SSH/admin access is allowed **before** dropping input. Prefer:

1. Console/IPMI/serial access when experimenting.
2. `nft -c -f ruleset.nft` to syntax-check.
3. Incremental changes; know how to `flush` or reboot recovery.
4. On Ubuntu desktops/servers already using **ufw**, don’t fight it with ad-hoc `nft` rules unless you understand the interaction — inspect first with `nft list ruleset`.

`nft flush ruleset` clears **everything** nft owns — including rules installed by other tools.

## Examples with Explanations

### See what is active

```bash
sudo nft list ruleset
sudo nft list tables
sudo nft -a list chain inet filter input   # handles for deletes (names vary)
```

On UFW-enabled hosts you will typically see ufw-related tables/chains.

### Minimal inet filter sketch (lab / understanding)

```bash
sudo nft add table inet filter
sudo nft add chain inet filter input  '{ type filter hook input priority 0; policy accept; }'
sudo nft add chain inet filter forward '{ type filter hook forward priority 0; policy drop; }'
sudo nft add chain inet filter output '{ type filter hook output priority 0; policy accept; }'

sudo nft add rule inet filter input iif lo accept
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input tcp dport 22 accept
# only after SSH works from a second session:
# sudo nft chain inet filter input '{ policy drop; }'
```

Treat as a **teaching sketch** — production policy needs ICMP, rate limits, logging, and persistence.

### Sets for many ports/IPs

```bash
sudo nft add set inet filter admin_v4 '{ type ipv4_addr; }'
sudo nft add element inet filter admin_v4 '{ 203.0.113.10, 198.51.100.25 }'
sudo nft add rule inet filter input ip saddr @admin_v4 tcp dport 22 accept
```

Sets keep rulesets readable when allow-lists grow.

### Delete a rule by handle

```bash
sudo nft -a list chain inet filter input
sudo nft delete rule inet filter input handle 12
```

Handles change when rules are reloaded — re-list before deleting.

### Save and restore

```bash
sudo nft list ruleset > backup.nft
# edit carefully...
sudo nft -c -f backup.nft          # check
sudo nft -f backup.nft             # apply (does not auto-flush unless file says so)
```

To replace entirely, many operators `flush ruleset` inside the file or before load — **know what you wipe**.

### Persist on Ubuntu (high level)

```bash
# Example approach: package nftables + enable service
sudo apt install nftables
# put rules in /etc/nftables.conf then:
sudo nft -c -f /etc/nftables.conf
sudo systemctl enable --now nftables
```

If **ufw** is enabled, prefer configuring ufw rather than parallel conflicting `nftables.service` policies.

### Coexistence checks

```bash
sudo ufw status verbose
sudo nft list ruleset | head -100
sudo iptables -L -n | head          # may be iptables-nft compat
sudo ss -lntp
```

Confirm listeners and path: cloud security group → host nft/ufw → app.

### JSON for scripts

```bash
sudo nft -j list ruleset | jq '.nftables | length'
```

## Notes

- Prefer **one** management plane: ufw *or* raw nft *or* firewalld (RHEL) — mixing without care causes “ghost” blocks.
- Docker/Kubernetes install their own chains/tables; order and forward policy matter for published ports.
- Counter/log statements help prove hits: `counter`, `log prefix "nft: "`.
- IPv6: `inet` family reduces duplicated ip/ip6 tables.
- Naming: table/chain names are yours in custom rulesets; distro tools use their own.

## Related Commands

- `ufw` — Ubuntu host firewall front-end
- `iptables` — legacy/compat syntax (`iptables-nft`)
- `ss -lntp` — listening sockets before opening ports
- `tcpdump` — packet proof beyond firewall counters
- `sysctl` — e.g. `net.ipv4.ip_forward` for routers
- `systemctl` — `nftables` service when used

## Additional Resources

- `man nft`
- `man nftables`
- `/etc/nftables.conf` (package example)
- [nftables wiki](https://wiki.nftables.org/)

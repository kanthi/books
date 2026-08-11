# firewall-cmd

## Overview

`firewall-cmd` is the client for **firewalld**, the dynamic firewall manager on Fedora, RHEL, CentOS Stream, and many related systems. Zones and services abstract raw nftables/iptables rules. On Ubuntu, prefer `ufw` or direct `nft` unless you installed firewalld intentionally.

```bash
sudo dnf install firewalld
sudo systemctl enable --now firewalld
```

## Syntax

```bash
firewall-cmd [options]
```

## Common Options / Patterns

| Action | Example |
|--------|---------|
| State | `firewall-cmd --state` |
| Active zones | `--get-active-zones` |
| List zone | `--list-all` / `--zone=public --list-all` |
| Allow service | `--add-service=http --permanent` |
| Allow port | `--add-port=8080/tcp --permanent` |
| Reload | `--reload` |
| Panic | `--panic-on` (blocks all — careful) |

## Safety

- Always pair `--permanent` with `--reload` (or use runtime-only for experiments).  
- Locking yourself out over SSH: ensure `ssh` service is allowed in the active zone before disconnecting.  
- Panic mode is a last resort.

## Examples with Explanations

### Inventory

```bash
sudo firewall-cmd --state
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --list-all
```

### Allow HTTP permanently

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
sudo firewall-cmd --list-services
```

### Open a custom port

```bash
sudo firewall-cmd --permanent --add-port=9090/tcp
sudo firewall-cmd --reload
```

### Rich rule example

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" port port="5432" protocol="tcp" accept'
sudo firewall-cmd --reload
```

### Runtime vs permanent

```bash
sudo firewall-cmd --add-service=http          # runtime only
sudo firewall-cmd --runtime-to-permanent      # promote
```

## Notes & Pitfalls

- Interfaces bind to zones (`--zone=public --change-interface=eth0`).  
- Conflicts with manual `nft`/`iptables` rules are common — pick one manager.  
- Container ports still need host firewall + publish rules.

## Related Commands

- `ufw` — Ubuntu’s simple frontend  
- `nft` / `iptables` — low-level  
- `ss` — verify listeners  
- `nmcli` — interface/zone integration on NM systems  

## Additional Resources

- `man firewall-cmd`  
- firewalld documentation (zones and services)

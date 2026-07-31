# apt

## Overview
`apt` is the user-friendly package manager front-end on Debian and Ubuntu. It installs, updates, searches, and removes `.deb` packages, resolving dependencies. Prefer `apt` for interactive use; `apt-get`/`apt-cache` remain for scripts and older docs.

## Syntax
```bash
apt [options] command
```

## Common Commands
| Command | Description |
|---------|-------------|
| `update` | Refresh package indexes |
| `upgrade` / `full-upgrade` | Install newer versions |
| `install PKG…` | Install |
| `remove` / `purge` | Remove (purge drops config) |
| `autoremove` | Drop unused deps |
| `search` / `show` | Discover package metadata |
| `list --installed` | Installed packages |
| `policy PKG` | Candidate versions / pinning |
| `edit-sources` | Open sources list |
| `history` | Recent transactions (newer apt) |

## Key Use Cases
1. Install software on Ubuntu/Debian  
2. Apply security updates  
3. Inspect why a package is installed  
4. Clean leftover dependencies  

## Safety
- Run `update` before install/upgrade.  
- Read the transaction summary before confirming.  
- Avoid mixing random PPAs without care; they complicate upgrades.  
- Prefer `apt install package=version` for pins when needed.  

## Examples with Explanations
### Refresh and upgrade
```bash
sudo apt update
sudo apt upgrade
# or: sudo apt full-upgrade   # may remove pkgs to satisfy deps
```

### Install / remove
```bash
sudo apt install curl jq htop
sudo apt remove htop
sudo apt purge htop
sudo apt autoremove
```

### Search and inspect
```bash
apt search nginx
apt show nginx
apt policy nginx
```

### List installed
```bash
apt list --installed | less
apt list --upgradable
```

### Fix broken deps
```bash
sudo apt --fix-broken install
```

### Clean caches
```bash
sudo apt clean
sudo apt autoclean
```

### Noninteractive (scripts/CI)
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install package
```
`apt-get` is more stable for automation flags.

## Notes & Pitfalls
- `apt` CLI is not fully API-stable for machines; many CI scripts still use `apt-get`.  
- Holds: `apt-mark hold PKG`.  
- Downloads live under `/var/cache/apt/archives`.  
- Snaps/flatpaks are separate systems.  

## Related Commands
- `dpkg` — low-level `.deb`  
- `apt-cache` / `apt-get` — classic tools  
- `snap` / `flatpak` — alternate app delivery  
- `dnf` / `rpm` — Fedora/RHEL family  

## Additional Resources
- `man apt`  
- Ubuntu packaging guide

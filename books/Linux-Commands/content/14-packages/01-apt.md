# apt

## Overview

`apt` is the friendly package manager front-end on Debian and Ubuntu. It installs, updates, searches, and removes `.deb` packages with dependency resolution. Prefer `apt` interactively; keep `apt-get`/`apt-cache` for scripts and older documentation. Fedora/RHEL use `dnf` instead.

## Syntax

```bash
apt [options] command
```

## Common Commands

| Command | Description |
|---------|-------------|
| `update` | Refresh package indexes from mirrors |
| `upgrade` | Install newer versions (conservative) |
| `full-upgrade` | Upgrade allowing removals to satisfy deps |
| `install PKG…` | Install or upgrade packages |
| `reinstall PKG` | Reinstall current version |
| `remove` / `purge` | Remove (purge drops conffiles) |
| `autoremove` | Drop unused automatic deps |
| `search` / `show` | Discover packages |
| `list --installed` / `--upgradable` | Inventory |
| `policy PKG` | Candidate versions / pinning |
| `depends` / `rdepends` | Dependency graph peek |
| `edit-sources` | Open sources list |
| `history` | Recent transactions (newer apt) |
| `changelog PKG` | Show changelog |

## Key Use Cases

1. Install software on Ubuntu/Debian  
2. Apply security updates  
3. Inspect why a package is present  
4. Clean leftover dependencies after removals  

## Safety

- Always `update` before install/upgrade when online.  
- Read the transaction summary (packages removed!) before confirming.  
- Random PPAs complicate upgrades — pin trust carefully.  
- Prefer staged upgrades on production (`apt-get` with maintenance windows).  
- Do not kill `dpkg`/`apt` mid-transaction without recovery plan.

## Examples with Explanations

### Refresh and upgrade

```bash
sudo apt update
sudo apt upgrade
sudo apt full-upgrade      # may remove packages to satisfy deps
apt list --upgradable
```

### Install / remove

```bash
sudo apt install curl jq htop
sudo apt remove htop
sudo apt purge htop        # also remove /etc config files owned by the pkg
sudo apt autoremove --purge
```

### Search and inspect

```bash
apt search '^nginx'
apt show nginx
apt policy nginx
apt depends nginx
apt rdepends openssl | head
```

### Version pinning at install

```bash
apt policy nginx
sudo apt install nginx=1.24.*
apt-mark hold nginx
apt-mark unhold nginx
apt-mark showhold
```

### Fix broken dependencies

```bash
sudo dpkg --configure -a
sudo apt --fix-broken install
```

Classic recovery after a failed upgrade or full disk mid-install.

### Clean caches

```bash
sudo apt clean              # wipe package caches
sudo apt autoclean          # only obsolete debs
du -sh /var/cache/apt/archives
```

### Noninteractive (scripts/CI)

```bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y install package
```

`apt-get` flags are more stable for automation than interactive `apt`.

### Simulate / dry-run

```bash
apt-get -s install heavy-metapackage
apt --dry-run full-upgrade
```

### Which package owns a file?

```bash
dpkg -S /usr/bin/curl
apt-file search bin/curl     # needs apt-file package + update
```

## Notes & Pitfalls

- `apt` CLI is **not** a stable machine API — many CI scripts stick to `apt-get`.  
- Snaps (`snap`) are a separate delivery channel on some Ubuntu systems; prefer debs for core server packages.  
- Held packages block upgrades silently until unheld.  
- Multi-arch (`:i386` / foreign architectures) appears when enabled for cross-arch deps — uncommon on pure amd64 servers.  
- Offline mirrors: `apt-offline` or local `file:` repositories.

## Related Commands

- `dpkg` — low-level `.deb` operations  
- `apt-get` / `apt-cache` — classic tooling  
- `snap` — optional snapd packages on Ubuntu  
- `dnf` / `rpm` — Fedora/RHEL family  
- `needrestart` — restart services after library upgrades (if installed)  

## Additional Resources

- `man apt` / `man apt-get`  
- Ubuntu Server Guide — package management

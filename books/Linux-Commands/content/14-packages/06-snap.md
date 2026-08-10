# snap

## Overview

`snap` installs **Snap** packages from the Snap Store. On **Ubuntu Server** you mainly meet snaps as optional delivery for server tools (for example some Canonical products, confinement demos, or ops utilities) — not as a desktop app store. Prefer distro packages (`apt` / `dnf`) for core system software; use snaps when a vendor ships only that channel or you want the snap’s isolation/refresh model.

Many minimal server images ship without `snapd`; install it only if you need it.

```bash
sudo apt update
sudo apt install snapd    # Debian/Ubuntu when required
```

## Syntax

```bash
snap [options] command
```

## Common Commands

| Command | Description |
|---------|-------------|
| `find query` | Search store |
| `info name` | Details / channels / confinement |
| `install name` | Install |
| `remove name` | Remove |
| `list` | Installed snaps |
| `refresh` | Update |
| `channels name` | Track/channel info |
| `services` | Services shipped inside snaps |
| `logs name` | Snap service logs |
| `connections` | Interface plugs/slots (confinement) |

## Safety

- Snaps **auto-refresh** by default — on production hosts, understand refresh timing or hold refreshes for critical tools.  
- Prefer `apt`/`dnf` for libraries and daemons that integrate tightly with the OS.  
- Classic confinement is less sandboxed — review `snap info` before install.  
- Disk growth under `/var/lib/snapd` from old revisions — prune intentionally.

## Key Use Cases

1. Vendor-distributed server tools published only as snaps  
2. Optional Ubuntu server components that use snapd  
3. Inspecting what snapd already installed on a host  

## Examples with Explanations

### Inventory and search

```bash
snap version
snap list
snap find lxd
snap info lxd
```

Use `info` to see tracks, confinement, and whether the snap is maintained.

### Install / remove (server-oriented)

```bash
# Example only — choose packages you actually need
sudo snap install hello-world
snap list
sudo snap remove hello-world
```

Prefer well-known server snaps you operate deliberately; avoid random desktop apps on headless hosts.

### Channels / tracks

```bash
snap info kubectl
# sudo snap install kubectl --classic --channel=1.29/stable
```

`--classic` relaxes confinement (common for developer/ops CLIs). Pin channels on production.

### Services and logs

```bash
snap services
# sudo snap restart <snap>.<service>
snap logs <snap-name>
```

Some snaps bundle systemd-like services managed through snapd.

### Hold refreshes (ops)

```bash
sudo snap refresh --hold
# review: snap refresh --time
# later: sudo snap refresh --unhold
```

Useful in maintenance windows so unattended refreshes do not change binaries mid-incident.

### Revisions / disk use

```bash
snap list --all
du -sh /var/lib/snapd
# remove disabled old revisions when appropriate:
# sudo snap remove <name> --revision=N
```

## Notes & Pitfalls

- Headless servers: no GUI plugs; do not install GUI-oriented snaps.  
- Mixing snap and apt packages of the same tool can put two binaries on `PATH` — check `which -a`.  
- Network-restricted environments need store/proxy access for install and refresh.  
- For Fedora/RHEL, this ecosystem is uncommon; use distro packages or containers instead.

## Related Commands

- `apt` / `dpkg` — primary Ubuntu/Debian packaging  
- `dnf` / `rpm` — Fedora/RHEL packaging  
- `systemctl` / `journalctl` — host services and logs  
- `podman` — containers as an alternative distribution model  

## Additional Resources

- `man snap`  
- Ubuntu Server documentation on snapd (when using Ubuntu)

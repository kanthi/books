# yum

## Overview

`yum` (Yellowdog Updater Modified) is the classic RPM package manager front-end for older RHEL/CentOS/Scientific Linux systems. On **RHEL 8+/Fedora/CentOS Stream**, the command is typically a compatibility wrapper around **`dnf`**. Prefer `dnf` on modern systems; learn `yum` for legacy fleets and muscle-memory commands that still work.

## Syntax

```bash
yum [options] command
```

## Common Commands

| Command | Description |
|---------|-------------|
| `install` | Install packages |
| `remove` / `erase` | Remove packages |
| `update` / `upgrade` | Update packages |
| `info` | Package details |
| `list` | List packages |
| `search` | Search metadata |
| `provides` / `whatprovides` | Which package owns a capability/file |
| `repolist` | Enabled repos |
| `clean all` | Clean caches |
| `history` | Transaction history |
| `groupinstall` | Group install |
| `check-update` | Check without installing |

## Common Options

| Option | Description |
|--------|-------------|
| `-y` | Assume yes |
| `-q` | Quiet |
| `--enablerepo=` / `--disablerepo=` | Toggle repos for one shot |
| `--setopt=` | Override config |
| `--downloadonly` | Download, don’t install |
| `--security` | Security updates (plugin/platform dependent) |
| `-C` | Run from cache only |

## Examples with Explanations

### Everyday

```bash
sudo yum check-update
sudo yum update -y
sudo yum install -y curl vim
sudo yum remove -y oldpkg
```

### Search and info

```bash
yum search nginx
yum info nginx
yum list installed 'nginx*'
yum provides /usr/bin/ps
```

### Repos

```bash
yum repolist
yum repolist all
sudo yum-config-manager --enable powertools   # platform specific
```

### History / undo

```bash
sudo yum history
sudo yum history info 42
sudo yum history undo 42
```

### Clean cache

```bash
sudo yum clean all
sudo yum makecache
```

### Prefer dnf when present

```bash
command -v dnf && dnf --version
sudo dnf install -y htop      # modern path
# yum may redirect:
yum --version
```

### Groups

```bash
yum group list
sudo yum groupinstall -y "Development Tools"
```

## Notes / Pitfalls

- RHEL 8+: `yum` → `dnf` API; some old yum plugins differ.
- `-y` in unattended scripts needs good testing (major upgrades).
- Multiple transactions: watch disk space for `/var/cache`.
- Proxy and mirror issues show as metadata download failures.
- EPEL and third-party repos change availability — pin carefully.

## 2026-relevant notes

- New work: document **`dnf`** first; mention `yum` as alias/legacy.
- CentOS Linux classic is EOL — care with unmaintained mirrors.
- For containers, use minimal base images and explicit package lists rather than interactive yum sessions.

## Related Commands

- `dnf` — modern replacement
- `rpm` — low-level RPM queries/installs
- `repoquery` — rich queries (dnf/yum tools)
- `subscription-manager` — RHEL entitlements
- `apt` — Debian family analog

## Additional Resources

- `man yum`, `man dnf`
- RHEL system admin docs for your major version

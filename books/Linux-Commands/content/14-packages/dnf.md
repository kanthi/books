# dnf

## Overview
`dnf` is the package manager on Fedora, RHEL 8+, CentOS Stream, Rocky, Alma. Successor to `yum` (often `yum` is a symlink to `dnf`).

## Syntax
```bash
dnf [options] command [pkg...]
```

## Common Commands
| Command | Description |
|---------|-------------|
| `install` / `remove` | Add/remove |
| `upgrade` | Update installed |
| `search` / `info` | Discover |
| `list installed\|available` | Lists |
| `provides /path` | Which package owns a file |
| `repolist` | Repos |
| `history` | Undo/redo transactions |
| `group install` | Package groups |
| `makecache` | Refresh metadata |
| `clean all` | Clear caches |

## Examples with Explanations
```bash
sudo dnf install htop jq
sudo dnf upgrade
dnf search nginx
dnf info nginx
dnf provides '*/bin/ss'
sudo dnf remove htop
sudo dnf history
sudo dnf history undo last
sudo dnf repolist
sudo dnf install @development-tools
```

### Scripted
```bash
sudo dnf -y install curl
```

## Notes
- Config: `/etc/dnf/dnf.conf`, repos in `/etc/yum.repos.d/`.  
- Modules (AppStreams) on RHEL: `dnf module list`.  
- For Debian/Ubuntu use `apt`.

## Related Commands
- `rpm` — low-level RPM  
- `yum` — legacy alias  
- `apt` — Debian family

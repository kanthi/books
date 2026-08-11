# getenforce

## Overview

`getenforce` prints the current **SELinux** mode: `Enforcing`, `Permissive`, or `Disabled`. Standard on Fedora/RHEL/CentOS; on Ubuntu SELinux is usually inactive in favor of AppArmor (`aa-status`). Use this before debugging “AVC denied” issues.

```bash
# RHEL family
sudo dnf install policycoreutils
```

## Syntax

```bash
getenforce
```

## Examples with Explanations

### Check mode

```bash
getenforce
# Enforcing | Permissive | Disabled
```

### Related status

```bash
sestatus
getsebool -a | head
```

## Notes & Pitfalls

- `Disabled` requires a reboot to re-enable on traditional setups (prefer permissive for troubleshooting).  
- Containers may show different SELinux visibility than the host.

## Related Commands

- `setenforce` — toggle enforcing/permissive  
- `sestatus` — richer status  
- `restorecon` / `chcon` — file contexts  
- `ausearch` / `audit2allow` — AVC triage  
- `aa-status` — AppArmor on Ubuntu  

## Additional Resources

- `man getenforce`  
- RHEL SELinux documentation

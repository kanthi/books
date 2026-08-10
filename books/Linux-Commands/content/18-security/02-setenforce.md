# setenforce

## Overview

`setenforce` switches SELinux between **Enforcing** (1) and **Permissive** (0) until reboot (or until changed again). Permissive logs denials without blocking — useful for triage, not a permanent hardening strategy.

## Syntax

```bash
sudo setenforce 1    # Enforcing
sudo setenforce 0    # Permissive
getenforce
```

## Safety

- Permissive mode reduces security — use briefly, then return to enforcing.  
- Does not enable SELinux if it is fully **Disabled** in the kernel/config; that needs config + reboot.  
- Production changes should go through change control; prefer boolean/`semanage` fixes over long-term permissive.

## Examples with Explanations

### Temporary permissive for debugging

```bash
getenforce
sudo setenforce 0
# reproduce the app failure; watch audit log
sudo ausearch -m avc -ts recent | tail
sudo setenforce 1
```

### Persist mode (config — not setenforce)

```bash
# /etc/selinux/config
# SELINUX=enforcing|permissive|disabled
```

## Related Commands

- `getenforce` / `sestatus`  
- `restorecon` — fix labels  
- `semanage` / `setsebool` — lasting policy tweaks  
- `audit2allow` — generate local policy modules carefully  

## Additional Resources

- `man setenforce`

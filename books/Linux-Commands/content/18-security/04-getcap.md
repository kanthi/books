# getcap / setcap

## Overview

Linux **file capabilities** grant subsets of root privilege to executables (e.g. bind low ports without full uid 0). `getcap` lists them; `setcap` assigns them. Prefer capabilities over setuid-root when you must elevate a single binary.

```bash
sudo apt install libcap2-bin
```

## Syntax

```bash
getcap [-r] path...
sudo setcap cap_spec path
sudo setcap -r path          # remove
```

## Examples with Explanations

### Inspect

```bash
getcap /usr/bin/ping
getcap -r /usr/bin 2>/dev/null | head
```

### Allow binding privileged ports (example)

```bash
# illustration — understand security impact first
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/myapp
getcap /usr/local/bin/myapp
```

### Remove capabilities

```bash
sudo setcap -r /usr/local/bin/myapp
```

## Safety

- Capabilities are powerful; `+ep` (effective+permitted) can be equivalent to selective root.  
- Package updates may overwrite custom capabilities.  
- Prefer systemd `AmbientCapabilities=` / `CapabilityBoundingSet=` for services.

## Notes & Pitfalls

- Filesystems must support extended attributes (`xattr`).  
- Copy tools may drop capabilities unless preserved.  
- Combine with seccomp/namespaces for real confinement.

## Related Commands

- `capsh` — capability-aware shell helpers  
- `systemctl edit` — service capabilities  
- `sudo` — broader elevation  
- `getfacl` — ACLs (different mechanism)  

## Additional Resources

- `man getcap` / `man setcap`  
- `man capabilities`

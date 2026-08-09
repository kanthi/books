# lsmod

## Overview

`lsmod` lists loaded **kernel modules** (name, size, use count, dependents). It is a thin, readable view of `/proc/modules`. Use it when debugging drivers, missing hardware support, or before `modprobe`/`rmmod` operations.

## Syntax

```bash
lsmod
# no significant options — see modprobe/rmmod for management
```

## Examples with Explanations

### List modules

```bash
lsmod
lsmod | sort
lsmod | head
```

### Search for a driver

```bash
lsmod | grep -i usb
lsmod | grep -i nvidia
lsmod | grep -E '^(nfs|overlay|br_netfilter)'
```

### Dependency / use count

```bash
lsmod | awk 'NR==1 || $3>0 {print}'
# third column: used by count; Used by column shows dependents
```

### Correlate with hardware

```bash
lsusb
lspci -k
lsmod | grep -i xhci
```

`lspci -k` shows which kernel driver is bound to a PCI device.

### Module details

```bash
modinfo e1000e
modprobe -n -v e1000e          # dry-run
cat /proc/modules | grep e1000e
```

### Unload safety check

```bash
lsmod | grep module_name
sudo modprobe -r module_name   # preferred over raw rmmod
# fails if in use — check dependents in lsmod
```

### Blacklist context

```bash
lsmod | grep nouveau
# if you blacklisted a module, it should not appear after reboot
grep -r nouveau /etc/modprobe.d/ 2>/dev/null
```

## Understanding columns

| Column | Meaning |
|--------|---------|
| Module | Module name |
| Size | Memory size in bytes |
| Used by | Reference count and dependent module names |

A non-zero use count means unload will fail until dependents release it.

## Notes / Pitfalls

- Built-in kernel features are **not** modules — absence from `lsmod` doesn’t mean “unsupported”.
- Out-of-tree modules (ZFS, some NVIDIA) still appear when loaded.
- Containers usually cannot load modules; operations need host privileges.
- Secure Boot may restrict unsigned modules.
- Don’t randomly `rmmod` storage/network drivers on remote hosts.

## 2026-relevant notes

- Initramfs and UKI images embed critical modules — `lsmod` after boot is not the whole story.
- Prefer `modprobe` over `insmod` for dependency resolution.
- For policy, use `/etc/modules-load.d/` and `/etc/modprobe.d/` rather than ad-hoc loads.

## Related Commands

- `modprobe` / `rmmod` / `insmod` — load/unload
- `modinfo` — module metadata
- `lspci -k` / `lsusb` — hardware binding
- `dmesg` — load errors
- `depmod` — rebuild module deps

## Additional Resources

- `man lsmod`, `man 5 modules`

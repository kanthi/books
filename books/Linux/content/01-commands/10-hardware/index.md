---
title: Intro
---

# Intro

Inventory and inspect physical devices: whole-system reports, PCI devices, DMI/SMBIOS data, and disk identity/timings. Use before opening tickets or swapping hardware.

## Commands in this part

| Command | Role |
|---------|------|
| `lshw` | lshw (list hardware) probes the system and prints a hardware tree: CPU, memory, storage, network, firmware, and buses. |
| `lspci` | lspci lists PCI and PCI Express devices: NICs, GPUs, storage controllers, USB controllers, bridges, and more. |
| `dmidecode` | dmidecode dumps DMI/SMBIOS tables: manufacturer, product name, serial numbers, BIOS version, memory slot population,… |
| `hdparm` | hdparm gets and sets ATA/SATA disk parameters: identify data, power management, read-ahead, write-cache, and… |


## Suggested starting points

1. Broad inventory: `lshw`.
2. PCI devices: `lspci`.
3. Firmware/DMI: `dmidecode`.
4. Disk identity/timings: `hdparm` (SMART health is under Storage: `smartctl`).

## Related parts

- System information — quick CPU/memory summaries
- Storage and filesystems — block devices and SMART
- Services and runtime — kernel modules via `modprobe`/`lsmod`

Continue with the individual command pages in this part.

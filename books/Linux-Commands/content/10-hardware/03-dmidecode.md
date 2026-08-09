# dmidecode

## Overview

`dmidecode` dumps **DMI/SMBIOS** tables: manufacturer, product name, serial numbers, BIOS version, memory slot population, processor strings, chassis type, and more. It is the go-to CLI for “what hardware is this?” on bare metal without opening a ticket to the DC. Requires **root**. VMs expose synthetic or partial DMI data.

## Syntax

```bash
sudo dmidecode [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t type` | Restrict by type name or number: `system`, `bios`, `baseboard`, `memory`, `processor`, `chassis`, `slot`, … |
| `-s keyword` | Print a single string (`system-serial-number`, `system-product-name`, `bios-version`, …) |
| `-u` | Dump raw formatted entries |
| `-q` | Quieter (less decoration) |
| `-d file` | Read from dump file instead of `/sys/firmware/dmi/tables` |
| `--oem-string N` | OEM string index |

Common `-t` names: `bios`, `system`, `baseboard`, `chassis`, `processor`, `memory`, `cache`, `connector`, `slot`.

## Key Use Cases

1. Inventory serial / product / UUID for asset tracking
2. BIOS/UEFI version before firmware upgrades
3. Memory slot map (which DIMM empty/populated)
4. Confirm bare-metal vs obvious VM DMI strings

## Examples with Explanations

### System identity

```bash
sudo dmidecode -t system
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-product-name
sudo dmidecode -s system-serial-number
sudo dmidecode -s system-uuid
```

Serial and UUID are sensitive — scrub before pasting into public tickets.

### BIOS / firmware

```bash
sudo dmidecode -t bios
sudo dmidecode -s bios-version
sudo dmidecode -s bios-release-date
sudo dmidecode -s bios-vendor
```

Capture before and after firmware updates.

### Memory population

```bash
sudo dmidecode -t memory
sudo dmidecode -t memory | grep -E 'Size:|Locator:|Bank Locator:|Speed:|Manufacturer:|Part Number:|Volatile Size:'
```

Shows per-slot size/speed; empty slots often report `No Module Installed` / size `No Module Installed`.

### Processor summary

```bash
sudo dmidecode -t processor
sudo dmidecode -t processor | grep -E 'Version:|Core Count:|Core Enabled:|Thread Count:|Max Speed:|Current Speed:'
```

Complement with `lscpu` for the kernel’s view of topology and flags.

### Baseboard and chassis

```bash
sudo dmidecode -t baseboard
sudo dmidecode -t chassis
sudo dmidecode -s baseboard-serial-number
sudo dmidecode -s chassis-type
```

Useful for blade/rack asset fields and chassis form factor.

### Inventory one-liners for scripts

```bash
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-product-name
sudo dmidecode -s system-serial-number
sudo dmidecode -s bios-version
```

`-s` fails closed if the keyword is invalid — check `man dmidecode` for the keyword list.

### Compare with sysfs (no full dump)

```bash
# many fields also appear here (root not always required for all):
cat /sys/class/dmi/id/product_name
cat /sys/class/dmi/id/sys_vendor
cat /sys/class/dmi/id/product_serial   # may be root-only / permission-denied
```

sysfs is handy for a few fields; dmidecode is better for structured tables (memory slots).

## Understanding Output

Output is grouped into **handles** (DMI record instances). Each handle has a type (e.g. Memory Device) and key/value fields. Multiple handles of the same type are normal (one per DIMM, per CPU socket, …).

| Area | What operators extract |
|------|-------------------------|
| System | Vendor, model, serial, UUID |
| BIOS | Version, date, vendor |
| Memory Device | Locator, size, speed, part number |
| Processor | Version string, core/thread counts |

Garbage or `Not Specified` / `To be filled by O.E.M.` means the vendor left SMBIOS incomplete — common on some whiteboxes and VMs.

## Notes & Pitfalls

- **Root required** for full access; without it you get little or nothing.
- VMs (KVM, VMware, cloud) synthesize DMI — serials may be instance IDs or placeholders.
- Serial numbers are **PII/asset-sensitive** — redact in chat logs.
- DMI can be wrong if vendors mess up tables; cross-check labels and BMC/iDRAC/iLO when stakes are high.
- Not a substitute for `lshw` PCI detail or `lspci` driver binding.
- `system-uuid` may be used by software licensing — changing it (rare/firmware) has consequences.

## Related Commands

- `lshw` — broader hardware tree (also often needs root)
- `lscpu` — CPU topology/flags from kernel
- `lspci` / `lsusb` — buses and peripherals
- `cat /sys/class/dmi/id/*` — quick sysfs fields
- `dmesg` — firmware/kernel hardware messages

## Additional Resources

- `man dmidecode`
- SMBIOS field quality varies by OEM; trust but verify against physical tags for RMA.

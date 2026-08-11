# pvs

## Overview

`pvs` reports **LVM physical volumes** (PVs) — disks or partitions initialized with `pvcreate` and used by volume groups. Part of the LVM reporting trio with `vgs` and `lvs`.

```bash
sudo apt install lvm2
```

## Syntax

```bash
pvs [options] [PV...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-o fields` | Custom columns |
| `-v` | Verbose |
| `--units h` | Human units |
| `-a` | All devices (incl. empty) |
| `--reportformat json` | JSON (newer) |

## Examples with Explanations

### List physical volumes

```bash
sudo pvs
sudo pvs -o+pv_used,pv_free,dev_size
```

### Initialize a new PV (related workflow)

```bash
sudo wipefs -a /dev/sdb1          # if reusing a disk — careful
sudo pvcreate /dev/sdb1
sudo pvs
```

### Free space across PVs

```bash
sudo pvs --units g -o pv_name,vg_name,pv_size,pv_free
```

## Notes & Pitfalls

- Whole-disk vs partition PVs: prefer a partition or carefully documented whole-disk use.  
- Removing a PV requires migrating extents (`pvmove`) first if the VG has data there.

## Related Commands

- `pvcreate` / `pvremove` / `pvresize`  
- `vgs` / `lvs` — VG and LV reports  
- `lsblk` — block layer view  

## Additional Resources

- `man pvs`  
- `man lvm`

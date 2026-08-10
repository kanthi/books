# vgs

## Overview

`vgs` reports **LVM volume groups** (VGs): how physical volumes are pooled and how much space is free for logical volumes. Use with `pvs` and `lvs` for a full LVM picture.

## Syntax

```bash
vgs [options] [VG...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-o fields` | Custom columns |
| `-v` | Verbose |
| `--units h` | Human-readable sizes |
| `-a` | Include hidden/internal where applicable |

## Examples with Explanations

### List volume groups

```bash
sudo vgs
sudo vgs -o+vg_extent_size,vg_extent_count,vg_free_count
```

### Create VG from PVs (workflow)

```bash
sudo vgcreate vg_data /dev/sdb1 /dev/sdc1
sudo vgs
```

### Free space before creating an LV

```bash
sudo vgs --units g -o vg_name,vg_size,vg_free
```

## Notes & Pitfalls

- Extent size is fixed at VG creation — plan large VGs carefully.  
- Cluster/shared VGs need locking infrastructure (not covered here).

## Related Commands

- `vgcreate` / `vgextend` / `vgreduce` / `vgremove`  
- `pvs` / `lvs`  
- `lvmdiskscan`  

## Additional Resources

- `man vgs`  
- `man vgcreate`

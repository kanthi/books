# lvs

## Overview

`lvs` reports **LVM logical volumes** (LVs) — the block devices you usually format and mount (`/dev/VG/LV` or `/dev/mapper/VG-LV`). Check size, attributes (thin, cache, snapshot), and path before growing filesystems.

## Syntax

```bash
lvs [options] [LV...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-o fields` | Custom columns (`lv_path`, `lv_size`, `lv_attr`, …) |
| `-a` | All LVs including internal |
| `--units h` | Human sizes |
| `-v` | Verbose |

## Examples with Explanations

### List LVs

```bash
sudo lvs
sudo lvs -o lv_name,vg_name,lv_size,lv_path,lv_attr
```

### Create and format an LV (workflow)

```bash
sudo lvcreate -n data -L 100G vg_data
sudo mkfs.ext4 /dev/vg_data/data
sudo mkdir -p /mnt/data
sudo mount /dev/vg_data/data /mnt/data
```

### Grow an LV (then filesystem)

```bash
sudo lvextend -L +50G /dev/vg_data/data
sudo resize2fs /dev/vg_data/data      # ext*
# sudo xfs_growfs /mnt/data          # xfs, grow while mounted
```

### Snapshots (classic thick)

```bash
sudo lvcreate -s -n data_snap -L 10G /dev/vg_data/data
sudo lvs
```

## Understanding Output

`lv_attr` is a multi-character state field (open/mounted, snapshot, thin, …). Paths under `/dev/mapper/` are commonly used in fstab via UUID of the **filesystem**, not the LV name alone.

## Related Commands

- `lvcreate` / `lvextend` / `lvremove` / `lvrename`  
- `pvs` / `vgs`  
- `resize2fs` / `xfs_growfs`  
- `findmnt`  

## Additional Resources

- `man lvs`  
- `man lvcreate`

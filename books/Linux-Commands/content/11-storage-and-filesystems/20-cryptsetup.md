# cryptsetup

## Overview

`cryptsetup` manages **LUKS** (and other) disk encryption: format, open, close, and resize encrypted block devices. Standard tool for full-disk and data-partition encryption on Linux.

```bash
sudo apt install cryptsetup
```

## Syntax

```bash
sudo cryptsetup [options] command device [args]
```

## Common Commands

| Command | Description |
|---------|-------------|
| `luksFormat` | Initialize LUKS header (**destroys data**) |
| `open` / `luksOpen` | Map decrypted device under `/dev/mapper/` |
| `close` / `luksClose` | Remove mapping |
| `status` | Show mapper status |
| `luksAddKey` / `luksRemoveKey` | Manage passphrases/keys |
| `luksDump` | Show header metadata |
| `resize` | Resize LUKS mapping after LV growth |

## Safety

- `luksFormat` is irreversible without backups of the header and key material.  
- Store recovery passphrases offline; header backups (`luksHeaderBackup`) matter.  
- Suspend-to-disk with unlocked volumes has threat-model implications.  
- Always confirm the target device with `lsblk` first.

## Examples with Explanations

### Format and open (data disk)

```bash
sudo cryptsetup luksFormat /dev/sdb1
sudo cryptsetup open /dev/sdb1 crypt_data
sudo mkfs.ext4 /dev/mapper/crypt_data
sudo mount /dev/mapper/crypt_data /mnt/data
```

### Status and close

```bash
sudo cryptsetup status crypt_data
sudo umount /mnt/data
sudo cryptsetup close crypt_data
```

### Add a second passphrase

```bash
sudo cryptsetup luksAddKey /dev/sdb1
sudo cryptsetup luksDump /dev/sdb1 | less
```

### Header backup

```bash
sudo cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file ~/luks-sdb1.header
chmod 600 ~/luks-sdb1.header
```

### fstab / crypttab sketch

```bash
# /etc/crypttab
# crypt_data UUID=… none luks,discard
# then fstab mounts /dev/mapper/crypt_data
```

Use UUIDs from `blkid` on the **LUKS** device for crypttab.

## Notes & Pitfalls

- LUKS2 is the modern default on current distros.  
- SSD discard/TRIM: `discard` option trades some security for wear-leveling — know your threat model.  
- Nested LVM-on-LUKS or LUKS-on-LVM both exist; order affects unlock at boot.

## Related Commands

- `lsblk` / `blkid` — find devices  
- `dmsetup` — device-mapper layer  
- `lvs` — often underneath or above LUKS  
- `mount` / `umount`  

## Additional Resources

- `man cryptsetup`  
- `crypttab(5)`

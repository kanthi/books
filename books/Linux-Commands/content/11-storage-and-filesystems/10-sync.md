# sync

## Overview

`sync` flushes filesystem buffers: dirty page cache and pending metadata are written to storage. Use it before removing USB media, after bulk `dd`/`cp` to removable devices, or when you need a durable checkpoint before power loss. Modern kernels and `umount` already sync as part of a clean unmount; calling `sync` explicitly is still a useful operator habit for removable media and scripts.

## Syntax

```bash
sync [options] [file...]
```

With no arguments, flushes all filesystems (global sync). With file arguments (GNU), flushes those files and the filesystems that hold them.

## Common Options

| Option | Description |
|--------|-------------|
| *(none)* | Sync all (classic usage) |
| `FILE...` | Sync data for listed files (GNU coreutils) |
| `-d`, `--data` | Sync data only, not metadata (when supported) |
| `-f`, `--file-system` | Sync the filesystems that contain the files |

BusyBox/`sync` on minimal systems may only support the no-argument form.

## Safety

- `sync` is **not a substitute for unmounting**. Always `umount` (or eject) removable volumes when possible so the kernel finishes metadata updates cleanly.
- `sync` does **not** make a crash-consistent snapshot of multi-file databases by itself — use application flush/quiesce or LVM/ZFS snapshots for that class of problem.
- Calling `sync` under heavy write load can stall the system briefly while I/O drains — expected, not a hang in most cases.

## Examples with Explanations

### Flush everything (classic)

```bash
sync
```

Blocks until outstanding dirty data is queued to devices (and typically completed for the global case). Common after imaging USBs or large copies.

### After writing a USB with dd

```bash
sudo dd if=image.iso of=/dev/sdX bs=4M status=progress conv=fsync
sync
# safely remove when activity LED is idle
```

`conv=fsync` already fsyncs the output; an extra `sync` is cheap insurance before unplug.

### Sync specific file (GNU)

```bash
cp bigfile /media/usb/bigfile
sync /media/usb/bigfile
# or
sync -f /media/usb/bigfile
```

Narrows flush to the file/filesystem of interest instead of the whole machine.

### Safe removable-media workflow

```bash
cp -a project/ /media/$USER/STICK/
sync
sudo umount /media/$USER/STICK
# or: udisksctl unmount -b /dev/sdX1
```

Copy → sync → unmount is the reliable order for thumb drives.

### In scripts before reboot/power events

```bash
install -m 644 app.conf /etc/myapp/app.conf
sync
sudo systemctl restart myapp
```

Ensures config hit disk before a service that might race with a crash/reboot path.

### Drop caches (admin debug — not for production routine)

```bash
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches
```

`sync` first so drop_caches does not discard dirty data. Used for I/O benchmarks; not a general cleanup step.

## Notes

- Journaling filesystems reduce risk of total corruption, but applications can still lose unflushed writes on power loss without `fsync`/`fdatasync`.
- `dd … conv=fsync` and `cp` with certain flags interact with durability differently than a bare write + delayed writeback.
- Desktop “eject” / file-manager safe-remove typically unmounts (which syncs); CLI operators should mirror that with `umount`.
- Network filesystems: `sync` semantics depend on the protocol and mount options (`nfs`, `cifs`); local flush may not equal server durability.

## Related Commands

- `dd` — block copy; pair with sync/fsync
- `umount` / `findmnt` — clean detach
- `mount -o sync` — mount with synchronous I/O (slow)
- `fsync` (syscall) / language APIs — per-fd durability
- `hdparm` / device caches — hardware write-cache caveats

## Additional Resources

- `man sync`
- `man 2 fsync`

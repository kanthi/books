# modprobe

## Overview

`modprobe` loads and unloads **kernel modules**, resolving dependencies via modules.dep — preferred over raw `insmod`/`rmmod` for daily admin. Pair with `lsmod` to see what is loaded and `dmesg` for driver messages.

## Syntax

```bash
sudo modprobe [options] module [module_options]
sudo modprobe -r module
```

## Common Options

| Option | Description |
|--------|-------------|
| `-r` / `--remove` | Unload module (+ unused deps) |
| `-v` | Verbose |
| `-n` | Dry-run |
| `-c` | Show config |
| `--show-depends` | Print dependency set |
| `-f` | Force (dangerous) |

## Safety

- Removing modules in use can fail or disrupt devices (`rmmod` may force more aggressively — still dangerous).  
- Blacklist broken modules via `/etc/modprobe.d/` rather than fighting boot.  
- Out-of-tree modules must match the running kernel.

## Examples with Explanations

### Load / unload

```bash
lsmod | head
sudo modprobe overlay
sudo modprobe -r overlay
```

### Dependencies

```bash
modprobe --show-depends xfs
```

### Module parameters

```bash
# example only — parameters are module-specific
sudo modprobe nfs nfsvers=4.2
modinfo nfs | less
```

### Blacklist (persist)

```bash
echo 'blacklist pcspkr' | sudo tee /etc/modprobe.d/blacklist-pcspkr.conf
```

### List available modules

```bash
find /lib/modules/"$(uname -r)" -name '*.ko*' | head
```

## Related Commands

- `lsmod` / `modinfo`  
- `rmmod` / `insmod` — low-level  
- `dmesg` — load errors  
- `uname -r` — running kernel  

## Additional Resources

- `man modprobe`  
- `modules.dep(5)`

# install

## Overview
`install` copies files with explicit mode/owner and optional directory creation. Preferred in Makefiles and packaging over `cp` + `chmod` + `mkdir -p` sequences.

## Syntax
```bash
install [options] SOURCE DEST
install [options] SOURCE... DIRECTORY
install -d [options] DIRECTORY...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Create directories |
| `-m MODE` | Set permission mode (e.g. 755) |
| `-o owner -g group` | Set ownership (requires rights) |
| `-t DIR` | Target directory |
| `-D` | Create leading dirs for DEST |
| `-b / -S` | Backup existing DEST |
| `-v` | Verbose |

## Key Use Cases
1. Install binaries to /usr/local/bin
2. Place config with correct mode
3. Create directory trees with mode
4. Reproducible packaging steps

## Examples with Explanations
### Install a script
```bash
sudo install -m 755 bin/tool /usr/local/bin/tool
```
Atomic-ish copy with mode in one step.

### Create a system directory
```bash
sudo install -d -m 755 /etc/myapp
```
Directory with known permissions.

### Config with ownership
```bash
sudo install -m 640 -o root -g adm myapp.conf /etc/myapp/myapp.conf
```
Drop privileges correctly for group-readable config.

### Leading path create
```bash
install -D -m 644 share/app.desktop ~/.local/share/applications/app.desktop
```
`-D` makes parent dirs as needed.

## Related Commands
- `cp` — general copy
- `mkdir` — directories only
- `rsync` — sync trees
- `install` in autotools/Makefiles — standard convention

# install

## Overview

`install` copies files with **explicit mode** (and optional owner/group) and can create destination directories. It is preferred in Makefiles, packaging, and deploy scripts over ad-hoc `cp` + `chmod` + `mkdir -p` sequences because intent is clear and modes are set in one step.

Despite the name, it is a userland coreutils program — not a package manager.

## Syntax

```bash
install [options] SOURCE DEST
install [options] SOURCE... DIRECTORY
install [options] -t DIRECTORY SOURCE...
install -d [options] DIRECTORY...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d`, `--directory` | Create directories (like `mkdir -p` with mode) |
| `-m MODE`, `--mode=MODE` | Permission mode (default often `755` for files historically — set explicitly) |
| `-o OWNER`, `-g GROUP` | Owner/group (requires privileges) |
| `-t DIR`, `--target-directory=DIR` | Destination directory |
| `-D` | Create leading components of DEST path |
| `-b` | Backup existing destination |
| `-S SUF` | Backup suffix |
| `-v` | Verbose |
| `-p` | Preserve timestamps (when supported) |
| `-C` | Install only if contents differ (compare; GNU) |
| `--strip` / `-s` | Strip symbol tables from binaries (toolchain) |

## Key Use Cases

1. Install binaries/scripts to `/usr/local/bin`
2. Drop configs with correct mode/owner
3. Create system directory trees with known permissions
4. Reproducible Makefile `make install` steps
5. Install unit files and server config snippets with correct modes

## Examples with Explanations

### Install a script or binary

```bash
sudo install -m 755 bin/tool /usr/local/bin/tool
sudo install -m 755 target/release/app /usr/local/bin/app
```

### Create directories

```bash
sudo install -d -m 755 /etc/myapp
sudo install -d -m 750 -o myapp -g myapp /var/lib/myapp
```

### Config with ownership

```bash
sudo install -m 640 -o root -g adm myapp.conf /etc/myapp/myapp.conf
```

### Leading path creation (systemd unit)

```bash
sudo install -D -m 644 myapp.service \
  /etc/systemd/system/myapp.service
sudo install -D -m 644 myapp.conf \
  /etc/myapp/myapp.conf
```

`-D` creates parent directories of the final DEST file.

### Multiple sources into a directory

```bash
sudo install -m 644 -t /etc/myapp/ conf.d/*.conf
```

### Compare before replace (GNU)

```bash
sudo install -C -m 644 app.conf /etc/myapp/app.conf
```

Avoids unnecessary writes/timestamp bumps when content is identical.

### Makefile fragment

```make
PREFIX ?= /usr/local
bindir ?= $(PREFIX)/bin

install:
	install -d $(DESTDIR)$(bindir)
	install -m 755 tool $(DESTDIR)$(bindir)/tool
```

### Versus cp

```bash
# verbose multi-step
mkdir -p /opt/app/bin
cp tool /opt/app/bin/tool
chmod 755 /opt/app/bin/tool

# one tool
install -D -m 755 tool /opt/app/bin/tool
```

## Notes / Pitfalls

- Default mode if you forget `-m` may not be what you want — **always set `-m`**.
- `-o`/`-g` need privileges; packaging often installs as root in `DESTDIR` then packages own metadata.
- `install` is not atomic across filesystems in a fancy way — still a copy into place; for live configs consider write-temp + `mv`.
- Stripping (`-s`) needs strip tools and is for binaries, not scripts.
- SELinux systems may need `restorecon` after install into labeled paths.

## 2026-relevant notes

- systemd unit installs: `install -D -m 644 unit /etc/systemd/system/` then `systemctl daemon-reload`.
- Prefer `%install`/`install` in packaging (RPM/deb helpers) with explicit modes for supply-chain clarity.
- User-level installs under `~/.local` pair well with XDG paths and no root.

## Related Commands

- `cp` — general copy
- `mkdir -p` — directories only
- `chmod` / `chown` — adjust after the fact
- `rsync` — sync trees
- `install` target in autotools/Meson/CMake — ecosystem convention
- `ln -s` — link instead of copy

## Additional Resources

- `man install`

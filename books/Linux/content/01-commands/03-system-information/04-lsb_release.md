# lsb_release

## Overview

`lsb_release` prints distribution identification claimed via the Linux Standard Base (LSB) interfaces and distro-specific release files. Still useful for quick “what am I on?” checks, but many modern tools prefer reading **`/etc/os-release`**, which is the freedesktop standard and always present on current systemd distros.

On some minimal images, `lsb_release` is not installed (`lsb-release` package).

## Syntax

```bash
lsb_release [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-v` | LSB modules / version info |
| `-i` | Distributor ID |
| `-d` | Description |
| `-r` | Release number |
| `-c` | Codename |
| `-a` | All of the above |
| `-s` | Short output (no headers) |

## Examples with Explanations

### Everyday

```bash
lsb_release -a
lsb_release -is
lsb_release -cs
lsb_release -rs
```

### Short for scripts

```bash
distro=$(lsb_release -is 2>/dev/null || true)
codename=$(lsb_release -cs 2>/dev/null || true)
```

### Prefer os-release (portable modern)

```bash
. /etc/os-release
echo "$ID $VERSION_ID $PRETTY_NAME"
# or
grep -E '^(ID|VERSION_ID|PRETTY_NAME)=' /etc/os-release
```

### Compare sources

```bash
lsb_release -a 2>/dev/null
cat /etc/os-release
hostnamectl | grep -i 'operating system'
```

### Install if missing

```bash
# Debian/Ubuntu
sudo apt install lsb-release
# Fedora
sudo dnf install redhat-lsb-core   # may be transitional / optional
```

Often unnecessary if you only need `os-release`.

## Notes / Pitfalls

- Not installed everywhere; scripts should fall back to `/etc/os-release`.
- Derived images and containers can customize IDs — trust but verify package availability separately.
- Codename strings differ (`jammy`, `bookworm`, `Trixie`) — don’t assume Ubuntu-only.
- LSB compliance fields (`-v`) are historical and less operationally useful today.
- Rolling releases may show unusual version strings.

## 2026-relevant notes

- **Canonical for automation:** `/etc/os-release` fields `ID`, `ID_LIKE`, `VERSION_ID`.
- Cloud images still include `lsb_release` sometimes for legacy install scripts.
- Prefer feature detection (`command -v`, `/etc/os-release`) over brittle distro name switches when possible.

## Related Commands

- `cat /etc/os-release` — standard identity
- `hostnamectl` — pretty OS string
- `uname` — kernel identity
- `cat /etc/debian_version` / `redhat-release` — legacy files
- package managers — `apt`/`dnf` confirm edition

## Additional Resources

- `man lsb_release`
- freedesktop os-release specification

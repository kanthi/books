# uname

## Overview

`uname` prints system information: kernel name, hostname/nodename, kernel release/version, machine hardware name, and sometimes processor/OS fields. Scripts use it to branch on architecture (`x86_64` vs `aarch64`) and kernel release.

## Syntax

```bash
uname [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a`, `--all` | All information in standard order |
| `-s`, `--kernel-name` | Kernel name (default if no options) e.g. `Linux` |
| `-n`, `--nodename` | Network node hostname |
| `-r`, `--kernel-release` | Kernel release e.g. `6.8.0-xx` |
| `-v`, `--kernel-version` | Kernel build version string |
| `-m`, `--machine` | Machine hardware name e.g. `x86_64`, `aarch64` |
| `-p`, `--processor` | Processor type (often `unknown` on Linux) |
| `-i`, `--hardware-platform` | Hardware platform (often `unknown`) |
| `-o`, `--operating-system` | OS name e.g. `GNU/Linux` |

## Examples with Explanations

### Everyday

```bash
uname
uname -a
uname -r
uname -m
```

### Architecture branching

```bash
case $(uname -m) in
  x86_64)  arch=amd64 ;;
  aarch64) arch=arm64 ;;
  armv7l)  arch=armhf ;;
  *) echo "unsupported: $(uname -m)" >&2; exit 1 ;;
esac
echo "download package for $arch"
```

### Kernel version checks

```bash
uname -r
# compare carefully — string sort ≠ version sort
printf '%s\n' "$(uname -r)" | sort -V
```

### vs os-release

```bash
uname -a
cat /etc/os-release
hostnamectl
```

`uname` is kernel-focused; distro identity lives in `/etc/os-release`.

### Container note

```bash
uname -r
# often shows the *host* kernel — containers share it
cat /etc/os-release   # container userspace
```

### Compact inventory line

```bash
printf '%s %s %s\n' "$(uname -s)" "$(uname -r)" "$(uname -m)"
```

## Notes / Pitfalls

- `-p`/`-i` frequently print `unknown` on Linux — use `-m`.
- Don’t parse `uname -a` as a stable API; request specific flags.
- Version compares need `sort -V` or proper version libraries.
- Different libc/coreutils may format fields slightly differently.
- WSL and custom kernels still report as Linux with distinctive release strings.

## 2026-relevant notes

- Multi-arch containers and ARM laptops make `uname -m` essential in install scripts.
- Long-term kernels vs mainline: check `uname -r` against CVE guidance for your distro package, not upstream only.
- Pair with `lscpu` for CPU features (`flags`) when deciding SIMD builds.

## Related Commands

- `hostname` / `hostnamectl` — host identity
- `cat /etc/os-release` — distro identity
- `lscpu` — CPU details
- `arch` — often alias-like to `uname -m`
- `hostnamectl` — pretty OS string on systemd

## Additional Resources

- `man uname`

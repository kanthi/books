# dnf

## Overview

`dnf` (Dandified YUM) is the primary high-level package manager on **Fedora, RHEL 8+, CentOS Stream, Rocky, AlmaLinux**, and related RPM distributions. This book is Ubuntu-first (`apt`), but operators routinely jump onto RHEL-family hosts — learn `dnf` as the counterpart to `apt`. It installs/removes RPM packages, resolves dependencies, and manages repositories/modules.

On older RHEL/CentOS 7 systems you will still see **`yum`**; on modern releases `yum` is often a compatibility symlink to `dnf`.

## Syntax

```bash
dnf [options] <command> [<args>...]
```

## Common commands

| Command | Description |
|---------|-------------|
| `install PKG…` | Install packages |
| `remove PKG…` | Remove packages |
| `reinstall PKG…` | Reinstall |
| `update` / `upgrade` | Apply updates (wording varies by version; both common) |
| `check-update` | List available updates without installing |
| `search KEYWORD` | Search names/descriptions |
| `info PKG` | Package metadata |
| `list` | List packages (`--installed`, `--available`, …) |
| `provides` / `whatprovides` | Which package owns a file/feature |
| `repoquery` | Advanced query (also `dnf repoquery`) |
| `repolist` | Enabled repositories |
| `makecache` | Refresh metadata |
| `clean all` | Clear caches |
| `history` | Transaction history / undo |
| `group install "Group Name"` | Environment/group packages |
| `module` | Modular streams (AppStream) |
| `distro-sync` | Sync to repo versions (powerful; careful) |
| `autoremove` | Remove unneeded deps (when supported) |

## Common options

| Option | Description |
|--------|-------------|
| `-y`, `--assumeyes` | Assume yes |
| `-q` | Quiet |
| `--refresh` | Force metadata refresh |
| `--enablerepo=ID` / `--disablerepo=ID` | Temporary repo toggles |
| `--setopt=` | Override config for this run |
| `--allowerasing` | Allow erasing conflicts to satisfy install |
| `--best` / `--nobest` | Strictness of version selection |
| `--security` | Prefer security updates where metadata allows |
| `--downloadonly` | Fetch without install |
| `--destdir=DIR` | With downloadonly, place RPMs here |

## Safety

- Read the **transaction summary** before accepting (package installs/removals).
- Avoid blind `dnf update -y` on production without a window and rollback plan.
- Third-party repos and modular stream switches can pin you into painful upgrades.
- `dnf history undo` is helpful but not magic after major version jumps or manual `rpm -Uvh` chaos.
- Prefer official AppStream modules over random COPR packages for critical runtimes.

## Key Use Cases

1. Install and update software on RHEL-family hosts
2. Map a binary path back to an owning package
3. Apply security updates selectively
4. Review and reverse recent transactions

## Examples with Explanations

### Example: refresh and update

```bash
sudo dnf check-update
sudo dnf upgrade
# older muscle memory:
sudo dnf update
```

`check-update` is a dry look at pending work. Confirm changelogs for kernel and glibc bumps.

### Example: install and remove

```bash
sudo dnf install htop jq curl
sudo dnf remove htop
```

Dependencies are resolved automatically. Removal may leave weak deps depending on config.

### Example: search and inspect

```bash
dnf search nginx
dnf info nginx
dnf list installed 'nginx*'
```

Non-root search/info works for most queries.

### Example: which package owns a file

```bash
dnf provides /usr/bin/ps
dnf provides '*/bin/htop'
```

Invaluable when a command is missing or two packages conflict.

### Example: repository visibility

```bash
dnf repolist
dnf repolist all
sudo dnf config-manager --set-enabled crb   # name varies by distro
```

Rocky/Alma often need CodeReady/CRB/PowerTools-style repos for extra build deps.

### Example: transaction history

```bash
dnf history
dnf history info 42
sudo dnf history undo 42
```

Undo a mistaken install when history still maps cleanly to reverse operations.

### Example: download only

```bash
sudo dnf download --resolve nginx
# or
sudo dnf install --downloadonly --destdir=/var/tmp/rpms nginx
```

Useful for air-gapped copies and change tickets that require artifact review.

### Example: groups and modules

```bash
dnf group list
sudo dnf group install "Development Tools"
dnf module list nodejs
sudo dnf module enable nodejs:18
sudo dnf module install nodejs:18/common
```

Modules select streams (versions) on RHEL-family AppStream — read stream notes before switching.

### Example: security-focused updates

```bash
sudo dnf update --security
sudo dnf updateinfo list security
```

Depends on repository updateinfo metadata quality.

### Example: clean caches

```bash
sudo dnf clean all
sudo dnf makecache
```

When metadata looks stale or disk under `/var/cache/dnf` is tight.

### Example: scripted noninteractive

```bash
sudo dnf -y install package-name
```

Still log transactions and pin versions when builds must be reproducible.

## Notes & Pitfalls

- This page is for **RPM-family** hosts; on Ubuntu use `apt` / `dpkg`.
- `yum` vs `dnf`: prefer `dnf` on modern systems; check `yum --version` if both exist.
- EPEL is common for extra packages — enable deliberately.
- Kernel updates need reboot; live patching may exist separately (kpatch, vendor tools).
- Mixing `rpm -e --nodeps` with dnf creates dependency debt — avoid.
- Proxy/SSL interception breaks metadata fetches; configure `/etc/dnf/dnf.conf` and repo files carefully.

## Related Commands

- `rpm` — low-level RPM query/install
- `yum` — legacy / symlink front-end
- `apt` / `dpkg` — Debian/Ubuntu counterparts
- `subscription-manager` — RHEL entitlements
- `needs-restarting` — which services/pids need restart after updates (yum-utils/dnf-utils)

## Additional Resources

- `man dnf`
- `man dnf.conf`
- Distribution docs: Fedora DNF guide, RHEL System Administrator’s Guide (packaging chapters)

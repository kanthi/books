# mkdir

## Overview

`mkdir` (make directory) creates new directories. With `-p` it creates parent paths as needed and does not error if the target already exists — the workhorse flag for scripts. Optional `-m` sets the mode for the created directory (subject to umask unless you understand the interaction).

## Syntax

```bash
mkdir [options] directory...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p`, `--parents` | Create parents; no error if existing |
| `-m MODE`, `--mode=MODE` | Set permission mode (e.g. `750`, `u+rwx`) |
| `-v`, `--verbose` | Print a line for each created directory |
| `-Z` | Set SELinux context (when SELinux enabled) |
| `--context=CTX` | Set complete SELinux context |

## Key Use Cases

1. Create project and deploy directory trees
2. Idempotent path ensure in scripts (`-p`)
3. Create with restrictive permissions (`-m 700`)
4. Batch-create sibling dirs with braces
5. Scaffold log/cache layouts

## Examples with Explanations

### Basics

```bash
mkdir project
mkdir dir1 dir2 dir3
mkdir -v newdir
```

### Parents

```bash
mkdir -p parent/child/grandchild
mkdir -p /var/lib/myapp/{data,cache,logs}
```

`mkdir -p` is safe to re-run: existing directories are left alone.

### Permissions

```bash
mkdir -m 755 public_dir
mkdir -m 700 private_dir
mkdir -m 750 secure_dir
# mode applies to the leaf created; with -p, behavior for parents is version-specific —
# set explicitly if parents need special modes:
mkdir -p -m 755 /srv/app
chmod 750 /srv/app
```

### Brace expansion scaffolds

```bash
mkdir -p logs/{app,nginx,db}
mkdir -p src/{cmd,internal,pkg} docs scripts
```

### Script: ensure writable data dir

```bash
#!/usr/bin/env bash
set -euo pipefail
DATA_DIR=${DATA_DIR:-/var/lib/myapp}
mkdir -p "$DATA_DIR"
chmod 750 "$DATA_DIR"
```

### SELinux (when relevant)

```bash
mkdir -Z /srv/webdata
# or restorecon after create on labeled systems
```

### Parallel with install

```bash
install -d -m 755 /opt/myapp/bin
install -d -m 700 /opt/myapp/secrets
```

`install -d` is often preferred in packaging for explicit modes.

### Failure cases

```bash
mkdir /proc/foo            # typically fails (pseudo-fs / perms)
mkdir /existing/file/sub   # fails if component is a file
```

## Notes / Pitfalls

- Without `-p`, existing directory → error; missing parent → error.
- **umask** affects final mode when you don’t fully specify bits; verify with `stat -c %a dir`.
- Race in concurrent scripts: two `mkdir` without `-p` can fail; prefer `-p` for idempotency.
- Creating under sticky dirs (`/tmp`) is fine; deleting others’ dirs there is not.
- NFS root_squash: creating as root may result in `nobody` ownership.

## 2026-relevant notes

- In containers, create runtime dirs in entrypoints with `-p` rather than baking empty layers unless needed for ownership.
- systemd `RuntimeDirectory=` / `StateDirectory=` can replace hand-rolled `mkdir` in unit files — prefer unit directives for services.
- Immutable systems may only allow mkdir on writable mounts (`/var`, `/home`, `/tmp`).

## Related Commands

- `rmdir` — remove empty directories
- `rm -r` — remove trees
- `install -d` — create dirs with mode/owner
- `chmod` / `chown` — adjust after create
- `mktemp -d` — secure temporary directories
- `ln -s` — link instead of nesting copies

## Additional Resources

- `man mkdir`
- [GNU coreutils — mkdir](https://www.gnu.org/software/coreutils/manual/html_node/mkdir-invocation.html)

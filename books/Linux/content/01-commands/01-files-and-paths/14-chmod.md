# chmod

## Overview

`chmod` changes file mode bits (permissions) and special bits (setuid, setgid, sticky). Modes can be **symbolic** (`u+x`, `go-rwx`) or **octal** (`755`, `640`). Ownership is separate — see `chown`. ACLs (`setfacl`) can grant additional access beyond the classic rwx triad.

## Syntax

```bash
chmod [options] mode[,mode]... file...
chmod [options] --reference=RFILE file...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-R`, `--recursive` | Recurse into directories |
| `-c` | Report only when a change is made |
| `-v` | Verbose every file |
| `-f` | Suppress most errors |
| `--reference=RFILE` | Copy mode from reference file |
| `-h` | Affect symlinks themselves where supported |

## Mode primer

| Octal digit | rwx meaning |
|-------------|-------------|
| `7` | rwx |
| `6` | rw- |
| `5` | r-x |
| `4` | r-- |
| `0` | --- |

Common whole modes:

| Mode | Typical use |
|------|-------------|
| `755` | Directories / public executables |
| `644` | Normal files |
| `600` | Private keys / secrets |
| `700` | Private directories |
| `640` | Group-readable configs |
| `4755` | setuid binary (rare; high risk) |
| `1777` | Sticky world-writable dir (`/tmp` style) |

Symbolic form: `who` + `op` + `perms`

- who: `u` (user), `g` (group), `o` (others), `a` (all)
- op: `+` add, `-` remove, `=` set exactly
- perms: `r`, `w`, `x`, `X`, `s`, `t`

## Safety

- Recursive `chmod -R 777` is almost always wrong on multi-user systems.
- Avoid setuid/setgid unless you fully understand the trust model.
- Directories need the execute bit to be entered (`x` on dirs = traverse).
- Prefer `find -type f/d` with separate modes over blind recursive octal.

## Examples with Explanations

### Octal

```bash
chmod 644 README.md
chmod 755 scripts/run.sh
chmod 600 ~/.ssh/id_ed25519
chmod 700 ~/.ssh
chmod 640 /etc/myapp/app.conf
```

### Symbolic

```bash
chmod u+x tool.sh
chmod go-rwx secret.txt
chmod a+r file.txt
chmod u=rwx,g=rx,o= file
chmod g+s shared_dir          # setgid directory
chmod +t /shared/uploads      # sticky
```

### Capital X (conditional execute)

```bash
chmod -R a+X project/         # add x to dirs and already-executable files
```

Useful to make trees traversable without making every file executable.

### Recursive the safe way

```bash
find ./public -type d -exec chmod 755 {} +
find ./public -type f -exec chmod 644 {} +
```

### Reference mode

```bash
chmod --reference=good.sh new.sh
```

### Diagnose

```bash
ls -l file
stat -c '%a %A %n' file
namei -l /path/to/file
```

### umask interaction (creation, not chmod)

```bash
umask
umask 022
touch newfile                 # typically 644
mkdir newdir                  # typically 755
```

`chmod` sets absolute/symbolic targets; `umask` affects default creation masks.

## Notes / Pitfalls

- Execute on directories: without `x`, you cannot `cd` into them even if `r` is set.
- `noexec` mount option blocks execution regardless of mode.
- ACLs may allow access that `ls -l` mode bits alone don’t explain — check `getfacl`.
- Copying with `cp` without `-p`/`-a` may drop modes; `install -m` is explicit.
- Root can chmod almost anything; wrong recursive mode on `/var/lib` causes outages.

## 2026-relevant notes

- Secrets: prefer `600`/`640` and dedicated system users; consider systemd `LoadCredential=` instead of world-readable files.
- Containers: mode bits still matter for processes sharing volumes; UIDs may be remapped.
- Git tracks executable bit only (`100755` vs `100644`), not full Unix modes — deploy with `install`/`chmod` in packaging.

## Related Commands

- `chown` / `chgrp` — ownership
- `umask` — default create mask
- `stat` — numeric mode
- `getfacl` / `setfacl` — ACLs
- `install -m` — copy with mode
- `ls -l` — human view
- `namei -l` — path component modes

## Additional Resources

- `man chmod`
- `info coreutils 'File permissions'`

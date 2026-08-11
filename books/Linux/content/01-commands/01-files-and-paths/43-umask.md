# umask

## Overview

`umask` sets the **file mode creation mask** for the current shell: bits that are turned *off* when new files and directories are created. It is a shell built-in (and a system call); this page covers the interactive/operator usage. Default Ubuntu login shells often use `0002` or `0022`.

## Syntax

```bash
umask [-p] [-S] [mode]
```

## Common Options

| Option | Description |
|--------|-------------|
| *(none)* | Print current mask (octal) |
| `-S` | Symbolic print (`u=rwx,g=rx,o=rx`) |
| `-p` | Print as a reusable `umask …` command |
| `mode` | Set mask (octal like `027` or symbolic) |

## Key Use Cases

1. Tighten default permissions for shared servers  
2. Understand why new files are `644` vs `664`  
3. Script sections that create secrets with stricter modes  

## Examples with Explanations

### Show current mask

```bash
umask
umask -S
```

### How mask applies

```bash
umask 022
touch /tmp/a; mkdir /tmp/d
ls -l /tmp/a /tmp/d
# file 666 & ~022 → 644; dir 777 & ~022 → 755
```

Base modes before umask: files `666`, directories `777` (exec bits matter for dirs).

### Stricter group isolation

```bash
umask 027
# new files 640, dirs 750 — others get nothing
```

### Secrets in a script

```bash
old=$(umask)
umask 077
install -m 600 /dev/null "$HOME/.config/myapp/token"
umask "$old"
```

Prefer `install -m` / explicit `chmod` for critical files; umask is a safety net.

### Persist for login shells

```bash
# ~/.profile or /etc/profile.d/umask.sh
umask 027
```

systemd user services and cron jobs may **not** read your interactive profile — set umask there too if needed.

## Notes & Pitfalls

- umask does not change existing files (`chmod` does).  
- ACLs default masks on directories can further alter effective rights.  
- Numeric umask is **not** the resulting mode; it is the bits stripped from the base.  
- BusyBox/dash vs bash symbolic forms can differ slightly.

## Related Commands

- `chmod` / `chown` — explicit modes/ownership  
- `install` — create files with mode in one step  
- `getfacl` / `setfacl` — ACL defaults for shared dirs  
- `stat` — inspect resulting mode  

## Additional Resources

- `help umask` (bash)  
- `man 2 umask`

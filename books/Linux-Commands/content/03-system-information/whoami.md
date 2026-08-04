# whoami

## Overview

`whoami` prints the **effective** username of the current user. It is a tiny identity check for scripts and for noticing when `sudo`/`su` changed who you are. For full identity (uid, gid, groups) use `id`. For login name from the controlling terminal, see `logname` (different edge cases).

## Syntax

```bash
whoami [OPTION]
# usually no options needed
```

## Common Options

| Option | Description |
|--------|-------------|
| `--help` | Help |
| `--version` | Version |

## Key Use Cases

1. Confirm effective user in a shell
2. Guard scripts that must (or must not) run as root
3. Annotate logs with actor name
4. Verify `sudo -u` targets

## Examples with Explanations

### Basics

```bash
whoami
sudo whoami                 # usually root
sudo -u nobody whoami
su - alice -c whoami
```

### Script guards

```bash
if [ "$(whoami)" != root ]; then
  echo "run as root" >&2
  exit 1
fi

# prefer numeric for reliability:
if [ "$(id -u)" -ne 0 ]; then
  echo "run as root" >&2
  exit 1
fi
```

### Contrast with id / logname

```bash
whoami
id -un                      # equivalent effective username
id
logname                     # user logged on the tty (may differ)
```

After `sudo -s`, `whoami` is `root` while `logname` may still show the original login user.

### Logging

```bash
echo "$(date -Is) user=$(whoami) action=deploy" >> deploy.log
```

### Containers

```bash
whoami
id
# USER instruction in Dockerfile determines default
```

## Notes / Pitfalls

- Reflects **effective** ids (setuid binaries can change this).
- Prefer `id -u` for root checks — numeric, locale-proof.
- Not a substitute for authentication/authorization in applications.
- May print `I have no name!` style issues only via related tools when passwd entry missing; `whoami` uses libc name lookup.

## 2026-relevant notes

- In Kubernetes/pods, check whether the container runs as non-root (`whoami` / `id`).
- Rootless Podman maps users — names inside may differ from host.
- Automation should key off uid numbers stored in configs, not display names alone.

## Related Commands

- `id` — full identity
- `logname` — login name from utmp
- `who` / `w` — logged-in sessions
- `sudo` / `su` — change user
- `getent passwd` — account database

## Additional Resources

- `man whoami`

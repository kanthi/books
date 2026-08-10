# ssh-copy-id

## Overview

`ssh-copy-id` installs your public key on a remote account’s `~/.ssh/authorized_keys` with safer permissions than hand-copying. Prefer it over pasting keys via ad-hoc `echo >>` when the remote still allows password auth for bootstrap.

## Syntax

```bash
ssh-copy-id [options] [user@]host
ssh-copy-id -i key.pub user@host
```

## Common Options

| Option | Description |
|--------|-------------|
| `-i key` | Public key file (default: first available id_*.pub) |
| `-p port` | SSH port |
| `-o Opt=Val` | Pass through to ssh |
| `-f` | Force add without duplicate check (implementation-dependent) |
| `-n` | Dry-run (where supported) |

## Safety

- Still authenticates once with the remote password (or existing key).  
- Review remote `authorized_keys` after install.  
- Do not use world-writable home or `.ssh` directories — sshd will ignore keys.

## Examples with Explanations

### Default identity

```bash
ssh-copy-id alice@server.example.com
ssh alice@server.example.com
```

### Explicit key and port

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2222 alice@server.example.com
```

### Via ProxyJump

```bash
ssh-copy-id -o ProxyJump=bastion.example.com alice@internal
```

### Manual equivalent (when tool missing)

```bash
cat ~/.ssh/id_ed25519.pub | ssh alice@server \
  'umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys'
```

## Notes & Pitfalls

- Multiple keys: specify `-i` so the wrong identity is not installed.  
- Some hardened images disable passwords — need console/cloud-init to place the first key.  
- SELinux contexts on `~/.ssh` can block access until restored.

## Related Commands

- `ssh-keygen` — create keys  
- `ssh` — connect  
- `getent passwd` — confirm remote home path  

## Additional Resources

- `man ssh-copy-id`

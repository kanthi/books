# ssh-keygen

## Overview

`ssh-keygen` creates and manages SSH key pairs, fingerprints host keys, and can update `known_hosts`. Modern default is **Ed25519**; RSA remains for legacy peers. Key management is the foundation of safe automation and admin access.

## Syntax

```bash
ssh-keygen [options]
ssh-keygen -t ed25519 -C 'comment' -f path
ssh-keygen -lf key.pub
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t type` | `ed25519`, `rsa`, `ecdsa`, … |
| `-b bits` | RSA bit length (e.g. 4096) |
| `-C comment` | Comment (often email) |
| `-f file` | Output path (private key) |
| `-N passphrase` | Passphrase (empty for none — automation only with care) |
| `-lf file` | Show fingerprint |
| `-y` | Derive public key from private |
| `-p` | Change passphrase |
| `-R host` | Remove host from known_hosts |
| `-F host` | Find host key in known_hosts |
| `-A` | Generate missing host keys (on servers) |

## Safety

- Private keys stay mode `600` and never leave your control.  
- Prefer passphrases + `ssh-agent` over unprotected keys on laptops.  
- Automation keys: scope with `authorized_keys` options (`from=`, `command=`, `restrict`).  
- Rotate and revoke by removing the public line from `authorized_keys`.

## Examples with Explanations

### Create an Ed25519 key

```bash
ssh-keygen -t ed25519 -C 'you@example.com' -f ~/.ssh/id_ed25519
```

### RSA for legacy only

```bash
ssh-keygen -t rsa -b 4096 -C 'legacy' -f ~/.ssh/id_rsa_legacy
```

### Fingerprint

```bash
ssh-keygen -lf ~/.ssh/id_ed25519.pub
ssh-keygen -E md5 -lf ~/.ssh/id_ed25519.pub   # older tooling compares MD5
```

### Fix / inspect known_hosts

```bash
ssh-keygen -F github.com
ssh-keygen -R old-server.example.com
```

### Public key from private

```bash
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

## Related Commands

- `ssh` / `ssh-copy-id` — use and install keys  
- `ssh-agent` / `ssh-add` — unlock keys in memory  
- `chmod` — enforce `700` on `~/.ssh`, `600` on private keys  

## Additional Resources

- `man ssh-keygen`  
- OpenSSH release notes on default algorithms

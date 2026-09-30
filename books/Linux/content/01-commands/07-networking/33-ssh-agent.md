# ssh-agent / ssh-add

## Overview

`ssh-agent` holds decrypted private keys in memory so you unlock a passphrase-protected identity once per session instead of on every `ssh`/`scp`/`rsync`/`git` connection. `ssh-add` loads, lists, locks, and removes those identities. Use the agent on workstations and jump hosts you control; do **not** treat agent forwarding (`ssh -A`) as a convenience default — it extends trust to every host that can reach the forwarded socket.

Prefer passphrase-protected keys in the agent over unencrypted private keys on disk. For automation on servers, scoped `authorized_keys` options usually beat long-lived agent sessions.

## Syntax

```bash
ssh-agent [-c|-s] [-Dd] [-a bind_address] [-t life] [command [arg ...]]
ssh-agent [-c|-s] -k

ssh-add [-cDdLlXx] [-t life] [-h constraint] [file ...]
ssh-add -T pubkey...
```

Bourne shells start an agent and import its environment with:

```bash
eval "$(ssh-agent -s)"
```

## Common Options

### ssh-agent

| Option | Description |
|--------|-------------|
| `-s` | Print Bourne-shell `export` lines (default for bash/zsh) |
| `-c` | Print C-shell `setenv` lines |
| `-k` | Kill the agent named by `SSH_AGENT_PID` |
| `-a path` | Bind the UNIX-domain socket to an explicit path |
| `-t life` | Default max lifetime for identities (seconds or `sshd_config` time format, e.g. `8h`) |
| `-D` | Foreground (no fork) — useful under systemd |
| `-d` | Debug + no fork |
| `command …` | Run a subprocess; agent exits when that command exits |

### ssh-add

| Option | Description |
|--------|-------------|
| *(no args)* | Add default identities (`~/.ssh/id_ed25519`, `id_rsa`, …) |
| `file` | Add a specific private key (and matching `-cert.pub` if present) |
| `-l` | List fingerprints of loaded identities |
| `-L` | List public keys of loaded identities |
| `-d` | Delete listed identities (paths to keys/`.pub`, or defaults if no args) |
| `-D` | Delete **all** identities |
| `-t life` | Lifetime for this add (overrides agent default) |
| `-c` | Require confirmation (via `ssh-askpass`) before each use |
| `-x` / `-X` | Lock / unlock the agent with a password |
| `-h constraint` | Destination-constrain the key (OpenSSH 8.9+) |
| `-T pubkey…` | Sign/verify test that matching private keys are usable |
| `-q` | Quiet on success |

### Client config that cooperates with the agent

| `~/.ssh/config` | Effect |
|-----------------|--------|
| `AddKeysToAgent yes` | First use of a key file loads it into a running agent |
| `AddKeysToAgent confirm` | Like `yes`, but each use needs confirmation |
| `IdentityAgent path` | Use this socket (overrides `SSH_AUTH_SOCK`; `none` disables) |
| `IdentitiesOnly yes` | Offer only configured/`-i` keys — avoids “too many authentication failures” when the agent holds many keys |
| `ForwardAgent no` | Safe default; never enable globally |

## Safety

- **Agent forwarding (`ssh -A` / `ForwardAgent yes`)** lets a compromised remote host request signatures from your local agent for as long as the session lasts. Prefer ProxyJump / `ProxyCommand` over forwarding. If you must forward, constrain keys with `ssh-add -h` and keep lifetimes short (`-t`).
- Anyone who can talk to `SSH_AUTH_SOCK` (same UID, or root) can use your loaded keys. Lock with `ssh-add -x` when stepping away; clear with `ssh-add -D` after sensitive work.
- Do not start nested agents blindly in every shell — orphan agents leave sockets and PIDs around. Prefer one agent per login session (desktop session, systemd user unit, or explicit `eval`).
- Passphrases never leave the machine that runs the agent; only signature requests travel over a forwarded channel. That still means a malicious remote can authenticate *as you* to other hosts while the forward is up.

## Key Use Cases

1. Unlock a passphrase-protected Ed25519 key once, then SSH to many hosts.
2. Keep several identities loaded and select with `IdentitiesOnly` + `IdentityFile`.
3. Time-box keys for a maintenance window (`ssh-add -t 2h`).
4. Avoid agent forwarding by using `ProxyJump` for bastion workflows.
5. Lock the agent on a shared workstation between tasks.

## Examples with Explanations

### Example: start an agent and add a key

```bash
eval "$(ssh-agent -s)"
# Agent pid 18421

ssh-add ~/.ssh/id_ed25519
# Enter passphrase for /home/alice/.ssh/id_ed25519:
# Identity added: /home/alice/.ssh/id_ed25519 (alice@laptop)

ssh-add -l
# 256 SHA256:AbCdEf... /home/alice/.ssh/id_ed25519 (ED25519)
```

`eval` imports `SSH_AUTH_SOCK` and `SSH_AGENT_PID` into the current shell. Subsequent OpenSSH clients in that environment ask the agent instead of reading the private key file (and prompting) on every connect.

### Example: confirm the environment is wired

```bash
echo "$SSH_AUTH_SOCK"
# /tmp/ssh-XXXXXX/agent.18420

ssh-add -l >/dev/null && echo 'agent reachable' || echo 'no agent (exit 2)'
```

`ssh-add` exits **2** when it cannot contact an agent — useful in scripts and shell prompts.

### Example: time-limited identity for a change window

```bash
ssh-add -t 2h ~/.ssh/id_ed25519_ops
ssh-add -l
# … (expires in ~2 hours)
```

After the lifetime, the agent drops the key; the next use prompts again (or fails if you rely only on the agent). Pair with a matching short change window.

### Example: list, remove one key, or clear all

```bash
ssh-add -L                          # full public keys (pasteable)
ssh-add -d ~/.ssh/id_ed25519.pub    # remove one identity
ssh-add -D                          # remove everything
```

`-d` accepts private key paths or `.pub` paths; if the path has no `.pub` sibling it retries with `.pub` appended.

### Example: AddKeysToAgent on first use

```bash
# ~/.ssh/config
Host *.example.com
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  AddKeysToAgent yes
  ForwardAgent no
```

```bash
eval "$(ssh-agent -s)"   # once per session
ssh bastion.example.com  # prompts for passphrase once; agent keeps the key
ssh app1.example.com     # reuses the agent — no second passphrase
```

`IdentitiesOnly yes` stops ssh from trying every agent key before the intended `IdentityFile`, which is a common cause of `Too many authentication failures`.

### Example: prefer ProxyJump over agent forwarding

```bash
# Good: auth from the laptop to both hops; no remote sees your agent
ssh -J bastion.example.com alice@app.internal.example.com

# ~/.ssh/config equivalent
Host app-internal
  HostName app.internal.example.com
  User alice
  ProxyJump bastion.example.com
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ForwardAgent no
```

```bash
# Avoid unless you understand the blast radius
ssh -A bastion.example.com   # remote can request signatures from your agent
```

With ProxyJump, OpenSSH authenticates each hop from your client. With `-A`, the bastion (and anything that can access the forwarded socket there) can use your loaded keys.

### Example: destination-constrained key (OpenSSH 8.9+)

```bash
# Allow this key only when authenticating to git.example.com
ssh-add -h git.example.com ~/.ssh/id_ed25519_git

# Allow use via bastion → internal (both hops must match)
ssh-add -h 'bastion.example.com>alice@app.internal.example.com' \
  ~/.ssh/id_ed25519_ops
```

Constraints are enforced by a cooperating agent and client. They reduce damage from forwarding but are **not** a substitute for `ForwardAgent no` as the default.

### Example: lock the agent while you step away

```bash
ssh-add -x          # set an agent lock password
# … leave the desk …
ssh-add -X          # unlock
```

While locked, the agent refuses signature requests until unlocked. This is orthogonal to key lifetimes.

### Example: kill a manually started agent

```bash
ssh-agent -k
# unset SSH_AUTH_SOCK;
# unset SSH_AGENT_PID;
# echo Agent pid 18421 killed;
```

Only works when `SSH_AGENT_PID` points at that agent. Desktop/session agents managed by systemd or a display manager should be stopped via that service, not `-k` from a random shell.

### Example: systemd user unit sketch (persistent per login)

On Ubuntu Server / workstations with systemd user sessions, a common pattern is a user service that runs `ssh-agent -D` and exposes the socket under `$XDG_RUNTIME_DIR`, then points clients with:

```bash
# ~/.ssh/config
Host *
  AddKeysToAgent yes
  IdentityAgent $XDG_RUNTIME_DIR/ssh-agent.socket
```

Wire the exact unit file to your distro’s docs; the important operator contract is **one socket path** exported (or set via `IdentityAgent`) for all shells in the session.

## Understanding Output

| Check | Meaning |
|-------|---------|
| `ssh-add -l` → fingerprints | Identities loaded and usable |
| `ssh-add -l` → `The agent has no identities.` | Agent up, empty — run `ssh-add` |
| `ssh-add -l` exit 2 / “Could not open a connection…” | No reachable agent (`SSH_AUTH_SOCK` wrong or dead) |
| `ssh -v` lines mentioning `Offering public key` / `Server accepts key` | Client is using a key (from file or agent) |

Fingerprints default to SHA256; use `ssh-add -E md5 -l` only when comparing against older inventory that still prints MD5.

## Notes & Pitfalls

- **Nested `eval "$(ssh-agent -s)"` in every new terminal** creates orphan agents. Start once per graphical/login session, or use a systemd user socket, then inherit `SSH_AUTH_SOCK`.
- **tmux/screen** panes may not see an agent started in another pane unless you export/refresh `SSH_AUTH_SOCK` (or use a stable socket path under `$XDG_RUNTIME_DIR`).
- **Many keys in the agent** without `IdentitiesOnly` causes servers with `MaxAuthTries` to reject you before the right key is offered.
- **macOS** may integrate with the Keychain (`UseKeychain` / `--apple-use-keychain`); those flags are not portable to Linux — stick to OpenSSH options here.
- **Debian/Ubuntu** historically install `ssh-agent` setgid to harden against ptrace stealing key material; unusual `LD_*` / `TMPDIR` behavior can surprise custom wrappers.
- FIDO/hardware keys (`sk` types) and PKCS#11 tokens have extra `ssh-add` flags (`-K`, `-S`, `-s`); treat them as specialized paths after the basic file-based workflow works.

## Common Usage Patterns

```bash
# Session bootstrap (interactive laptop)
eval "$(ssh-agent -s)"
ssh-add -t 8h ~/.ssh/id_ed25519

# Verify before a deploy burst
ssh-add -l
ssh -o BatchMode=yes alice@app1 true && echo ok

# End of sensitive work
ssh-add -D
```

## Related Commands

- `ssh-keygen` — create and fingerprint key pairs
- `ssh-copy-id` — install a public key on a remote account
- `ssh` — client; `ProxyJump`, `ForwardAgent`, `IdentityAgent`, `AddKeysToAgent`
- `scp` / `sftp` / `rsync` — reuse the same agent over SSH transports

## Additional Resources

- `man ssh-agent`, `man ssh-add`, `man ssh_config` (Ubuntu 24.04 / OpenSSH as shipped)
- OpenSSH release notes for destination constraints (8.9+) and agent defaults

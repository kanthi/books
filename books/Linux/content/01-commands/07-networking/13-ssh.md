# ssh

## Overview
`ssh` (OpenSSH client) creates encrypted sessions to a remote host for shell access, command execution, port forwarding, and tunneling. Pair with `scp`/`sftp`/`rsync` for files.

## Syntax
```bash
ssh [options] [user@]host [command]
ssh -J jump user@host
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i key` | Private key identity file |
| `-p port` | Remote port (default 22) |
| `-L` / `-R` / `-D` | Local / remote / dynamic port forwards |
| `-N` | No remote command (forward only) |
| `-f` | Background after auth |
| `-A` | Agent forwarding (use sparingly) |
| `-J host` | ProxyJump |
| `-o Opt=Val` | Config override |
| `-v` / `-vv` | Debug auth/connection |
| `-t` | Force TTY |
| `-C` | Compression |

## Key Use Cases
1. Remote administration  
2. Run one-shot remote commands  
3. Port forwards to private services  
4. Jump-host (bastion) workflows  

## Safety
- Prefer keys over passwords; disable agent forwarding except when required.  
- Verify host keys on first connect; investigate changed key warnings (possible MITM).  
- Do not forward agent (`-A`) to untrusted hosts.  

## Examples with Explanations
### Login
```bash
ssh alice@server.example.com
ssh -i ~/.ssh/id_ed25519 alice@server.example.com
```

### Remote command
```bash
ssh alice@server 'hostname; uptime'
```

### Custom port / options
```bash
ssh -p 2222 -o ConnectTimeout=5 alice@server
```

### ProxyJump via bastion
```bash
ssh -J bastion.example.com alice@internal.example.com
# config equivalent: ProxyJump bastion.example.com
```

### Local port forward (remote DB to local)
```bash
ssh -N -L 5432:127.0.0.1:5432 alice@server
# then connect local clients to localhost:5432
```

### Dynamic SOCKS proxy
```bash
ssh -N -D 1080 alice@server
```

### Config file (~/.ssh/config)
```bash
Host prod
  HostName 203.0.113.10
  User deploy
  IdentityFile ~/.ssh/prod_ed25519
  ForwardAgent no
```
```bash
ssh prod
```

### Verbose auth debug
```bash
ssh -vv alice@server
```

## Common Usage Patterns
### Copy key (once)
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub alice@server
```

### Escape sequence (client)
`Enter ~ .` disconnects a wedged session; `Enter ~ ?` lists escapes.

## Notes & Pitfalls
- `user@host` defaults user to local username if omitted.  
- Global known hosts: `~/.ssh/known_hosts`.  
- Multiplexing: `ControlMaster` / `ControlPath` speeds repeated connections.  

## Related Commands
- `scp` / `sftp` — file copy  
- `rsync -e ssh` — efficient sync  
- `ssh-keygen` — key pairs  
- `sshd` / `sshd_config` — server side  

## Additional Resources
- `man ssh`, `man ssh_config`

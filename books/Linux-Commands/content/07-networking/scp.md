# scp

## Overview
`scp` copies files over SSH. Simple and ubiquitous; for large trees or resumes, prefer **`rsync -e ssh`**. OpenSSH 9+ uses SFTP protocol under the hood for `scp`.

## Syntax
```bash
scp [options] source... destination
```

Sources/destinations: `file`, `user@host:path`, `user@host:dir/`.

## Common Options
| Option | Description |
|--------|-------------|
| `-r` | Recursive |
| `-p` | Preserve mtime/mode |
| `-P port` | SSH port (**capital P**) |
| `-i key` | Identity file |
| `-C` | Compression |
| `-q` | Quiet |
| `-v` | Verbose |
| `-l limit` | Kbit/s bandwidth limit |
| `-o Opt=Val` | Pass SSH config |

## Safety
Remote paths can overwrite files. Quote remote paths with spaces carefully. Host key verification still applies (`known_hosts`).

## Examples with Explanations
### Local → remote
```bash
scp report.pdf alice@server:/var/tmp/
scp -i ~/.ssh/id_ed25519 report.pdf alice@server:
```

### Remote → local
```bash
scp alice@server:/var/log/app.log ./
scp -r alice@server:/etc/myapp/ ./myapp-backup/
```

### Non-default port
```bash
scp -P 2222 file alice@server:/tmp/
```

### Multiple files
```bash
scp file1 file2 alice@server:/tmp/
```

### Through jump host
```bash
scp -o ProxyJump=bastion file alice@internal:/tmp/
```

### Prefer rsync for trees
```bash
rsync -av -e ssh project/ alice@server:project/
```

## Notes
- `-P` is port for scp; ssh uses `-p`.  
- Remote→remote copies still stream via your client in classic modes.  
- For interactive filesystem browsing use `sftp`.

## Related Commands
- `rsync` — delta sync  
- `sftp` — interactive  
- `ssh` — login  
- `tar` over ssh — stream archives

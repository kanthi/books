# sftp

## Overview

`sftp` is the interactive SSH file-transfer client (SFTP subsystem). Prefer it over legacy `ftp`/`telnet` for remote file work; for scripted bulk sync, prefer `rsync` or `scp`/`sftp` batch modes. Uses the same auth and config as `ssh`.

## Syntax

```bash
sftp [options] [user@]host
sftp [options] -b batchfile [user@]host
```

## Common Options

| Option | Description |
|--------|-------------|
| `-i key` | Private key |
| `-P port` | Port (note capital **P**, unlike ssh’s `-p`) |
| `-o Opt=Val` | ssh options (`ProxyJump`, …) |
| `-b file` | Batch commands from file |
| `-a` | Attempt to continue interrupted downloads (where supported) |
| `-r` | Recursive for `get`/`put` in modern OpenSSH |

## Examples with Explanations

### Interactive session

```bash
sftp alice@server.example.com
# sftp> ls
# sftp> get remote.txt
# sftp> put local.txt /var/tmp/
# sftp> bye
```

### Batch download

```bash
cat > /tmp/sftp.batch <<'EOF'
cd /var/backups
lcd /tmp
get -r weekly/
bye
EOF
sftp -b /tmp/sftp.batch alice@server
```

### Jump host

```bash
sftp -o ProxyJump=bastion.example.com alice@internal
```

### Non-interactive one-shot via ssh

```bash
ssh alice@server 'cat /etc/os-release' > os-release.txt
rsync -av alice@server:/var/www/ ./www-mirror/
```

Often clearer than SFTP batch for automation.

## Notes & Pitfalls

- Port flag is `-P` for sftp/scp historical reasons.  
- Recursive behavior and resume support vary by OpenSSH version.  
- File modes/ownership on put depend on remote umask and SSH config.

## Related Commands

- `scp` — simple remote copy  
- `rsync` — efficient sync  
- `ssh` — remote shell  
- `rclone` — multi-cloud sync if installed  

## Additional Resources

- `man sftp`  
- `man sftp-server`

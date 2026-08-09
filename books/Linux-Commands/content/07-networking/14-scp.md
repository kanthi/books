# scp

## Overview
`scp` (secure copy) copies files to or from a remote host over SSH. It is simple and available almost everywhere, but it is **not** a sync tool: every run re-transfers whole files. For large trees, resumes, and mirrors, prefer `rsync` over SSH. On modern OpenSSH, `scp` uses the SFTP protocol under the hood by default.

## Syntax
```bash
scp [OPTIONS] SOURCE... DEST
# SOURCE or DEST can be: local path  or  [user@]host:[path]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r` | Recursive (directories) |
| `-P port` | SSH port (**capital** `-P`; not `-p`) |
| `-i identity` | Private key file |
| `-C` | Compression |
| `-p` | Preserve mtime and modes |
| `-q` | Quiet (less progress noise) |
| `-v` | Verbose (debug SSH/auth) |
| `-l limit` | Bandwidth limit in **kbit/s** |
| `-o Opt=Val` | Pass SSH option (e.g. `ProxyJump`) |
| `-3` | Copy between two remotes via local host |

## Safety
- `scp` overwrites destination files without an interactive “are you sure?” for normal paths — double-check remote paths.
- Do not embed passwords in scripts; use keys and `ssh-agent`.
- Recursively copying into the wrong remote directory can fill disks; test with a single file first.
- Prefer explicit paths (`user@host:/var/tmp/file`) over relying on remote home defaults when automating.

## Examples with Explanations
### Local → remote file
```bash
scp ./report.pdf alice@server.example.com:~/uploads/
```

### Remote → local
```bash
scp alice@server:/var/log/nginx/access.log ./access.log
```

### Directory tree
```bash
scp -r ./site alice@server:/var/www/
```
Copies the `site` directory as `/var/www/site` (unless you structure paths carefully).

### Custom port and key
```bash
scp -P 2222 -i ~/.ssh/deploy_ed25519 \
  ./app.tgz deploy@server:/opt/releases/
```
Remember: **`-P`** for port on `scp`; **`ssh`/`rsync` use `-p`**.

### Preserve times/modes
```bash
scp -p config.yml alice@server:/etc/myapp/config.yml
```

### Via jump host (bastion)
```bash
scp -o ProxyJump=bastion.example.com \
  ./secret.env alice@internal:/tmp/
```
Or with OpenSSH `ProxyJump` in `~/.ssh/config` under a `Host` alias, then:
```bash
scp ./secret.env internal:/tmp/
```

### Bandwidth-limited copy
```bash
scp -l 8000 large.iso alice@server:/data/
```
`8000` ≈ 8 Mbit/s (~1 MB/s). Units are kilobits per second.

### Multiple sources to a remote directory
```bash
scp a.conf b.conf c.conf alice@server:/etc/myapp/
```

### Remote-to-remote through your laptop
```bash
scp -3 alice@host-a:/data/file bob@host-b:/data/file
```
Useful when hosts cannot talk to each other directly.

### Verbose debug when auth fails
```bash
scp -v ./file alice@server:~/
```

## Understanding Output
By default `scp` shows a progress meter per file (name, percent, speed, ETA). `-q` suppresses most of that. Failures print to stderr; non-zero exit means the copy did not fully succeed — check partial remote files.

## Notes & Pitfalls
- **Port flag case:** `scp -P 2222` vs `ssh -p 2222`. Mixing them is a common ops mistake.
- Spaces in paths need quoting on both local shell and careful remote escaping:
  ```bash
  scp './My File.txt' 'alice@server:./My File.txt'
  ```
- `scp` is poor at resume: interrupt a multi-GB transfer and you usually start over. Use `rsync -P` instead.
- Recursive `scp` does not delete extraneous remote files (not a mirror).
- Older docs mention `scp`’s legacy RCP-based protocol; current Ubuntu OpenSSH prefers SFTP mode. If a weird old device fails, check `man scp` for `-O` (legacy mode) on your version.
- Globs expand **locally** unless quoted for the remote shell. `scp server:*.log .` may not do what you want; often better: `ssh server 'tar czf - /var/log/*.log' | tar xzf -`.

## Related Commands
- `rsync -e ssh` — delta sync, dry-run, delete, resume-friendly
- `sftp` — interactive SSH file transfer
- `ssh` — remote shell / one-shot commands
- `install` / `install -D` — local install with mode control
- `tar` + `ssh` — stream many files efficiently

## Additional Resources
- `man scp`
- `man ssh_config` (ProxyJump, IdentityFile, Host aliases)

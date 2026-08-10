# restorecon

## Overview

`restorecon` restores the default **SELinux file contexts** for paths based on policy file-context rules. First fix when a moved/copied file is denied because it carries the wrong label (`httpd` cannot read a file labeled `user_home_t`, etc.).

## Syntax

```bash
sudo restorecon [options] path...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-v` | Verbose (show changes) |
| `-R` | Recursive |
| `-F` | Force reset  
| `-n` | Dry-run (no change) |
| `-e dir` | Exclude directory |

## Examples with Explanations

### Fix a web tree after rsync/mv

```bash
sudo restorecon -Rv /var/www/html
ls -Z /var/www/html | head
```

### Dry-run

```bash
sudo restorecon -Rvn /srv/data
```

### Single file after manual copy

```bash
sudo cp ~/index.html /var/www/html/
sudo restorecon -v /var/www/html/index.html
```

## Notes & Pitfalls

- `cp -a` preserves contexts; `mv` within a filesystem keeps labels that may be wrong for the destination type.  
- Custom paths may need `semanage fcontext` **before** restorecon will apply the right type.  
- On Ubuntu/AppArmor systems this tool may be absent or irrelevant.

## Related Commands

- `chcon` — temporary/manual context (prefer restorecon + semanage)  
- `ls -Z` / `id -Z` — show contexts  
- `setenforce` / `getenforce`  
- `semanage fcontext`  

## Additional Resources

- `man restorecon`  
- `man semanage-fcontext`

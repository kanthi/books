# chmod

## Overview
`chmod` changes file mode bits (permissions) and optionally executable/setuid bits. Modes can be **symbolic** (`u+x`) or **octal** (`755`).

## Syntax
```bash
chmod [options] mode[,mode]... file...
chmod [options] --reference=RFILE file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-R` | Recursive |
| `-c` | Report only when a change is made |
| `-v` | Verbose |
| `--reference=RFILE` | Copy mode from reference file |

## Mode primer
| Octal | Meaning (rwx) |
|------|----------------|
| `7` | rwx |
| `6` | rw- |
| `5` | r-x |
| `4` | r-- |
| `0` | --- |

Common: `755` = u=rwx,go=rx; `644` = u=rw,go=r; `600` = u=rw.

Symbolic: `u`/`g`/`o`/`a` + `-`/`+`/`=` + `r`/`w`/`x`/`X`/`s`/`t`.

## Safety
Recursive `chmod -R 777` is almost always wrong and dangerous on multi-user systems. Avoid setuid (`u+s`) unless you understand the security model. Directories need execute bit to be entered.

## Examples with Explanations
### Octal modes
```bash
chmod 644 README.md
chmod 755 scripts/run.sh
chmod 600 ~/.ssh/id_ed25519
```

### Symbolic
```bash
chmod u+x tool.sh
chmod go-rwx secret.txt
chmod a+r file.txt
chmod u=rwx,g=rx,o= file
```

### Recursive (careful)
```bash
find ./public -type d -exec chmod 755 {} +
find ./public -type f -exec chmod 644 {} +
```
Prefer typed find over blind `chmod -R 755`.

### Reference
```bash
chmod --reference=good.sh new.sh
```

### Directory execute for traverse only
```bash
chmod 711 $HOME   # common for home that allows path traversal to public_html
```

## Understanding Output
Usually silent on success. Use `-c`/`-v` to see changes. Mode is visible in `ls -l` (e.g. `-rwxr-xr-x`) and `stat`.

## Notes & Pitfalls
- Execute bit on directories = enter/list semantics (with read).  
- `X` (capital) sets execute only if directory or already executable for some.  
- ACLs (`setfacl`) can extend beyond classic mode bits.  
- Mount options (`noexec`) can block execution regardless of mode.  

## Related Commands
- `chown` — owner/group  
- `chgrp` — group only  
- `umask` — default create mask  
- `stat` — show mode numerically  
- `getfacl` / `setfacl` — ACLs  
- `install -m` — copy with mode  

## Additional Resources
- `man chmod`  
- `info coreutils 'File permissions'`

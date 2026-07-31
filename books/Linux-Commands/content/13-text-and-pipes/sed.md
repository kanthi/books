# sed

## Overview
`sed` (stream editor) transforms text line by line — substitute, delete, print, and simple inserts — without opening an interactive editor. GNU sed is common on Linux.

## Syntax
```bash
sed [options] 'script' [file...]
sed [options] -e 'script' -e 'script' [file...]
sed [options] -f script.sed [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Quiet; only explicit prints |
| `-E` / `-r` | Extended regex |
| `-i[SUFFIX]` | In-place edit (optional backup suffix) |
| `-e` | Multiple scripts |
| `-f` | Script file |

## Common Commands (in script)
| Cmd | Meaning |
|-----|---------|
| `s/pat/repl/flags` | Substitute (`g`, `i`, `p`) |
| `d` | Delete line |
| `p` | Print |
| `a`/`i`/`c` | Append/insert/change |
| `q` | Quit |

## Safety
`sed -i` rewrites files — keep backups (`-i.bak`) until trusted. Quoting matters: prefer single quotes around scripts; use `'\''` to embed a single quote.

## Examples with Explanations
### Substitute first match per line
```bash
sed 's/foo/bar/' file.txt
```

### Global substitute
```bash
sed 's/foo/bar/g' file.txt
```

### Extended regex
```bash
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log
```

### Delete matching lines
```bash
sed '/^#/d; /^$/d' config.txt
```

### Print only matches (like grep with rewrite)
```bash
sed -n 's/.*ERROR: //p' app.log
```

### In-place with backup
```bash
sed -i.bak 's/Enable=false/Enable=true/' app.conf
```

### Line ranges
```bash
sed -n '10,20p' file.txt
sed '1,5d' file.txt
```

### Multiple expressions
```bash
sed -e 's/\r$//' -e 's/[ \t]\+$//' file.txt
```

## Notes & Pitfalls
- Default regex is BRE; `+`/`|` need escapes unless `-E`.  
- `&` in replacement is the whole match; use `\&` for literal.  
- Binary files: do not `sed -i` blindly.  
- Complex multi-line edits are awkward — consider `perl -0pe` or an editor.  

## Related Commands
- `awk` — field-oriented  
- `grep` — filter only  
- `tr` — character classes  
- `perl -pe` — richer substitutions  
- `ed`/`ex`/`vim` — full editors  

## Additional Resources
- `man sed`  
- GNU sed manual

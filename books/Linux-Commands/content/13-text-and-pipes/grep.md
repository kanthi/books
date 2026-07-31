# grep

## Overview
`grep` searches input lines for a pattern. GNU grep supports basic/extended/Perl-like regexes, recursive directory search, and rich context controls. Still the default everywhere; `rg` (ripgrep) is a popular faster alternative when installed.

## Syntax
```bash
grep [OPTIONS] PATTERN [FILE...]
grep [OPTIONS] -e PATTERN ... [FILE...]
command | grep [OPTIONS] PATTERN
```

## Common Options
| Option | Description |
|--------|-------------|
| `-E` | Extended regex (ERE) |
| `-F` | Fixed strings (no regex) |
| `-P` | Perl-compatible regex (PCRE) if built-in |
| `-i` | Case-insensitive |
| `-v` | Invert match |
| `-n` | Line numbers |
| `-H` / `-h` | With / without filename |
| `-r` / `-R` | Recursive (follow / include symlinks differently) |
| `-I` | Skip binary |
| `-l` / `-L` | Files with / without matches |
| `-c` | Count matches per file |
| `-A`/`-B`/`-C` n | Context after/before/both |
| `-w` | Whole word |
| `-o` | Only the match |
| `-m n` | Stop after n matches per file |
| `--color=auto` | Highlight |
| `-q` | Silent (exit status only) |

## Key Use Cases
1. Filter logs and command output  
2. Code/config search in trees  
3. Scripting success/failure via exit status  
4. Extract substrings with `-o`  

## Examples with Explanations
### Basic
```bash
grep error /var/log/syslog
grep -i error /var/log/syslog
```

### Extended regex
```bash
grep -E 'error|warn|fail' app.log
```

### Fixed string (fast, safe)
```bash
grep -F 'https://example.com/path?x=1' urls.txt
```

### Recursive code search
```bash
grep -RIn --exclude-dir=.git --exclude-dir=node_modules 'TODO' .
```

### Context
```bash
grep -n -C3 'OutOfMemory' heap.log
```

### Files that match
```bash
grep -rl 'Listen 80' /etc/apache2 2>/dev/null
```

### Exit status in scripts
```bash
if grep -q 'ready' /tmp/status; then
  echo ok
fi
```

### Only matching part
```bash
grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' access.log | sort -u
```

### Invert
```bash
grep -v '^#' /etc/ssh/sshd_config | grep -v '^$'
```

## Understanding Output
Default: matching lines. With multiple files, lines are prefixed by filename. Exit codes: `0` match, `1` no match, `2` error.

## Common Usage Patterns
### Pipe from journalctl
```bash
journalctl -u nginx --since today | grep -i error
```

### Count HTTP status codes
```bash
grep -oE 'HTTP/[0-9.]+" [0-9]{3}' access.log | awk '{print $NF}' | sort | uniq -c
```

## Notes & Pitfalls
- Quote patterns to stop shell globbing.  
- Basic regex treats `+`/`|` differently than `-E`.  
- Binary matches print “Binary file … matches”; use `-a` or `-I`.  
- For huge repos, consider `rg` or `git grep`.  

## Related Commands
- `rg` — ripgrep (if installed)  
- `ack` / `ag` — other code search tools  
- `sed` / `awk` — transform, not just filter  
- `find` … `-exec grep` — older recursive pattern  
- `journalctl` / `dmesg` — log sources  

## Additional Resources
- `man grep`  
- GNU grep manual

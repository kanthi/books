# xargs

## Overview
`xargs` builds and executes command lines from stdin. Bridges tools that emit lists (find, grep -l) to commands that expect argv.

## Syntax
```bash
xargs [options] [command [initial-arguments]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-0` | NUL-delimited input |
| `-n N` | Max args per command |
| `-P N` | Parallel processes |
| `-I {}` | Replace string |
| `-r` | Do not run if empty (GNU) |
| `-t` | Print command before run |
| `-p` | Prompt |

## Safety
Unquoted newlines/spaces break default splitting — prefer `find -print0 | xargs -0`. Be careful with `xargs rm`.

## Examples with Explanations
### Safe with find
```bash
find . -name '*.log' -print0 | xargs -0 -r ls -l
find . -name '*.tmp' -print0 | xargs -0 -r rm -v
```

### Placeholder
```bash
echo -e 'a\nb' | xargs -I{} cp {} {}.bak
```

### Parallel gzip
```bash
find . -name '*.log' -print0 | xargs -0 -n 1 -P 4 gzip
```

### Lines as args
```bash
xargs -a urls.txt -n 1 curl -O
```

## Related Commands
- `find -exec` — often enough alone  
- `parallel` — GNU parallel for complex jobs  
- `while read` — bash loops

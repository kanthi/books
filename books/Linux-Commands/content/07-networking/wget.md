# wget

## Overview
`wget` downloads files over HTTP(S)/FTP non-interactively. Strong at recursive site mirrors and resume; for API work many prefer `curl`.

## Syntax
```bash
wget [options] [URL...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-O file` | Output name |
| `-c` | Continue partial |
| `-q` | Quiet |
| `-b` | Background |
| `-P dir` | Directory prefix |
| `--spider` | Check existence only |
| `-r` | Recursive |
| `-l n` | Recursion depth |
| `-np` | No parent |
| `--user-agent=` | UA string |
| `--header=` | Extra header |

## Examples with Explanations
### Simple download
```bash
wget https://example.com/file.tgz
wget -O out.tgz https://example.com/file.tgz
```

### Resume
```bash
wget -c https://example.com/large.iso
```

### Quiet to directory
```bash
wget -q -P /tmp https://example.com/a.bin
```

### Spider (existence)
```bash
wget --spider -S https://example.com/ 2>&1 | head
```

### Recursive limited mirror
```bash
wget -r -l 1 -np -k -p https://example.com/docs/
```

## Related Commands
- `curl` — more protocols/methods  
- `aria2c` — multi-connection downloads  
- `rsync` — sync trees

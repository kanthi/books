# tee

## Overview
`tee` copies stdin to stdout **and** to files — a T-junction in pipelines. Essential when you want to log and still process a stream.

## Syntax
```bash
tee [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Append |
| `-i` | Ignore SIGINT |
| `-p` | Diagnose write errors to pipes (GNU) |

## Examples with Explanations
```bash
make 2>&1 | tee build.log
echo hello | tee file.txt
echo more | tee -a file.txt
command | tee /dev/tty | wc -l
command | tee out1.txt out2.txt
sudo tee /etc/myapp.conf >/dev/null <<'EOF'
key=value
EOF
```

### Why `sudo tee`?
Redirection `>` runs as your shell (unprivileged). `sudo tee` writes the file as root while you keep the pipeline.

## Related Commands
- `script` — record whole session  
- `>` / `>>` redirection  
- `pv` — progress pipe (if installed)

# uniq

## Overview
`uniq` reports or filters **adjacent** duplicate lines. Almost always used after `sort` unless input is already grouped.

## Syntax
```bash
uniq [options] [input [output]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Count occurrences |
| `-d` | Only duplicates |
| `-u` | Only unique lines |
| `-i` | Ignore case |
| `-f N` | Skip first N fields |
| `-s N` | Skip first N chars |
| `-w N` | Compare width |
| `-z` | NUL-terminated |

## Examples with Explanations
```bash
sort file.txt | uniq
sort file.txt | uniq -c | sort -nr
sort file.txt | uniq -d
sort file.txt | uniq -u
cut -d: -f1 /etc/passwd | sort | uniq -c
```

### From logs
```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head
```

## Related Commands
- `sort -u` — unique sorted  
- `comm` — compare sets  
- `awk '!a[$0]++'` — unique without sort (memory)

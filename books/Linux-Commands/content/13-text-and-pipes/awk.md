# awk

## Overview
`awk` is a pattern-action language for column-oriented text. It shines at field extraction, reports, and light data transforms in pipelines — often replacing multi-step `cut`/`grep` combinations.

## Syntax
```bash
awk [options] 'program' [file...]
awk -f program.awk [file...]
```

Program form: `pattern { actions }`. Built-in field vars: `$1..$NF`, `NF`, `NR`, `FS`, `OFS`, `RS`.

## Common Options
| Option | Description |
|--------|-------------|
| `-F fs` | Input field separator |
| `-v var=val` | Set variable |
| `-f file` | Program file |
| `-f -` | Program from stdin (implementation-dependent) |

## Key Use Cases
1. Print selected columns  
2. Sum/average numeric fields  
3. Filter rows by field values  
4. Reformat logs into CSV/TSV  

## Examples with Explanations
### Print columns
```bash
awk '{print $1, $3}' file.txt
awk -F: '{print $1, $7}' /etc/passwd
```

### Filter rows
```bash
ps aux | awk 'NR==1 || $3+0 > 5.0'   # header + high CPU
awk -F, '$3 > 100 {print $1}' data.csv
```

### Sum a column
```bash
awk '{s+=$1} END {print s}' numbers.txt
awk '{s+=$1; n++} END {if(n) print s/n}' numbers.txt
```

### Change separators
```bash
awk -F, 'BEGIN{OFS="\t"} {print $2,$1}' data.csv
```

### Last field
```bash
awk '{print $NF}' file.txt
```

### Multiple patterns
```bash
awk '/ERROR/ {err++} /WARN/ {warn++} END {print err, warn}' app.log
```

### Build simple report
```bash
awk -F: '{uids[$3]++} END {for (u in uids) print u, uids[u]}' /etc/passwd | sort -n
```

## Notes & Pitfalls
- Default FS is whitespace (runs of spaces/tabs).  
- `awk` arithmetic forces numeric context (`$3+0`).  
- For complex CSV with quotes, use a real CSV parser / `python` / `mlr`.  
- Implementations: `gawk` has more features than `mawk`/`nawk`.  

## Related Commands
- `cut` — simple field slice  
- `sed` — stream edits  
- `perl`/`python` — heavier logic  
- `jq` — JSON data  
- `sort`/`uniq` — often after awk  

## Additional Resources
- `man awk`  
- [GNU Awk User’s Guide](https://www.gnu.org/software/gawk/manual/)

# paste

## Overview
`paste` merges lines of files side-by-side (parallel) or serially, using a delimiter (default TAB). Ideal for building TSV columns from separate lists.

## Syntax
```bash
paste [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d LIST` | Delimiter characters (cycle through LIST) |
| `-s` | Serial: paste one file at a time |
| `-` | Read stdin as a file |

## Key Use Cases
1. Combine columns from two files
2. Build CSV/TSV quickly
3. Pair names with IDs
4. Join command outputs

## Examples with Explanations
### Side-by-side merge
```bash
paste names.txt emails.txt
```
Line 1 of each file joined by TAB.

### Comma-separated
```bash
paste -d, names.txt emails.txt > contacts.csv
```
Simple CSV without a spreadsheet.

### Number lines with nl + paste
```bash
nl -ba file.txt | head
```
Often combined with other column tools; `paste -d: <(seq 3) <(echo -e "a\nb\nc")` for bash process substitution.

### Serial mode
```bash
paste -s -d, file.txt
```
Joins all lines of one file onto one line with commas.

## Related Commands
- `cut` — select columns
- `column` — pretty align tables
- `join` — merge on a key field
- `awk` — richer field logic
- `pr -m` — side-by-side pages

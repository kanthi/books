# column

## Overview
`column` formats text into aligned columns or tables. Great for making `mount`, `ls`, or script output human-readable.

## Syntax
```bash
column [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t` | Create a table (whitespace → columns) |
| `-s sep` | Input separator for -t |
| `-o sep` | Output separator |
| `-x` | Fill columns before rows |
| `-n` | Do not merge empty columns (util-linux) |

## Key Use Cases
1. Pretty-print tabular CLI output
2. Align CSV/TSV for reading
3. Format script reports

## Examples with Explanations
### Table mode
```bash
mount | column -t
```
Aligns mount table fields for eyeballing.

### CSV to table
```bash
column -t -s, contacts.csv
```
Use comma as input separator.

### From a pipeline
```bash
printf 'name age\nalice 30\nbob 2\n' | column -t
```
Quick aligned report.

## Notes & Pitfalls
- util-linux `column` features vary slightly by version; check `column --help`.

## Related Commands
- `paste` — build columns
- `cut` / `awk` — select fields
- `jq -r ... | column -t` — JSON to table

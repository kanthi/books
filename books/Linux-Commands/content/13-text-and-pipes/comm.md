# comm

## Overview
`comm` compares two **sorted** files line by line and outputs three columns: lines only in file1, only in file2, and in both.

## Syntax
```bash
comm [options] file1 file2
```

## Common Options
| Option | Description |
|--------|-------------|
| `-1` | Suppress column 1 (only in file1) |
| `-2` | Suppress column 2 (only in file2) |
| `-3` | Suppress column 3 (both) |
| `--check-order` | Error if inputs not sorted |
| `--output-delimiter=STR` | Column separator |

## Key Use Cases
1. Set difference of two lists
2. Intersection of sorted IDs
3. Audit user/host lists

## Examples with Explanations
### Prepare sorted inputs
```bash
sort a.txt -o a.sorted
sort b.txt -o b.sorted
comm a.sorted b.sorted
```
Unsorted input produces wrong results.

### Only in first file
```bash
comm -23 a.sorted b.sorted
```
Suppress 2 and 3 → unique to A (set difference A−B).

### Intersection
```bash
comm -12 a.sorted b.sorted
```
Lines common to both.

## Related Commands
- `sort` — required preprocessing
- `diff` — richer differences
- `grep -F -f` — membership tests
- `join` — field-keyed merge

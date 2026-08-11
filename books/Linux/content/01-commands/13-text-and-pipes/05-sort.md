# sort

## Overview
`sort` orders lines of text (or selected fields) and can merge pre-sorted files. It is a core building block for log analytics, unique counts (`sort | uniq -c`), and deterministic output in scripts. GNU `sort` (Ubuntu default) supports huge files via temporary disk, multiple keys, numeric/version/human-size modes, and stable sort.

## Syntax
```bash
sort [OPTIONS] [FILE...]
command | sort [OPTIONS]
```
With no files (or `-`), reads stdin. Multiple files are concatenated then sorted unless `-m` merges already-sorted inputs.

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Numeric sort |
| `-h` | Human numeric (`2K`, `3M`, `1G`) |
| `-V` | Version sort (`v2.10` after `v2.9`) |
| `-r` | Reverse |
| `-u` | Unique (drop duplicate lines after sort) |
| `-f` | Fold case (ignore case) |
| `-b` | Ignore leading blanks |
| `-k POS[,POS]` | Sort by key/field (see below) |
| `-t CHAR` | Field separator |
| `-s` | Stable sort (preserve order of equal keys) |
| `-R` | Random shuffle (hash-based) |
| `-o file` | Write output to file (safe for in-place with care) |
| `-m` | Merge already-sorted files |
| `-c` / `-C` | Check whether sorted (`-C` quiet) |
| `-z` | NUL-terminated lines (with `find -print0` pipelines) |
| `--parallel=N` | Parallel sort threads (GNU) |
| `-S size` | Memory buffer size (GNU) |

### Key syntax (`-k`)
Fields are 1-based. Examples:
- `-k2,2` — only field 2  
- `-k2` — field 2 through end of line  
- `-k2n` — field 2 as number  
- `-k1,1 -k2,2n` — first by field 1, then numeric field 2  

Default field separator is non-blank to blank transitions (whitespace runs).

## Examples with Explanations
### Lexicographic sort
```bash
sort names.txt
sort -r names.txt
```

### Numeric sort
```bash
sort -n scores.txt
printf '10\n2\n1\n' | sort -n
```
Without `-n`, `10` sorts before `2` as text.

### Human-readable sizes
```bash
du -h /var/* 2>/dev/null | sort -h
du -h /var/* 2>/dev/null | sort -hr | head
```

### Version numbers
```bash
printf 'v1.9\nv1.10\nv2.0\n' | sort -V
```

### Sort by a column (whitespace)
```bash
# passwd-like: sort by UID (field 3) numerically
sort -t: -k3,3n /etc/passwd
```

### CSV-ish second column (simple cases)
```bash
sort -t, -k2,2 file.csv
```
Embedded commas/quotes need a real CSV tool (`mlr`, `python`); `sort` is field-dumb.

### Unique lines
```bash
sort -u access-hosts.txt
# equivalent pipeline often written as:
sort access-hosts.txt | uniq
```

### Frequency report (sort | uniq -c | sort)
```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head
```
Classic “top talkers” pattern: count then re-sort by count.

### Check if already sorted
```bash
sort -c names.txt && echo sorted
sort -C names.txt   # silent; use exit status
```

### Safe “sort in place”
```bash
sort -o names.txt names.txt
```
GNU sort handles `-o` same-file correctly; `sort file > file` truncates first and destroys data.

### Merge pre-sorted shards
```bash
sort -m part-a.txt part-b.txt part-c.txt > all-sorted.txt
```
Much faster than re-sorting the concatenation when inputs are already ordered.

### Stable sort by key, preserve secondary order
```bash
sort -s -k1,1 events.log
```

### NUL-safe with find
```bash
find . -type f -print0 | sort -z | xargs -0 ls -l
```

### Randomize lines
```bash
sort -R items.txt | head -n 5
```
For cryptographic shuffles use `shuf` instead of relying on `sort -R` alone.

## Understanding Output
Output is the full lines in sorted order. With `-u`, only the first of equal lines (per current key/order rules) remains. Exit status `0` on success; `sort -c` returns non-zero if out of order.

Locale (`LC_COLLATE` / `LANG`) affects byte vs dictionary order. For scripts that need byte-wise sort:
```bash
LC_ALL=C sort file
```

## Notes & Pitfalls
- **Locale surprises:** `en_US.UTF-8` vs `C` can reorder punctuation and case. Pin `LC_ALL=C` for deterministic machine output.
- Numeric sort of non-numeric prefixes: `sort -n` parses a leading number; garbage may sort as zero.
- `-k2` vs `-k2,2` is a frequent bug — open-ended keys include the rest of the line.
- Large sorts use `/tmp` (or `$TMPDIR`); disk-full mid-sort fails — free space or set `-S`/`TMPDIR` on big data hosts.
- `sort -u` uniqueness respects the sort keys/options, not always the whole line if keys are restricted — know what you keyed.
- Prefer `shuf` for sampling random lines; prefer `mlr`/`csvkit` for real CSV.

## Related Commands
- `uniq` — adjacent unique/count (usually after `sort`)
- `shuf` — random permutations
- `comm` — compare two sorted files
- `join` — relational join on sorted files
- `awk` / `cut` — extract fields before sorting
- `wc -l` — count lines after filtering

## Additional Resources
- `man sort`
- GNU coreutils info: `info sort`

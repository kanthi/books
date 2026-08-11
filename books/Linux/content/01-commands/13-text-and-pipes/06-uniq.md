# uniq

## Overview
`uniq` reports or filters **adjacent** duplicate lines. It does not search the whole file for duplicates unless identical lines are already next to each other — which is why the standard pattern is `sort | uniq`. GNU `uniq` can count runs, show only duplicates, or skip comparison of leading fields/characters.

## Syntax
```bash
uniq [OPTIONS] [INPUT [OUTPUT]]
command | uniq [OPTIONS]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Prefix each line with occurrence count |
| `-d` | Only print lines that are duplicated |
| `-D` | Print all duplicate lines (GNU; every copy in a run) |
| `-u` | Only print lines that are unique (appear once) |
| `-i` | Case-insensitive compare |
| `-f N` | Skip first N fields when comparing |
| `-s N` | Skip first N characters when comparing |
| `-w N` | Compare at most N characters |
| `-z` | NUL-terminated lines (GNU) |

## Examples with Explanations
### Remove adjacent duplicates
```bash
printf 'a\na\nb\na\n' | uniq
# → a / b / a   (the second 'a' group is separate)
```
Without sorting, non-adjacent duplicates remain.

### The usual “unique lines in file” pattern
```bash
sort names.txt | uniq
sort -u names.txt          # often faster one-process equivalent
```

### Count occurrences
```bash
sort access-hosts.txt | uniq -c
sort access-hosts.txt | uniq -c | sort -nr | head
```
`uniq -c` counts **runs**; sorting first groups equal lines so the count is global.

### Top IPs from a log (field extract → sort → uniq -c → sort)
```bash
awk '{print $1}' /var/log/nginx/access.log \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n 20
```

### Only lines that appear more than once
```bash
sort ids.txt | uniq -d
```

### Only lines that appear exactly once
```bash
sort ids.txt | uniq -u
```

### Case-insensitive uniqueness
```bash
printf 'Foo\nfoo\nBAR\n' | sort -f | uniq -i
```
Sort with matching case rules (`-f`) so case variants become adjacent.

### Ignore leading fields when comparing
```bash
# two columns: timestamp id — unique by id only among adjacent
sort -k2,2 events.txt | uniq -f 1
```
`-f 1` skips field 1 (the timestamp) during comparison; whitespace field rules match `sort`’s default.

### Compare only a prefix of each line
```bash
uniq -w 8 hashes.txt
```
Useful when a fixed-width key leads the line.

### Show every line that is part of a duplicate group
```bash
sort data.txt | uniq -D
```

### NUL-separated path lists
```bash
find . -type f -print0 | sort -z | uniq -z | xargs -0 …
```
Rare but correct for exotic pipelines that stay NUL-safe end-to-end.

### Count total unique lines (quick)
```bash
sort file.txt | uniq | wc -l
# or
sort -u file.txt | wc -l
```

## Understanding Output
Default: one line per adjacent run of identical lines. With `-c`, output looks like:
```text
     12 10.0.0.5
      7 10.0.0.8
      1 10.0.0.9
```
Counts are right-aligned in a fixed width (GNU). Leading spaces are normal — strip with `awk '{print $1}'` when you need the number alone.

## Notes & Pitfalls
- **`uniq` without `sort` only collapses neighbors.** This is the #1 misconception.
- `sort -u` and `sort | uniq` are often equivalent for whole-line uniqueness; prefer one clear form in scripts.
- Locale can affect whether lines compare equal; use `LC_ALL=C` for byte-wise behavior in tooling.
- `uniq -c | sort -n` sorts by the whole line as text unless you use `sort -nr` and account for leading spaces — `sort -k1,1nr` is clearer on counted output.
- Blank lines are real lines; consecutive empties collapse under `uniq`.
- For multisets and complex keys, `awk` associative arrays or `datamash` may be clearer than `uniq -f` gymnastics.

## Related Commands
- `sort` / `sort -u` — order and unique
- `comm` — compare two sorted unique streams
- `awk '!seen[$0]++'` — unique without sorting (memory-bound, order-preserving first wins)
- `grep -v` — filter patterns, not duplicate runs
- `wc -l` — count remaining lines

## Additional Resources
- `man uniq`
- GNU coreutils info: `info uniq`

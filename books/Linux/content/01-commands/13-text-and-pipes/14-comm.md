# comm

## Overview

`comm` compares **two sorted files** line by line and outputs three columns: lines only in file1, only in file2, and common to both. Perfect for set operations on sorted word lists, user lists, and package inventories. Unsorted input produces garbage — sort first.

## Syntax

```bash
comm [options] file1 file2
```

## Common Options

| Option | Description |
|--------|-------------|
| `-1` | Suppress column 1 (unique to file1) |
| `-2` | Suppress column 2 (unique to file2) |
| `-3` | Suppress column 3 (common) |
| `-z` | NUL-terminated lines |
| `--check-order` | Check that inputs are sorted |
| `--nocheck-order` | Skip order check |
| `--output-delimiter=STR` | Column separator |
| `--total` | Output summary counts (newer) |

## Examples with Explanations

### Basic three columns

```bash
sort a.txt -o a.s
sort b.txt -o b.s
comm a.s b.s
```

### Only in first / second / both

```bash
comm -23 a.s b.s     # only in a
comm -13 a.s b.s     # only in b
comm -12 a.s b.s     # common
```

Mnemonic: suppress the columns you don’t want (`-23` keeps col1).

### Users differences

```bash
getent passwd | cut -d: -f1 | sort > host_users
# compare to expected list
comm -23 expected_users host_users    # expected but missing
comm -13 expected_users host_users    # unexpected present
```

### Package set ops

```bash
rpm -qa | sort > now
comm -13 baseline now    # newly installed vs baseline
```

### Check order

```bash
comm --check-order a.txt b.txt
```

### Process substitution

```bash
comm -12 <(sort list1) <(sort list2)
```

### Empty markers

Columns are tab-separated; empty leading fields mean a line isn’t in earlier columns. Use `cat -A` to see tabs:

```bash
comm a.s b.s | cat -A
```

## Notes / Pitfalls

- **Both files must be sorted** in the same collation (`LC_ALL=C sort` for stable byte order).
- Locale sort order can surprise — set `LC_ALL=C` for machine lists.
- Duplicate lines: `comm` is multiset-aware in the sense of sorted runs; unique with `sort -u` if needed.
- Binary files / CRLF: normalize first (`dos2unix`).
- For unsorted fuzzy joins, use `join`, `grep -F -f`, or databases.

## 2026-relevant notes

- Still excellent for offline set diffs without loading Python.
- Large inventories: ensure sort can use tmp space (`TMPDIR`).
- Combine with `rg --files` lists for workspace membership diffs.

## Related Commands

- `sort` / `uniq` — prepare inputs
- `join` — join on fields
- `diff` / `git diff` — line-oriented diffs with context
- `grep -F -f` — filter by list
- `cmp` — binary compare

## Additional Resources

- `man comm`

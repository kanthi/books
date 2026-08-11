# paste

## Overview

`paste` merges lines of files **side by side**, writing corresponding lines separated by tabs (or another delimiter). The counterpart mindset to `cut` (split columns) — paste builds columns from separate files or serializes lines with `-s`.

## Syntax

```bash
paste [options] [file...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d LIST`, `--delimiters=LIST` | Cycle delimiter characters instead of tab |
| `-s`, `--serial` | Paste one file at a time (serialize lines of each file) |
| `-z`, `--zero-terminated` | NUL-terminated lines |

Use `-` for stdin.

## Examples with Explanations

### Side by side

```bash
paste names.txt ages.txt
paste <(echo -e 'a\nb') <(echo -e '1\n2')
```

### Custom delimiter

```bash
paste -d, names.txt ages.txt
paste -d'|' a.txt b.txt c.txt
paste -d '\t|' a.txt b.txt     # cycle delimiters
```

### Serialize lines of one file

```bash
# join all lines with comma
paste -sd, file.txt
# words to CSV row
paste -sd' ' words.txt
```

### Combine with cut/seq

```bash
paste <(seq 1 3) <(seq 10 12)
cut -d: -f1 /etc/passwd | head | paste - - -    # 3 columns
```

### Join data columns from commands

```bash
paste <(nproc; echo cores) <(free -h | awk '/Mem:/{print $2}')
```

### NUL-safe

```bash
paste -z -d '' file1 file2
```

### Classic: make CSV from columns

```bash
paste -d, col1.txt col2.txt col3.txt > out.csv
```

## Notes / Pitfalls

- Unequal line counts: shorter files yield empty fields for missing lines.
- Default tab delimiter can be hard to see — use `-d,` or `cat -A`.
- `-s` changes semantics dramatically (horizontal merge of each file’s own lines).
- Not a full CSV writer (no quoting of embedded commas) — use proper CSV tools when needed.
- Large files stream line-by-line; keep inputs aligned intentionally.

## 2026-relevant notes

- Still great for quick ops glue between two tool outputs.
- For structured data, prefer `jq -s` / `python` when quoting/escaping matters.
- Pair with `column -t` after paste for display.

## Related Commands

- `cut` — extract columns
- `join` — merge sorted files on a key
- `awk` — general field processing
- `column` — pretty alignment
- `pr -m` — merge files in columns (different tool)

## Additional Resources

- `man paste`

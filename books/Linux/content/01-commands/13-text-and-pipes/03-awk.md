# awk

## Overview

`awk` is a pattern–action language for column-oriented text. It shines at field extraction, reports, and light transforms in pipelines — often replacing multi-step `cut`/`grep`/`sed` combinations. Prefer it when you think in **rows and fields**; use `sed` for pure stream edits and `jq` for JSON.

On Ubuntu you typically get **`mawk`** or **`gawk`** depending on package; install `gawk` when you need GNU extensions (gensub, multi-dimensional arrays, network redirections).

## Syntax

```bash
awk [options] 'program' [file...]
awk -f program.awk [file...]
… | awk 'program'
```

Program form: `pattern { actions }`. Default action is `{ print }`. Built-in field vars: `$1`…`$NF`, `NF` (field count), `NR`/`FNR` (record numbers), `FS`/`OFS` (separators), `RS`/`ORS`, `FILENAME`.

## Common Options

| Option | Description |
|--------|-------------|
| `-F fs` | Input field separator (same as `BEGIN { FS=… }`) |
| `-v var=val` | Set variable before program runs |
| `-f file` | Read program from file |
| `-W` | Implementation warnings (gawk) |

## Key Use Cases

1. Print or reorder selected columns  
2. Filter rows by field values or regex  
3. Sum / average / count groups  
4. Reformat logs into CSV/TSV for spreadsheets  
5. Quick reports from `/etc/passwd`, `ps`, or access logs  

## Examples with Explanations

### Print columns

```bash
awk '{print $1, $3}' file.txt
awk -F: '{print $1, $7}' /etc/passwd
```

Space-separated print uses `OFS` (default space). For passwd, `-F:` is the standard delimiter.

### Filter rows

```bash
ps aux | awk 'NR==1 || $3+0 > 5.0'          # header + high CPU
awk -F, '$3 > 100 {print $1}' data.csv
awk '/ERROR/ && !/retry/' app.log
```

`$3+0` forces a numeric comparison (avoids string “10” < “9” surprises).

### Sum and average a column

```bash
awk '{s+=$1} END {print s}' numbers.txt
awk '{s+=$1; n++} END {if (n) print s/n}' numbers.txt
```

`END` runs once after all input. Guard division by zero when the file may be empty.

### Change separators (CSV → TSV)

```bash
awk -F, 'BEGIN{OFS="\t"} {print $2,$1}' data.csv
```

Set `OFS` in `BEGIN` so every `print` uses tabs.

### Last field and field count

```bash
awk '{print $NF}' file.txt          # last field
awk '{print NF, $0}' file.txt       # how many fields per line
```

`$NF` is “last field”; `$(NF-1)` is second-to-last.

### Multiple patterns / counters

```bash
awk '/ERROR/ {err++} /WARN/ {warn++} END {print "err=" err, "warn=" warn}' app.log
```

Patterns without braces still run the default print; here braces only tally.

### Build a frequency report

```bash
awk -F: '{uids[$3]++} END {for (u in uids) print u, uids[u]}' /etc/passwd | sort -n
```

Associative arrays are the usual way to group. Order of `for (u in …)` is undefined — pipe to `sort`.

### Extract IP from mixed lines

```bash
awk 'match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {
  print substr($0, RSTART, RLENGTH)
}' access.log
```

`match` sets `RSTART`/`RLENGTH` for the first match on the line (works in mawk/gawk).

### Skip header, process the rest

```bash
awk -F, 'NR==1 {next} {sum+=$4} END {print sum}' report.csv
```

`next` jumps to the following record without running later rules on this line.

### Script-friendly exit status

```bash
awk 'BEGIN{exit 0}' </dev/null
# fail CI if any line exceeds threshold:
awk -v lim=90 '$1+0 > lim {bad=1; print} END {exit bad+0}' metrics.txt
```

`END { exit code }` is useful in pipelines and checks.

### Field splitting on multi-character FS (gawk)

```bash
gawk -F'[[:space:]]*\|[[:space:]]*' '{print $2}' table.txt
```

When separators are messy, prefer `gawk` or preprocess with `tr`/`sed`.

## Understanding Output

- Records are lines by default (`RS = "\n"`).  
- Empty fields still count toward `NF` when `FS` is a single character (e.g. `a::b` → three fields with `-F:`).  
- Uninitialized variables are `""` or `0` depending on context (string vs numeric).  
- Exit status is 0 on success; non-zero if the program calls `exit n` or the implementation hits a fatal error.

## Notes & Pitfalls

- Default `FS` is **whitespace** (runs of spaces/tabs), not a single space.  
- Locale can affect regex and sorting of output you pipe to `sort`.  
- Complex CSV with quoted commas needs a real CSV parser (`python`, `mlr`), not naive `-F,`.  
- `print $1 $2` concatenates; `print $1, $2` inserts `OFS`.  
- BusyBox awk is smaller — stick to portable constructs in scripts meant for containers/embed.

## Related Commands

- `cut` — simple fixed-field slice  
- `sed` — stream edits / substitutions  
- `sort` / `uniq` — often after awk for reports  
- `jq` — JSON  
- `mlr` (Miller) — richer tabular CLI if installed  

## Additional Resources

- `man awk`  
- [GNU Awk User’s Guide](https://www.gnu.org/software/gawk/manual/)

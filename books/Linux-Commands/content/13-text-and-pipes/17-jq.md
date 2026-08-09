# jq

## Overview
`jq` is a lightweight command-line JSON processor. It slices, filters, maps, and transforms structured data the way `sed`/`awk` do for text lines.

## Syntax
```bash
jq [options] <filter> [file...]
… | jq [options] <filter>
```

## Common Options
| Option | Description |
|--------|-------------|
| `.` | Identity — pretty-print JSON |
| `-r` | Raw string output (no JSON quotes) |
| `-c` | Compact (one object per line) |
| `-s` | Slurp: read all inputs into one array |
| `-n` | Null input (build JSON from filter only) |
| `-e` | Exit non-zero if result is false/null |
| `--arg name value` | Bind a string variable for use as $name |
| `--argjson name json` | Bind a JSON-valued variable |

## Key Use Cases
1. Pretty-print API responses
2. Extract fields for scripts
3. Transform arrays of objects
4. Build JSON from shell variables
5. Validate presence of keys in CI

## Examples with Explanations
### Pretty-print stdin
```bash
curl -s https://api.github.com/repos/jqlang/jq | jq .
```
Readable indentation for exploration.

### Extract a field
```bash
jq -r .name package.json
```
`-r` drops quotes so the value is shell-friendly.

### Map a list of objects
```bash
jq -r '.items[] | [.id, .name] | @tsv' data.json
```
TSV is easy to pipe into `cut`, `sort`, or spreadsheets.

### Filter array elements
```bash
jq '.[] | select(.status=="active")' users.json
```
`select` keeps only matching objects.

### Default / optional field
```bash
jq -r '.email // "missing"' user.json
```
`//` provides a fallback when the path is null/false.

### Build JSON from shell
```bash
jq -n --arg user "$USER" --arg host "$(hostname)" '{user:$user, host:$host, ts: now|todate}'
```
Safe construction without hand-escaped quotes.

### Count keys
```bash
jq 'keys | length' config.json
```
Quick shape check on an object.

## Understanding Output
`jq` prints the filter result as JSON by default. Use `-r` for bare strings. Errors go to stderr; exit status is non-zero on parse/filter failures (and with `-e` on false/null).

## Notes & Pitfalls
- Always prefer `--arg` / `--argjson` over string-interpolating JSON by hand.
- Filters are programs: learn `.`, `[]`, `|`, `select`, `map`, `keys`, `has`.
- Package: `sudo apt install jq` on Debian/Ubuntu.

## Related Commands
- `grep` / `sed` / `awk` — line-oriented text
- `curl` — often the JSON source
- `python3 -m json.tool` — pretty-print without filters
- `yq` — YAML/JSON cousin (if installed)

## Additional Resources
- [jq manual](https://jqlang.github.io/jq/manual/)
- [jq play](https://play.jqlang.org/)

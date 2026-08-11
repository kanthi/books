# sed

## Overview

`sed` (stream editor) transforms text **line by line** — substitute, delete, print, and simple inserts — without opening an interactive editor. GNU sed is standard on Ubuntu/Debian. Prefer `sed` for mechanical rewrites; use `awk` for field logic and an editor for multi-line structural edits.

## Syntax

```bash
sed [options] 'script' [file...]
sed [options] -e 'script' -e 'script' [file...]
sed [options] -f script.sed [file...]
… | sed 'script'
```

## Common Options

| Option | Description |
|--------|-------------|
| `-n` | Quiet; only explicit `p` prints |
| `-E` / `-r` | Extended regex (ERE) |
| `-i[SUFFIX]` | In-place edit (optional backup suffix) |
| `-e` | Add a script expression |
| `-f file` | Read script from file |
| `-z` | NUL-separated “lines” (GNU; useful with `find -print0`) |

## Common script commands

| Cmd | Meaning |
|-----|---------|
| `s/pat/repl/flags` | Substitute (`g` global, `i` ignore case, `p` print, `2` Nth only) |
| `d` | Delete line |
| `p` | Print line |
| `a\` / `i\` / `c\` | Append / insert / change (multi-line form in scripts) |
| `q` / `Q` | Quit (GNU `Q` without printing pattern space) |
| `y/src/dst/` | Transliterate like `tr` |
| `=` | Print line number |

## Safety

- `sed -i` rewrites files — always keep backups (`-i.bak`) until the expression is trusted.  
- Prefer **single quotes** around scripts so the shell does not expand `$` and `` ` ``.  
- Never run `sed -i` on binary files or unknown encodings.  
- On macOS, `-i` requires a mandatory suffix argument — scripts written for GNU sed may break there.

## Key Use Cases

1. Bulk string replace in config/logs  
2. Strip comments/blank lines  
3. Extract a capture group (print-only substitute)  
4. Normalize line endings / trailing whitespace  
5. Quick in-place flips for feature flags  

## Examples with Explanations

### Substitute first match per line

```bash
sed 's/foo/bar/' file.txt
```

Only the first `foo` on each line becomes `bar`.

### Global substitute

```bash
sed 's/foo/bar/g' file.txt
```

Every non-overlapping match on the line is replaced.

### Extended regex

```bash
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log
```

With `-E`, `{}` and `()` work without backslashes (GNU ERE).

### Delete matching lines

```bash
sed '/^#/d; /^$/d' config.txt
```

Drops comment lines and empty lines — useful for “effective config” views.

### Print only rewritten matches

```bash
sed -n 's/.*ERROR: //p' app.log
```

`-n` suppresses default output; `p` prints only successful substitutions — like a capturing `grep`.

### In-place with backup

```bash
sed -i.bak 's/Enable=false/Enable=true/' app.conf
diff -u app.conf.bak app.conf
```

Inspect the diff before deleting the `.bak`.

### Line addresses and ranges

```bash
sed -n '10,20p' file.txt          # print lines 10–20
sed '1,5d' file.txt               # delete first five
sed '/^## Start/,/^## End/d' doc.md
```

Addresses can be numbers, `$` (last line), or `/regex/`.

### Multiple expressions

```bash
sed -e 's/\r$//' -e 's/[[:space:]]\+$//' file.txt
```

Strip CR from CRLF files and trailing whitespace.

### Use match in replacement

```bash
sed -E 's/(user=)[^ ]+/\1REDACTED/g' app.log
```

Parentheses capture; `\1` reinserts the prefix. `&` is the whole match.

### Change delimiter when paths have slashes

```bash
sed 's|/usr/local/bin|/opt/bin|g' env.sh
```

Any character after `s` can be the delimiter (`s|||`, `s###`).

### Hold space: join two lines (advanced)

```bash
sed -n '1h;1!H;${x;s/\n/,/g;p}' list.txt
```

GNU sed can join lines via hold space; for heavy multi-line work prefer `awk` or `perl`.

### Dry-run pattern for risky edits

```bash
sed 's/prod/staging/g' settings.yml | diff -u settings.yml -
# then:
sed -i.bak 's/prod/staging/g' settings.yml
```

Always preview against the original before `-i`.

## Understanding Output

By default sed prints every line (after script processing) to stdout. Exit status is 0 on success; GNU sed can return non-zero for invalid options or I/O errors. In-place mode still writes a temporary file then renames — a full disk mid-edit can fail; keep backups.

## Notes & Pitfalls

- Default regex is **BRE**; `+`, `?`, `|` need escapes unless you use `-E`.  
- `s/a/b/` only changes the first match; forget `g` often.  
- `&` in the replacement is the whole match; write `\&` for a literal ampersand.  
- `sed` is line-oriented — multi-line HTML/XML edits are painful.  
- Character classes: prefer `[[:space:]]` over `\s` for portable scripts.

## Related Commands

- `awk` — field-oriented processing  
- `grep` — filter only  
- `tr` — character classes / deletion  
- `perl -pe` — richer substitutions  
- `diff` / `patch` — review and apply edits  

## Additional Resources

- `man sed`  
- GNU sed manual

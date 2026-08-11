# cat

## Overview

`cat` (concatenate) reads files sequentially and writes them to standard output. Use it to print small files, join files, and write heredocs. For large files, prefer a pager (`less`). For syntax-highlighted viewing, consider `bat`. For following growth, use `tail -f` / `journalctl -f`.

Classic Unix joke still holds: `cat file | something` is often better as `something < file` or `something file`.

## Syntax

```bash
cat [options] [file ...]
```

With no file (or `-`), reads standard input.

## Common Options

| Option | Description |
|--------|-------------|
| `-n` | Number all output lines |
| `-b` | Number non-blank lines |
| `-s` | Squeeze multiple blank lines |
| `-A` | Show all non-printing (`-vET`) |
| `-E` | Show `$` at end of lines |
| `-T` | Show tabs as `^I` |
| `-v` | Show non-printing characters |
| `-u` | Unbuffered (historical; often default) |
| `--` | End of options |

## Key Use Cases

1. Print small config/text files
2. Concatenate parts into one file
3. Create files via heredoc
4. Reveal invisible characters (`-A`)
5. Quick copy via redirect

## Examples with Explanations

### Print files

```bash
cat file.txt
cat /etc/os-release
cat -n file.txt              # number lines
cat -A file.txt              # show tabs/line endings
```

### Concatenate

```bash
cat part1 part2 part3 > whole
cat part1 part2 >> whole     # append
cat header.json body.json > combined.json
```

### Heredocs

```bash
cat <<'EOF' > greeting.txt
hello
world
EOF

cat <<EOF >> /etc/hosts
# added by bootstrap
10.0.0.5 app.local
EOF
```

Quoted `'EOF'` disables expansion; unquoted `EOF` expands `$vars` and command substitutions.

### Here-string and stdin

```bash
cat <<< 'single line'
cat - <<'EOF' | ssh host 'cat > /tmp/x'
content
EOF
```

### Show non-printing / DOS endings

```bash
cat -A dosfile.txt
# CRLF shows as ^M$
```

### Useless use of cat — avoid

```bash
# avoid
cat file | grep pattern
# prefer
grep pattern file
grep pattern < file
```

### Binary caution

```bash
cat binary.dat                # can mess up terminal
cat binary.dat | xxd | less   # better
```

### Multiple files with separators (manual)

```bash
for f in *.conf; do
  echo "===== $f ====="
  cat "$f"
done | less
```

## Notes / Pitfalls

- Large files: use `less`, `tail`, or streaming tools; don’t dump multi-GB logs with `cat`.
- `cat file1 file2 > file1` **truncates file1 first** — data loss. Write to a new name.
- Terminal corruption from binary output: `reset` or `tput reset`.
- Order matters for concatenation; globs are sorted by shell locale.
- BusyBox `cat` may support fewer flags.

## 2026-relevant notes

- Prefer `bat` for interactive reading; keep `cat` for scripts and POSIX pipelines.
- `systemd-cat` sends stdin to the journal — different tool for logging.
- For cloud-init / config blobs, heredoc with `cat <<'EOF'` remains standard in shell provisioning.

## Related Commands

- `less` / `more` — pagers
- `bat` — enhanced viewing
- `tac` — reverse line order
- `head` / `tail` — portions of files
- `tee` — copy stdin to file and stdout
- `paste` / `join` — columnar combine

## Additional Resources

- `man cat`

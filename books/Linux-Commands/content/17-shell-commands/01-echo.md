# echo

## Overview

`echo` writes its arguments to standard output, separated by spaces, usually followed by a newline. It is the everyday way to print status lines in the shell. Behavior of escapes (`-e`) and options differs across shells and `/bin/echo` — for portable formatting prefer **`printf`**.

This page stays **operator-light**. Shell programming depth lives in the Linux-ShellScripting-Bash book.

## Syntax

```bash
echo [options] [string...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-n` | No trailing newline |
| `-e` | Enable backslash escapes (`\n`, `\t`, `\\`, …) — **bash builtin** / some `echo`s |
| `-E` | Disable escapes (bash default) |

BusyBox and non-bash `echo` may ignore or treat flags differently. When it matters, use `printf`.

## Examples with Explanations

### Print text

```bash
echo 'Hello'
echo Hello world
echo "User: $USER"
```

Single quotes preserve literals; double quotes expand variables.

### No newline

```bash
echo -n 'Prompt: '
# useful before read in interactive snippets
```

### Escapes (bash)

```bash
echo -e 'line1\nline2\tcolumn'
```

Prefer `printf 'line1\nline2\tcolumn\n'` for scripts you share.

### Redirect / append

```bash
echo 'enabled=1' > /tmp/flags.conf
echo 'note' >> /tmp/flags.conf
```

### Pipe into other commands

```bash
echo 'example.com' | dig +short
echo "$TOKEN" | wc -c
```

Avoid `echo $TOKEN` unquoted (word-splitting/globbing).

### Show a path or command you are about to run

```bash
echo "Installing into $PREFIX"
echo "+ apt install -y curl"
```

Common in install scripts for operator visibility.

## Notes

- `echo` is often a **shell builtin** (`type echo`); `/bin/echo` may differ.
- Arguments starting with `-` can be misread as options — use `printf '%s\n' "$arg"` for arbitrary data.
- `echo *` expands globs; quote when you mean a literal `*`.
- Don’t use `echo` to print binary-safe data; use `printf` or `cat`.

## Related Commands

- `printf` — reliable formatting
- `cat` — write multi-line or file contents
- `tee` — print and log
- `yes` — repeat a line

## Additional Resources

- `help echo` (bash)
- `man echo`

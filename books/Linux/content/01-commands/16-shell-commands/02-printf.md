# printf

## Overview

`printf` formats and prints arguments using a format string, like C’s `printf`. Prefer it over `echo` when you need reliable escapes, fixed columns, no unexpected options parsing, or portable scripts. Available as a bash builtin and `/usr/bin/printf` (usually identical enough for ops use).

Keep complex format logic in the ShellScripting book; here are the operator essentials.

## Syntax

```bash
printf FORMAT [ARGUMENT...]
```

## Common Format Pieces

| Sequence | Meaning |
|----------|---------|
| `%s` | String |
| `%d` / `%i` | Decimal integer |
| `%x` / `%X` | Hex integer |
| `%f` | Floating point |
| `%b` | String with backslash escapes interpreted |
| `%%` | Literal `%` |
| `\n` `\t` `\\` | Newline, tab, backslash (in FORMAT) |

Width/precision: `%-20s`, `%08d`, `%.2f`.

## Examples with Explanations

### Safe newline print

```bash
printf '%s\n' "$var"
printf '%s\n' '---' line1 line2
```

Repeats the format as needed for leftover arguments (POSIX).

### No trailing newline

```bash
printf 'Status: %s' ok
```

### Columns

```bash
printf '%-12s %8s\n' NAME SIZE
printf '%-12s %8s\n' root 120G
printf '%-12s %8s\n' home 800G
```

Handy for quick operator tables in scripts.

### Zero-pad numbers

```bash
printf 'ticket-%04d\n' 7
# ticket-0007
```

### Interpret escapes in data

```bash
printf '%b\n' 'line1\nline2'
```

`%b` vs putting `\n` only in FORMAT — know which side holds the escapes.

### Hex / bytes (light)

```bash
printf '%02x\n' 255
printf '\\x%x' 42; echo
```

For full hex dumps use `xxd`.

### Build a file

```bash
printf 'user=%s\nrole=%s\n' "$USER" admin > /tmp/who.ini
```

### Arbitrary strings that look like options

```bash
printf '%s\n' -n
# correctly prints -n  (echo -n would swallow it as a flag)
```

## Notes

- Exit status is non-zero on write errors; format errors are shell-dependent.
- Floating formats and locales: decimal comma/point can surprise — set `LC_ALL=C` for machine output.
- Prefer `printf '%s\n' "$x"` over `echo "$x"` in production shell snippets.
- Builtin `printf` vs `/usr/bin/printf`: rare differences; stick to common formats.

## Related Commands

- `echo` — simple print
- `sprintf` — not a shell command; use command substitution with `printf`
- `column` — align tables from text
- `xxd` — binary/hex dumps

## Additional Resources

- `help printf` (bash)
- `man 1 printf`

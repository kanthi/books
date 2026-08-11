# touch

## Overview

`touch` updates file timestamps and, by default, **creates** empty files that do not exist. Operators use it to create placeholders, nudge `make` rebuilds, normalize mtimes in tests, and clone timestamps from a reference file.

Linux files typically track at least **atime** (access), **mtime** (content modification), and **ctime** (metadata change). `touch` adjusts atime/mtime; ctime updates as a side effect of the metadata change.

## Syntax

```bash
touch [options] file...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Change access time only |
| `-m` | Change modification time only |
| `-c`, `--no-create` | Do not create missing files |
| `-d STRING`, `--date=STRING` | Parse human-friendly time string |
| `-t [[CC]YY]MMDDhhmm[.ss]` | Set time in compact form |
| `-r REF`, `--reference=REF` | Copy timestamps from REF |
| `--time=WORD` | `access`/`atime`/`use` or `modify`/`mtime` |
| `-h` | Affect symlink itself (when supported) |

## Key Use Cases

1. Create empty files / placeholders
2. Update mtime to trigger build systems
3. Set explicit timestamps for tests and packages
4. Copy times from a reference file
5. Batch-create names (`touch file{1..5}`)

## Examples with Explanations

### Create or refresh

```bash
touch newfile
touch file1 file2 file3
touch file{1..5}
touch logs/.gitkeep
```

### Do not create

```bash
touch -c missing_file     # no-op if absent; exit 0 typically
ls missing_file
```

### atime / mtime only

```bash
touch -a file             # access time
touch -m file             # modification time
stat file
```

### Date strings

```bash
touch -d '2020-01-01' file
touch -d '2 days ago' file
touch -d '2024-06-15 14:30:00' file
touch -d 'next Monday' file
```

GNU `touch` accepts many `date`-style strings.

### Compact `-t` form

```bash
touch -t 202312201200 file
touch -t 202312201200.30 file
# [[CC]YY]MMDDhhmm[.ss]
```

### Reference file

```bash
touch -r /etc/hosts mycopy
stat -c '%y %n' /etc/hosts mycopy
```

### Make and empty targets

```bash
touch src/main.c          # force rebuild consumers of main.c
make
```

### Scripts: ensure path exists as empty file

```bash
mkdir -p "$(dirname "$out")"
touch "$out"
```

### Clear mtime into the past for cleanup tests

```bash
touch -d '30 days ago' /tmp/old.log
find /tmp -name 'old.log' -mtime +7
```

## Understanding timestamps

```bash
stat file
stat -c 'mtime=%y atime=%x ctime=%z' file
```

| Field | Meaning |
|-------|---------|
| atime | Last access (often lazy/relatime on modern mounts) |
| mtime | Last content modification |
| ctime | Last inode/metadata change (not “creation”) |
| birth | Creation time on some filesystems (`stat` `%w`) |

**relatime** / **noatime** mount options mean `touch -a` may not behave as you expect for real reads; the explicit `touch -a` still sets atime.

## Notes / Pitfalls

- Creating files requires write permission on the parent directory.
- `touch` on a directory updates the directory’s timestamps, not children.
- Timestamp precision and timezone depend on filesystem and locale settings.
- NFS root_squash and permission quirks can make `touch` fail with EACCES.
- `touch` is not a substitute for writing content — use redirection or editors.

## 2026-relevant notes

- Build caches (Bazel, Nix, container layer caches) care deeply about mtime vs content hashes; know which model your toolchain uses.
- `touch -r` is handy when replaying reproducible package layouts.
- For pure “ensure file exists” in bash, ` : >>file ` or `umask` + redirect may be clearer than `touch` when you also write content.

## Related Commands

- `stat` — display timestamps and inode data
- `date` — print/set system time; format strings
- `find -mtime/-mmin` — select by age
- `mkdir` — create directories
- `install` — install files with mode/owner
- `make` — rebuild based on mtimes

## Additional Resources

- `man touch`
- [GNU coreutils — touch](https://www.gnu.org/software/coreutils/manual/html_node/touch-invocation.html)

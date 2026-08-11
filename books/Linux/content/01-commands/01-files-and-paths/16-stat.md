# stat

## Overview

`stat` displays detailed **inode metadata**: size, ownership, mode, timestamps, device/inode numbers, links, and filesystem identity. It is more precise than `ls -l` for scripting and debugging (“why can’t I write this?”, “is this the same file?”, “when was mtime?”).

GNU `stat` supports custom output formats with `-c` (files) and `-f` (filesystems).

## Syntax

```bash
stat [options] file...
stat -c FORMAT file...
stat -f -c FORMAT file...     # filesystem (GNU)
```

## Common Options

| Option | Description |
|--------|-------------|
| `-c FORMAT`, `--format=FORMAT` | Custom file format string |
| `-f` | Filesystem status instead of file |
| `-L` | Follow symlinks |
| `-t` | Terse form |
| `--printf=FORMAT` | Like `-c` with escape sequences; no forced newline |
| `-x` | BSD-style verbose (some systems) |

## Useful format sequences (GNU file)

| Seq | Meaning |
|-----|---------|
| `%n` | File name |
| `%s` | Size in bytes |
| `%a` / `%A` | Octal / human access rights |
| `%u` / `%U` | UID / user name |
| `%g` / `%G` | GID / group name |
| `%i` | Inode number |
| `%d` / `%D` | Device (decimal / hex) |
| `%h` | Hard link count |
| `%F` | File type string |
| `%x` / `%X` | atime human / epoch |
| `%y` / `%Y` | mtime human / epoch |
| `%z` / `%Z` | ctime human / epoch |
| `%w` / `%W` | birth time human / epoch (if supported) |
| `%N` | Quoted name with symlink target |

## Examples with Explanations

### Default view

```bash
stat /etc/hosts
stat -L /usr/bin/python3
```

### Script-friendly fields

```bash
stat -c '%a %n' file
stat -c '%U:%G %a %n' file
stat -c '%s bytes  mtime=%y  %n' file
stat -c '%d:%i %n' file          # device:inode identity
```

### Compare identities (same file?)

```bash
stat -c '%d:%i' a b
# equal device+inode → hard-linked or same path
```

### Timestamps

```bash
stat -c 'atime=%x' file
stat -c 'mtime=%y' file
stat -c 'ctime=%z' file
stat -c 'birth=%w' file          # may show '-' if unsupported
stat -c '%Y' file                # mtime epoch for sorting
```

### Filesystem info

```bash
stat -f /var
stat -f -c '%T %b %f %S' /       # type, blocks, free, block size (see man)
df -T /var
```

### Batch

```bash
stat -c '%08a %s %n' /etc/*.conf
find . -type f -printf '' -exec stat -c '%Y %n' {} + | sort -n | tail
```

### Permissions debugging

```bash
namei -l /var/lib/myapp/data.db
stat -c '%A %U %G %n' /var/lib/myapp /var/lib/myapp/data.db
```

### Terse / portable caution

```bash
stat -t file                     # compact; format not for portable scripts
```

Prefer explicit `-c` formats in automation.

## Notes / Pitfalls

- **ctime** is metadata change time, not “creation time”. Birth/creation is `%w` where supported (ext4, btrfs, …).
- atime may be unreliable under `relatime`/`noatime` mounts.
- Following symlinks (`-L`) vs not changes which inode you inspect.
- BSD `stat` format flags differ completely — GNU examples are Linux-oriented.
- Parsing default multi-line output is fragile; always use `-c`/`--printf` in scripts.

## 2026-relevant notes

- Still the best quick metadata tool before reaching for Python `os.stat`.
- Network FS may fake or delay some timestamps; verify on the server.
- Combine with `find -printf` for bulk metadata without one `stat` exec per file when possible.

## Related Commands

- `ls -l` — human listing
- `file` — content type guess
- `stat` filesystem vs `df` / `findmnt`
- `readlink` / `realpath` — path resolution
- `getfacl` — ACLs beyond mode bits
- `lsattr` / `chattr` — ext attributes

## Additional Resources

- `man stat`
- [GNU coreutils — stat](https://www.gnu.org/software/coreutils/manual/html_node/stat-invocation.html)

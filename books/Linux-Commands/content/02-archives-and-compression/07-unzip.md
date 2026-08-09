# unzip

## Overview

`unzip` lists, tests, and extracts **ZIP** archives. It is the usual counterpart to `zip` on Linux. Options differ from `tar`; path traversal and overwrite behavior deserve care when extracting untrusted archives.

## Syntax

```bash
unzip [options] archive.zip [file...] [-x xfile...] [-d exdir]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | List contents |
| `-v` | Verbose listing / version |
| `-t` | Test integrity |
| `-o` | Overwrite files without prompting |
| `-n` | Never overwrite |
| `-d dir` | Extract into directory |
| `-j` | Junk paths (flatten) |
| `-q` | Quiet |
| `-f` | Freshen existing files only |
| `-u` | Update (freshen + extract new) |
| `-P pass` | Password (visible in process list — avoid) |
| `-x pattern` | Exclude files |
| `-Z` | Zipinfo mode (if compiled) |

## Examples with Explanations

### List and test

```bash
unzip -l archive.zip
unzip -v archive.zip
unzip -t archive.zip
```

### Extract

```bash
unzip archive.zip
unzip archive.zip -d /tmp/out/
mkdir -p /tmp/out && unzip -d /tmp/out archive.zip
```

### Selective extract

```bash
unzip archive.zip readme.txt
unzip archive.zip 'src/*.c' -d /tmp/src
unzip archive.zip -x '*.o' -d /tmp/out
```

### Overwrite policies

```bash
unzip -o archive.zip            # always overwrite
unzip -n archive.zip            # never overwrite
```

### Flatten paths

```bash
unzip -j archive.zip -d /tmp/flat
```

### Pipe / quiet automation

```bash
unzip -q -o artifact.zip -d "$BUILD_DIR"
```

### Untrusted archives — path safety

```bash
# inspect before extract
unzip -l untrusted.zip | less
# extract into empty sandbox only
mkdir -p /tmp/sandbox && unzip -d /tmp/sandbox untrusted.zip
# watch for entries with .. or absolute paths
unzip -l untrusted.zip | awk '{print $NF}' | grep -E '(^\.\.|^\|/)'
```

Modern `unzip` versions try to block some unsafe paths; still extract untrusted input in a sandbox.

### Password

```bash
unzip -P 'secret' encrypted.zip     # leaks via ps
unzip encrypted.zip                 # prompts
```

## Notes / Pitfalls

- Default extract path is the **current directory** — use `-d` deliberately.
- Filename encoding (CP437 vs UTF-8) can garble non-ASCII names from Windows zips.
- ZIP64 needed for huge archives; old unzip fails.
- Don’t use `-P` in shared environments.
- `busybox unzip` supports a subset of flags.

## 2026-relevant notes

- CI jobs should pin `-o`/`-n` explicitly for non-interactive reliability.
- Prefer artifact scanning before unzip on multi-tenant builders.
- For tar-based Linux artifacts, stick to `tar` rather than converting everything to zip.

## Related Commands

- `zip` — create archives
- `zipinfo` — detailed metadata
- `7z x` — alternative extractor
- `bsdtar` / `tar` — can read some zips depending on build
- `funzip` — pipe single-member extract

## Additional Resources

- `man unzip`

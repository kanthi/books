# getfacl / setfacl

## Overview

POSIX **ACLs** extend the classic owner/group/other mode bits with named user and group entries. On Ubuntu, `getfacl` displays ACLs; `setfacl` changes them. Use ACLs when several users/groups need different rights on shared directories without resorting to `777` or endless group reshuffles. Classic `chmod` bits remain the base; ACL masks interact with them — always verify with `getfacl` after changes.

Package: `acl` (`sudo apt install acl` if missing). Filesystem must be mounted with ACL support (default for ext4/xfs on modern Ubuntu).

## Syntax

```bash
getfacl [options] file...
setfacl [options] file...
setfacl -b|-k file...          # remove ACLs / default ACLs
```

## Common Options

### getfacl

| Option | Description |
|--------|-------------|
| `-a`, `--access` | Access ACL only |
| `-d`, `--default` | Default ACL only (directories) |
| `-c`, `--omit-header` | Skip file name header |
| `-R`, `--recursive` | Recurse |
| `-p`, `--absolute-names` | Don’t strip leading `/` |
| `--all-effective` | Comment effective rights (mask) |

### setfacl

| Option | Description |
|--------|-------------|
| `-m`, `--modify=acl` | Modify ACL entries |
| `-M file` | Modify from ACL file |
| `-x`, `--remove=acl` | Remove entries |
| `-b`, `--remove-all` | Remove all extended ACL entries |
| `-k`, `--remove-default` | Remove default ACL |
| `-R`, `--recursive` | Recurse |
| `-d`, `--default` | Apply to default ACL (dirs) |
| `--set=acl` | Replace entire ACL |
| `-n`, `--no-mask` | Don’t recalculate mask (advanced) |
| `--test` | Dry-run: show resulting ACL |

ACL entry forms: `u:user:rwx`, `g:group:rx`, `m::rx`, `o::r`, `u::rwx` (owner), `g::rx` (owning group).

## Safety

- Recursive `setfacl -R` can lock out services if you omit needed identities — test on a small tree first (`--test` / non-prod).
- The **mask** entry caps effective rights for named users/groups; surprising “I granted rwx but it’s only r-x” is usually the mask.
- Removing ACLs (`-b`) falls back to ordinary mode bits — confirm those bits with `ls -l` afterward.
- Network shares (NFS/SMB) and containers may map IDs differently; ACL usernames must resolve on the host that enforces them.

## Examples with Explanations

### View ACLs

```bash
getfacl /srv/shared
getfacl -p /srv/shared/file.txt
ls -l /srv/shared
# files with ACLs show a trailing '+' on the mode, e.g. -rw-rwxr--+
```

### Grant a user access

```bash
sudo setfacl -m u:alice:rwx /srv/shared
sudo setfacl -m u:bob:r-x /srv/shared
getfacl /srv/shared
```

### Grant a group and adjust mask

```bash
sudo setfacl -m g:devs:rwx /srv/shared
getfacl /srv/shared
# check "effective:" comments if mask limits rights
```

### Default ACL on a directory (inherit for new files)

```bash
sudo setfacl -d -m u:alice:rwx /srv/shared
sudo setfacl -d -m g:devs:rwx /srv/shared
sudo setfacl -d -m o::--- /srv/shared
touch /srv/shared/newfile
getfacl /srv/shared/newfile
```

Default ACLs apply to **new** children; existing files need a separate recursive pass if required.

### Recursive grant

```bash
sudo setfacl -R -m g:devs:rwX /srv/shared
sudo setfacl -R -d -m g:devs:rwX /srv/shared
```

Capital `X` in ACL text means execute only if the file is a directory or already executable — same idea as `chmod`’s `X`.

### Remove entries / clear ACLs

```bash
sudo setfacl -x u:bob /srv/shared
sudo setfacl -b /srv/shared/file.txt     # strip extended ACL
sudo setfacl -k /srv/shared              # strip default ACL only
getfacl /srv/shared
```

### Copy ACL from one file to another

```bash
getfacl file1 | sudo setfacl --set-file=- file2
# or
sudo getfacl --access file1 | sudo setfacl --set-file=- file2
```

### Dry-run

```bash
setfacl --test -m u:alice:rw /srv/shared/file.txt
```

Shows the ACL that would be applied without writing it.

### Backup and restore ACL tree

```bash
getfacl -R /srv/shared > shared-acls.backup
# later:
sudo setfacl --restore=shared-acls.backup
```

Paths in the backup must still make sense relative to how `getfacl` recorded them.

## Notes

- Install: `sudo apt install acl`.
- `ls -l` `+` flag means “has ACL (or other security xattr)” — inspect with `getfacl`.
- umask and default ACLs both affect new file modes; defaults win for ACL-aware creates when a default ACL exists.
- `chmod` can change the ACL mask as a side effect when ACLs are present — re-check with `getfacl` after chmod.
- Not every backup tool preserves ACLs; use `getfacl --restore`, `rsync -A`, or `tar --acls` consciously.

## Related Commands

- `chmod` / `chown` — base mode and ownership
- `ls -l` — trailing `+` hint
- `namei -l` — path component permissions
- `rsync -A` — copy ACLs
- `chattr` — ext file attributes (different mechanism)

## Additional Resources

- `man getfacl`, `man setfacl`, `man acl`
- `man 5 acl`

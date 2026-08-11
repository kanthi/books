---
title: Intro
---

# Intro

Navigate the filesystem, create and move data, inspect metadata, search by name or content, and manage permissions (mode bits, ACLs, and attributes). This is the daily CLI surface for almost every task.

## Commands in this part

| Command | Role |
|---------|------|
| `pwd` | pwd (print working directory) writes the absolute path of the current directory. |
| `cd` | cd (change directory) sets the shell’s current working directory. |
| `ls` | ls lists directory contents. |
| `tree` | tree prints a directory hierarchy as an indented tree. |
| `mkdir` | mkdir (make directory) creates new directories. |
| `rmdir` | rmdir removes empty directories only. |
| `touch` | touch updates file timestamps and, by default, creates empty files that do not exist. |
| `cp` | cp copies files and directories. |
| `mv` | mv renames or moves files and directories. |
| `rm` | rm removes directory entries (unlinks files). |
| `cat` | cat (concatenate) reads files sequentially and writes them to standard output. |
| `less` | less is a pager: it displays text one screen at a time with searching, scrolling both ways, and optional follow mode. |
| `more` | more is a simple historical pager that displays text one screen at a time. |
| `chmod` | chmod changes file mode bits (permissions) and special bits (setuid, setgid, sticky). |
| `chown` | chown (change owner) sets the user and/or group ownership of files and directories. |
| `stat` | stat displays detailed inode metadata: size, ownership, mode, timestamps, device/inode numbers, links, and… |
| `file` | file classifies files by inspecting content magic (and optionally the filesystem type), not just the name extension. |
| `find` | find walks a directory tree and selects files by name, type, time, size, permissions, and more. |
| `fd` | fd is a fast, user-friendly alternative to find. |
| `locate` | locate finds files by name using a prebuilt database (historically mlocate; on modern Ubuntu often plocate). |
| ripgrep (rg) | ripgrep (rg) recursively searches the filesystem for a regex pattern. |
| `ln` | ln creates links: hard links (default) or symbolic links (-s). |
| `readlink` | readlink prints the target of a symbolic link, or with GNU flags like -f/-e/-m, canonicalizes paths by resolving… |
| `realpath` | realpath prints the resolved absolute path of each argument, expanding . |
| `basename` | basename strips the directory portion (and optionally a suffix) from a path, leaving the final component. |
| `dirname` | dirname removes the last path component, returning the directory portion of a path. |
| `which` | which locates executables by searching the PATH environment variable and printing the path of the first match. |
| alias / unalias | alias is a shell builtin that creates command shortcuts in the current shell session. |
| `install` | install copies files with explicit mode (and optional owner/group) and can create destination directories. |
| `df` | df reports filesystem disk space usage for mounted filesystems. |
| `du` | du estimates file and directory space usage by walking the tree. |
| `bat` | bat is a modern cat replacement with syntax highlighting, git integration, line numbers, and automatic paging. |
| `eza` | eza is a modern replacement for ls (community successor to exa) with colors, git status, icons (optional), tree… |
| `sha256sum` | sha256sum computes or verifies SHA-256 message digests. |
| `base64` | base64 encodes binary data to ASCII text, or decodes it back. |
| `cmp` | cmp compares two files byte by byte. |
| getfacl / setfacl | POSIX ACLs extend the classic owner/group/other mode bits with named user and group entries. |
| chattr / lsattr | chattr sets ext file attributes (immutable, append-only, no-dump, etc.); lsattr lists them. |
| `xxd` | xxd creates a hex dump of a file (or stdin) and can reverse a dump back to binary. |
| `strings` | strings extracts printable character sequences from binary files. |
| `namei` | namei walks a path component by component, showing whether each element is a file, directory, or symlink — and… |
| `umask` | umask sets the file mode creation mask for the current shell: bits that are turned *off* when new files and… |


## Suggested starting points

1. Orientation: `pwd`, `ls`, `cd`, `tree` / `eza`.
2. Mutate carefully: `cp`, `mv`, `rm`, `mkdir` (prefer dry-run / backups when unsure).
3. Permissions: `chmod`, `chown`, then ACLs (`getfacl`) or attributes (`chattr`/`lsattr`) when modes are not enough.
4. Find things: `find` or `fd` for live trees; `locate` for indexed names; `rg` for content.
5. Space: `df`, `du` (and later Storage tools like `ncdu`).

## Related parts

- Storage and filesystems — block devices, mounts, LVM
- Text and pipes — process file contents
- Security — SELinux labels when DAC is not the issue

Continue with the individual command pages in this part.

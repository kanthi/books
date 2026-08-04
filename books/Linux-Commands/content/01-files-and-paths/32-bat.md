# bat

## Overview

`bat` is a modern `cat` replacement with **syntax highlighting**, git integration, line numbers, and automatic paging. Optional package on most distros (`apt install bat` — binary may be `batcat` on Debian/Ubuntu). Excellent for reading code and configs interactively; keep `cat` for portable scripts.

## Syntax

```bash
bat [options] [file...]
batcat [options] [file...]     # Debian/Ubuntu package name collision
```

## Common Options

| Option | Description |
|--------|-------------|
| `-n`, `--number` | Show line numbers (often default in some themes) |
| `-p`, `--plain` | Plain mode (no decorations; closer to cat) |
| `-A`, `--show-all` | Show non-printable characters |
| `-l`, `--language` | Force language for highlighting |
| `-r`, `--line-range` | Only print a range (`N:M`) |
| `-H`, `--highlight-line` | Highlight a line |
| `-C`, `--context` | Context lines around highlights (with grep integration) |
| `--style` | Configure decorations (`auto,full,plain,numbers,…`) |
| `--theme` | Color theme |
| `-f`, `--force-colorization` | Color even when piping (careful) |
| `--paging=never` | Disable pager |
| `-d`, `--diff` | Show git diff modifications |
| `-m`, `--map-syntax` | Map glob → language |

## Examples with Explanations

### View files

```bash
bat README.md
bat /etc/ssh/sshd_config
bat src/main.rs
```

### Debian binary name

```bash
command -v bat batcat
alias bat=batcat          # common convenience on Ubuntu
batcat -p file.txt
```

### Plain / script-friendly

```bash
bat -p file.txt
bat --paging=never -p file.txt | wc -l
```

### Ranges and highlights

```bash
bat -r 20:40 file.go
bat -H 42 config.yaml
bat -r :50 -H 10 app.py
```

### Force language

```bash
bat -l json mystery.conf
bat -l yaml /etc/netplan/01-netcfg.yaml
```

### Multiple files and stdin

```bash
bat *.md
command | bat -l log
curl -fsSL https://example.com/file.yaml | bat -l yaml
```

### Git-aware

```bash
bat -d src/main.rs          # highlight modifications when in a git repo
```

### Themes and style

```bash
bat --list-themes
bat --theme=TwoDark file.rs
bat --style=numbers,changes file.rs
```

### As man / pager helper

```bash
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# or use bat's own man integration if configured
```

### Compare with cat / less

```bash
cat file.md          # raw dump
bat file.md          # highlight + pager
less -R file.md      # pager only
```

## Notes / Pitfalls

- Not installed by default on servers; scripts should not require `bat`.
- Color in pipes can break consumers — default is usually no color when non-tty; use `-p`/`--paging=never` when unsure.
- Debian renames to `batcat` because of another `bat` package.
- Huge minified JSON/logs: disable paging or use `less`/`jq` for structure.
- Theme readability depends on terminal truecolor support.

## 2026-relevant notes

- Pairs well with `eza`, `fd`, `rg`, `delta` as a modern CLI toolkit.
- `batcache` / automatic syntax detection covers most languages; force `-l` for unusual extensions.
- In CI, stick to `cat` for deterministic plain logs.

## Related Commands

- `cat` — portable concatenate/print
- `less` — pager
- `highlight` / `pygmentize` — other highlighters
- `delta` — git diff highlighter
- `jq` — structured JSON view
- `man` — manuals (can pipe through bat)

## Additional Resources

- `man bat` / `bat --help`
- [sharkdp/bat](https://github.com/sharkdp/bat)

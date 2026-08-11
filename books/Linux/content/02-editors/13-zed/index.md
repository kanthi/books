---
title: "Zed"
---

# Zed: Fast Native Code Editor

**Zed** is a modern, GPU-accelerated code editor written in Rust. It targets snappy local editing, first-class collaboration, and tight language tooling—without Electron. On Linux it is a strong **GUI** counterpart to terminal editors like Neovim and Helix.

Homepage: [https://zed.dev/](https://zed.dev/)

## Why Zed on Linux

- **Performance** — native UI, responsive large files and multi-buffer work
- **Language awareness** — tree-sitter + LSP-style intelligence
- **Collaboration** — real-time multiplayer editing (Zed’s signature feature)
- **Vim mode** (optional) — softer landing from modal editors
- **Agent / AI features** — evolving; often used *beside* terminal agents in tmux/Herdr
- **Default themes** — **One Dark** / **One Light** (the palette many terminals and this book’s code theme echo)

Zed is **not** a drop-in for rescue-shell editing. Keep `vi`/`nano` skills. Use Zed on workstations and powerful laptops; use TUI editors over raw SSH.

## Install

Channels move quickly—prefer the official install docs if a command fails.

```bash
# Official script (check zed.dev for current recommendation)
curl -f https://zed.dev/install.sh | sh

# Some distros / community packages (availability varies)
# Arch (AUR often): yay -S zed
# Flatpak (if published for your channel): flatpak install ...
# Nix: search nixpkgs for zed-editor
```

Verify:

```bash
zed --version
which zed
```

Open a project:

```bash
zed .
zed path/to/file.rs:42
```

### Wait flag for `$EDITOR`

GUI editors must block the caller until the file is closed:

```bash
export EDITOR="zed --wait"
export VISUAL="$EDITOR"
git config --global core.editor "zed --wait"
```

Without `--wait`, git commits may open an empty editor and continue immediately.

## Core UI map

| Area | Role |
|------|------|
| **Buffer** | File contents |
| **Tab bar** | Open files |
| **Project panel** | File tree |
| **Outline / symbols** | Jump inside file |
| **Terminal panel** | Integrated shell (optional; many still use external tmux) |
| **Command palette** | Fuzzy all-the-commands |

Command palette is the discovery tool: open it and type what you want (`format`, `theme`, `vim`, `terminal`).

Default chord families (approximate—confirm in Command Palette / docs):

- **Command palette** — often `Ctrl+Shift+P` (Linux)
- **File finder** — often `Ctrl+P`
- **Save** — `Ctrl+S`
- **Toggle terminal** — palette: “terminal”

Keymaps are configurable in Zed settings (JSON).

## Settings and config

Zed stores settings in its config directory (typically under `~/.config/zed/` on Linux). Use the UI **Settings** or edit JSON.

Illustrative settings (keys evolve—validate against your version):

```json
{
  "theme": "One Dark",
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 14,
  "ui_font_size": 14,
  "tab_size": 2,
  "hard_tabs": false,
  "format_on_save": "on",
  "autosave": "on_focus_change",
  "vim_mode": false,
  "relative_line_numbers": false,
  "soft_wrap": "editor_width",
  "preferred_line_length": 100,
  "remove_trailing_whitespace_on_save": true,
  "ensure_final_newline_on_save": true
}
```

### Themes

Built-in **One Dark** and **One Light** match Zed’s defaults. Extensions add more. Theme overrides can tweak syntax tokens (see Zed docs on `theme_overrides`).

## Vim mode

If you migrate from Vim/Neovim/Helix:

```json
{
  "vim_mode": true
}
```

Expect:

- Motions and operators covering daily editing
- Occasional gaps vs full Neovim (plugins, exact text objects)
- Escape to normal mode still fundamental

Helix users: selection-first muscle memory will not map 1:1; use palette and multi-cursor features instead of forcing Helix habits.

## Language servers and extensions

Zed uses extensions for languages, themes, and tools.

Typical flow:

1. Open a file type (e.g. `main.go`)
2. Install recommended extension when prompted
3. Confirm diagnostics and go-to-definition work

Install language tools on the host as needed (`rust-analyzer`, `gopls`, `pyright`, etc.). Zed coordinates; it does not always bundle every server.

## Projects and workspaces

```bash
# Prefer opening the project root (git root)
cd ~/src/myapp && zed .

# Multi-folder workspaces: use Zed’s workspace UI / recent projects
```

Trust the project panel + file finder over deep nested terminal `cd` when working locally.

## Pairing with tmux and Herdr

Zed is a **GUI**. Common architectures:

### A. Local Zed + terminal multiplexer for agents

```text
Desktop: Zed (code)
Terminal: herdr or tmux
  ├─ claude / codex
  ├─ just dev
  └─ lazygit
```

### B. All in terminal (no Zed remote)

When only SSH is available: use Neovim/Helix inside tmux—not Zed.

### C. Remote code

Options people use:

- SSHFS / mutual NFS + local Zed (latency sensitive)
- Dev containers / remote hosts with local sync (mutagen, etc.)
- Stay on terminal editors for high-latency links

Do not expect classic “Zed over dumb SSH” to feel like local.

## Collaboration

Zed’s multiplayer lets multiple people edit a project together. Use when:

- Pairing on a design spike
- Mentoring
- Shared incident editing (with care around secrets)

Turn collaboration off for sensitive codebases unless policy allows.

## Git workflow

Zed provides git UI affordances (status, diffs—feature set depends on version). Many Linux power users still prefer:

```bash
# In an adjacent terminal / Herdr pane
lazygit
git diff | delta
```

Use Zed for editing hunks; use terminal for complex rebase surgery if you already know it.

## Comparison: Zed vs neighbors

| | **Zed** | **VSCodium/Code** | **Neovim** | **Helix** |
|--|---------|-------------------|------------|-----------|
| UI | Native GPU | Electron | TUI | TUI |
| SSH-first | Weak | Remote-SSH ext | Strong | Strong |
| Config | JSON / UI | JSON + ext | Lua | TOML |
| Plugins | Extensions | Huge | Huge | Minimal (built-ins) |
| Startup | Fast | Heavier | Fast | Fast |
| Collab | Built-in focus | Live Share etc. | Plugins | Limited |

## Migration tips

### From VS Code

- Install language extensions analogous to your VS Code set
- Relearn a smaller command palette surface
- Map keybindings gradually; do not clone 200 VS Code chords day one

### From Neovim

- Enable `vim_mode` or keep a terminal nvim for remote
- Accept that Lua plugin ecosystems do not transfer
- Keep tmux/Herdr muscle memory for session persistence

### From Helix

- Use multi-cursor and palette
- Rely on extensions for features Helix builds in

## Troubleshooting

| Problem | Try |
|---------|-----|
| `zed` not in PATH | Re-login; add install dir to PATH |
| Git opens and exits | Use `zed --wait` |
| Ugly fonts | Set `buffer_font_family` to a Nerd/ mono font you installed |
| LSP dead | Install extension + server binary; check language logs in UI |
| Wayland quirks | Update GPU drivers; try X11 session only for isolation tests |
| Flatpak permissions | Grant filesystem access to project paths |

## Practice checklist

- [ ] Install Zed and open a real git repo with `zed .`
- [ ] Set `EDITOR="zed --wait"` and make a git commit
- [ ] Toggle One Dark / One Light
- [ ] Enable or deliberately skip Vim mode
- [ ] Run tests in an external tmux/Herdr pane while editing in Zed
- [ ] Use command palette to format document and jump to file

## When to choose Zed

**Choose Zed** when you want a fast local GUI, collaboration, and modern defaults on Linux desktops.

**Choose Neovim/Helix** when you live in SSH, minimal environments, or keyboard-only modal purity.

**Choose both**: Zed locally, terminal editor remotely—the norm for many teams.

Next: [Workflows](../14-workflows/index.md) for end-to-end stacks that combine Zed, tmux, Herdr, and the editors from earlier parts.

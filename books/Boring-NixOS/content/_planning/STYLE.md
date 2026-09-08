# Chapter Style Guide (Boring NixOS)

## Core Philosophy: Boring, Explicit, Deterministic
1. **Clarity beats magic.** Favor reproducible, self-contained, and readable configurations over esoteric flakes or macro-heavy abstractions.
2. **Standalone Book:** Never cross-reference or assume the reader has read any other book in the library. All prerequisites and context are self-contained.
3. **No loose external files.** Every expression, flake, shell, or module listing must be complete and displayed inline inside fenced code blocks.
4. **Runnable listings:** First line of every fenced block is the filename comment: `# default.nix`, `# flake.nix`, `# shell.nix`, `# configuration.nix`.
5. **Exact Command & Output:** After every code fence, provide the exact invocation (`nix-build`, `nix-shell`, `nix eval`, etc.) and its terminal output.
6. **Consistent Domain:** A recurring infrastructure desk scenario (workstation, team devShell, internal services) runs through the worked examples.

## Standard Chapter Skeleton
- YAML frontmatter with `title:` matching the `#` heading.
- One-paragraph thesis: the boring default and why it wins.
- `## Mental model`
- `## Worked examples` (Cases 1 to 5)
- `## The trap` (common pitfall, anti-pattern, and fix)
- `## The boring rule` (concise bullet guidelines)
- `## Try this` (hands-on exercises)

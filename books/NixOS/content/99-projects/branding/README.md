# Sample distro branding assets (lab only)

These files are **teaching placeholders** for Projects 5–7 (custom NixOS-based distro).

| File | Use |
|------|-----|
| `logo.svg` | System `environment.etc`, greeter/docs mockups, ISO branding notes |
| `os-release.fragment.example` | Fields to merge into identity module experiments |
| `plymouth-theme-notes.md` | How to think about splash themes without vendoring huge assets |

## License

Original simple geometry in `logo.svg` is provided for this monorepo as **CC0-1.0** (public domain dedication) so you can remix freely for personal labs.

## Trademark

Do **not** reuse official NixOS snowflake artwork as your distro mark. Use a **distinct name** (e.g. `MyNixOS`, `YararaLab`) and follow [NixOS branding guidance](https://nixos.org/community/) when mentioning upstream.

## Wire into a flake

```nix
environment.etc."mynixos/logo.svg".source = ./branding/logo.svg;
```

Or copy into your own repo:

```bash
cp -r path/to/books/NixOS/content/99-projects/branding ~/src/my-distro/branding
```

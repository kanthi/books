# Plymouth / greeter theme notes (lab)

## Goal

Visible **product identity** on boot/login without shipping megabytes of third-party themes you do not license.

## Practical path on 26.05

1. **Console first** — `console.colors`, `console.font`, `/etc/issue` (Projects 5–6). Cheap and reliable in QEMU.
2. **Plymouth** — `boot.plymouth.enable = true` with a **stock** theme (`spinner`, etc.) while learning. Custom themes = package a theme derivation later.
3. **Greeter logo** — option names depend on GDM/SDDM/LightDM and nixpkgs revision. Verify on your pin; if missing, set wallpaper via Home Manager on installed systems.
4. **ISO volume label** — `isoImage.volumeID` / `isoImage.isoName` when using installer profiles.

## Custom Plymouth (stretch)

- Theme = directory of script + images under the Plymouth theme path.
- Package with `stdenv.mkDerivation` installing into `$out/share/plymouth/themes/...`.
- Reference via `boot.plymouth.themePackages` + `boot.plymouth.theme`.
- Test only in a VM with enough RAM; Plymouth failures are painful on metal.

## Assets in this folder

Use `logo.svg` as a greeter/docs mark. Convert to PNG if a greeter requires bitmap:

```bash
# if rsvg-convert available
rsvg-convert -w 256 logo.svg -o logo.png
```

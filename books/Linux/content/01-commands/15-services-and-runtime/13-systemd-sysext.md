---
title: "systemd-sysext"
author:
  - name: "K19G"
  - name: "grok-bot"
---

## Overview

**Thesis:** immutable and image-based Linux hosts still need *optional* tools — `strace`, a newer debug agent, a lab-only CLI — without baking every binary into the base OS or punching holes in the read-only root. **`systemd-sysext`** activates **system extension images** that overlay `/usr/` and `/opt/` via OverlayFS at runtime. Drop a versioned image (directory, `.raw` disk image, or GPT image) under the extension search path, `merge` (or enable `systemd-sysext.service`), and the files appear as if they had always been part of the OS. `unmerge` takes them away again. The companion **`systemd-confext`** does the same for `/etc/`.

Typical operator jobs:

- Add debug/compiler toolchains to MicroOS / Flatcar / custom immutable images without a reboot-heavy transactional update.
- Temporarily override one `/usr` component with a locally built tree (`DESTDIR=… make install && systemd-sysext refresh`).
- Deliver optional additive software as versioned artefacts (including OCI-published `.raw` images) that track the base OS ID/VERSION.

```bash
systemd-sysext --version | head -1
systemd-sysext status
systemd-sysext list
```

```text
systemd 257 (257.13-1~deb13u1)
HIERARCHY EXTENSIONS SINCE
/opt      none       -
/usr      none       -
No OS extensions found.
```

Outputs below come from **systemd 257** on Debian 13 (kernel 6.12). Commands match `systemd-sysext(8)` as of systemd 262~devel man pages; mutability modes arrived in 256, `--always-refresh=` in 260.

## Mental model

```text
  /var/lib/extensions/<name>/     or  <name>.raw
  /run/extensions/…              or  /etc/extensions/… (often symlinks)
                 │
                 ▼
        extension-release.NAME     ← must match image name; ID=/VERSION_ID=/SYSEXT_LEVEL=
                 │
                 ▼
   systemd-sysext merge|refresh    OverlayFS over host /usr and /opt
                 │
                 ▼
        binaries appear under /usr and /opt as if shipped in the base image
        (files outside /usr and /opt in the image are ignored)
```

| Fact | Consequence |
|------|-------------|
| Merge is **OverlayFS**, not a package install | No dependency solver. Carry what you need, or link only against libraries the base OS already has |
| Only `/usr` and `/opt` from the image are merged | Dropping files in the image's `/etc` or `/var` does **nothing** for sysext (use **confext** for `/etc`) |
| Matching uses **`extension-release.NAME`** | `ID=` must match host `os-release` (or be `_any`); then `SYSEXT_LEVEL=` or `VERSION_ID=` must match unless forced |
| Installed ⇒ activated (no enable bit) | Every image found at boot is merged if `systemd-sysext.service` runs. Mask with an empty `/etc/extensions/NAME/` directory |
| sysext ≠ portable services | Portable services are sandboxed units with their own root. Sysext is *additive host files* with **no** isolation |

## Syntax

```bash
systemd-sysext [OPTIONS...] status|merge|unmerge|refresh|list
systemd-confext [OPTIONS...] status|merge|unmerge|refresh|list   # /etc only
```

| Command | Meaning |
|---------|---------|
| `status` | Show whether `/usr` and `/opt` (or `/etc` for confext) are currently merged |
| `list` | Brief list of installed extension images |
| `merge` | Overlay all currently installed images (fails if already merged) |
| `unmerge` | Tear down the overlay |
| `refresh` | Unmerge + merge (after installing/removing an image). Brief window where extension files disappear |

Common options:

| Option | Meaning |
|--------|---------|
| `--root=PATH` | Operate relative to PATH (image builds, chroots) |
| `--force` | Ignore version / ID mismatches |
| `--mutable=…` | `no` (default), `auto`, `yes`, `import`, `ephemeral`, `ephemeral-import` — see Mutability |
| `--image-policy=…` | Disk-image dissection policy (`systemd.image-policy(7)`) |
| `--no-reload` | Skip manager reload / unit restart hooks from `extension-release` |

Search paths (sysext): `/etc/extensions/`, `/run/extensions/`, `/var/lib/extensions/` (primary for large images), plus `/.extra/sysext/` in the initrd.

## Safety

- **Sysext is not a security boundary.** Merged binaries run as part of the host OS with the same trust as `/usr`. Prefer portable services or containers when you need isolation.
- **`refresh` briefly unmounts.** Anything that must not disappear mid-flight (in-use DSOs, running binaries from the extension) can break across refresh; prefer a maintenance window or restart units listed in `EXTENSION_RESTART_UNITS=`.
- **Default merge makes `/usr` and `/opt` read-only** on mutable hosts. That surprises admins who then cannot `apt install` into `/usr` until they `unmerge` or enable a mutability mode.
- **`--force` skips compatibility checks.** Easy way to load an extension built for another OS release and get subtle ABI breakage.
- Merging needs privileges and a working mount namespace (OverlayFS). Confined CI containers often can `list`/`status` but fail `merge`.

## Examples with Explanations

### 1. Inventory and status

```bash
systemd-sysext status
systemd-sysext list
systemctl is-enabled systemd-sysext.service 2>/dev/null || true
```

```text
HIERARCHY EXTENSIONS SINCE
/opt      none       -
/usr      none       -
No OS extensions found.
```

On a stock Debian workstation you will usually see an empty list. On MicroOS / image-based fleets, `list` is the first question after "why is `/usr/bin/strace` missing?"

### 2. Build a directory-based extension

A directory tree that looks like a mini OS, plus a matching `extension-release` file:

```bash
# layout.sh — create a toy sysext that ships one script
ROOT=/var/lib/extensions/mytools   # needs root to install system-wide
# For labs, build under a staging dir first:
STAGE=/tmp/mytools
rm -rf "$STAGE"
mkdir -p "$STAGE/usr/bin" \
         "$STAGE/usr/lib/extension-release.d"
cat > "$STAGE/usr/bin/hello-sysext" <<'EOF'
#!/bin/sh
echo "hello from sysext"
EOF
chmod 755 "$STAGE/usr/bin/hello-sysext"
cat > "$STAGE/usr/lib/extension-release.d/extension-release.mytools" <<'EOF'
ID=_any
# VERSION_ID= / SYSEXT_LEVEL= omitted: ID=_any skips host version match
EOF
find "$STAGE" -type f | sort
```

```text
/tmp/mytools/usr/bin/hello-sysext
/tmp/mytools/usr/lib/extension-release.d/extension-release.mytools
```

Install by copying/symlinking into a search path, then merge:

```bash
sudo mkdir -p /var/lib/extensions
sudo cp -a /tmp/mytools /var/lib/extensions/mytools
sudo systemd-sysext merge          # or: refresh, if already merged
systemd-sysext status
command -v hello-sysext && hello-sysext
sudo systemd-sysext unmerge
```

Expected after a successful merge on a real host:

```text
HIERARCHY EXTENSIONS SINCE
/usr      mytools    …
hello from sysext
```

`--root=` is useful in image pipelines. `systemd-sysext --root=/path/to/rootfs list` enumerates extensions under that root without touching the live `/usr`. Full `merge` still needs a capable mount namespace; confined environments may return `Failed to merge hierarchies`.

### 3. `extension-release` matching

| Field | Role |
|-------|------|
| `ID=` | Must equal host `ID=` unless `_any` |
| `SYSEXT_LEVEL=` | If set, must match host `SYSEXT_LEVEL=` |
| `VERSION_ID=` | Used when `SYSEXT_LEVEL` is absent |
| `ARCHITECTURE=` | Optional; `_any` or match `uname` arch identifiers |
| `EXTENSION_RELOAD_MANAGER=1` | Reload PID 1 after merge/refresh |
| `EXTENSION_RESTART_UNITS=` | Units to restart after merge/unmerge (binary replaced) |
| `EXTENSION_RELOAD_OR_RESTART_UNITS=` | Prefer reload when the unit supports it |

Name rule: file must be `extension-release.<image-name>` matching the directory or the `.raw` basename. Sysext images should **not** ship `/usr/lib/os-release` (it would overlay the host's identity).

### 4. Mutability (systemd 256+)

By default, merging on a writable host **locks** `/usr` and `/opt` to read-only. Modes:

| Mode | Behaviour |
|------|-----------|
| `no` (default) | Force immutable overlay |
| `auto` | Mutable only if write-routing dirs exist under `/var/lib/extensions.mutable/` |
| `yes` | Force mutable; create routing dirs as needed |
| `import` | Immutable, but merge contents of routing dirs into the host view |
| `ephemeral` | Mutable via temp dirs; changes discarded on unmerge |
| `ephemeral-import` | Like ephemeral, but also import routing-dir contents |

```bash
sudo systemd-sysext --mutable=ephemeral merge
# experiment under /usr …
sudo systemd-sysext unmerge   # experiments gone
```

### 5. OCI / image delivery pattern (openSUSE-style)

Upstream `systemd-sysext` itself accepts directories and disk images, **not** an `oci:` URL. Distros layer delivery on top:

- **openSUSE MicroOS `sysextmgrcli` / `sysextmgrd`** (2026): Varlink daemon downloads verified images into `/var/lib/sysext-store`, symlinks them into `/etc/extensions/` (so they ride Btrfs snapshots / rollbacks), then you still **`systemd-sysext merge`** to activate. Default catalogue includes `debug`, `gcc`, and `git` sysexts — e.g. `sysextmgrcli install git && systemd-sysext merge`.
- **OCI proxy / sysupdate experiments**: publish a `.raw` (or single-layer scratch image wrapping it) to a registry; a helper pulls into the sysext search path. Kairos and community `sysext-oci-proxy` document `oci:` URIs as *alpha* delivery — activation remains `systemd-sysext`.

Boring rule for fleets: treat OCI/HTTP as **transport**. The trust boundary is still `extension-release` matching + image policy (verity/signatures when you use `.raw` GPT images), and activation is always merge/refresh.

```bash
# conceptual MicroOS flow (package names from openSUSE 2026 docs)
sysextmgrcli list
sysextmgrcli install debug          # store + symlink
systemd-sysext merge                # actually overlay /usr
# …
systemd-sysext unmerge
```

### 6. confext vs sysext

```bash
systemd-confext status    # overlays /etc only; nosuid (+ noexec by default)
```

Use **sysext** for binaries and libraries under `/usr`/`/opt`. Use **confext** when you want to swap drop-in config without shipping code. Do not expect a sysext's `/etc` files to appear on the host.

## The trap

1. **Expecting package-manager semantics.** No deps, no scripts, no triggers — just files.
2. **Putting config in a sysext.** Ignored. Ship a confext or bake config into the base image.
3. **Forgetting `extension-release` name match.** Silent skip / version error; `--force` hides the lesson.
4. **Leaving sysext merged while trying to mutate `/usr` with `apt`/`dnf`.** Remount/read-only surprises; `unmerge` first or use `--mutable=`.
5. **Confusing sysext with portable services or Flatpak.** Different isolation and lifecycle models.

## The boring rule

For optional additive software on an immutable base: build a sysext (directory or `.raw`) with a correct `extension-release`, install it under `/var/lib/extensions/`, enable `systemd-sysext.service` (or `merge` by hand), and keep delivery (HTTP/OCI/sysextmgr) separate from activation. Prefer `_any` + careful library choices, or pin `VERSION_ID`/`SYSEXT_LEVEL` to the base image you tested.

## Try this

1. `systemd-sysext list && systemd-sysext status` on your hosts; enable the service only where you intend extensions to apply at boot.
2. Stage a directory extension under `/tmp`, install it into `/var/lib/extensions/`, `merge`, run the binary, `unmerge`.
3. On MicroOS, install the `debug` sysext via `sysextmgrcli`, merge, run `strace --version`, unmerge, and confirm the binary disappears.

## Sources

- `systemd-sysext(8)`, `sysext.conf(5)`, `os-release(5)` — systemd project man pages (verified against systemd 257 locally; man text through 262~devel)
- [Managing System Extensions with sysextmgrcli](https://microos.opensuse.org/blog/2026-04-23-sysextmgr/) — openSUSE MicroOS, 2026-04-23
- Inspiration: X discussion of openSUSE OCI/sysext delivery (post `2099088197942935737`); chapter verified against systemd man + MicroOS docs, not the post

# CI assets

## TinyTeX cache (Option A)

GitHub Actions installs **TinyTeX** under `~/.TinyTeX` (not apt `texlive-*`) and
caches it with `actions/cache@v4`.

| File | Role |
|------|------|
| `tinytex-version.txt` | Pinned release tag (e.g. `v2026.08`) |
| `tinytex-packages.txt` | `tlmgr install` list (cache miss only) |
| `fontawesome5.zip` | Vendored Font Awesome 5 for Quarto callouts |

Scripts:

| Script | Role |
|--------|------|
| `books/scripts/setup-ci-tinytex.sh` | Download/extract TinyTeX-1, tlmgr packages, PATH |
| `books/scripts/install-ci-tex-extras.sh` | Unpack fontawesome5 into `~/texmf` |
| `books/scripts/ci-tex-setup.sh` | Orchestrates both + checks `soul` / `fontawesome5` |

### Cache key

Invalidated when any of these change:

- `tinytex-version.txt`
- `tinytex-packages.txt`
- `fontawesome5.zip`
- setup / install scripts above

On **cache hit**: restore `~/.TinyTeX` + `~/texmf`, set PATH, skip bulk `tlmgr install`.  
On **cache miss**: download TinyTeX-1 from GitHub releases + install package list.

### Refresh TinyTeX pin

```bash
# pick a tag from https://github.com/rstudio/tinytex-releases/releases
echo v2026.08 > books/ci/tinytex-version.txt
# edit tinytex-packages.txt if needed
git add books/ci/tinytex-version.txt books/ci/tinytex-packages.txt
```

### Refresh fontawesome5

```bash
cd books/ci
curl -fsSL -o fontawesome5.zip https://mirrors.ctan.org/fonts/fontawesome5.zip
unzip -t fontawesome5.zip
```

Do **not** rely on CTAN from CI (SSL/timeouts). Commit the zip.

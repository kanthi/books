# CI assets

## `fontawesome5.zip`

Vendored [fontawesome5](https://ctan.org/pkg/fontawesome5) package (CTAN).

Used by `books/scripts/install-ci-tex-extras.sh` so GitHub Actions does **not** download from CTAN mirrors (those often fail with curl SSL exit 60 or timeouts).

Quarto PDF callouts need `fontawesome5.sty`. We avoid installing full `texlive-fonts-extra` (~629 MB).

### Refresh (rare)

```bash
cd books/ci
curl -fsSL -o fontawesome5.zip https://mirrors.ctan.org/fonts/fontawesome5.zip
# or: https://mirror.ctan.org/fonts/fontawesome5.zip
unzip -t fontawesome5.zip
```

Commit the updated zip if upstream fontawesome5 changes and PDF icons break.

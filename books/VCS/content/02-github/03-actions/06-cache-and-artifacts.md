---
title: "Cache and artifacts"
---

# Cache and artifacts

They are not interchangeable.

| | **Cache** | **Artifact** |
|--|-----------|--------------|
| Purpose | Speed up *this* job next time (deps, tool downloads) | Hand a file to a **later job** or a human |
| Keyed by | `key:` / `restore-keys:` | `name:` |
| Eviction | LRU, ~10 GB/repo | Retention days (default 90, or what you set) |
| Cross-fork | Not restored for PRs from forks the same way you think — do not put secrets in a cache | Upload from a trusted job, download in another job of the **same run** |
| Typical | pip/npm directory | `dist/`, test reports, wheels |

A cache that stores build output you then ship is an artifact you forgot to name.

## Cache

`actions/setup-python` can cache pip itself (`cache: pip` + `cache-dependency-path`). Use that before you reach for `actions/cache`.

When you do need a raw cache:

```yaml
- uses: actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6.1.0
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('pyproject.toml') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

- `key` exact match → cache hit, skip the download.
- `restore-keys` prefix match → stale cache, still better than empty; then your install command refreshes.
- Include `runner.os` in the key. A Linux cache on Windows is a miss you paid to restore.

Do not cache files that contain credentials. Cache poisoning (a PR writing a malicious `~/.cache` that `main` then restores) is why GitHub scopes caches; still treat cache as **untrusted input** on `pull_request`.

## Artifacts

Job `build` uploads; job `test` or a human downloads.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - run: mkdir -p dist && echo "wheel" > dist/desk_tickets-0.1.0.txt
      - uses: actions/upload-artifact@043fb46d1a93c77aae656e7c1c64a875d1fc6a0a # v7.0.1
        with:
          name: tickets-dist
          path: dist/
          retention-days: 7
          if-no-files-found: error

  inspect:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c # v8.0.1
        with:
          name: tickets-dist
          path: dist
      - run: test -f dist/desk_tickets-0.1.0.txt
```

`if-no-files-found: error` stops the silent “uploaded nothing” success.

Artifacts are visible on the run page. Do not upload `.env`, wheels that embed tokens, or production databases.

## Which one?

- **Will another job in this run consume it?** Artifact.
- **Will a future run on the same repo be faster if this directory still exists?** Cache.
- **Both?** Build → artifact for the deploy job; cache only the package manager directory.

## Try this

1. Upload `dist/` from `build` and download it in `inspect`. Delete the upload step and confirm `if-no-files-found: error` fails the job.
2. Add a pip cache, run twice on `main`, compare “Install dependencies” wall time.
3. Find the artifact on the run summary page and download it locally.

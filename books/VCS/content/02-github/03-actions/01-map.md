---
title: "What Actions is"
---

# What Actions is

A **workflow** is a YAML file in `.github/workflows/` on the branch GitHub evaluates. GitHub-hosted runners are VMs GitHub starts for you (`ubuntu-latest`, `windows-latest`, `macos-latest`). A **self-hosted** runner is a machine you register; public-fork CI on those machines is a later security chapter, not the default.

| Word | Meaning |
|------|---------|
| Event | Why the run started (`push`, `pull_request`, …) |
| Workflow | One YAML file; one or more jobs |
| Job | Steps that share a runner and a filesystem |
| Step | One `run:` shell or one `uses:` action |
| Action | Reusable unit (`uses: owner/repo@sha`) |
| `GITHUB_TOKEN` | Short-lived token GitHub injects for that run |

Jobs in the same workflow run **in parallel** unless you set `needs:`. Steps in a job run **in order**.

## YAML you actually need

- Maps and lists. Indent with spaces, not tabs.
- `on:` is required. `jobs:` is required.
- `${{ }}` is an expression. Quote strings that would look like booleans (`"3.14"`).
- A workflow-level `permissions:` block sets the default for every job. If you name any permission, **unlisted scopes become `none`**.

## First green workflow

Repo layout (desk tickets, Python 3.14):

```text
desk-tickets/
├── pyproject.toml
├── src/tickets/__init__.py
└── .github/workflows/ci.yml
```

```toml
# pyproject.toml
[project]
name = "desk-tickets"
version = "0.1.0"
requires-python = ">=3.14"
```

```python
# src/tickets/__init__.py
def ping() -> str:
    return "ok"
```

Save this as `.github/workflows/ci.yml` and push to GitHub:

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:

permissions:
  contents: read

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: "3.14"
      - name: Prove the tree is here
        run: python -c "from src.tickets import ping; assert ping() == 'ok'"
```

On GitHub: **Actions** tab → the run named CI. A green check on the commit means this file parsed, the runner started, and the last step exited 0.

`contents: read` is enough to check out a public repo. Do not omit `permissions:` and hope the org default is read-only — orgs created before 2023 often still default to read-write.

## Pin by SHA, comment the tag

```yaml
uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
```

A moving tag (`@v4`, `@main`) can change under you. The SHA is the bits that run. Re-resolve:

```bash
git ls-remote https://github.com/actions/checkout.git refs/tags/v7.0.1
```

First-party pins used in this section (resolved 2026-09-12):

| Action | Tag | Commit |
|--------|-----|--------|
| `actions/checkout` | v7.0.1 | `3d3c42e5aac5ba805825da76410c181273ba90b1` |
| `actions/setup-python` | v7.0.0 | `5fda3b95a4ea91299a34e894583c3862153e4b97` |
| `actions/cache` | v6.1.0 | `55cc8345863c7cc4c66a329aec7e433d2d1c52a9` |
| `actions/upload-artifact` | v7.0.1 | `043fb46d1a93c77aae656e7c1c64a875d1fc6a0a` |
| `actions/download-artifact` | v8.0.1 | `3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c` |
| `actions/github-script` | v9.0.0 | `3a2844b7e9c422d3c10d287c895573f7108da1b3` |

## Try this

1. Push `ci.yml` to a new empty GitHub repo. Confirm the Actions tab shows a success.
2. Change `ping()` to return `"nope"`, push, confirm the job fails.
3. Remove the `permissions:` block in a fork of your own org, then check the run’s **Permissions** panel — write down what the token actually received.

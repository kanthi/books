---
title: "Security and OIDC"
---

# Security and OIDC

Actions security is four rules. Everything else is commentary.

1. Pin third-party actions to a **commit SHA**.
2. Set **`permissions:`** so `GITHUB_TOKEN` is least privilege.
3. Never run **fork code** with **base secrets** (`pull_request_target` + `checkout` of the PR).
4. Log into clouds with **OIDC**, not a 90-day access key in secrets.

## Pin

```yaml
# Good
- uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1

# Bad — tag can move
- uses: actions/checkout@v7

# Worse
- uses: some-user/cool-action@main
```

Resolve:

```bash
git ls-remote https://github.com/actions/checkout.git refs/tags/v7.0.1
```

Dependabot can open PRs that bump the SHA and the comment together. That is the boring update path.

## `pull_request` vs `pull_request_target`

| | `pull_request` | `pull_request_target` |
|--|----------------|------------------------|
| Workflow file taken from | The PR merge / head side (untrusted on forks) | **Default branch of the base repo** (trusted) |
| `GITHUB_TOKEN` | Read-only on public forks; no repo secrets | **Write** + **secrets** of the base |
| Default `checkout` | PR merge commit | Base default branch |

`pull_request_target` exists so you can label or comment on a fork PR with a write token **without executing the fork’s code**.

This is the pwn:

```yaml
# DO NOT
on: pull_request_target
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          ref: ${{ github.event.pull_request.head.sha }}
      - run: pip install -e . && pytest
```

You just ran the attacker’s `setup.py` / `pyproject` scripts with production secrets and an OIDC-capable token.

Safe pattern for “comment on fork PRs”:

```yaml
on:
  pull_request_target:
    types: [opened]

permissions:
  pull-requests: write
  contents: read

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
        with:
          script: |
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: "thanks — CI on pull_request will run tests without secrets",
            });
```

No checkout of `head.sha`. Tests stay on `pull_request`.

## OIDC

The job asks GitHub for a short JWT (`id-token: write`), the cloud trusts `token.actions.githubusercontent.com`, and you get a role for minutes — not a stored key.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    environment: production
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      # Pin this action's SHA yourself before production:
      - uses: aws-actions/configure-aws-credentials@v5
        with:
          role-to-assume: arn:aws:iam::123456789012:role/desk-tickets-gha
          aws-region: eu-west-1
```

Cloud trust policy must constrain `sub` (repo and ref), not “any GitHub repo in the world.” Repos created after **2026-07-15** get an immutable default subject that includes owner and repo **ids** so a recycled namespace cannot assume the old role. Prefer those claims when you create new trust policies.

Do not combine `id-token: write` with `pull_request_target` and a checkout of PR code. That is how stolen OIDC deploys happen.

## Self-hosted runners

A self-hosted runner is a persistent machine with your network and your caches. A `pull_request` from a fork on that machine is **remote code execution on your LAN**.

- Public repo: do not attach self-hosted runners to `pull_request` from forks.
- Private repo: still treat the workflow as code execution; lock labels and repo allow-lists.
- Ephemeral VMs (one job, then destroy) are the least-bad self-hosted shape.

GitHub-hosted `ubuntu-latest` is the default until you have a measured reason (GPU, internal network, bigger disk).

## Script injection

Untrusted strings (`github.event.issue.title`, branch names) go into `env:`, not into `${{ }}` inside `run:`.

```yaml
- env:
    TITLE: ${{ github.event.pull_request.title }}
  run: printf '%s\n' "$TITLE"
```

## Try this

1. Search the org for `pull_request_target` and for `ref: ${{ github.event.pull_request.head`. Every hit needs a named owner.
2. Search for `uses: .*-action@v[0-9]` without a 40-character SHA. Pin or delete.
3. Create an AWS/GCP/Azure trust policy limited to `repo:YOURORG/desk-tickets:ref:refs/heads/main`. Prove a workflow on another branch cannot assume the role.

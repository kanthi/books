---
title: "Secrets and environments"
---

# Secrets and environments

Three buckets of values, in increasing sensitivity:

1. **`env` / `vars`** — non-secret configuration (`PYTHON_VERSION`, feature flags).
2. **Repository / org secrets** — `secrets.FOO`. Masked in logs. Available to workflows that GitHub considers trusted for that event.
3. **`GITHUB_TOKEN`** — minted per job. Scopes come from `permissions:`, the org/repo Actions default, and the event (fork `pull_request` is read-only).

Fork `pull_request` runs **do not** receive repository secrets. That is not a bug.

## `GITHUB_TOKEN` permissions

Put a deny-by-default block at the top of every workflow, then grant per job.

```yaml
permissions: {}

jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1

  comment:
    needs: test
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      - uses: actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3 # v9.0.0
        with:
          script: |
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: "tests green",
            });
```

If you set any permission at a level, unspecified permissions at that level are `none`. `write` includes `read`. `id-token: write` is **only** “may request an OIDC JWT” — it is not contents write. That belongs in Security.

Org owners can force a maximum of read for `GITHUB_TOKEN`. Check **Settings → Actions → General → Workflow permissions**.

`GITHUB_TOKEN` cannot add itself as a ruleset bypass actor. If a ruleset blocks the token from commenting or pushing, that is the ruleset, not a missing `permissions:` key.

## Secrets in steps

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    environment: staging
    steps:
      - env:
          TICKET_TOKEN: ${{ secrets.TICKET_TOKEN }}
        run: |
          test -n "$TICKET_TOKEN"
          # never: echo "$TICKET_TOKEN"
```

GitHub masks exact secret values in logs. It does not mask substrings you derived (`echo ${TICKET_TOKEN:0:4}`). Do not print them.

Configuration variables (`vars.APP_REGION`) are not secret. Do not put tokens there.

## Environments

An **environment** (`staging`, `production`) is a GitHub object: optional required reviewers, wait timer, deployment branch policy, and environment-scoped secrets.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://tickets.example.invalid
    permissions:
      contents: read
      deployments: write
    steps:
      - env:
          PROD_TOKEN: ${{ secrets.PROD_TOKEN }}
        run: echo "would deploy"
```

`secrets.PROD_TOKEN` can exist only on the `production` environment. A job without `environment: production` cannot see it.

Required reviewers pause the job at “Waiting for review.” That is a human gate, not a substitute for OIDC and SHA pins.

## Inheritance

| Source | Who sees it |
|--------|-------------|
| Job `env:` | That job |
| Workflow `env:` | All jobs |
| Environment secret | Jobs that name that environment |
| Org secret | Repos allowed by the org secret policy |
| Fork PR | Neither repo nor environment secrets |

## Try this

1. Add `permissions: {}` at the top of CI, then `contents: read` only on the test job. Confirm checkout still works.
2. Create environment `production` with a required reviewer and a secret. Run a workflow that names it. Confirm the job waits.
3. Open a fork PR that prints `env | grep TICKET`. Confirm the secret is absent.

---
title: "Actions"
---

# Actions

GitHub Actions runs **workflows** from YAML under `.github/workflows/`. A runner checks out your repo, executes **jobs** made of **steps**, and reports a check on the commit or pull request.

This section is the Actions curriculum. Later GitHub sections cover Pages, Packages, and `gh` as products; here the question is only: **what runs, with which token, on whose code?**

| Chapter | You should be able to |
|---------|------------------------|
| Map | Ship a first green workflow |
| Triggers | Choose `push` vs `pull_request` vs `workflow_dispatch` vs `schedule` |
| Jobs and steps | Chain jobs, `if:`, `run` vs `uses`, contexts |
| Secrets and environments | Scope `GITHUB_TOKEN`, secrets, Environments |
| Matrix | Test versions without copy-paste |
| Cache and artifacts | Know which one you need |
| CI | Lint and test a PR on a desk repo |
| Reuse | Composite actions and `workflow_call` |
| Custom actions | When a local composite is not enough |
| Security and OIDC | SHA pins, pwn requests, cloud login without long-lived keys |
| Operate | Concurrency, minutes, `gh run` |

Examples use a tiny Python **desk-tickets** repo and pin first-party actions to commit SHAs (with the tag in a comment). Re-resolve those SHAs before you copy them into a real org.

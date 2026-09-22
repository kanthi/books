# VCS syllabus

Four parts. Git is the tool. GitHub is a product. Jujutsu is a separate VCS (seed now, full later). Forges are GitLab and Gitea.

Do not reteach Git inside GitHub or JJ. A GitHub reader needs remotes, branches, and commits; give a one-paragraph recap at the GitHub door, not a second Git course.

---

## Part 1 — Git (`content/01-git/`)

Rebased onto the practical Git TOC (mental model → recovery), merged with the old Git chapters. Pull requests and Actions stay in the GitHub part.

| Section | Topics |
|---------|--------|
| Intro | One section: why Git, evolution, mental model (DAG, three trees, reset, detached HEAD), cheatsheet |
| Install and config | Install, system/global/local, identity, SSH vs HTTPS |
| First repository | init, add/commit, status, log, `.gitignore`, undo |
| Commits and history | Amend, squash, cherry-pick, shared-history rewrites |
| Branching and merging | Branches, tags, fast-forward / three-way / octopus, conflicts |
| Rebasing | Interactive rebase, per-commit conflicts, `--force-with-lease`, vs merge |
| Remotes | fetch/pull/push, tracking, extra remotes (no PR UI) |
| Workflows | Git Flow, trunk-based, GitHub Flow as a *git topology*, monorepos |
| Stash, tags, and cleanup | Stash (incl. `-p`), blame, grep, log, cleanup |
| Hooks | Client/server hooks, templates, pre-commit framework (not Actions) |
| Submodules and worktrees | Worktrees vs submodules vs subtree |
| Internals | Object store, SHA, packfiles, plumbing, `cat-file` |
| Performance and scale | Large repos, LFS, shallow/sparse/partial clone, bisect, tuning |
| Security | Signed commits (SSH/GPG), `filter-repo`, secrets in history |
| Troubleshooting | Reflog, `fsck`, recovery drills |

GitHub Flow in Workflows is a **branch topology**. Pull-request UI belongs in GitHub.

---

## Part 2 — GitHub (`content/02-github/`)

**Now:** six seed chapters moved out of Git (introduction, collaboration, Actions, platform, open source, orgs/teams). They are not the final outline.

**Next writing pass:** split and expand. Do not add empty section dirs until that pass starts.

| Future section | Intent |
|----------------|--------|
| Map | Git vs GitHub vs `gh`; what this part assumes |
| Identity | Account, 2FA/passkeys, SSH vs HTTPS, fine-grained PATs, SSO, verified commits |
| Repositories | Create, templates, `.github` repo, topics, README/LICENSE, default branch |
| Pull requests | Drafts, reviews, CODEOWNERS, auto-merge, merge queue, merge methods, `gh pr` |
| Issues and planning | Issues, types/sub-issues, labels, milestones, Projects v2, Discussions, forms |
| Actions | **Published** under `02-github/03-actions/` (11 chapters): map, triggers (incl. fork PRs), jobs/steps/contexts, secrets/environments/`GITHUB_TOKEN`, matrix, cache vs artifacts, PR CI (desk-tickets Python), composite + `workflow_call`, custom actions, SHA pins / pwn requests / OIDC / self-hosted, `gh run` + concurrency + minutes |
| Security | Rulesets vs classic branch protection, Dependabot, secret scanning, code scanning, advisories |
| Ship artifacts | Releases, Packages, Pages, environments/deployments |
| Automate GitHub | `gh` in depth, REST, GraphQL, webhooks, GitHub Apps vs OAuth apps |
| Orgs and enterprise | Teams, roles, inner source, Enterprise Cloud vs Server vs data residency, audit log |
| Open source | Community health files, sponsorships, first contribution, maintainer load |

Copilot is at most a short aside (it dates fast). Current seed files get broken apart into these sections; they are not one more 800-line dump.

---

## Part 3 — Jujutsu (`content/03-jj/`)

**Now:** seed overview (former Misc page). Not current as a full curriculum.

**Later pass:** change IDs, no index, `@` working-copy commit, revsets, colocated Git repos, bookmarks, undo, `jj git push`. Do not reteach Git.

---

## Part 4 — Forges (`content/04-forges/`)

Published seeds: GitLab, Gitea. Optional later: Codeberg, Forgejo, SourceHut. Not GitHub.

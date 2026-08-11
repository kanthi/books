# Chapter 7: Advanced Branching Strategies

## Introduction to Branching Strategies

Branching strategies are systematic approaches to organizing branches in a project. They define how teams create, name, merge, and delete branches to support different development workflows.

### Why Branching Strategies Matter

- **Consistency**: Team follows same patterns
- **Collaboration**: Clear rules for working together
- **Quality**: Systematic testing and review processes
- **Deployment**: Organized release management
- **Maintenance**: Easier bug fixes and hotfixes

## Git Flow

Git Flow is a branching model designed around project releases, created by Vincent Driessen.

### Git Flow Branch Types

#### Main Branches
- **main/master**: Production-ready code
- **develop**: Integration branch for features

#### Supporting Branches
- **feature/**: New features
- **release/**: Prepare new releases
- **hotfix/**: Critical production fixes

### Git Flow Workflow

#### 1. Feature Development
```bash
# Start feature from develop
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication

# Develop feature
# ... make commits ...

# Finish feature
git checkout develop
git merge --no-ff feature/user-authentication
git branch -d feature/user-authentication
git push origin develop
```

#### 2. Release Process
```bash
# Start release branch
git checkout develop
git checkout -b release/1.2.0

# Prepare release (version bumps, documentation)
echo "1.2.0" > VERSION
git commit -am "Bump version to 1.2.0"

# Finish release
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"

git checkout develop
git merge --no-ff release/1.2.0
git branch -d release/1.2.0

git push origin main develop --tags
```

#### 3. Hotfix Process
```bash
# Start hotfix from main
git checkout main
git checkout -b hotfix/1.2.1

# Fix critical issue
echo "Critical fix" > hotfix.patch
git commit -am "Fix critical security issue"

# Finish hotfix
git checkout main
git merge --no-ff hotfix/1.2.1
git tag -a v1.2.1 -m "Hotfix version 1.2.1"

git checkout develop
git merge --no-ff hotfix/1.2.1
git branch -d hotfix/1.2.1

git push origin main develop --tags
```

### Git Flow Tools

#### Git Flow Extension
```bash
# Install git-flow
# macOS: brew install git-flow
# Ubuntu: sudo apt-get install git-flow

# Initialize git-flow
git flow init

# Feature workflow
git flow feature start user-authentication
# ... develop feature ...
git flow feature finish user-authentication

# Release workflow
git flow release start 1.2.0
# ... prepare release ...
git flow release finish 1.2.0

# Hotfix workflow
git flow hotfix start 1.2.1
# ... fix issue ...
git flow hotfix finish 1.2.1
```

### Git Flow Pros and Cons

#### Advantages
- Clear separation of concerns
- Systematic release process
- Good for scheduled releases
- Well-documented workflow

#### Disadvantages
- Complex for simple projects
- Overhead for continuous deployment
- Long-lived branches can cause conflicts
- Not suitable for rapid iterations

## GitHub Flow

GitHub Flow is a simpler, more streamlined workflow designed for continuous deployment.

### GitHub Flow Principles

1. **main branch is always deployable**
2. **Create descriptive branches**
3. **Push to named branches frequently**
4. **Open pull request when ready**
5. **Deploy after review**
6. **Merge after deployment**

### GitHub Flow Workflow

```bash
# 1. Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/add-payment-processing

# 2. Make changes and push frequently
echo "Payment code" > payment.js
git add payment.js
git commit -m "Add payment processing logic"
git push -u origin feature/add-payment-processing

# 3. Open pull request (on GitHub)
# 4. Discuss and review code
# 5. Deploy to staging/production for testing
# 6. Merge pull request after approval

# 7. Clean up
git checkout main
git pull origin main
git branch -d feature/add-payment-processing
```

### GitHub Flow Best Practices

```bash
# Use descriptive branch names
git checkout -b feature/improve-search-performance
git checkout -b fix/login-redirect-issue
git checkout -b docs/update-api-documentation

# Push early and often
git push origin feature-branch

# Keep branches focused and small
# One feature/fix per branch

# Write good commit messages
git commit -m "Add search indexing for better performance

- Implement Elasticsearch integration
- Add search result caching
- Update search API endpoints"
```

### GitHub Flow Advantages

- **Simple**: Easy to understand and follow
- **Fast**: Quick iterations and deployments
- **Flexible**: Adapts to different project needs
- **Continuous**: Supports continuous deployment
- **Collaborative**: Built around pull requests

## GitLab Flow

GitLab Flow combines Git Flow and GitHub Flow concepts with environment-specific branches.

### GitLab Flow with Environment Branches

```bash
# Branch structure
main                    # Development
pre-production         # Staging environment
production            # Production environment

# Workflow
git checkout main
git checkout -b feature/new-dashboard

# Develop feature
git push origin feature/new-dashboard
# Create merge request to main

# After merge to main, promote to staging
git checkout pre-production
git merge main
git push origin pre-production

# After testing, promote to production
git checkout production
git merge pre-production
git push origin production
```

### GitLab Flow with Release Branches

```bash
# For projects with scheduled releases
main                   # Development
2-3-stable            # Release branch for version 2.3
2-4-stable            # Release branch for version 2.4

# Create release branch
git checkout main
git checkout -b 2-4-stable
git push origin 2-4-stable

# Cherry-pick fixes to release branch
git checkout 2-4-stable
git cherry-pick <commit-hash>
git push origin 2-4-stable
```

## Feature Branch Workflow

A simple workflow focusing on feature isolation.

### Basic Feature Branch Workflow

```bash
# 1. Update main branch
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/user-notifications

# 3. Develop feature
echo "Notification system" > notifications.js
git add notifications.js
git commit -m "Add notification system"

echo "Email notifications" > email.js
git add email.js
git commit -m "Add email notification support"

# 4. Push feature branch
git push -u origin feature/user-notifications

# 5. Create pull request
# 6. Code review and approval
# 7. Merge to main
git checkout main
git pull origin main

# 8. Clean up
git branch -d feature/user-notifications
git push origin --delete feature/user-notifications
```

### Feature Branch Best Practices

```bash
# Keep branches up to date
git checkout feature-branch
git rebase main

# Or merge main into feature
git merge main

# Squash commits before merging
git rebase -i HEAD~3

# Use meaningful branch names
feature/user-authentication
feature/payment-integration
bugfix/login-error
hotfix/security-vulnerability
```

## Release Branching

### Release Branch Strategy

```bash
# Create release branch
git checkout main
git checkout -b release/v2.1.0

# Prepare release
echo "2.1.0" > VERSION
git commit -am "Bump version to 2.1.0"

# Bug fixes during release preparation
git commit -am "Fix release blocker bug"

# Merge back to main and develop
git checkout main
git merge release/v2.1.0
git tag v2.1.0

git checkout develop
git merge release/v2.1.0

# Clean up
git branch -d release/v2.1.0
```

### Release Branch Benefits

- **Stabilization**: Fix bugs without blocking new features
- **Parallel development**: Continue feature work on develop
- **Quality assurance**: Dedicated testing phase
- **Documentation**: Update docs and changelogs

## Choosing the Right Strategy

### Project Characteristics

#### Small Teams / Simple Projects
- **GitHub Flow**: Simple, fast iterations
- **Feature Branch Workflow**: Basic isolation

#### Large Teams / Complex Projects
- **Git Flow**: Structured, systematic
- **GitLab Flow**: Environment-aware

#### Continuous Deployment
- **GitHub Flow**: Built for CD
- **GitLab Flow**: Environment branches

#### Scheduled Releases
- **Git Flow**: Release branches
- **GitLab Flow**: Release branches

### Decision Matrix

| Factor | Git Flow | GitHub Flow | GitLab Flow | Feature Branch |
|--------|----------|-------------|-------------|----------------|
| Complexity | High | Low | Medium | Low |
| Release Schedule | Scheduled | Continuous | Flexible | Flexible |
| Team Size | Large | Any | Any | Small-Medium |
| Deployment | Traditional | Continuous | Environment-based | Manual |
| Learning Curve | Steep | Gentle | Medium | Gentle |

## Implementing Branching Strategies

### Team Guidelines

```markdown
# Branching Strategy Guidelines

## Branch Naming
- feature/description-of-feature
- bugfix/description-of-bug
- hotfix/critical-issue-description
- release/version-number

## Workflow Rules
1. Always branch from main/develop
2. Keep branches focused and small
3. Write descriptive commit messages
4. Test before merging
5. Delete branches after merging

## Code Review
- All changes require pull request
- At least one approval required
- Automated tests must pass
- Documentation updated if needed
```

### Automation and Tools

```bash
# Branch protection rules (GitHub)
# - Require pull request reviews
# - Require status checks
# - Restrict pushes to main

# Git hooks for enforcement
# pre-commit: Run tests
# pre-push: Prevent direct pushes to main
# commit-msg: Enforce commit message format

# CI/CD integration
# - Automated testing on feature branches
# - Deployment pipelines
# - Quality gates
```

## Advanced Techniques

### Branch Policies

```bash
# Prevent direct pushes to main
git config branch.main.pushRemote no_push

# Require merge commits
git config branch.main.mergeoptions "--no-ff"

# Set up branch protection
# (Usually done through Git hosting platform)
```

### Automated Branch Management

```bash
# Delete merged branches automatically
git branch --merged | grep -v "\*\|main\|develop" | xargs -n 1 git branch -d

# Prune remote tracking branches
git remote prune origin

# Clean up old branches (script)
#!/bin/bash
git for-each-ref --format='%(refname:short) %(committerdate)' refs/heads | \
awk '$2 <= "'$(date -d '30 days ago' '+%Y-%m-%d')'"' | \
cut -d' ' -f1 | \
xargs -r git branch -D
```

## Exercises

### Exercise 1: Git Flow Implementation
1. Set up a repository with Git Flow
2. Create a feature branch and implement a feature
3. Create a release branch and prepare a release
4. Simulate a hotfix scenario

### Exercise 2: GitHub Flow Practice
1. Set up a repository for GitHub Flow
2. Create feature branches for different features
3. Practice pull request workflow
4. Implement branch protection rules

### Exercise 3: Strategy Comparison
1. Implement the same feature using different strategies
2. Compare the complexity and overhead
3. Analyze which strategy fits different scenarios
4. Document pros and cons for your team

## Summary

Branching strategies provide structure and consistency for team development:

- **Git Flow**: Comprehensive strategy for scheduled releases
- **GitHub Flow**: Simple strategy for continuous deployment
- **GitLab Flow**: Flexible strategy with environment awareness
- **Feature Branch Workflow**: Basic isolation strategy

Key considerations:
- Team size and experience
- Release schedule and deployment model
- Project complexity and requirements
- Tool integration and automation

The right branching strategy depends on your specific context. Start simple and evolve as your team and project grow. The next chapter will explore working with remote repositories, which is essential for implementing these collaborative branching strategies effectively.
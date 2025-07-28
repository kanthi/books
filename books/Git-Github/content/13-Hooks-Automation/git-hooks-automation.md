# Chapter 13: Git Hooks and Automation

## Introduction to Git Hooks

Git hooks are scripts that run automatically at specific points in the Git workflow. They allow you to automate tasks, enforce policies, and integrate with external systems.

### Types of Git Hooks

#### Client-Side Hooks
- **pre-commit**: Runs before commit is created
- **prepare-commit-msg**: Runs before commit message editor opens
- **commit-msg**: Runs after commit message is entered
- **post-commit**: Runs after commit is completed
- **pre-rebase**: Runs before rebase operation
- **post-checkout**: Runs after checkout operation
- **post-merge**: Runs after merge operation
- **pre-push**: Runs before push operation

#### Server-Side Hooks
- **pre-receive**: Runs before any references are updated
- **update**: Runs for each reference being updated
- **post-receive**: Runs after all references are updated
- **post-update**: Runs after post-receive (for compatibility)

### Hook Location and Setup

```bash
# Hooks are stored in .git/hooks/
ls .git/hooks/

# Sample hooks are provided (with .sample extension)
# To activate, remove .sample extension and make executable
mv .git/hooks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Client-Side Hooks

### Pre-Commit Hook

The pre-commit hook runs before a commit is created, allowing you to validate changes.

#### Basic Pre-Commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Check for debugging statements
if git diff --cached --name-only | xargs grep -l "console.log\|debugger\|pdb.set_trace"; then
    echo "Error: Debugging statements found in staged files"
    echo "Please remove debugging code before committing"
    exit 1
fi

# Check for TODO comments in staged files
if git diff --cached | grep -q "TODO\|FIXME\|XXX"; then
    echo "Warning: TODO/FIXME comments found in changes"
    echo "Consider addressing these before committing"
    # Don't exit 1 here - just warn
fi

echo "Pre-commit checks passed"
exit 0
```

#### Advanced Pre-Commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${GREEN}Running pre-commit checks...${NC}"

# Check if this is an initial commit
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    against=HEAD
else
    # Initial commit: diff against an empty tree object
    against=$(git hash-object -t tree /dev/null)
fi

# Check for whitespace errors
if ! git diff-index --check --cached $against --; then
    echo "${RED}Error: Whitespace errors found${NC}"
    exit 1
fi

# Check for large files
large_files=$(git diff --cached --name-only | xargs ls -la 2>/dev/null | awk '$5 > 1048576 {print $9 " (" $5 " bytes)"}')
if [ -n "$large_files" ]; then
    echo "${YELLOW}Warning: Large files detected:${NC}"
    echo "$large_files"
    echo "${YELLOW}Consider using Git LFS for large files${NC}"
fi

# Run linting for JavaScript files
js_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.js$')
if [ -n "$js_files" ]; then
    echo "Linting JavaScript files..."
    if ! npx eslint $js_files; then
        echo "${RED}ESLint failed. Please fix the issues above.${NC}"
        exit 1
    fi
fi

# Run tests
echo "Running tests..."
if ! npm test; then
    echo "${RED}Tests failed. Please fix failing tests before committing.${NC}"
    exit 1
fi

echo "${GREEN}All pre-commit checks passed!${NC}"
exit 0
```

### Commit-Msg Hook

The commit-msg hook validates commit messages.

```bash
#!/bin/sh
# .git/hooks/commit-msg

commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "Invalid commit message format!"
    echo "Format: type(scope): description"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    echo "Example: feat(auth): add user login functionality"
    exit 1
fi

# Check commit message length
if [ $(head -n1 "$1" | wc -c) -gt 72 ]; then
    echo "Commit message first line too long (max 72 characters)"
    exit 1
fi

exit 0
```

### Pre-Push Hook

The pre-push hook runs before pushing to a remote repository.

```bash
#!/bin/sh
# .git/hooks/pre-push

protected_branch='main'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# Prevent direct push to protected branch
if [ "$current_branch" = "$protected_branch" ]; then
    echo "Direct push to $protected_branch branch is not allowed"
    echo "Please create a pull request instead"
    exit 1
fi

# Run full test suite before push
echo "Running full test suite before push..."
if ! npm run test:full; then
    echo "Full test suite failed. Push aborted."
    exit 1
fi

# Check if branch is up to date with remote
remote_ref=$(git rev-parse origin/$current_branch 2>/dev/null)
local_ref=$(git rev-parse $current_branch)

if [ "$remote_ref" != "$local_ref" ] && [ -n "$remote_ref" ]; then
    echo "Your branch is not up to date with origin/$current_branch"
    echo "Please pull the latest changes first"
    exit 1
fi

exit 0
```

### Post-Commit Hook

The post-commit hook runs after a commit is completed.

```bash
#!/bin/sh
# .git/hooks/post-commit

# Send notification
commit_hash=$(git rev-parse HEAD)
commit_message=$(git log -1 --pretty=%B)
author=$(git log -1 --pretty=%an)

# Log commit to file
echo "$(date): $author committed $commit_hash" >> .git/commit.log

# Send Slack notification (if webhook configured)
if [ -n "$SLACK_WEBHOOK_URL" ]; then
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"New commit by $author: $commit_message\"}" \
        "$SLACK_WEBHOOK_URL"
fi

# Update documentation if needed
if git diff HEAD~1 --name-only | grep -q "README\|docs/"; then
    echo "Documentation updated, consider regenerating docs"
fi
```

## Server-Side Hooks

### Pre-Receive Hook

The pre-receive hook runs on the server before any references are updated.

```bash
#!/bin/sh
# hooks/pre-receive

# Read all references being updated
while read oldrev newrev refname; do
    # Extract branch name
    branch=$(echo $refname | cut -d/ -f3)

    # Protect main branch
    if [ "$branch" = "main" ]; then
        # Only allow fast-forward merges to main
        if [ "$oldrev" != "0000000000000000000000000000000000000000" ]; then
            # Check if this is a fast-forward
            if ! git merge-base --is-ancestor $oldrev $newrev; then
                echo "Error: Non-fast-forward updates to main branch are not allowed"
                echo "Please rebase your changes or use a pull request"
                exit 1
            fi
        fi
    fi

    # Check commit messages in the push
    for commit in $(git rev-list $oldrev..$newrev); do
        message=$(git log -1 --pretty=%s $commit)
        if ! echo "$message" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'; then
            echo "Error: Invalid commit message format in $commit"
            echo "Message: $message"
            exit 1
        fi
    done
done

exit 0
```

### Post-Receive Hook

The post-receive hook runs after all references are updated.

```bash
#!/bin/sh
# hooks/post-receive

# Read all references that were updated
while read oldrev newrev refname; do
    branch=$(echo $refname | cut -d/ -f3)

    # Deploy if main branch was updated
    if [ "$branch" = "main" ]; then
        echo "Deploying to production..."

        # Change to deployment directory
        cd /var/www/myapp

        # Pull latest changes
        git pull origin main

        # Install dependencies
        npm install --production

        # Restart application
        sudo systemctl restart myapp

        echo "Deployment completed"

        # Send notification
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Production deployment completed"}' \
            "$SLACK_WEBHOOK_URL"
    fi

    # Update staging if develop branch was updated
    if [ "$branch" = "develop" ]; then
        echo "Updating staging environment..."
        # Similar deployment process for staging
    fi
done
```

## Hook Management and Distribution

### Sharing Hooks with Team

Since hooks are not tracked by Git, you need alternative methods to share them:

#### Method 1: Hooks Directory in Repository
```bash
# Create hooks directory in repository
mkdir .githooks

# Create hooks in .githooks/
cat > .githooks/pre-commit << 'EOF'
#!/bin/sh
echo "Running pre-commit hook..."
# Hook content here
EOF

# Make executable
chmod +x .githooks/pre-commit

# Configure Git to use hooks from .githooks/
git config core.hooksPath .githooks

# Team members run:
git config core.hooksPath .githooks
```

#### Method 2: Installation Script
```bash
#!/bin/bash
# install-hooks.sh

HOOK_DIR=".git/hooks"
HOOKS_SOURCE="scripts/hooks"

# Copy hooks
for hook in pre-commit commit-msg pre-push; do
    if [ -f "$HOOKS_SOURCE/$hook" ]; then
        cp "$HOOKS_SOURCE/$hook" "$HOOK_DIR/$hook"
        chmod +x "$HOOK_DIR/$hook"
        echo "Installed $hook hook"
    fi
done

echo "Git hooks installation completed"
```

### Hook Templates

Create reusable hook templates:

```bash
# templates/pre-commit-template
#!/bin/sh
# Pre-commit hook template

# Configuration
ENABLE_LINTING=true
ENABLE_TESTING=false
ENABLE_SECURITY_SCAN=true

# Source common functions
. "$(dirname "$0")/hook-functions"

# Run checks based on configuration
if [ "$ENABLE_LINTING" = true ]; then
    run_linting || exit 1
fi

if [ "$ENABLE_TESTING" = true ]; then
    run_tests || exit 1
fi

if [ "$ENABLE_SECURITY_SCAN" = true ]; then
    run_security_scan || exit 1
fi

exit 0
```

## Advanced Hook Patterns

### Language-Specific Hooks

#### Python Project Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Check Python syntax
python_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')
if [ -n "$python_files" ]; then
    echo "Checking Python syntax..."
    for file in $python_files; do
        python -m py_compile "$file"
        if [ $? -ne 0 ]; then
            echo "Python syntax error in $file"
            exit 1
        fi
    done

    # Run Black formatter check
    if ! black --check $python_files; then
        echo "Code formatting issues found. Run 'black .' to fix."
        exit 1
    fi

    # Run flake8 linting
    if ! flake8 $python_files; then
        echo "Linting issues found. Please fix before committing."
        exit 1
    fi

    # Run mypy type checking
    if ! mypy $python_files; then
        echo "Type checking failed. Please fix type issues."
        exit 1
    fi
fi
```

#### Node.js Project Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Check for package.json changes
if git diff --cached --name-only | grep -q "package\.json"; then
    echo "package.json changed, updating package-lock.json..."
    npm install
    git add package-lock.json
fi

# Lint JavaScript/TypeScript files
js_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|jsx|tsx)$')
if [ -n "$js_files" ]; then
    echo "Linting JavaScript/TypeScript files..."
    npx eslint $js_files
    if [ $? -ne 0 ]; then
        echo "ESLint failed. Please fix the issues."
        exit 1
    fi

    # Type checking for TypeScript
    if echo "$js_files" | grep -q '\.tsx\?$'; then
        echo "Running TypeScript type checking..."
        npx tsc --noEmit
        if [ $? -ne 0 ]; then
            echo "TypeScript type checking failed."
            exit 1
        fi
    fi
fi

# Run tests for changed files
if [ -n "$js_files" ]; then
    echo "Running tests for changed files..."
    npx jest --findRelatedTests $js_files --passWithNoTests
    if [ $? -ne 0 ]; then
        echo "Tests failed for changed files."
        exit 1
    fi
fi
```

### Security-Focused Hooks

```bash
#!/bin/sh
# .git/hooks/pre-commit - Security focused

# Check for secrets
echo "Scanning for secrets..."
if git diff --cached | grep -E "(password|secret|key|token)" -i; then
    echo "Warning: Potential secrets detected in commit"
    echo "Please review the changes carefully"
fi

# Check for hardcoded IPs and URLs
if git diff --cached | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}|https?://[a-zA-Z0-9.-]+"; then
    echo "Warning: Hardcoded IPs or URLs detected"
    echo "Consider using configuration files instead"
fi

# Scan for common security issues
security_patterns=(
    "eval\("
    "exec\("
    "system\("
    "shell_exec\("
    "passthru\("
    "innerHTML\s*="
    "document\.write\("
)

for pattern in "${security_patterns[@]}"; do
    if git diff --cached | grep -E "$pattern"; then
        echo "Security warning: Potentially dangerous pattern detected: $pattern"
    fi
done

# Run security scanner if available
if command -v bandit >/dev/null 2>&1; then
    python_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')
    if [ -n "$python_files" ]; then
        echo "Running Bandit security scanner..."
        bandit $python_files
    fi
fi
```

## Hook Automation Tools

### Husky (Node.js)

Husky simplifies Git hooks management for Node.js projects:

```bash
# Install Husky
npm install --save-dev husky

# Initialize Husky
npx husky install

# Add pre-commit hook
npx husky add .husky/pre-commit "npm test"

# Add commit-msg hook
npx husky add .husky/commit-msg 'npx commitlint --edit "$1"'
```

Package.json configuration:
```json
{
  "scripts": {
    "prepare": "husky install"
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
}
```

### Pre-commit Framework

The pre-commit framework provides a multi-language hook manager:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 22.10.0
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/flake8
    rev: 5.0.4
    hooks:
      - id: flake8

  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.28.0
    hooks:
      - id: eslint
        files: \.(js|ts|jsx|tsx)$
        types: [file]
```

Installation and usage:
```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run on all files
pre-commit run --all-files

# Update hooks
pre-commit autoupdate
```

## Continuous Integration Integration

### GitHub Actions with Hooks

```yaml
# .github/workflows/hooks-validation.yml
name: Validate Hooks

on: [push, pull_request]

jobs:
  validate-hooks:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm ci

    - name: Run pre-commit checks
      run: |
        # Simulate pre-commit hook
        .githooks/pre-commit

    - name: Validate commit messages
      run: |
        # Check commit message format
        git log --oneline -10 | while read line; do
          message=$(echo "$line" | cut -d' ' -f2-)
          if ! echo "$message" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'; then
            echo "Invalid commit message: $message"
            exit 1
          fi
        done
```

### Hook Testing

```bash
#!/bin/bash
# test-hooks.sh

# Test pre-commit hook
echo "Testing pre-commit hook..."

# Create test repository
test_repo=$(mktemp -d)
cd "$test_repo"
git init

# Copy hook
cp "$OLDPWD/.git/hooks/pre-commit" .git/hooks/
chmod +x .git/hooks/pre-commit

# Test with good commit
echo "console.log('test');" > test.js
git add test.js

if .git/hooks/pre-commit; then
    echo "ERROR: Hook should have failed on console.log"
    exit 1
else
    echo "PASS: Hook correctly rejected console.log"
fi

# Test with clean commit
echo "function test() { return true; }" > test.js
git add test.js

if .git/hooks/pre-commit; then
    echo "PASS: Hook accepted clean code"
else
    echo "ERROR: Hook should have passed clean code"
    exit 1
fi

# Cleanup
cd "$OLDPWD"
rm -rf "$test_repo"

echo "All hook tests passed!"
```

## Exercises

### Exercise 1: Basic Hook Setup
1. Create pre-commit hook that checks for debugging statements
2. Create commit-msg hook that enforces message format
3. Test hooks with various scenarios
4. Set up hook sharing for team

### Exercise 2: Advanced Hook Development
1. Create language-specific hooks for your project
2. Implement security scanning in hooks
3. Add notification system to post-commit hook
4. Create hook testing framework

### Exercise 3: Hook Automation
1. Set up Husky or pre-commit framework
2. Configure multiple hooks with different tools
3. Integrate hooks with CI/CD pipeline
4. Create hook performance monitoring

### Exercise 4: Server-Side Hooks
1. Set up server-side hooks for deployment
2. Implement branch protection with hooks
3. Create automated testing on push
4. Add monitoring and alerting to server hooks

## Best Practices

### Hook Development
1. **Keep hooks fast** - slow hooks frustrate developers
2. **Provide clear error messages** - help developers fix issues
3. **Make hooks configurable** - allow team customization
4. **Test hooks thoroughly** - prevent blocking legitimate commits
5. **Document hook behavior** - team should understand what hooks do

### Hook Management
1. **Version control hook scripts** - track changes to hooks
2. **Consistent installation** - automate hook setup for team
3. **Regular updates** - keep hooks current with project needs
4. **Performance monitoring** - track hook execution time
5. **Graceful degradation** - handle missing dependencies

### Security Considerations
1. **Validate hook inputs** - don't trust user data
2. **Limit hook permissions** - run with minimal privileges
3. **Secure hook distribution** - verify hook integrity
4. **Audit hook changes** - review modifications carefully
5. **Monitor hook execution** - detect malicious activity

## Summary

Git hooks provide powerful automation capabilities:

- **Quality assurance**: Automated testing and linting
- **Policy enforcement**: Commit message formats, branch protection
- **Integration**: CI/CD, notifications, deployments
- **Security**: Vulnerability scanning, secret detection
- **Workflow optimization**: Automated tasks and validations

Key concepts mastered:
- Client-side and server-side hook types
- Hook development and testing
- Team hook distribution strategies
- Integration with automation tools
- Security and performance considerations

Git hooks transform Git from a simple version control tool into a comprehensive development workflow platform. They enable teams to maintain code quality, enforce standards, and automate repetitive tasks, ultimately improving productivity and reducing errors.

The next chapter will explore troubleshooting and recovery techniques, building upon the automation foundation to handle problems when they arise.
# Chapter 16: GitHub Advanced Features

## GitHub Pages

GitHub Pages allows you to host static websites directly from your GitHub repositories.

### Setting Up GitHub Pages

#### Basic Setup
```bash
# Method 1: Use main branch
# 1. Create repository with HTML files
# 2. Go to Settings > Pages
# 3. Select source: Deploy from branch
# 4. Choose branch: main
# 5. Site available at: https://username.github.io/repository

# Method 2: Use docs/ folder
mkdir docs
echo "<h1>My Project Documentation</h1>" > docs/index.html
git add docs/
git commit -m "Add documentation"
git push origin main
# Configure Pages to use docs/ folder
```

#### Custom Domain
```bash
# Add CNAME file to repository root
echo "www.example.com" > CNAME
git add CNAME
git commit -m "Add custom domain"
git push origin main

# Configure DNS:
# CNAME record: www -> username.github.io
# A records for apex domain:
# 185.199.108.153
# 185.199.109.153
# 185.199.110.153
# 185.199.111.153
```

### Jekyll Integration

#### Basic Jekyll Site
```yaml
# _config.yml
title: My Project
description: A great project description
baseurl: "/repository-name"
url: "https://username.github.io"

markdown: kramdown
highlighter: rouge
theme: minima

plugins:
  - jekyll-feed
  - jekyll-sitemap
```

```markdown
---
layout: default
title: Home
---

# Welcome to My Project

This is the homepage of my project.

## Features

- Feature 1
- Feature 2
- Feature 3
```

#### Custom Jekyll Theme
```bash
# Create Gemfile
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
gem "jekyll-theme-minimal"
EOF

# Install dependencies
bundle install

# Update _config.yml
echo "theme: jekyll-theme-minimal" >> _config.yml
```

### Advanced Pages Features

#### GitHub Actions for Pages
```yaml
# .github/workflows/pages.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build site
        run: npm run build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: ./dist

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v1
```

## GitHub Packages

GitHub Packages is a package hosting service integrated with GitHub.

### Publishing Packages

#### npm Package
```json
{
  "name": "@username/package-name",
  "version": "1.0.0",
  "publishConfig": {
    "registry": "https://npm.pkg.github.com"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/username/package-name.git"
  }
}
```

```bash
# Configure npm registry
echo "@username:registry=https://npm.pkg.github.com" >> .npmrc

# Login to GitHub Packages
npm login --registry=https://npm.pkg.github.com

# Publish package
npm publish
```

#### Docker Package
```dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

```bash
# Build image
docker build -t ghcr.io/username/app-name:latest .

# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u username --password-stdin

# Push image
docker push ghcr.io/username/app-name:latest
```

#### GitHub Actions for Package Publishing
```yaml
name: Publish Package

on:
  release:
    types: [published]

jobs:
  publish-npm:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          registry-url: 'https://npm.pkg.github.com'

      - name: Install dependencies
        run: npm ci

      - name: Publish to GitHub Packages
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  publish-docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Login to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
```

## Security Features

### Dependabot

#### Dependabot Configuration
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    reviewers:
      - "username"
    assignees:
      - "username"
    commit-message:
      prefix: "npm"
      include: "scope"

  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

#### Custom Dependabot Configuration
```yaml
# Advanced Dependabot settings
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "daily"
      time: "04:00"
      timezone: "America/New_York"
    allow:
      - dependency-type: "direct"
      - dependency-type: "indirect"
        update-type: "security"
    ignore:
      - dependency-name: "express"
        versions: ["4.x", "5.x"]
    labels:
      - "dependencies"
      - "npm"
    milestone: 4
    target-branch: "develop"
```

### Security Advisories

#### Creating Security Advisory
```markdown
# Security Advisory Template

## Summary
Brief description of the vulnerability.

## Details
Detailed explanation of the security issue.

## Impact
What kind of impact this vulnerability has.

## Patches
Information about patches or fixes.

## Workarounds
Temporary workarounds if patches aren't available.

## References
Links to additional information.

## Credits
Credit to security researchers who found the issue.
```

#### Private Vulnerability Reporting
```bash
# Enable private vulnerability reporting
# 1. Go to repository Settings
# 2. Security & analysis section
# 3. Enable "Private vulnerability reporting"

# Researchers can then report vulnerabilities privately
# You can collaborate on fixes before public disclosure
```

### Code Scanning

#### CodeQL Analysis
```yaml
# .github/workflows/codeql-analysis.yml
name: "CodeQL"

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * 1'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript', 'python' ]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}
        queries: security-extended,security-and-quality

    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
```

#### Third-Party Security Tools
```yaml
# Snyk security scanning
name: Snyk Security

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Snyk to check for vulnerabilities
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

### Secret Scanning

#### Secret Scanning Configuration
```bash
# GitHub automatically scans for secrets
# Common patterns detected:
# - API keys
# - Tokens
# - Passwords
# - Private keys
# - Database connection strings

# Custom patterns can be defined for organizations
```

#### Preventing Secret Commits
```bash
# Pre-commit hook to detect secrets
#!/bin/sh
# .git/hooks/pre-commit

# Check for common secret patterns
if git diff --cached | grep -E "(password|secret|key|token)" -i; then
    echo "Warning: Potential secrets detected"
    echo "Please review your changes"
fi

# Use tools like git-secrets
git secrets --scan
```

## GitHub API

### REST API Usage

#### Basic API Calls
```bash
# Get repository information
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/username/repository

# List issues
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/username/repository/issues

# Create issue
curl -X POST \
     -H "Authorization: token $GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"title":"Bug report","body":"Description of bug"}' \
     https://api.github.com/repos/username/repository/issues
```

#### API with JavaScript
```javascript
// Using Octokit
const { Octokit } = require("@octokit/rest");

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

// Get repository
async function getRepository() {
  const { data } = await octokit.rest.repos.get({
    owner: "username",
    repo: "repository",
  });
  return data;
}

// Create issue
async function createIssue(title, body) {
  const { data } = await octokit.rest.issues.create({
    owner: "username",
    repo: "repository",
    title: title,
    body: body,
  });
  return data;
}

// List pull requests
async function listPullRequests() {
  const { data } = await octokit.rest.pulls.list({
    owner: "username",
    repo: "repository",
    state: "open",
  });
  return data;
}
```

### GraphQL API

#### Basic GraphQL Queries
```graphql
# Get repository information
query {
  repository(owner: "username", name: "repository") {
    name
    description
    stargazerCount
    forkCount
    issues(first: 10) {
      nodes {
        title
        state
        createdAt
      }
    }
  }
}
```

```bash
# Execute GraphQL query
curl -X POST \
  -H "Authorization: bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query":"query { viewer { login } }"}' \
  https://api.github.com/graphql
```

#### Advanced GraphQL Operations
```javascript
// Using GraphQL with Octokit
const { graphql } = require("@octokit/graphql");

const graphqlWithAuth = graphql.defaults({
  headers: {
    authorization: `token ${process.env.GITHUB_TOKEN}`,
  },
});

// Complex query
const query = `
  query($owner: String!, $repo: String!, $first: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequests(first: $first, states: OPEN) {
        nodes {
          title
          author {
            login
          }
          reviews(first: 5) {
            nodes {
              state
              author {
                login
              }
            }
          }
        }
      }
    }
  }
`;

async function getPullRequestsWithReviews() {
  const result = await graphqlWithAuth(query, {
    owner: "username",
    repo: "repository",
    first: 10,
  });
  return result.repository.pullRequests.nodes;
}
```

## GitHub CLI

### Installation and Setup

```bash
# Install GitHub CLI
# macOS
brew install gh

# Ubuntu
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

### Common CLI Operations

#### Repository Management
```bash
# Clone repository
gh repo clone username/repository

# Create repository
gh repo create my-new-repo --public --description "My new repository"

# Fork repository
gh repo fork username/repository

# View repository
gh repo view username/repository

# List repositories
gh repo list username
```

#### Issue Management
```bash
# List issues
gh issue list

# Create issue
gh issue create --title "Bug report" --body "Description of bug"

# View issue
gh issue view 123

# Close issue
gh issue close 123

# Assign issue
gh issue edit 123 --add-assignee username
```

#### Pull Request Management
```bash
# Create pull request
gh pr create --title "Add new feature" --body "Description of changes"

# List pull requests
gh pr list

# View pull request
gh pr view 456

# Checkout pull request
gh pr checkout 456

# Merge pull request
gh pr merge 456 --squash

# Review pull request
gh pr review 456 --approve --body "Looks good!"
```

### CLI Automation

#### Scripting with GitHub CLI
```bash
#!/bin/bash
# automated-pr-workflow.sh

# Create feature branch
git checkout -b feature/new-functionality

# Make changes
echo "New functionality" > new-feature.txt
git add new-feature.txt
git commit -m "Add new functionality"

# Push branch
git push -u origin feature/new-functionality

# Create pull request
gh pr create \
  --title "Add new functionality" \
  --body "This PR adds new functionality to the application" \
  --reviewer teammate1,teammate2 \
  --assignee myself

# Wait for approval and merge
echo "Pull request created. Waiting for approval..."
```

#### GitHub CLI Extensions
```bash
# Install extensions
gh extension install github/gh-copilot

# List installed extensions
gh extension list

# Use extension
gh copilot suggest "create a function to sort an array"

# Create custom extension
gh extension create my-extension
```

## Advanced Automation

### GitHub Apps

#### Creating GitHub App
```javascript
// app.js - Simple GitHub App
const { App } = require("@octokit/app");
const { Octokit } = require("@octokit/rest");

const app = new App({
  appId: process.env.GITHUB_APP_ID,
  privateKey: process.env.GITHUB_PRIVATE_KEY,
});

// Handle webhook events
app.webhooks.on("issues.opened", async ({ octokit, payload }) => {
  const issue = payload.issue;

  // Auto-label new issues
  await octokit.rest.issues.addLabels({
    owner: payload.repository.owner.login,
    repo: payload.repository.name,
    issue_number: issue.number,
    labels: ["triage"],
  });

  // Add welcome comment
  await octokit.rest.issues.createComment({
    owner: payload.repository.owner.login,
    repo: payload.repository.name,
    issue_number: issue.number,
    body: "Thank you for opening this issue! We'll review it soon.",
  });
});

// Start server
const port = process.env.PORT || 3000;
app.webhooks.listen(port);
```

### Webhooks

#### Webhook Configuration
```javascript
// webhook-handler.js
const crypto = require("crypto");
const express = require("express");

const app = express();
app.use(express.json());

// Verify webhook signature
function verifySignature(payload, signature) {
  const hmac = crypto.createHmac("sha256", process.env.WEBHOOK_SECRET);
  const digest = "sha256=" + hmac.update(payload).digest("hex");
  return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(digest));
}

// Handle webhook events
app.post("/webhook", (req, res) => {
  const signature = req.headers["x-hub-signature-256"];
  const payload = JSON.stringify(req.body);

  if (!verifySignature(payload, signature)) {
    return res.status(401).send("Unauthorized");
  }

  const event = req.headers["x-github-event"];

  switch (event) {
    case "push":
      handlePushEvent(req.body);
      break;
    case "pull_request":
      handlePullRequestEvent(req.body);
      break;
    case "issues":
      handleIssueEvent(req.body);
      break;
  }

  res.status(200).send("OK");
});

function handlePushEvent(payload) {
  console.log(`Push to ${payload.repository.full_name}`);
  // Trigger deployment, run tests, etc.
}

function handlePullRequestEvent(payload) {
  console.log(`PR ${payload.action} in ${payload.repository.full_name}`);
  // Run checks, assign reviewers, etc.
}

app.listen(3000, () => {
  console.log("Webhook server listening on port 3000");
});
```

## Exercises

### Exercise 1: GitHub Pages Setup
1. Create a project documentation site with GitHub Pages
2. Set up custom domain and SSL
3. Implement automated deployment with GitHub Actions
4. Add Jekyll theme and customization

### Exercise 2: Package Publishing
1. Create and publish an npm package to GitHub Packages
2. Set up Docker image publishing
3. Implement automated publishing on releases
4. Configure package access and permissions

### Exercise 3: Security Implementation
1. Set up Dependabot for dependency updates
2. Configure CodeQL security scanning
3. Create security advisory for test vulnerability
4. Implement secret scanning prevention

### Exercise 4: API Integration
1. Build application using GitHub REST API
2. Create GraphQL queries for complex data
3. Implement GitHub CLI automation scripts
4. Create simple GitHub App with webhooks

## Best Practices

### GitHub Pages
1. **Use custom domains** for professional appearance
2. **Implement HTTPS** for security
3. **Optimize for performance** with static site generators
4. **Automate deployments** with GitHub Actions
5. **Monitor site analytics** and performance

### Security
1. **Enable all security features** available
2. **Regular security audits** of dependencies
3. **Implement secret scanning** prevention
4. **Monitor security advisories** for dependencies
5. **Train team** on security best practices

### API Usage
1. **Use authentication** for all API calls
2. **Implement rate limiting** handling
3. **Cache responses** when appropriate
4. **Handle errors gracefully** in applications
5. **Use GraphQL** for complex queries

### Automation
1. **Start simple** and build complexity gradually
2. **Test webhooks** thoroughly before production
3. **Monitor automation** performance and errors
4. **Document automation** workflows for team
5. **Implement proper error handling** and logging

## Summary

GitHub's advanced features provide comprehensive platform capabilities:

- **GitHub Pages**: Static site hosting with custom domains and automation
- **GitHub Packages**: Integrated package registry for multiple ecosystems
- **Security Features**: Comprehensive security scanning and vulnerability management
- **APIs**: Powerful REST and GraphQL APIs for integration
- **GitHub CLI**: Command-line interface for automation and productivity
- **Apps and Webhooks**: Custom integrations and automation

Key skills developed:
- Static site deployment and management
- Package publishing and distribution
- Security implementation and monitoring
- API integration and automation
- CLI scripting and workflow optimization
- Custom app development and webhook handling

These advanced features transform GitHub from a simple code hosting platform into a comprehensive development ecosystem, enabling teams to build, secure, and deploy applications efficiently.

The next chapter will explore open source contribution, building upon these advanced GitHub features to participate effectively in the global open source community.
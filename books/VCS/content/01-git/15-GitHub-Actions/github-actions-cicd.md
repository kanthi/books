# Chapter 15: GitHub Actions and CI/CD

## Introduction to GitHub Actions

GitHub Actions is a powerful automation platform that allows you to build, test, and deploy your code directly from your GitHub repository. It enables continuous integration and continuous deployment (CI/CD) workflows.

### Key Concepts

- **Workflow**: Automated process defined in YAML files
- **Event**: Trigger that starts a workflow (push, pull request, schedule)
- **Job**: Set of steps that execute on the same runner
- **Step**: Individual task within a job
- **Action**: Reusable unit of code for a step
- **Runner**: Server that executes workflows

### Benefits of GitHub Actions

- **Integrated**: Built into GitHub platform
- **Flexible**: Supports any language and framework
- **Scalable**: Runs on GitHub-hosted or self-hosted runners
- **Community**: Large marketplace of pre-built actions
- **Cost-effective**: Free tier for public repositories

## Workflow Basics

### Workflow File Structure

Workflows are defined in `.github/workflows/` directory as YAML files:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    - name: Install dependencies
      run: npm install
    - name: Run tests
      run: npm test
```

### Workflow Triggers (Events)

#### Push Events
```yaml
on:
  push:
    branches: [ main, develop ]
    paths: [ 'src/**', 'tests/**' ]
    tags: [ 'v*' ]
```

#### Pull Request Events
```yaml
on:
  pull_request:
    branches: [ main ]
    types: [ opened, synchronize, reopened ]
```

#### Scheduled Events
```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC
```

#### Manual Triggers
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
        - staging
        - production
```

#### Multiple Events
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'
  workflow_dispatch:
```

## Jobs and Steps

### Job Configuration

```yaml
jobs:
  build:
    name: Build Application
    runs-on: ubuntu-latest
    timeout-minutes: 30

    strategy:
      matrix:
        node-version: [16, 18, 20]
        os: [ubuntu-latest, windows-latest, macos-latest]

    steps:
      # Job steps here
```

### Step Types

#### Using Actions
```yaml
steps:
- name: Checkout code
  uses: actions/checkout@v3

- name: Setup Node.js
  uses: actions/setup-node@v3
  with:
    node-version: '18'
    cache: 'npm'
```

#### Running Commands
```yaml
steps:
- name: Install dependencies
  run: npm install

- name: Run multiple commands
  run: |
    echo "Building application..."
    npm run build
    echo "Build complete!"
```

#### Conditional Steps
```yaml
steps:
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: npm run deploy:prod

- name: Deploy to staging
  if: github.ref != 'refs/heads/main'
  run: npm run deploy:staging
```

## Common CI/CD Patterns

### Node.js Application Workflow

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16, 18, 20]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run linter
      run: npm run lint

    - name: Run tests
      run: npm test

    - name: Run build
      run: npm run build

    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      if: matrix.node-version == '18'

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Build application
      run: npm run build

    - name: Deploy to production
      run: npm run deploy
      env:
        DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

### Python Application Workflow

```yaml
name: Python CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version: [3.8, 3.9, '3.10', 3.11]

    steps:
    - uses: actions/checkout@v3

    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt

    - name: Lint with flake8
      run: |
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

    - name: Test with pytest
      run: |
        pytest --cov=./ --cov-report=xml

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      if: matrix.python-version == '3.10'
```

### Docker Build and Push

```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: myusername/myapp
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}

    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
```

## Secrets and Environment Variables

### Managing Secrets

```yaml
# Repository Settings > Secrets and variables > Actions
# Add secrets like:
# - API_KEYS
# - DEPLOY_TOKENS
# - DATABASE_PASSWORDS

steps:
- name: Deploy application
  run: ./deploy.sh
  env:
    API_KEY: ${{ secrets.API_KEY }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Environment Variables

```yaml
env:
  NODE_ENV: production
  API_URL: https://api.example.com

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      BUILD_ENV: staging

    steps:
    - name: Build with environment
      run: npm run build
      env:
        SPECIFIC_VAR: value
```

### Environment Protection

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Requires approval for production

    steps:
    - name: Deploy to production
      run: ./deploy.sh
      env:
        PROD_TOKEN: ${{ secrets.PROD_TOKEN }}
```

## Matrix Builds

### Basic Matrix

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16, 18, 20]
        os: [ubuntu-latest, windows-latest, macos-latest]

    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
```

### Complex Matrix

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}

    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
        include:
          - os: ubuntu-latest
            node-version: 20
            experimental: true
        exclude:
          - os: windows-latest
            node-version: 16

    steps:
    - name: Test on ${{ matrix.os }} with Node ${{ matrix.node-version }}
      run: npm test
```

## Artifacts and Caching

### Uploading Artifacts

```yaml
steps:
- name: Build application
  run: npm run build

- name: Upload build artifacts
  uses: actions/upload-artifact@v3
  with:
    name: build-files
    path: |
      dist/
      build/
    retention-days: 30
```

### Downloading Artifacts

```yaml
steps:
- name: Download build artifacts
  uses: actions/download-artifact@v3
  with:
    name: build-files
    path: ./artifacts
```

### Caching Dependencies

```yaml
steps:
- uses: actions/checkout@v3

- name: Cache Node modules
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-

- name: Install dependencies
  run: npm ci
```

## Custom Actions

### JavaScript Action

```yaml
# .github/actions/hello-world/action.yml
name: 'Hello World'
description: 'Greet someone and record the time'
inputs:
  who-to-greet:
    description: 'Who to greet'
    required: true
    default: 'World'
outputs:
  time:
    description: 'The time we greeted you'
runs:
  using: 'node16'
  main: 'index.js'
```

```javascript
// .github/actions/hello-world/index.js
const core = require('@actions/core');
const github = require('@actions/github');

try {
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);

  const time = (new Date()).toTimeString();
  core.setOutput("time", time);

  const payload = JSON.stringify(github.context.payload, undefined, 2);
  console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}
```

### Using Custom Action

```yaml
steps:
- uses: actions/checkout@v3
- uses: ./.github/actions/hello-world
  with:
    who-to-greet: 'GitHub Actions'
```

## Deployment Strategies

### Blue-Green Deployment

```yaml
name: Blue-Green Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Deploy to green environment
      run: ./deploy-green.sh
      env:
        DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}

    - name: Run health checks
      run: ./health-check.sh green

    - name: Switch traffic to green
      run: ./switch-traffic.sh green

    - name: Cleanup blue environment
      run: ./cleanup-blue.sh
```

### Rolling Deployment

```yaml
name: Rolling Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        server: [server1, server2, server3]

    steps:
    - uses: actions/checkout@v3

    - name: Deploy to ${{ matrix.server }}
      run: ./deploy.sh ${{ matrix.server }}
      env:
        SERVER_TOKEN: ${{ secrets.SERVER_TOKEN }}

    - name: Health check ${{ matrix.server }}
      run: ./health-check.sh ${{ matrix.server }}
```

### Canary Deployment

```yaml
name: Canary Deployment

on:
  push:
    branches: [ main ]

jobs:
  canary:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Deploy canary (10% traffic)
      run: ./deploy-canary.sh 10
      env:
        DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}

    - name: Monitor canary metrics
      run: ./monitor-canary.sh
      timeout-minutes: 10

    - name: Full deployment
      if: success()
      run: ./deploy-full.sh

    - name: Rollback canary
      if: failure()
      run: ./rollback-canary.sh
```

## Monitoring and Notifications

### Slack Notifications

```yaml
steps:
- name: Notify Slack on success
  if: success()
  uses: 8398a7/action-slack@v3
  with:
    status: success
    text: 'Deployment successful! :rocket:'
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

- name: Notify Slack on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    text: 'Deployment failed! :x:'
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Email Notifications

```yaml
steps:
- name: Send email notification
  if: always()
  uses: dawidd6/action-send-mail@v3
  with:
    server_address: smtp.gmail.com
    server_port: 465
    username: ${{ secrets.EMAIL_USERNAME }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: 'Build ${{ job.status }}: ${{ github.repository }}'
    body: |
      Build ${{ job.status }} for commit ${{ github.sha }}

      Repository: ${{ github.repository }}
      Branch: ${{ github.ref }}
      Commit: ${{ github.sha }}
      Author: ${{ github.actor }}
    to: team@example.com
    from: ci@example.com
```

## Security Best Practices

### Secure Secrets Management

```yaml
# Use environment-specific secrets
jobs:
  deploy-staging:
    environment: staging
    steps:
    - name: Deploy
      run: ./deploy.sh
      env:
        API_KEY: ${{ secrets.STAGING_API_KEY }}

  deploy-production:
    environment: production
    steps:
    - name: Deploy
      run: ./deploy.sh
      env:
        API_KEY: ${{ secrets.PRODUCTION_API_KEY }}
```

### Least Privilege Access

```yaml
permissions:
  contents: read
  packages: write
  security-events: write

jobs:
  security-scan:
    runs-on: ubuntu-latest
    permissions:
      security-events: write

    steps:
    - uses: actions/checkout@v3
    - name: Run security scan
      uses: github/codeql-action/analyze@v2
```

### Input Validation

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options:
        - staging
        - production
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Validate input
      run: |
        if [[ "${{ github.event.inputs.environment }}" != "staging" && "${{ github.event.inputs.environment }}" != "production" ]]; then
          echo "Invalid environment specified"
          exit 1
        fi
```

## Exercises

### Exercise 1: Basic CI Pipeline
1. Create a simple Node.js or Python project
2. Set up a basic CI workflow that:
   - Runs on push and pull requests
   - Tests multiple versions
   - Runs linting and tests
3. Test the workflow with different scenarios

### Exercise 2: Docker Build Pipeline
1. Create a Dockerfile for your application
2. Set up a workflow that:
   - Builds Docker image
   - Pushes to registry
   - Tags appropriately
3. Test with different triggers

### Exercise 3: Deployment Pipeline
1. Set up a staging and production environment
2. Create a deployment workflow that:
   - Deploys to staging automatically
   - Requires approval for production
   - Includes rollback capability
3. Test the approval process

### Exercise 4: Custom Action
1. Create a custom action for your specific needs
2. Use the action in a workflow
3. Publish the action to the marketplace (optional)

## Best Practices Summary

### Workflow Design
1. **Keep workflows focused**: One responsibility per workflow
2. **Use matrix builds**: Test across multiple environments
3. **Fail fast**: Stop on first failure when appropriate
4. **Cache dependencies**: Speed up builds with caching
5. **Use artifacts**: Share data between jobs

### Security
1. **Protect secrets**: Never log or expose secrets
2. **Use least privilege**: Minimal permissions required
3. **Validate inputs**: Check user inputs thoroughly
4. **Environment protection**: Require approvals for sensitive deployments
5. **Regular updates**: Keep actions and dependencies current

### Performance
1. **Parallel jobs**: Run independent jobs concurrently
2. **Conditional execution**: Skip unnecessary steps
3. **Efficient caching**: Cache at appropriate levels
4. **Resource optimization**: Choose appropriate runner sizes
5. **Artifact management**: Clean up old artifacts

## Summary

GitHub Actions provides comprehensive CI/CD capabilities:

- **Automated workflows**: Trigger on various events
- **Flexible execution**: Support for any language or platform
- **Integrated platform**: Built into GitHub ecosystem
- **Scalable infrastructure**: GitHub-hosted and self-hosted runners
- **Rich marketplace**: Thousands of pre-built actions

Key concepts mastered:
- Workflow syntax and structure
- Job and step configuration
- Secrets and environment management
- Matrix builds and parallel execution
- Custom actions development
- Deployment strategies
- Security best practices

GitHub Actions enables modern DevOps practices, automating the entire software development lifecycle from code commit to production deployment. The next chapter will explore additional GitHub features that complement these automation capabilities.
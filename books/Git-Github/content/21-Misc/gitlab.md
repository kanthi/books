# GitLab: Complete DevOps Platform

GitLab is a comprehensive DevOps platform that provides Git repository management, CI/CD pipelines, issue tracking, and much more in a single application.

## What is GitLab?

GitLab offers a complete DevOps lifecycle in one platform:
- **Source Code Management**: Git repositories with advanced features
- **CI/CD**: Built-in continuous integration and deployment
- **Issue Tracking**: Project management and bug tracking
- **Security**: Built-in security scanning and compliance
- **Monitoring**: Application performance monitoring
- **Package Registry**: Container and package management

## GitLab Editions

- **GitLab CE (Community Edition)**: Free, open-source version
- **GitLab EE (Enterprise Edition)**: Paid version with advanced features
- **GitLab.com**: SaaS offering hosted by GitLab

## Installation Methods

### Method 1: Package Installation (Recommended)

#### Ubuntu/Debian Installation

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Add GitLab package repository
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

# Install GitLab
sudo EXTERNAL_URL="https://gitlab.yourdomain.com" apt-get install gitlab-ee

# For Community Edition, use:
# sudo EXTERNAL_URL="https://gitlab.yourdomain.com" apt-get install gitlab-ce
```

#### CentOS/RHEL Installation

```bash
# Install dependencies
sudo yum install -y curl policycoreutils-python openssh-server perl

# Enable SSH daemon
sudo systemctl enable sshd
sudo systemctl start sshd

# Configure firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld

# Add GitLab repository
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

# Install GitLab
sudo EXTERNAL_URL="https://gitlab.yourdomain.com" yum install -y gitlab-ee
```

### Method 2: Docker Installation

#### Basic Docker Setup

```bash
# Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.6'
services:
  gitlab:
    image: gitlab/gitlab-ee:latest
    container_name: gitlab
    restart: always
    hostname: 'gitlab.yourdomain.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.yourdomain.com'
        gitlab_rails['gitlab_shell_ssh_port'] = 2224
        # Email configuration
        gitlab_rails['smtp_enable'] = true
        gitlab_rails['smtp_address'] = "smtp.gmail.com"
        gitlab_rails['smtp_port'] = 587
        gitlab_rails['smtp_user_name'] = "gitlab@yourdomain.com"
        gitlab_rails['smtp_password'] = "your-app-password"
        gitlab_rails['smtp_domain'] = "yourdomain.com"
        gitlab_rails['smtp_authentication'] = "login"
        gitlab_rails['smtp_enable_starttls_auto'] = true
        gitlab_rails['smtp_tls'] = false
        gitlab_rails['gitlab_email_from'] = 'gitlab@yourdomain.com'
    ports:
      - '80:80'
      - '443:443'
      - '2224:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
EOF

# Set GitLab home directory
export GITLAB_HOME=/srv/gitlab

# Create directories
sudo mkdir -p $GITLAB_HOME/{config,logs,data}

# Start GitLab
docker-compose up -d
```

#### Production Docker Setup with External Database

```bash
# docker-compose.yml for production
cat > docker-compose.yml <<EOF
version: '3.6'
services:
  redis:
    restart: always
    image: redis:6.2-alpine
    command:
    - --loglevel warning
    volumes:
    - redis-data:/var/lib/redis:Z

  postgresql:
    restart: always
    image: postgres:13.6-alpine
    environment:
      - POSTGRES_USER=gitlab
      - POSTGRES_PASSWORD=gitlab
      - POSTGRES_DB=gitlabhq_production
      - POSTGRES_EXTENSION=pg_trgm,btree_gist
    volumes:
    - postgresql-data:/var/lib/postgresql/data:Z

  gitlab:
    image: gitlab/gitlab-ee:latest
    restart: always
    hostname: 'gitlab.yourdomain.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'https://gitlab.yourdomain.com'
        gitlab_rails['db_adapter'] = 'postgresql'
        gitlab_rails['db_encoding'] = 'unicode'
        gitlab_rails['db_host'] = 'postgresql'
        gitlab_rails['db_port'] = '5432'
        gitlab_rails['db_database'] = 'gitlabhq_production'
        gitlab_rails['db_username'] = 'gitlab'
        gitlab_rails['db_password'] = 'gitlab'

        redis['enable'] = false
        gitlab_rails['redis_host'] = 'redis'
        gitlab_rails['redis_port'] = '6379'

        # Disable built-in services
        postgresql['enable'] = false
        redis['enable'] = false

        # Performance tuning
        unicorn['worker_processes'] = 3
        sidekiq['max_concurrency'] = 25

        # Backup configuration
        gitlab_rails['backup_keep_time'] = 604800
        gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
    ports:
      - '80:80'
      - '443:443'
      - '2224:22'
    volumes:
      - gitlab-config:/etc/gitlab:Z
      - gitlab-logs:/var/log/gitlab:Z
      - gitlab-data:/var/opt/gitlab:Z
    depends_on:
      - redis
      - postgresql

volumes:
  gitlab-config:
  gitlab-logs:
  gitlab-data:
  postgresql-data:
  redis-data:
EOF
```

### Method 3: Kubernetes Installation

```yaml
# gitlab-values.yaml for Helm chart
global:
  hosts:
    domain: yourdomain.com
    https: true
  ingress:
    configureCertmanager: true
    class: nginx

certmanager:
  install: true

nginx-ingress:
  enabled: true

prometheus:
  install: true

gitlab-runner:
  install: true
  runners:
    privileged: true

postgresql:
  install: true
  postgresqlPassword: secure-password

redis:
  install: true

registry:
  enabled: true

minio:
  enabled: true
```

```bash
# Install using Helm
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=yourdomain.com \
  --set global.hosts.externalIP=YOUR_EXTERNAL_IP \
  --set certmanager-issuer.email=admin@yourdomain.com \
  -f gitlab-values.yaml
```

## Initial Configuration

### First-Time Setup

1. **Access GitLab**: Navigate to your GitLab URL
2. **Set Root Password**: Create password for root user
3. **Sign In**: Use username `root` and your password

### Configuration File (gitlab.rb)

```ruby
# /etc/gitlab/gitlab.rb

# External URL
external_url 'https://gitlab.yourdomain.com'

# SSH settings
gitlab_rails['gitlab_shell_ssh_port'] = 22
gitlab_sshd['enable'] = true
gitlab_sshd['port'] = 22

# Email configuration
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "gitlab@yourdomain.com"
gitlab_rails['smtp_password'] = "your-app-password"
gitlab_rails['smtp_domain'] = "yourdomain.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['gitlab_email_from'] = 'gitlab@yourdomain.com'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@yourdomain.com'

# LDAP configuration
gitlab_rails['ldap_enabled'] = true
gitlab_rails['prevent_ldap_sign_in'] = false
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main:
    label: 'LDAP'
    host: 'ldap.yourdomain.com'
    port: 389
    uid: 'sAMAccountName'
    bind_dn: 'CN=gitlab,OU=Service Accounts,DC=yourdomain,DC=com'
    password: 'ldap-password'
    encryption: 'plain'
    verify_certificates: true
    smartcard_auth: false
    active_directory: true
    allow_username_or_email_login: false
    lowercase_usernames: false
    block_auto_created_users: false
    base: 'DC=yourdomain,DC=com'
    user_filter: ''
    attributes:
      username: ['uid', 'userid', 'sAMAccountName']
      email: ['mail', 'email', 'userPrincipalName']
      name: 'cn'
      first_name: 'givenName'
      last_name: 'sn'
    group_base: 'OU=Groups,DC=yourdomain,DC=com'
    admin_group: 'GitLab Administrators'
EOS

# Database configuration (external PostgreSQL)
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = 'postgres.yourdomain.com'
gitlab_rails['db_port'] = '5432'
gitlab_rails['db_database'] = 'gitlabhq_production'
gitlab_rails['db_username'] = 'gitlab'
gitlab_rails['db_password'] = 'secure-password'

# Redis configuration (external)
gitlab_rails['redis_host'] = 'redis.yourdomain.com'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_password'] = 'redis-password'

# Disable built-in services when using external
postgresql['enable'] = false
redis['enable'] = false

# Performance tuning
unicorn['worker_processes'] = 4
unicorn['worker_timeout'] = 60
sidekiq['max_concurrency'] = 25

# Backup settings
gitlab_rails['backup_keep_time'] = 604800
gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"

# Container Registry
registry_external_url 'https://registry.yourdomain.com'
gitlab_rails['registry_enabled'] = true

# Pages configuration
pages_external_url 'https://pages.yourdomain.com'
gitlab_pages['enable'] = true

# Monitoring
prometheus['enable'] = true
grafana['enable'] = true
alertmanager['enable'] = true

# Security
gitlab_rails['webhook_timeout'] = 10
gitlab_rails['gitlab_default_can_create_group'] = false
gitlab_rails['gitlab_username_changing_enabled'] = false
```

After editing the configuration:
```bash
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
```

## Real-World Setup Scenarios

### Scenario 1: Small Development Team

**Requirements**: 10-person team, basic CI/CD, issue tracking

```bash
#!/bin/bash
# small-team-gitlab-setup.sh

# Install GitLab CE
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo EXTERNAL_URL="http://gitlab.local" apt-get install gitlab-ce

# Basic configuration
sudo tee -a /etc/gitlab/gitlab.rb <<EOF
# Basic settings for small team
external_url 'http://gitlab.local'

# Reduce resource usage
unicorn['worker_processes'] = 2
sidekiq['max_concurrency'] = 10

# Enable container registry
registry_external_url 'http://gitlab.local:5050'
gitlab_rails['registry_enabled'] = true

# Basic backup
gitlab_rails['backup_keep_time'] = 259200  # 3 days
EOF

sudo gitlab-ctl reconfigure

# Create initial groups and projects
gitlab-rails console -e production <<EOF
# Create development group
group = Group.create!(
  name: 'Development Team',
  path: 'dev-team',
  visibility_level: Gitlab::VisibilityLevel::PRIVATE
)

# Create sample project
project = Projects::CreateService.new(
  User.first,
  name: 'Sample Project',
  namespace: group,
  visibility_level: Gitlab::VisibilityLevel::PRIVATE
).execute

puts "Setup completed!"
EOF
```

### Scenario 2: Enterprise Production Environment

**Requirements**: High availability, external database, LDAP integration, advanced security

```bash
#!/bin/bash
# enterprise-gitlab-setup.sh

# Install GitLab EE
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="https://gitlab.company.com" apt-get install gitlab-ee

# Configure for enterprise use
sudo tee /etc/gitlab/gitlab.rb <<EOF
external_url 'https://gitlab.company.com'

# SSL configuration
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.company.com.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.company.com.key"

# External PostgreSQL
gitlab_rails['db_adapter'] = 'postgresql'
gitlab_rails['db_encoding'] = 'unicode'
gitlab_rails['db_host'] = 'postgres-primary.company.com'
gitlab_rails['db_port'] = '5432'
gitlab_rails['db_database'] = 'gitlabhq_production'
gitlab_rails['db_username'] = 'gitlab'
gitlab_rails['db_password'] = '$(cat /etc/gitlab/db_password)'
postgresql['enable'] = false

# External Redis
gitlab_rails['redis_host'] = 'redis-primary.company.com'
gitlab_rails['redis_port'] = 6379
gitlab_rails['redis_password'] = '$(cat /etc/gitlab/redis_password)'
redis['enable'] = false

# LDAP integration
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main:
    label: 'Company LDAP'
    host: 'ldap.company.com'
    port: 636
    uid: 'sAMAccountName'
    bind_dn: 'CN=gitlab-service,OU=Service Accounts,DC=company,DC=com'
    password: '$(cat /etc/gitlab/ldap_password)'
    encryption: 'simple_tls'
    verify_certificates: true
    active_directory: true
    base: 'DC=company,DC=com'
    user_filter: '(memberOf=CN=GitLab Users,OU=Groups,DC=company,DC=com)'
    admin_group: 'GitLab Administrators'
EOS

# Performance optimization
unicorn['worker_processes'] = 8
unicorn['worker_timeout'] = 60
sidekiq['max_concurrency'] = 50

# Security settings
gitlab_rails['webhook_timeout'] = 10
gitlab_rails['gitlab_default_can_create_group'] = false
gitlab_rails['gitlab_username_changing_enabled'] = false
gitlab_rails['password_authentication_enabled_for_web'] = false
gitlab_rails['password_authentication_enabled_for_git'] = false

# Backup configuration
gitlab_rails['backup_keep_time'] = 2592000  # 30 days
gitlab_rails['backup_upload_connection'] = {
  'provider' => 'AWS',
  'region' => 'us-east-1',
  'aws_access_key_id' => '$(cat /etc/gitlab/aws_access_key)',
  'aws_secret_access_key' => '$(cat /etc/gitlab/aws_secret_key)'
}
gitlab_rails['backup_upload_remote_directory'] = 'gitlab-backups'

# Container Registry
registry_external_url 'https://registry.company.com'
gitlab_rails['registry_enabled'] = true

# Pages
pages_external_url 'https://pages.company.com'
gitlab_pages['enable'] = true

# Monitoring
prometheus['enable'] = true
grafana['enable'] = true
EOF

sudo gitlab-ctl reconfigure
```

### Scenario 3: Multi-Node High Availability Setup

```bash
#!/bin/bash
# ha-gitlab-setup.sh

# Node 1: Application Server
cat > /etc/gitlab/gitlab.rb <<EOF
external_url 'https://gitlab.company.com'

# Disable services that will run elsewhere
postgresql['enable'] = false
redis['enable'] = false
nginx['enable'] = false
prometheus['enable'] = false
grafana['enable'] = false
alertmanager['enable'] = false
gitlab_exporter['enable'] = false

# External services
gitlab_rails['db_host'] = 'postgres-cluster.company.com'
gitlab_rails['redis_host'] = 'redis-cluster.company.com'

# Shared storage (NFS)
gitlab_rails['shared_path'] = '/mnt/gitlab/shared'
git_data_dirs({
  "default" => {
    "path" => "/mnt/gitlab/git-data"
  }
})

# Load balancer
gitlab_rails['trusted_proxies'] = ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16']
EOF

# Node 2: GitLab Pages
cat > /etc/gitlab/gitlab.rb <<EOF
external_url 'https://gitlab.company.com'
pages_external_url 'https://pages.company.com'

# Disable all services except Pages
postgresql['enable'] = false
redis['enable'] = false
nginx['enable'] = false
unicorn['enable'] = false
sidekiq['enable'] = false
gitlab_workhorse['enable'] = false
gitaly['enable'] = false
gitlab_pages['enable'] = true

# Pages configuration
gitlab_pages['external_http'] = ['0.0.0.0:80']
gitlab_pages['external_https'] = ['0.0.0.0:443']
EOF

# Node 3: Container Registry
cat > /etc/gitlab/gitlab.rb <<EOF
external_url 'https://gitlab.company.com'
registry_external_url 'https://registry.company.com'

# Disable all services except Registry
postgresql['enable'] = false
redis['enable'] = false
nginx['enable'] = false
unicorn['enable'] = false
sidekiq['enable'] = false
gitlab_workhorse['enable'] = false
gitaly['enable'] = false
registry['enable'] = true

# Registry configuration
registry['storage'] = {
  's3' => {
    'accesskey' => 'ACCESS_KEY',
    'secretkey' => 'SECRET_KEY',
    'bucket' => 'registry-bucket',
    'region' => 'us-east-1'
  }
}
EOF
```

## CI/CD Pipeline Examples

### Basic Pipeline Configuration

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

before_script:
  - echo "Starting pipeline for $CI_COMMIT_REF_NAME"

# Test stage
test:unit:
  stage: test
  image: node:16
  script:
    - npm install
    - npm run test:unit
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week

test:lint:
  stage: test
  image: node:16
  script:
    - npm install
    - npm run lint
  allow_failure: true

# Build stage
build:docker:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
    - develop

# Deploy stages
deploy:staging:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache curl
  script:
    - curl -X POST "$STAGING_WEBHOOK_URL"
      -H "Content-Type: application/json"
      -d '{"image":"'$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA'"}'
  environment:
    name: staging
    url: https://staging.yourdomain.com
  only:
    - develop

deploy:production:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache curl
  script:
    - curl -X POST "$PRODUCTION_WEBHOOK_URL"
      -H "Content-Type: application/json"
      -d '{"image":"'$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA'"}'
  environment:
    name: production
    url: https://yourdomain.com
  when: manual
  only:
    - main
```

### Advanced Pipeline with Security Scanning

```yaml
# .gitlab-ci.yml with security scanning
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml
  - template: Security/DAST.gitlab-ci.yml

stages:
  - test
  - security
  - build
  - deploy
  - review

variables:
  DOCKER_DRIVER: overlay2
  SAST_EXCLUDED_PATHS: "spec, test, tests, tmp"
  DS_EXCLUDED_PATHS: "spec, test, tests, tmp"

# Custom security job
security:secrets:
  stage: security
  image: trufflesecurity/trufflehog:latest
  script:
    - trufflehog filesystem . --json > secrets-report.json
  artifacts:
    reports:
      secret_detection: secrets-report.json
    expire_in: 1 week
  allow_failure: true

# Infrastructure as Code scanning
security:terraform:
  stage: security
  image: bridgecrew/checkov:latest
  script:
    - checkov -d . --framework terraform --output json > terraform-security.json
  artifacts:
    reports:
      sast: terraform-security.json
    expire_in: 1 week
  only:
    changes:
      - "**/*.tf"
  allow_failure: true

# Performance testing
performance:
  stage: test
  image: sitespeedio/sitespeed.io:latest
  script:
    - sitespeed.io --budget budget.json https://staging.yourdomain.com
  artifacts:
    paths:
      - sitespeed-result/
    expire_in: 1 week
  only:
    - schedules

# Review app deployment
review:
  stage: review
  script:
    - helm upgrade --install review-$CI_COMMIT_REF_SLUG ./helm-chart
      --set image.tag=$CI_COMMIT_SHA
      --set ingress.host=review-$CI_COMMIT_REF_SLUG.yourdomain.com
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://review-$CI_COMMIT_REF_SLUG.yourdomain.com
    on_stop: stop_review
  only:
    - merge_requests

stop_review:
  stage: review
  script:
    - helm uninstall review-$CI_COMMIT_REF_SLUG
  environment:
    name: review/$CI_COMMIT_REF_NAME
    action: stop
  when: manual
  only:
    - merge_requests
```

## GitLab Runner Configuration

### Installing GitLab Runner

```bash
# Install GitLab Runner
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install gitlab-runner

# Register runner
sudo gitlab-runner register \
  --url "https://gitlab.yourdomain.com/" \
  --registration-token "YOUR_REGISTRATION_TOKEN" \
  --description "docker-runner" \
  --tag-list "docker,linux" \
  --executor "docker" \
  --docker-image alpine:latest \
  --docker-privileged=true \
  --docker-volumes="/certs/client"
```

### Advanced Runner Configuration

```toml
# /etc/gitlab-runner/config.toml
concurrent = 4
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "docker-runner"
  url = "https://gitlab.yourdomain.com/"
  token = "RUNNER_TOKEN"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
      ServerAddress = "s3.amazonaws.com"
      AccessKey = "ACCESS_KEY"
      SecretKey = "SECRET_KEY"
      BucketName = "gitlab-runner-cache"
      BucketLocation = "us-east-1"
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/certs/client", "/cache"]
    shm_size = 0

[[runners]]
  name = "kubernetes-runner"
  url = "https://gitlab.yourdomain.com/"
  token = "RUNNER_TOKEN"
  executor = "kubernetes"
  [runners.kubernetes]
    host = ""
    namespace = "gitlab-runner"
    privileged = true
    image = "alpine:latest"
    [[runners.kubernetes.volumes.host_path]]
      name = "docker-sock"
      mount_path = "/var/run/docker.sock"
      host_path = "/var/run/docker.sock"
```

## Project Management Features

### Issue Templates

```markdown
<!-- .gitlab/issue_templates/Bug.md -->
## Bug Report

### Description
A clear and concise description of what the bug is.

### Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

### Expected Behavior
A clear and concise description of what you expected to happen.

### Actual Behavior
A clear and concise description of what actually happened.

### Environment
- OS: [e.g. Ubuntu 20.04]
- Browser: [e.g. Chrome 91]
- Version: [e.g. 1.2.3]

### Additional Context
Add any other context about the problem here.

/label ~bug ~needs-investigation
/assign @maintainer
```

### Merge Request Templates

```markdown
<!-- .gitlab/merge_request_templates/Default.md -->
## Description
Brief description of changes

## Changes Made
- [ ] Feature A implemented
- [ ] Bug B fixed
- [ ] Documentation updated

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)

## Related Issues
Closes #123
Related to #456

/assign @reviewer
/label ~feature
```

## Backup and Maintenance

### Automated Backup Script

```bash
#!/bin/bash
# gitlab-backup.sh

BACKUP_DIR="/backup/gitlab"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Create GitLab backup
gitlab-backup create BACKUP=gitlab_backup_$DATE

# Copy configuration files
cp /etc/gitlab/gitlab.rb $BACKUP_DIR/gitlab.rb.$DATE
cp /etc/gitlab/gitlab-secrets.json $BACKUP_DIR/gitlab-secrets.json.$DATE

# Upload to S3 (optional)
if [ "$UPLOAD_TO_S3" = "true" ]; then
    aws s3 cp /var/opt/gitlab/backups/gitlab_backup_${DATE}_gitlab_backup.tar \
        s3://gitlab-backups/gitlab_backup_${DATE}_gitlab_backup.tar
    aws s3 cp $BACKUP_DIR/gitlab.rb.$DATE s3://gitlab-backups/
    aws s3 cp $BACKUP_DIR/gitlab-secrets.json.$DATE s3://gitlab-backups/
fi

# Clean old backups
find /var/opt/gitlab/backups -name "*.tar" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "gitlab.rb.*" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "gitlab-secrets.json.*" -mtime +$RETENTION_DAYS -delete

echo "Backup completed: $DATE"
```

### Health Check Script

```bash
#!/bin/bash
# gitlab-health-check.sh

# Check GitLab status
if ! gitlab-ctl status | grep -q "run:"; then
    echo "ERROR: Some GitLab services are not running"
    gitlab-ctl status
    exit 1
fi

# Check disk space
DISK_USAGE=$(df /var/opt/gitlab | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "WARNING: Disk usage is ${DISK_USAGE}%"
fi

# Check database connectivity
if ! gitlab-rails runner "ActiveRecord::Base.connection.execute('SELECT 1')" > /dev/null 2>&1; then
    echo "ERROR: Database connection failed"
    exit 1
fi

# Check Redis connectivity
if ! gitlab-rails runner "Gitlab::Redis::Cache.with { |redis| redis.ping }" > /dev/null 2>&1; then
    echo "ERROR: Redis connection failed"
    exit 1
fi

# Check repository storage
gitlab-rake gitlab:storage:check_repository_storages

echo "GitLab health check passed"
```

## Migration and Integration

### Migrating from GitHub

```bash
#!/bin/bash
# github-to-gitlab-migration.sh

GITHUB_TOKEN="your-github-token"
GITLAB_TOKEN="your-gitlab-token"
GITLAB_URL="https://gitlab.yourdomain.com"
GITHUB_ORG="source-org"
GITLAB_GROUP="target-group"

# Get GitHub repositories
curl -H "Authorization: token $GITHUB_TOKEN" \
     "https://api.github.com/orgs/$GITHUB_ORG/repos?per_page=100" | \
     jq -r '.[].name' > repos.txt

# Migrate each repository
while read -r repo_name; do
    echo "Migrating $repo_name..."

    # Create project in GitLab
    curl -X POST \
         -H "Authorization: Bearer $GITLAB_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{
             \"name\": \"$repo_name\",
             \"namespace_id\": \"$GITLAB_GROUP_ID\",
             \"import_url\": \"https://$GITHUB_TOKEN@github.com/$GITHUB_ORG/$repo_name.git\",
             \"visibility\": \"private\"
         }" \
         "$GITLAB_URL/api/v4/projects"

    # Wait for import to complete
    sleep 10
done < repos.txt

echo "Migration completed"
```

This comprehensive GitLab guide covers installation, configuration, CI/CD setup, and real-world scenarios for different organizational needs.
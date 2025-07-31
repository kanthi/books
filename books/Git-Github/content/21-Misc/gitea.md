# Gitea: Self-Hosted Git Service

Gitea is a lightweight, self-hosted Git service written in Go. It provides a GitHub-like web interface for managing Git repositories, issues, pull requests, and more.

## What is Gitea?

Gitea is a community-managed fork of Gogs, designed to be:
- **Lightweight**: Minimal resource requirements
- **Fast**: Written in Go for performance
- **Easy to deploy**: Single binary with minimal dependencies
- **Cross-platform**: Runs on Linux, macOS, Windows, and ARM

## Installation Methods

### Method 1: Binary Installation (Recommended)

#### Linux/macOS Installation

```bash
# Download the latest binary
wget -O gitea https://dl.gitea.io/gitea/1.21.3/gitea-1.21.3-linux-amd64
chmod +x gitea

# Create gitea user
sudo adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git

# Create directory structure
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/

# Move binary to system location
sudo cp gitea /usr/local/bin/gitea
sudo chown root:root /usr/local/bin/gitea
sudo chmod 755 /usr/local/bin/gitea
```

#### Create Systemd Service

```bash
# Create service file
sudo tee /etc/systemd/system/gitea.service > /dev/null <<EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable gitea
sudo systemctl start gitea
```

### Method 2: Docker Installation

#### Basic Docker Setup

```bash
# Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: "3"

networks:
  gitea:
    external: false

services:
  server:
    image: gitea/gitea:1.21.3
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__database__DB_TYPE=mysql
      - GITEA__database__HOST=db:3306
      - GITEA__database__NAME=gitea
      - GITEA__database__USER=gitea
      - GITEA__database__PASSWD=gitea
    restart: always
    networks:
      - gitea
    volumes:
      - ./gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "222:22"
    depends_on:
      - db

  db:
    image: mysql:8
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=gitea
      - MYSQL_DATABASE=gitea
    networks:
      - gitea
    volumes:
      - ./mysql:/var/lib/mysql
EOF

# Start services
docker-compose up -d
```

#### Production Docker Setup with Nginx

```bash
# Extended docker-compose.yml with reverse proxy
cat > docker-compose.yml <<EOF
version: "3"

networks:
  gitea:
    external: false

services:
  server:
    image: gitea/gitea:1.21.3
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__database__DB_TYPE=postgres
      - GITEA__database__HOST=db:5432
      - GITEA__database__NAME=gitea
      - GITEA__database__USER=gitea
      - GITEA__database__PASSWD=gitea
      - GITEA__server__DOMAIN=git.yourdomain.com
      - GITEA__server__SSH_DOMAIN=git.yourdomain.com
      - GITEA__server__ROOT_URL=https://git.yourdomain.com/
    restart: always
    networks:
      - gitea
    volumes:
      - ./gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    expose:
      - "3000"
    ports:
      - "222:22"
    depends_on:
      - db

  db:
    image: postgres:14
    restart: always
    environment:
      - POSTGRES_USER=gitea
      - POSTGRES_PASSWORD=gitea
      - POSTGRES_DB=gitea
    networks:
      - gitea
    volumes:
      - ./postgres:/var/lib/postgresql/data

  nginx:
    image: nginx:alpine
    container_name: gitea-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    networks:
      - gitea
    depends_on:
      - server
EOF
```

## Initial Configuration

### Web-based Setup

1. **Access Gitea**: Navigate to `http://localhost:3000`
2. **Database Configuration**:
   - Database Type: SQLite3 (for simple setups) or PostgreSQL/MySQL
   - Host: localhost:5432 (for PostgreSQL)
   - Username/Password: As configured
   - Database Name: gitea

3. **General Settings**:
   - Site Title: Your Organization Name
   - Repository Root Path: `/var/lib/gitea/gitea-repositories`
   - Git LFS Root Path: `/var/lib/gitea/data/lfs`
   - Run As Username: `git`

4. **Server and Third-Party Service Settings**:
   - SSH Server Domain: your-domain.com
   - SSH Port: 22 (or 222 if using Docker)
   - HTTP Port: 3000
   - Application URL: `https://git.yourdomain.com/`

### Configuration File (app.ini)

```ini
# /etc/gitea/app.ini
APP_NAME = Your Company Git Service
RUN_MODE = prod

[repository]
ROOT = /var/lib/gitea/gitea-repositories
SCRIPT_TYPE = bash
DETECTED_CHARSETS_ORDER = UTF-8, UTF-16BE, UTF-16LE, UTF-32BE, UTF-32LE, ISO-8859, windows-1252, ISO-8859, windows-1250, ISO-8859, ISO-8859, ISO-8859, windows-1253, ISO-8859, windows-1255, ISO-8859, windows-1251, windows-874, ISO-8859, ISO-8859, ISO-8859, ISO-8859, ISO-8859, ISO-8859
ANSI_CHARSET =
FORCE_PRIVATE = false
DEFAULT_PRIVATE = last
DEFAULT_PUSH_CREATE_PRIVATE = true
MAX_CREATION_LIMIT = -1
MIRROR_QUEUE_LENGTH = 1000
PULL_REQUEST_QUEUE_LENGTH = 1000
PREFERRED_LICENSES = Apache License 2.0,MIT License
DISABLE_HTTP_GIT = false
ACCESS_CONTROL_ALLOW_ORIGIN =
USE_COMPAT_SSH_URI = false

[server]
APP_DATA_PATH = /var/lib/gitea/data
DOMAIN = git.yourdomain.com
HTTP_PORT = 3000
ROOT_URL = https://git.yourdomain.com/
DISABLE_SSH = false
SSH_PORT = 22
SSH_LISTEN_PORT = 22
SSH_DOMAIN = git.yourdomain.com
OFFLINE_MODE = false
DISABLE_ROUTER_LOG = false
CERT_FILE =
KEY_FILE =
STATIC_ROOT_PATH =
ENABLE_GZIP = false
LANDING_PAGE = home
LFS_START_SERVER = true
LFS_CONTENT_PATH = /var/lib/gitea/data/lfs
LFS_JWT_SECRET =

[database]
PATH = /var/lib/gitea/data/gitea.db
DB_TYPE = sqlite3
HOST =
NAME =
USER =
PASSWD =
LOG_SQL = false
SQLITE_TIMEOUT = 500
ITERATE_BUFFER_SIZE = 50

[security]
INSTALL_LOCK = true
SECRET_KEY =
LOGIN_REMEMBER_DAYS = 7
COOKIE_USERNAME = gitea_awesome
COOKIE_REMEMBER_NAME = gitea_incredible
REVERSE_PROXY_AUTHENTICATION = false
REVERSE_PROXY_AUTO_REGISTRATION = false
DISABLE_GIT_HOOKS = false
ONLY_ALLOW_PUSH_IF_GITEA_ENVIRONMENT_SET = true
IMPORT_LOCAL_PATHS = false
INTERNAL_TOKEN =
PASSWORD_HASH_ALGO = pbkdf2

[service]
ACTIVE_CODE_LIVE_MINUTES = 180
RESET_PASSWD_CODE_LIVE_MINUTES = 180
REGISTER_EMAIL_CONFIRM = false
DISABLE_REGISTRATION = false
ALLOW_ONLY_EXTERNAL_REGISTRATION = false
REQUIRE_SIGNIN_VIEW = false
ENABLE_NOTIFY_MAIL = false
ENABLE_REVERSE_PROXY_AUTO_REGISTRATION = false
ENABLE_REVERSE_PROXY_EMAIL = false
ENABLE_CAPTCHA = false
DEFAULT_KEEP_EMAIL_PRIVATE = false
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING = true
NO_REPLY_ADDRESS = noreply.git.yourdomain.com

[mailer]
ENABLED = true
HOST = smtp.gmail.com:587
FROM = git@yourdomain.com
USER = git@yourdomain.com
PASSWD = your-app-password
SKIP_VERIFY = false
USE_SENDMAIL = false
SENDMAIL_PATH = sendmail
SENDMAIL_ARGS =

[log]
MODE = file
LEVEL = info
ROOT_PATH = /var/lib/gitea/log
```

## Real-World Setup Scenarios

### Scenario 1: Small Team Development Server

**Requirements**: 5-person development team, internal network only

```bash
#!/bin/bash
# setup-team-gitea.sh

# Install dependencies
sudo apt update
sudo apt install -y git curl wget

# Create gitea user and directories
sudo adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/

# Download and install Gitea
GITEA_VERSION="1.21.3"
wget -O gitea https://dl.gitea.io/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64
chmod +x gitea
sudo mv gitea /usr/local/bin/

# Create configuration directory
sudo mkdir -p /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea

# Create systemd service
sudo tee /etc/systemd/system/gitea.service > /dev/null <<EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable gitea
sudo systemctl start gitea

echo "Gitea is now running on http://localhost:3000"
echo "Complete setup through the web interface"
```

### Scenario 2: Production Environment with SSL

**Requirements**: Public-facing, SSL-enabled, with backup strategy

```bash
#!/bin/bash
# production-gitea-setup.sh

# Install Nginx and Certbot
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx

# Configure Nginx
sudo tee /etc/nginx/sites-available/gitea > /dev/null <<EOF
server {
    listen 80;
    server_name git.yourdomain.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name git.yourdomain.com;

    # SSL configuration will be added by certbot

    client_max_body_size 512M;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/gitea /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Get SSL certificate
sudo certbot --nginx -d git.yourdomain.com

# Setup backup script
sudo tee /usr/local/bin/backup-gitea.sh > /dev/null <<EOF
#!/bin/bash
BACKUP_DIR="/backup/gitea"
DATE=\$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p \$BACKUP_DIR

# Stop Gitea
systemctl stop gitea

# Backup data
tar -czf \$BACKUP_DIR/gitea-data-\$DATE.tar.gz -C /var/lib/gitea .
cp /etc/gitea/app.ini \$BACKUP_DIR/app.ini-\$DATE

# Backup database (if using external DB)
# mysqldump -u gitea -p gitea > \$BACKUP_DIR/gitea-db-\$DATE.sql

# Start Gitea
systemctl start gitea

# Clean old backups (keep 7 days)
find \$BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
find \$BACKUP_DIR -name "app.ini-*" -mtime +7 -delete

echo "Backup completed: \$DATE"
EOF

chmod +x /usr/local/bin/backup-gitea.sh

# Add to crontab for daily backups
echo "0 2 * * * /usr/local/bin/backup-gitea.sh" | sudo crontab -
```

## Repository Management

### Creating Your First Repository

1. **Through Web Interface**:
   - Click "+" → "New Repository"
   - Fill in repository details
   - Choose visibility (public/private)
   - Initialize with README, .gitignore, license

2. **Through Git CLI**:
```bash
# Create local repository
mkdir my-project
cd my-project
git init
echo "# My Project" > README.md
git add README.md
git commit -m "Initial commit"

# Add Gitea remote
git remote add origin https://git.yourdomain.com/username/my-project.git
git push -u origin main
```

### Repository Settings and Features

#### Branch Protection
```bash
# Access via: Repository → Settings → Branches
# Configure:
# - Protect main branch
# - Require pull request reviews
# - Dismiss stale reviews
# - Require status checks
# - Restrict pushes
```

#### Webhooks Configuration
```bash
# Repository → Settings → Webhooks
# Add webhook for CI/CD integration:
# URL: https://ci.yourdomain.com/gitea-webhook
# Content Type: application/json
# Events: Push, Pull Request, Issues
```

## User and Organization Management

### Creating Organizations

```bash
# Through web interface:
# 1. Click "+" → "New Organization"
# 2. Fill organization details
# 3. Set visibility and permissions
# 4. Add members and teams
```

### Team Management Example

```bash
# Create teams for different access levels:
# - Developers: Read/Write access to repositories
# - Maintainers: Admin access to repositories
# - Viewers: Read-only access

# Team permissions:
# - Read: Clone, pull
# - Write: Clone, pull, push
# - Admin: All permissions + settings
```

## Integration Examples

### CI/CD Integration with Drone

```yaml
# .drone.yml
kind: pipeline
type: docker
name: default

steps:
- name: test
  image: node:16
  commands:
  - npm install
  - npm test

- name: build
  image: node:16
  commands:
  - npm run build

- name: deploy
  image: plugins/ssh
  settings:
    host: production-server.com
    username: deploy
    key:
      from_secret: ssh_key
    script:
      - cd /var/www/app
      - git pull origin main
      - npm install --production
      - pm2 restart app

trigger:
  branch:
  - main
  event:
  - push
```

### Integration with External Authentication

#### LDAP Configuration
```ini
[auth.ldap]
ENABLED = true
HOST = ldap.company.com
PORT = 389
SECURITY_PROTOCOL = unencrypted
SKIP_TLS_VERIFY = false
BIND_DN = cn=gitea,ou=service,dc=company,dc=com
BIND_PASSWORD = password
USER_BASE = ou=users,dc=company,dc=com
USER_FILTER = (&(objectClass=person)(uid=%s))
ADMIN_FILTER = (memberOf=cn=gitea-admins,ou=groups,dc=company,dc=com)
USERNAME_ATTRIBUTE = uid
FIRSTNAME_ATTRIBUTE = givenName
SURNAME_ATTRIBUTE = sn
EMAIL_ATTRIBUTE = mail
```

## Maintenance and Monitoring

### Health Checks

```bash
#!/bin/bash
# gitea-health-check.sh

# Check if Gitea is running
if ! systemctl is-active --quiet gitea; then
    echo "ERROR: Gitea service is not running"
    systemctl start gitea
fi

# Check disk space
DISK_USAGE=$(df /var/lib/gitea | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "WARNING: Disk usage is ${DISK_USAGE}%"
fi

# Check database connectivity
if ! sudo -u git /usr/local/bin/gitea admin auth list > /dev/null 2>&1; then
    echo "ERROR: Database connection failed"
fi

# Check repository integrity
sudo -u git /usr/local/bin/gitea admin regenerate hooks
sudo -u git /usr/local/bin/gitea admin regenerate keys
```

### Log Management

```bash
# Configure log rotation
sudo tee /etc/logrotate.d/gitea > /dev/null <<EOF
/var/lib/gitea/log/gitea.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 git git
    postrotate
        systemctl reload gitea
    endscript
}
EOF
```

## Migration Scenarios

### Migrating from GitHub

```bash
# Using Gitea's built-in migration tool
# 1. Go to "+" → "New Migration"
# 2. Select "GitHub"
# 3. Enter GitHub repository URL
# 4. Provide GitHub token for private repos
# 5. Configure migration options:
#    - Migrate issues
#    - Migrate pull requests
#    - Migrate releases
#    - Migrate wiki
```

### Bulk Repository Migration Script

```bash
#!/bin/bash
# bulk-migrate.sh

GITHUB_TOKEN="your-github-token"
GITEA_TOKEN="your-gitea-token"
GITEA_URL="https://git.yourdomain.com"
GITHUB_USER="source-username"

# Get list of repositories
curl -H "Authorization: token $GITHUB_TOKEN" \
     "https://api.github.com/users/$GITHUB_USER/repos?per_page=100" | \
     jq -r '.[].clone_url' > repos.txt

# Migrate each repository
while read -r repo_url; do
    repo_name=$(basename "$repo_url" .git)
    echo "Migrating $repo_name..."

    curl -X POST \
         -H "Authorization: token $GITEA_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{
             \"clone_addr\": \"$repo_url\",
             \"repo_name\": \"$repo_name\",
             \"service\": \"github\",
             \"auth_token\": \"$GITHUB_TOKEN\",
             \"mirror\": false,
             \"private\": false,
             \"description\": \"Migrated from GitHub\"
         }" \
         "$GITEA_URL/api/v1/repos/migrate"
done < repos.txt
```

## Troubleshooting Common Issues

### Issue 1: SSH Key Authentication Problems

```bash
# Check SSH configuration
sudo -u git ssh -T git@localhost -p 22

# Verify SSH key format
ssh-keygen -l -f ~/.ssh/id_rsa.pub

# Check Gitea SSH configuration
sudo -u git /usr/local/bin/gitea admin auth list

# Regenerate SSH keys if needed
sudo -u git /usr/local/bin/gitea admin regenerate keys
```

### Issue 2: Database Connection Problems

```bash
# Check database status
systemctl status postgresql  # or mysql

# Test database connection
sudo -u git /usr/local/bin/gitea admin auth list

# Check database logs
sudo journalctl -u postgresql -f

# Repair database if needed
sudo -u git /usr/local/bin/gitea doctor check --all
```

### Issue 3: Performance Issues

```bash
# Check system resources
htop
df -h
free -h

# Optimize Gitea configuration
# In app.ini:
[server]
LFS_START_SERVER = false  # if not using LFS
ENABLE_GZIP = true

[database]
MAX_IDLE_CONNS = 30
MAX_OPEN_CONNS = 300
CONN_MAX_LIFETIME = 3s

[indexer]
ISSUE_INDEXER_TYPE = bleve
REPO_INDEXER_ENABLED = true
```

This comprehensive guide covers Gitea installation, configuration, and real-world usage scenarios. The examples provide practical setups for different environments, from small teams to production deployments.
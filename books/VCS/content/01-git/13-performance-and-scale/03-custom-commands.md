---
title: "Custom commands and interfaces"
---

# Custom commands and interfaces

## Custom Git Commands

### Creating Git Aliases

#### Simple Aliases
```bash
# Shorthand commands
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# Complex aliases
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

#### Advanced Aliases
```bash
# Pretty log format
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Show branches with last commit
git config --global alias.br-last "for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

# Find commits by message
git config --global alias.find "log --all --full-history -- "
```

### Custom Git Scripts

#### Git Cleanup Script
```bash
#!/bin/bash
# ~/.local/bin/git-cleanup

# Delete merged branches
git branch --merged | grep -v "\*\|main\|develop" | xargs -n 1 git branch -d

# Prune remote tracking branches
git remote prune origin

# Garbage collect
git gc --prune=now

echo "Repository cleanup complete!"
```

#### Git Release Script
```bash
#!/bin/bash
# ~/.local/bin/git-release

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "Usage: git release <version>"
    exit 1
fi

# Create release branch
git checkout -b release/$VERSION

# Update version file
echo $VERSION > VERSION
git add VERSION
git commit -m "Bump version to $VERSION"

# Merge to main
git checkout main
git merge --no-ff release/$VERSION

# Create tag
git tag -a v$VERSION -m "Release version $VERSION"

# Merge back to develop
git checkout develop
git merge --no-ff release/$VERSION

# Clean up
git branch -d release/$VERSION

echo "Release $VERSION created successfully!"
```


## Alternative Git Interfaces

### GUI Applications

#### GitKraken
- Professional Git GUI
- Visual commit history
- Merge conflict resolution
- Integration with GitHub/GitLab

#### Sourcetree
- Free Git GUI by Atlassian
- Visual branching and merging
- Built-in Git Flow support
- Cross-platform

#### GitHub Desktop
- Simple, user-friendly interface
- Seamless GitHub integration
- Visual diff and merge tools
- Beginner-friendly

### IDE Integration

#### VS Code Git Integration
```json
// settings.json
{
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "git.autofetch": true,
    "git.showPushSuccessNotification": true,
    "gitlens.hovers.currentLine.over": "line",
    "gitlens.currentLine.enabled": true
}
```

#### JetBrains IDEs
- Built-in Git support
- Visual merge tools
- Branch management
- Commit history visualization

### Web-based Git

#### GitPod
```yaml
# .gitpod.yml
tasks:
  - init: npm install
    command: npm start

ports:
  - port: 3000
    onOpen: open-preview

vscode:
  extensions:
    - ms-vscode.vscode-typescript-next
```

#### GitHub Codespaces
```json
// .devcontainer/devcontainer.json
{
    "name": "Node.js",
    "image": "mcr.microsoft.com/vscode/devcontainers/javascript-node:16",
    "features": {
        "ghcr.io/devcontainers/features/git:1": {}
    },
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-vscode.vscode-typescript-next"
            ]
        }
    },
    "postCreateCommand": "npm install"
}
```


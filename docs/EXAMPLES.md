# Examples and Use Cases

This document provides real-world examples of how to use GDoctor Service effectively.

## Scenario 1: Developer with Work and Personal Projects

### Setup
```bash
# Initialize
gdoctor --init

# Edit ~/.gitprofiles
cat >> ~/.gitprofiles << 'EOF'

[work]
name=Jane Smith
email=jane.smith@company.com
server=github.company.com

[personal]
name=Jane Smith
email=jane@personal.com
server=github.com
EOF

# Enable auto-switching
gdoctor --install-shell
```

### Workflow
```bash
# Work on company project
cd ~/projects/company-app
# Auto-switches to 'work' profile

# Work on personal project
cd ~/projects/my-blog
# Auto-switches to 'personal' profile

# Check current profile
gdoctor --current
```

## Scenario 2: Open Source Contributor

### Setup
```bash
# Add opensource profile
cat >> ~/.gitprofiles << 'EOF'

[opensource]
name=John Developer
email=john.dev@gmail.com
server=github.com

[work]
name=John Developer
email=j.developer@company.com
server=gitlab.company.com
EOF
```

### Usage
```bash
# Contributing to open source
cd ~/projects/popular-library
gdoctor --switch opensource
git commit -m "Fix bug in feature X"

# Back to work project
cd ~/work/internal-tool
# Auto-switches to 'work' profile
```

## Scenario 3: Freelancer with Multiple Clients

### Setup
```bash
cat >> ~/.gitprofiles << 'EOF'

[client-a]
name=Alex Freelancer
email=alex@client-a.com
server=gitlab.client-a.com

[client-b]
name=Alex Freelancer
email=a.freelancer@client-b.io
server=github.com

[personal]
name=Alex Freelancer
email=alex.freelancer@gmail.com
server=github.com
EOF
```

### Advanced Usage
```bash
# Install hooks in all client repositories
find ~/clients -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    gdoctor --install-hooks
    echo "Hooks installed in $(pwd)"
done

# Use validation before important commits
cd ~/clients/client-a/project
gdoctor --validate
git commit -m "Important feature for client A"
```

## Scenario 4: Team Lead Setting Up Team

### Automation Script
```bash
#!/bin/bash
# setup-team.sh

echo "Setting up GDoctor Service for team..."

# Clone and install
git clone https://github.com/your-org/gdoctor.git
cd gdoctor
./install.sh

# Create team profile template
cat > ~/.gitprofiles << 'EOF'
[company]
name=REPLACE_WITH_YOUR_NAME
email=REPLACE_WITH_YOUR_EMAIL@company.com
server=github.company.com

[personal]
name=REPLACE_WITH_YOUR_NAME
email=REPLACE_WITH_YOUR_PERSONAL_EMAIL
server=github.com
EOF

echo "Edit ~/.gitprofiles with your information"
echo "Then run: gdoctor --install-shell"
```

## Scenario 5: Security-Conscious Developer

### Validation Workflow
```bash
# Always validate before pushing
gdoctor --validate
git push origin main

# Install hooks everywhere for safety
find ~/git -name ".git" -type d -exec dirname {} \; | while read repo; do
    cd "$repo"
    gdoctor --install-hooks
done

# Check status regularly
gdoctor --status
```

## Scenario 6: CI/CD Integration

### Pre-commit Hook Enhancement
```bash
# Add to .git/hooks/pre-commit
#!/bin/bash

# Validate git profile
if command -v gdoctor &> /dev/null; then
    if ! gdoctor --validate; then
        echo "❌ Wrong git profile!"
        echo "Expected profile based on repository:"
        gdoctor --auto-switch
        echo "Run 'gdoctor --auto-switch' to fix"
        exit 1
    fi
fi

# Continue with other pre-commit checks...
```

## Scenario 7: Multiple Git Servers

### Complex Setup
```bash
cat >> ~/.gitprofiles << 'EOF'

[work-github]
name=Dev Name
email=dev@company.com
server=github.com

[work-gitlab]
name=Dev Name
email=dev@company.com
server=gitlab.company.com

[work-bitbucket]
name=Dev Name
email=dev@company.com
server=bitbucket.company.com

[personal]
name=Dev Name
email=dev.name@gmail.com
server=github.com
EOF
```

### Smart Switching
```bash
# The service will auto-detect based on full server URLs
cd ~/work/github-project      # Uses work-github
cd ~/work/gitlab-project      # Uses work-gitlab
cd ~/work/bitbucket-project   # Uses work-bitbucket
cd ~/personal/my-project      # Uses personal
```

## Scenario 8: Debugging and Monitoring

### Debug Commands
```bash
# Check what's happening
gdoctor --status

# View recent activity
tail -f ~/.gdoctor.log

# Test auto-switching
gdoctor --auto-switch

# Validate specific URL
gdoctor --validate https://github.com/company/repo.git
```

### Log Analysis
```bash
# See profile switches today
grep "$(date '+%Y-%m-%d')" ~/.gdoctor.log | grep "Switched to profile"

# Find validation failures
grep "ERROR" ~/.gdoctor.log
```

## Scenario 9: Temporary Profile Override

### Manual Override
```bash
# Temporarily use different profile
gdoctor --switch opensource

# Work in current directory
git commit -m "Contribute to open source"

# Let auto-switching resume
cd . && gdoctor --auto-switch  # Back to normal
```

## Scenario 10: Backup and Migration

### Backup Configuration
```bash
# Backup all config files
tar -czf gdoctor-backup.tar.gz ~/.gitprofiles ~/.gdoctor_service ~/.current_gitprofile

# Restore on new machine
tar -xzf gdoctor-backup.tar.gz -C ~/
```

### Migration Script
```bash
#!/bin/bash
# migrate-gdoctor.sh

# Copy from old machine
scp old-machine:~/.gitprofiles ~/.gitprofiles
scp old-machine:~/.gdoctor_service ~/.gdoctor_service

# Install service
gdoctor --install-shell

echo "Migration complete!"
```

## Tips and Best Practices

1. **Always set server field** in profiles for auto-switching
2. **Use descriptive profile names** (work-github, personal-gitlab)
3. **Enable shell integration** for seamless experience
4. **Install hooks in important repositories** for safety
5. **Check status regularly** with `--status`
6. **Monitor logs** for unexpected behavior
7. **Test with `--validate`** before important commits
8. **Use `--auto-switch`** to fix profile mismatches

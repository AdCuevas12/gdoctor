# GDoctor Service Edition

A service-enabled version of Git Profile Doctor with automatic profile switching, git hooks, and shell integration.

## Features

### Original Features
- **Multiple Profile Management**: Switch between different Git configurations
- **URL Validation**: Ensure repository URLs match the expected server
- **Easy Profile Switching**: Quickly switch between work, personal, or other Git profiles
- **Profile Listing**: View all configured profiles with their details

### New Service Features
- **🔄 Auto-switching**: Automatically switch profiles when entering repositories
- **🪝 Git Hooks**: Validate profiles before commits
- **🐚 Shell Integration**: Seamless integration with bash/zsh
- **📊 Service Status**: Monitor service components
- **📝 Logging**: Track all profile switches and operations
- **🔧 Daemon Mode**: Background service (experimental)

## Installation

### Quick Install
```bash
# Clone or download the gdoctor script
chmod +x gdoctor

# Create symlink for global access
sudo ln -s "$(pwd)/gdoctor" /usr/local/bin/gdoctor

# Or for user-only installation
mkdir -p ~/.local/bin
ln -s "$(pwd)/gdoctor" ~/.local/bin/gdoctor
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
```

## Quick Setup

1. **Initialize profiles**:
   ```bash
   gdoctor --init
   ```

2. **Enable auto-switching** (recommended):
   ```bash
   gdoctor --install-shell
   ```

3. **Enable git hooks** (optional):
   ```bash
   cd your-git-repository
   gdoctor --install-hooks
   ```

## Usage

### Basic Commands
```bash
# Show current profile
gdoctor current

# List all profiles
gdoctor list

# Switch profile manually
gdoctor switch work

# Validate current repository
gdoctor validate

# Show version information
gdoctor version

# Check service status
gdoctor --status

# Complete uninstallation
gdoctor uninstall
```

### Service Commands
```bash
# Install shell integration (auto-switching)
gdoctor --install-shell

# Install git hooks for validation
gdoctor --install-hooks

# Auto-switch for current directory
gdoctor --auto-switch

# Run as daemon (experimental)
gdoctor --daemon
```

## How It Works

### Auto-switching
When shell integration is enabled, gdoctor automatically:
1. Detects when you enter a git repository
2. Checks the repository's remote URL
3. Finds the matching profile based on server configuration
4. Switches to the appropriate profile if needed

### Git Hooks
When git hooks are installed, gdoctor:
1. Validates your profile before each commit
2. Prevents commits with wrong profiles
3. Suggests the correct profile to switch to

### Example Workflow
```bash
# Setup profiles
gdoctor init
# Edit ~/.gitprofiles to add work and personal profiles

# Enable auto-switching
gdoctor --install-shell

# Now when you cd into repositories:
cd ~/work/company-repo     # Auto-switches to 'work' profile
cd ~/personal/my-project   # Auto-switches to 'personal' profile
```

## Configuration

### Profile Configuration (`~/.gitprofiles`)
```ini
[work]
name=John Doe
email=john.doe@company.com
server=github.company.com

[personal]
name=John Doe
email=john@personal.com
server=github.com

[opensource]
name=John Doe
email=john.doe@gmail.com
server=gitlab.com
```

### Service Configuration
- **Config file**: `~/.gdoctor_service`
- **Log file**: `~/.gdoctor.log`
- **Current profile**: `~/.current_gitprofile`

## Service Status

Check what's enabled:
```bash
gdoctor --status
```

Output example:
```
GDoctor Service Status:

✓ Profiles configured
✓ Active profile: work
✓ Shell integration installed
✓ In git repository
✓ Git hooks installed
```

## Troubleshooting

### Shell Integration Not Working
1. Restart your shell: `exec $SHELL`
2. Check if integration is installed: `gdoctor --status`
3. Manually source your shell config: `source ~/.bashrc` or `source ~/.zshrc`

### Git Hooks Not Working
1. Make sure you're in a git repository
2. Check hooks are installed: `ls -la .git/hooks/`
3. Verify hook is executable: `chmod +x .git/hooks/pre-commit`

### Auto-switching Not Working
1. Ensure profiles have `server` configured
2. Check repository has remote: `git remote -v`
3. Verify URL matches profile server configuration

## Advanced Usage

### Manual Auto-switch
```bash
# Test auto-switching in current directory
gdoctor --auto-switch
```

### Install Hooks in Multiple Repositories
```bash
# Install hooks in all repositories
find ~/git -name ".git" -type d | while read gitdir; do
    cd "$(dirname "$gitdir")"
    gdoctor --install-hooks
done
```

### Daemon Mode (Experimental)
```bash
# Run as background service
gdoctor --daemon
```

## Uninstalling

```bash
# Remove shell integration
gdoctor --uninstall-shell

# Remove git hooks (per repository)
gdoctor --uninstall-hooks

# Remove service files
rm ~/.gdoctor_service ~/.gdoctor.log
```

## Differences from Original GDoctor

| Feature | Original | Service Edition |
|---------|----------|-----------------|
| Manual switching | ✅ | ✅ |
| Auto-switching | ❌ | ✅ |
| Git hooks | ❌ | ✅ |
| Shell integration | ❌ | ✅ |
| Logging | ❌ | ✅ |
| Service status | ❌ | ✅ |
| Daemon mode | ❌ | ✅ (experimental) |

## License

Same as original GDoctor project.

# 🩺 GDoctor - Git Profile Doctor

The definitive tool for managing multiple Git profiles with automatic switching, validation, and service integration.

![Bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

## 🚀 Getting Started

```bash
# Quick installation
./install.sh
```

## ✨ Features

### 🔄 **Automatic Profile Switching**
- Detects git repositories and switches profiles automatically
- Shell integration with bash/zsh
- Directory-based profile detection

### 🪝 **Git Hook Validation (Enabled by Default!)**
- **Automatic hooks**: Enabled by default for all new repositories
- **Global template**: Sets up git template directory automatically  
- **Pre-commit validation**: Prevents commits with wrong profiles
- **Per-repository control**: Disable/enable hooks as needed
- **Zero configuration**: Works out of the box after installation

### 🔧 **Service Integration**
- macOS LaunchAgent support
- Linux systemd service
- Background daemon mode
- Comprehensive logging

### 📊 **Management & Monitoring**
- Service status monitoring
- Detailed logging and error tracking
- Easy installation/uninstallation
- Team deployment support

## 📖 Documentation

- **[Complete Documentation](docs/README.md)** - Full feature documentation
- **[Usage Examples](docs/EXAMPLES.md)** - Real-world scenarios
- **[Installation Guide](#installation)** - Setup instructions
- **[Changelog](CHANGELOG.md)** - Version history and release notes

## 🛠️ Installation

### Option 1: Quick Setup (Recommended)
```bash
# Default installation with hooks enabled
./setup.sh

# Installation without automatic hooks
./setup.sh --disable-hooks
```

### Option 2: Manual Installation
```bash
# Install with hooks enabled by default
./scripts/install.sh

# Install without hooks
./scripts/install.sh --disable-hooks

# Enable auto-switching (recommended)
./bin/gdoctor --install-shell
```

### Option 3: System Service
```bash
# macOS LaunchAgent
./scripts/macos-service.sh install

# Linux systemd (as root)
./scripts/deploy.sh --daemon-install
```

## 🎯 Basic Usage

```bash
# Check service status
./bin/gdoctor --status

# List profiles
./bin/gdoctor list

# Manual profile switch
./bin/gdoctor switch work

# Validate current repository
./bin/gdoctor validate

# Show version information
./bin/gdoctor version

# Auto-switch for current directory
./bin/gdoctor --auto-switch

# Git hooks management (enabled by default!)
./bin/gdoctor --disable-hooks      # Disable in current repo
./bin/gdoctor --enable-hooks       # Re-enable in current repo
./bin/gdoctor --setup-global-hooks # Set up for all new repos

# Complete uninstallation
./bin/gdoctor uninstall
```

## 🎉 Git Hooks (New Default Behavior!)

**Git hooks are now enabled by default!** After installation, all new repositories automatically include profile validation hooks.

```bash
# This now automatically includes hooks:
git init my-project
cd my-project
# Pre-commit hook is already active!

# Disable hooks in specific repository
gdoctor --disable-hooks

# Re-enable hooks if needed
gdoctor --enable-hooks

# Set up global template manually (done automatically during install)
gdoctor --setup-global-hooks
```

## 🔧 Configuration

### Profile Configuration (`~/.gitprofiles`)
```ini
[work]
name=Your Name
email=you@company.com
server=github.company.com

[personal]
name=Your Name
email=you@personal.com
server=github.com
```

### Service Configuration
- **Config**: `~/.gdoctor_service`
- **Logs**: `~/.gdoctor.log`
- **Current Profile**: `~/.current_gitprofile`

## 🧪 Testing

```bash
# Run all tests
./tests/test-service.sh

# Test specific functionality
./bin/gdoctor --validate
```

## 🚀 Deployment

### Team Deployment
```bash
# Create deployment package
./scripts/deploy.sh --team-setup

# Distribute the generated tar.gz
```

### Individual Installation
```bash
# Full installation with all features
./scripts/deploy.sh --install

# System service installation
./scripts/deploy.sh --daemon-install
```

## 📱 Platform Support

| Platform | Auto-Switch | Git Hooks | Global Template | System Service | Status |
|----------|-------------|-----------|-----------------|----------------|---------|
| macOS    | ✅          | ✅ (Default) | ✅              | ✅ (LaunchAgent) | Full Support |
| Linux    | ✅          | ✅ (Default) | ✅              | ✅ (systemd)     | Full Support |
| Windows  | ✅          | ✅ (Default) | ✅              | ⚠️ (Manual)      | Basic Support |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `./tests/test-service.sh`
5. Submit a pull request

## 📄 License

MIT License - See original GDoctor project for details.

## 🆘 Support

- **Documentation**: [docs/README.md](docs/README.md)
- **Examples**: [docs/EXAMPLES.md](docs/EXAMPLES.md)
- **Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **Hook Templates**: [hooks/README.md](hooks/README.md)
- **Issues**: Create GitHub issues for bugs/features
- **Logs**: Check `~/.gdoctor.log` for troubleshooting

## 🎯 What's New in v2.2.0

- **🎉 Git hooks enabled by default** - Zero configuration required!
- **🔧 Enhanced hook management** - `--enable-hooks`, `--disable-hooks`, `--setup-global-hooks`
- **📁 Better organization** - Dedicated `hooks/` directory with templates
- **⚙️ Installation customization** - Use `--disable-hooks` to opt-out

---

**Transform your git workflow with intelligent profile management and automatic validation! 🎯✨**

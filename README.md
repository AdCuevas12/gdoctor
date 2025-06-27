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

### 🪝 **Git Hook Validation**
- Pre-commit profile validation
- Prevents commits with wrong profiles
- Repository-specific hook installation

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

### Option 1: Quick Setup
```bash
./setup.sh
```

### Option 2: Manual Installation
```bash
# Install the service
./scripts/install.sh

# Enable auto-switching (recommended)
./bin/gdoctor --install-shell

# Enable git hooks (optional)
./bin/gdoctor --install-hooks
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

# Complete uninstallation
./bin/gdoctor uninstall
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

| Platform | Auto-Switch | Git Hooks | System Service | Status |
|----------|-------------|-----------|----------------|---------|
| macOS    | ✅          | ✅        | ✅ (LaunchAgent) | Full Support |
| Linux    | ✅          | ✅        | ✅ (systemd)     | Full Support |
| Windows  | ✅          | ✅        | ⚠️ (Manual)      | Basic Support |

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
- **Issues**: Create GitHub issues for bugs/features
- **Logs**: Check `~/.gdoctor.log` for troubleshooting

---

**Transform your git workflow with intelligent profile management! 🎯**

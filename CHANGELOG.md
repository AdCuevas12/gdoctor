# Changelog

All notable changes to this project will be documented in this file.

## [2.2.0] - 2025-06-27

### 🎉 Git Hooks Enabled by Default

### Added
- **🪝 Default Git Hooks**
  - Git hooks are now **enabled by default** during installation
  - Global git template directory automatically configured (`~/.git-templates`)
  - All new repositories automatically include profile validation hooks
  - Zero configuration required - works out of the box

- **🔧 Enhanced Hook Management**
  - New `--setup-global-hooks` command to configure global template
  - New `--enable-hooks` command to enable hooks in current repository
  - New `--disable-hooks` command to disable hooks in current repository
  - Enhanced `--auto-switch` to automatically install missing hooks
  - Organized hooks in dedicated `hooks/` directory with templates

- **⚙️ Installation Customization**
  - Added `--disable-hooks` option to `setup.sh` and `install.sh`
  - Users can opt-out of automatic hooks during installation
  - Updated installation messages and help text

### Changed
- **🔄 Default Behavior**
  - **BREAKING**: Git hooks are now enabled by default (previously optional)
  - Installation process automatically sets up global git template
  - All new `git init` and `git clone` operations include hooks automatically
  - Users must explicitly use `--disable-hooks` to opt-out

- **📁 Better Organization**
  - Created dedicated `hooks/` directory with template files
  - Added `hooks/README.md` with comprehensive documentation
  - Hook templates are now file-based rather than inline

### Enhanced
- **🧪 Updated Tests**
  - Test suite now expects hooks to be enabled by default
  - Added tests for new hook management commands
  - Enhanced test coverage for global template functionality

- **📖 Updated Documentation**
  - README now highlights hooks-by-default behavior
  - Updated installation instructions and examples
  - Added new section specifically for git hooks management

## [2.1.0] - 2025-06-27

### 🚀 Enhanced Commands & Uninstallation

### Added
- **🗑️ Complete Uninstallation**
  - New `gdoctor uninstall` command for complete removal
  - Interactive confirmation with detailed warning
  - Removes all configuration files and data
  - Removes shell integrations and git hooks
  - Detects and guides removal of system installations
  - Safe uninstallation with git configuration preservation

- **ℹ️ Version Information**
  - New `gdoctor version` command to display version and system information
  - Shows current version, build date, and platform details
  - Displays available features and configuration file paths
  - Helpful for troubleshooting and support

### Changed
- **⚡ Simplified Command Interface**
  - Basic commands now work without `--` prefix for better usability
  - Backward compatibility maintained (both `gdoctor list` and `gdoctor --list` work)
  - Service commands still use `--` prefix for clear distinction
  - Updated help text and documentation to reflect new command structure

### Enhanced
- **📖 Improved Documentation**
  - Updated README with simplified command examples
  - Enhanced docs/README.md with new command structure
  - Clear distinction between basic and service commands

## [2.0.0] - 2025-06-27

### 🚀 Major Release - Production-Ready Enhanced Edition

This is a complete rewrite and enhancement of the original GDoctor script, transforming it from a simple Bash utility into a comprehensive, production-ready tool for enterprise and professional use.

### Added
- **🔄 Automatic Profile Switching**
  - Shell integration for bash/zsh with automatic detection
  - Directory-based profile switching
  - Background daemon service for continuous monitoring
  - Smart repository detection and profile matching

- **🪝 Git Hook Integration**
  - Pre-commit hook installation and validation
  - Repository-specific hook management
  - Profile validation before commits
  - Prevents commits with incorrect profiles

- **🔧 Service/Daemon Support**
  - macOS LaunchAgent integration with proper plist files
  - Linux systemd service support
  - Background daemon mode with comprehensive logging
  - Service status monitoring and management
  - Automatic startup and recovery

- **📊 Management & Monitoring**
  - Comprehensive logging system (`~/.gdoctor.log`)
  - Service status checking and reporting
  - Error tracking and debugging capabilities
  - Team deployment and distribution support

- **🏗️ Professional Project Structure**
  - Organized folder structure (`bin/`, `scripts/`, `service/`, `docs/`, `tests/`)
  - Separation of concerns with dedicated modules
  - Installation and deployment scripts
  - Comprehensive test suite

- **📖 Enhanced Documentation**
  - Complete feature documentation in `docs/README.md`
  - Real-world usage examples in `docs/EXAMPLES.md`
  - Platform compatibility matrix
  - Installation guides for different scenarios

- **🛠️ Installation & Deployment**
  - Multiple installation options (quick setup, manual, service)
  - Automated installation scripts (`setup.sh`, `scripts/install.sh`)
  - Team deployment capabilities (`scripts/deploy.sh`)
  - macOS service management (`scripts/macos-service.sh`)
  - Makefile for streamlined project management

- **🧪 Testing Infrastructure**
  - Comprehensive test suite (`tests/test-service.sh`)
  - Service functionality testing
  - Installation verification
  - Cross-platform compatibility testing

### Enhanced
- **🔐 Security & Reliability**
  - Enhanced error handling with `set -euo pipefail`
  - Input validation and sanitization
  - Secure profile switching mechanisms
  - Robust configuration file handling

- **🎨 User Experience**
  - Colorized output for better readability
  - Clear error messages and suggestions
  - Interactive installation process
  - Comprehensive help system

- **📱 Cross-Platform Support**
  - Full support for macOS (including Apple Silicon)
  - Full support for Linux distributions
  - Basic support for Windows (Git Bash/WSL)
  - Platform-specific optimizations

### Changed
- **Project Structure**: Complete reorganization from single script to professional project layout
- **Naming**: Unified naming convention using `gdoctor` throughout (removed `-service` suffix)
- **Configuration**: Enhanced configuration format with backward compatibility
- **Logging**: Centralized logging system with structured output
- **Service Management**: Native integration with OS service managers

### Fixed
- Cross-platform compatibility issues
- Profile switching edge cases
- Configuration file parsing robustness
- Service startup and shutdown reliability
- Shell integration compatibility

### Security
- Improved input validation to prevent injection attacks
- Secure handling of git configuration modifications
- Safe profile switching with validation
- Protected service configuration files

## [1.0.0] - Original Release

### Added
- Basic git profile switching functionality
- Simple profile management with `~/.gitprofiles`
- URL validation against configured servers
- Command-line interface for profile operations
- INI-format configuration file support

### Features
- Multiple profile support (work, personal, etc.)
- Git configuration switching (name, email, server)
- Repository URL validation
- Profile listing and current profile display
- Basic error handling and colored output

---

## Migration Guide

### From v1.x to v2.0

**Backup your existing configuration:**
```bash
cp ~/.gitprofiles ~/.gitprofiles.backup
cp ~/.current_gitprofile ~/.current_gitprofile.backup
```

**Install the new version:**
```bash
# Quick setup
./setup.sh

# Or manual installation
./scripts/install.sh
```

**Configuration compatibility:**
- Existing `~/.gitprofiles` files are fully compatible
- Current profile tracking continues to work
- No manual migration required

**New features to explore:**
- Enable shell integration: `./bin/gdoctor --install-shell`
- Install git hooks: `./bin/gdoctor --install-hooks`
- Start the service: `./scripts/macos-service.sh install` (macOS)

---

## Versioning Strategy

- **Major versions (X.0.0)**: Breaking changes, major feature additions
- **Minor versions (X.Y.0)**: New features, enhancements, backward compatible
- **Patch versions (X.Y.Z)**: Bug fixes, minor improvements

## Support

- **Documentation**: [docs/README.md](docs/README.md)
- **Examples**: [docs/EXAMPLES.md](docs/EXAMPLES.md)
- **Issues**: GitHub Issues for bug reports and feature requests
- **Logs**: Check `~/.gdoctor.log` for troubleshooting

---
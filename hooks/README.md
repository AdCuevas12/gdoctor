# Git Hooks

This directory contains Git hook templates used by GDoctor.

## Available Hooks

### pre-commit
- **Purpose**: Validates that the current Git profile matches the repository
- **Behavior**: 
  - Runs `gdoctor --validate` before each commit
  - Blocks commit if profile validation fails
  - Suggests using `gdoctor --auto-switch` to fix issues

## Automatic Installation

- Hooks are installed automatically when running `./setup.sh` or `./scripts/install.sh`
- Global template directory is set up so all new repositories get hooks automatically
- Use `gdoctor --disable-hooks` to disable hooks in specific repositories
- Use `gdoctor --enable-hooks` to re-enable hooks in specific repositories

## Manual Management

```bash
# Set up global hooks template
gdoctor --setup-global-hooks

# Install hooks in current repository
gdoctor --install-hooks

# Remove hooks from current repository
gdoctor --uninstall-hooks

# Disable hooks in current repository (keeps file but removes execute permission)
gdoctor --disable-hooks

# Re-enable hooks in current repository
gdoctor --enable-hooks
```

## Customization

You can modify the hook templates in this directory. Changes will be applied:
- When running `--setup-global-hooks` (affects new repositories)
- When running `--install-hooks` (affects current repository)

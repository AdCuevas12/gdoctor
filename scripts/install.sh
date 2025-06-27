#!/bin/bash

# install.sh - Installation script for GDoctor Service

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

colored_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Parse command line arguments
DISABLE_HOOKS=false
for arg in "$@"; do
    case $arg in
        --disable-hooks)
            DISABLE_HOOKS=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--disable-hooks]"
            echo "  --disable-hooks    Skip automatic git hooks setup"
            exit 0
            ;;
    esac
done

echo "🚀 Installing GDoctor Service..."
echo

# Check if gdoctor exists
if [[ ! -f "bin/gdoctor" ]]; then
    colored_message "$RED" "Error: bin/gdoctor script not found"
    colored_message "$YELLOW" "Make sure you're in the gdoctor directory"
    exit 1
fi

# Make executable
chmod +x bin/gdoctor
colored_message "$GREEN" "✓ Made gdoctor executable"

# Offer installation options
echo "Choose installation method:"
echo "1) System-wide (requires sudo) - /usr/local/bin"
echo "2) User-only - ~/.local/bin"
echo "3) Skip symlink creation"
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        sudo ln -sf "$(pwd)/bin/gdoctor" /usr/local/bin/gdoctor
        colored_message "$GREEN" "✓ Installed to /usr/local/bin/gdoctor"
        ;;
    2)
        mkdir -p ~/.local/bin
        ln -sf "$(pwd)/bin/gdoctor" ~/.local/bin/gdoctor
        colored_message "$GREEN" "✓ Installed to ~/.local/bin/gdoctor"
        
        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            colored_message "$YELLOW" "Add ~/.local/bin to your PATH:"
            echo "echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
            echo "source ~/.bashrc"
        fi
        ;;
    3)
        colored_message "$BLUE" "Skipping symlink creation"
        ;;
    *)
        colored_message "$RED" "Invalid choice"
        exit 1
        ;;
esac

# Initialize if not already done
if [[ ! -f "$HOME/.gitprofiles" ]]; then
    colored_message "$BLUE" "Initializing profiles..."
    ./bin/gdoctor --init
else
    colored_message "$YELLOW" "Profiles already initialized"
fi

# Offer to enable features
echo
colored_message "$BLUE" "Setting up automatic features..."

read -p "Enable shell integration for auto-switching? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./bin/gdoctor --install-shell
fi

# Set up global git hooks by default (unless disabled)
if [[ "$DISABLE_HOOKS" == "false" ]]; then
    colored_message "$BLUE" "Setting up automatic git hooks for all repositories..."
    ./bin/gdoctor --setup-global-hooks
    colored_message "$GREEN" "✓ Git hooks enabled by default for all new repositories"
    colored_message "$YELLOW" "  Use 'gdoctor --disable-hooks' in specific repos to disable"
else
    colored_message "$YELLOW" "Git hooks setup skipped (--disable-hooks flag used)"
fi

# Check if in git repo for immediate hooks installation
if git rev-parse --git-dir >/dev/null 2>&1; then
    if [[ "$DISABLE_HOOKS" == "false" ]]; then
        colored_message "$BLUE" "Installing hooks in current repository..."
        ./bin/gdoctor --install-hooks
    else
        read -p "Install git hooks in current repository? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ./bin/gdoctor --install-hooks
        fi
    fi
fi

echo
colored_message "$GREEN" "🎉 GDoctor Service installation complete!"
echo
colored_message "$BLUE" "Next steps:"
echo "1. Edit ~/.gitprofiles to add your profiles"
echo "2. Use 'gdoctor --status' to check setup"
echo "3. Use 'gdoctor --help' for all commands"
if [[ "$DISABLE_HOOKS" == "false" ]]; then
    echo "4. Git hooks are enabled by default for all new repositories! 🎉"
    echo "   - Use 'gdoctor --disable-hooks' to disable in specific repos"
    echo "   - Use 'gdoctor --enable-hooks' to re-enable if needed"
else
    echo "4. Git hooks were disabled - use 'gdoctor --enable-hooks' to enable per repo"
fi
echo
colored_message "$YELLOW" "If you enabled shell integration, restart your shell or run:"
echo "source ~/.bashrc  # or ~/.zshrc"

#!/bin/bash

# setup.sh - Quick setup script for GDoctor

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

echo "🩺 GDoctor - Quick Setup"
echo "========================"
echo

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

# Check if we're in the right directory
if [[ ! -f "bin/gdoctor" ]]; then
    colored_message "$RED" "Error: Please run this script from the gdoctor directory"
    colored_message "$YELLOW" "Make sure bin/gdoctor exists"
    exit 1
fi

# Make executable
chmod +x bin/gdoctor
chmod +x scripts/*.sh
chmod +x tests/*.sh

colored_message "$BLUE" "Setting up GDoctor..."
echo

# Run the installer
if [[ -f "scripts/install.sh" ]]; then
    if [[ "$DISABLE_HOOKS" == "true" ]]; then
        colored_message "$YELLOW" "Installing with hooks disabled..."
        ./scripts/install.sh --disable-hooks
    else
        colored_message "$BLUE" "Installing with hooks enabled by default..."
        ./scripts/install.sh
    fi
else
    colored_message "$RED" "Error: scripts/install.sh not found"
    exit 1
fi

echo
colored_message "$GREEN" "🎉 Quick setup complete!"
echo
colored_message "$BLUE" "Available commands:"
echo "  ./bin/gdoctor --help           # Show all commands"
echo "  ./bin/gdoctor --status         # Check service status"
echo "  ./scripts/macos-service.sh install     # Install macOS service"
echo "  ./scripts/deploy.sh --help             # Deployment options"
echo "  ./tests/test-service.sh                # Run tests"
echo
colored_message "$YELLOW" "Next steps:"
echo "1. Edit ~/.gitprofiles to add your profiles"
echo "2. Enable shell integration: ./bin/gdoctor --install-shell"
if [[ "$DISABLE_HOOKS" == "true" ]]; then
    echo "3. Git hooks were disabled. Use 'gdoctor --enable-hooks' to enable per repo"
else
    echo "3. Git hooks are now enabled by default! 🎉"
    echo "   - Use 'gdoctor --disable-hooks' to disable in specific repos"
    echo "   - Use 'gdoctor --enable-hooks' to re-enable if needed"
fi
echo
colored_message "$GREEN" "Happy profile switching! 🚀"

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
    ./scripts/install.sh
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
echo "3. Install git hooks: ./bin/gdoctor --install-hooks"
echo
colored_message "$GREEN" "Happy profile switching! 🚀"

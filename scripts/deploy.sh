#!/bin/bash

# deploy.sh - Deploy GDoctor Service with various options

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

show_help() {
    cat << 'EOF'
GDoctor Service Deployment Script

USAGE:
    ./deploy.sh [OPTIONS]

OPTIONS:
    --help              Show this help
    --install           Install and setup service
    --uninstall         Remove service
    --test              Run tests
    --daemon-install    Install as system daemon
    --daemon-remove     Remove system daemon
    --team-setup        Setup for team deployment

EXAMPLES:
    ./deploy.sh --install          # Basic installation
    ./deploy.sh --daemon-install   # Install as system service
    ./deploy.sh --test             # Run all tests
    ./deploy.sh --uninstall        # Complete removal

EOF
}

install_service() {
    colored_message "$BLUE" "Installing GDoctor Service..."
    
    # Run install script
    if [[ -f "scripts/install.sh" ]]; then
        ./scripts/install.sh
    else
        colored_message "$RED" "scripts/install.sh not found!"
        exit 1
    fi
    
    colored_message "$GREEN" "✓ Service installation complete!"
}

uninstall_service() {
    colored_message "$BLUE" "Uninstalling GDoctor Service..."
    
    # Remove shell integration
    if command -v gdoctor &> /dev/null; then
        gdoctor --uninstall-shell 2>/dev/null || true
    fi
    
    # Remove symlinks
    sudo rm -f /usr/local/bin/gdoctor 2>/dev/null || true
    rm -f ~/.local/bin/gdoctor 2>/dev/null || true
    
    # Remove config files
    read -p "Remove configuration files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f ~/.gitprofiles ~/.gdoctor_service ~/.current_gitprofile ~/.gdoctor.log
        colored_message "$GREEN" "✓ Configuration files removed"
    fi
    
    colored_message "$GREEN" "✓ Service uninstalled"
}

run_tests() {
    colored_message "$BLUE" "Running tests..."
    
    if [[ -f "tests/test-service.sh" ]]; then
        ./tests/test-service.sh
    else
        colored_message "$RED" "tests/test-service.sh not found!"
        exit 1
    fi
}

install_daemon() {
    colored_message "$BLUE" "Installing system daemon..."
    
    local os_type
    os_type=$(uname -s)
    
    case "$os_type" in
        Linux)
            install_systemd_service
            ;;
        Darwin)
            install_launchd_service
            ;;
        *)
            colored_message "$RED" "Unsupported OS for daemon installation: $os_type"
            exit 1
            ;;
    esac
}

install_systemd_service() {
    # Check if systemd is available
    if ! command -v systemctl &> /dev/null; then
        colored_message "$RED" "systemctl not found. Is systemd available?"
        exit 1
    fi
    
    # Install service file
    sudo cp service/gdoctor@.service /etc/systemd/system/
    sudo systemctl daemon-reload
    
    # Enable for current user
    local username
    username=$(whoami)
    sudo systemctl enable "gdoctor@$username.service"
    sudo systemctl start "gdoctor@$username.service"
    
    colored_message "$GREEN" "✓ Systemd service installed and started"
    colored_message "$YELLOW" "Check status: sudo systemctl status gdoctor@$username.service"
}

install_launchd_service() {
    # Install to user LaunchAgents
    local plist_path="$HOME/Library/LaunchAgents/com.gdoctor.service.plist"
    cp service/com.gdoctor.service.plist "$plist_path"
    
    # Load the service
    launchctl load "$plist_path"
    
    colored_message "$GREEN" "✓ LaunchAgent installed and loaded"
    colored_message "$YELLOW" "Check status: launchctl list | grep gdoctor"
}

remove_daemon() {
    colored_message "$BLUE" "Removing system daemon..."
    
    local os_type
    os_type=$(uname -s)
    
    case "$os_type" in
        Linux)
            remove_systemd_service
            ;;
        Darwin)
            remove_launchd_service
            ;;
        *)
            colored_message "$YELLOW" "Manual daemon removal required for: $os_type"
            ;;
    esac
}

remove_systemd_service() {
    local username
    username=$(whoami)
    
    sudo systemctl stop "gdoctor@$username.service" 2>/dev/null || true
    sudo systemctl disable "gdoctor@$username.service" 2>/dev/null || true
    sudo rm -f "/etc/systemd/system/gdoctor@.service"
    sudo systemctl daemon-reload
    
    colored_message "$GREEN" "✓ Systemd service removed"
}

remove_launchd_service() {
    local plist_path="$HOME/Library/LaunchAgents/com.gdoctor.service.plist"
    
    launchctl unload "$plist_path" 2>/dev/null || true
    rm -f "$plist_path"
    
    colored_message "$GREEN" "✓ LaunchAgent removed"
}

team_setup() {
    colored_message "$BLUE" "Setting up for team deployment..."
    
    # Create deployment package
    local package_name="gdoctor-$(date +%Y%m%d).tar.gz"
    tar -czf "$package_name" \
        bin/ \
        scripts/ \
        service/ \
        docs/ \
        tests/ \
        setup.sh \
        README.md
    
    colored_message "$GREEN" "✓ Created deployment package: $package_name"
    
    # Create team instructions
    cat > TEAM_DEPLOYMENT.md << 'EOF'
# Team Deployment Instructions

## Quick Setup for Team Members

1. **Extract package**:
   ```bash
   tar -xzf gdoctor-YYYYMMDD.tar.gz
   cd gdoctor
   ```

2. **Install**:
   ```bash
   ./deploy.sh --install
   ```

3. **Configure profiles** (edit ~/.gitprofiles):
   ```ini
   [work]
   name=Your Name
   email=your.email@company.com
   server=github.company.com
   
   [personal]
   name=Your Name
   email=your.personal@email.com
   server=github.com
   ```

4. **Enable auto-switching**:
   ```bash
   gdoctor --install-shell
   ```

5. **Test**:
   ```bash
   gdoctor --status
   ```

## For System Administrators

- Use `./deploy.sh --daemon-install` for system-wide daemon
- Distribute the tar.gz package to team members
- Customize default profiles as needed

EOF
    
    colored_message "$GREEN" "✓ Created TEAM_DEPLOYMENT.md"
    colored_message "$BLUE" "Package ready for distribution: $package_name"
}

# Main execution
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                ;;
            --install)
                install_service
                ;;
            --uninstall)
                uninstall_service
                ;;
            --test)
                run_tests
                ;;
            --daemon-install)
                install_daemon
                ;;
            --daemon-remove)
                remove_daemon
                ;;
            --team-setup)
                team_setup
                ;;
            *)
                colored_message "$RED" "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

main "$@"

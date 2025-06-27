#!/bin/bash

# macos-service.sh - macOS LaunchAgent management for GDoctor Service

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
macOS LaunchAgent Manager for GDoctor Service

USAGE:
    ./macos-service.sh <command>

COMMANDS:
    install     Install and start LaunchAgent
    uninstall   Stop and remove LaunchAgent
    start       Start the service
    stop        Stop the service
    restart     Restart the service
    status      Show service status
    logs        Show service logs

EXAMPLES:
    ./macos-service.sh install    # Install and start service
    ./macos-service.sh status     # Check if running
    ./macos-service.sh logs       # View logs

EOF
}

get_plist_path() {
    echo "$HOME/Library/LaunchAgents/com.gdoctor.service.plist"
}

create_user_plist() {
    local plist_path
    plist_path=$(get_plist_path)
    
    # Create LaunchAgents directory if it doesn't exist
    mkdir -p "$HOME/Library/LaunchAgents"
    
    # Use template and replace placeholders
    if [[ -f "service/com.gdoctor.service.template.plist" ]]; then
        local template_file="service/com.gdoctor.service.template.plist"
    else
        local template_file="service/com.gdoctor.service.plist"
    fi
    
    # Replace placeholders with actual values
    sed -e "s|USER_HOME_PLACEHOLDER|$HOME|g" \
        -e "s|USERNAME_PLACEHOLDER|$(whoami)|g" \
        -e "s|SHELL_PLACEHOLDER|$SHELL|g" \
        "$template_file" > "$plist_path"
    
    colored_message "$GREEN" "✓ Created personalized plist at $plist_path"
}

install_service() {
    colored_message "$BLUE" "Installing GDoctor LaunchAgent..."
    
    # Check if gdoctor exists
    if ! command -v gdoctor &> /dev/null; then
        colored_message "$RED" "Error: gdoctor not found in PATH"
        colored_message "$YELLOW" "Install gdoctor first with: ./install.sh"
        exit 1
    fi
    
    # Create user-specific plist
    create_user_plist
    
    local plist_path
    plist_path=$(get_plist_path)
    
    # Load the service
    if launchctl load "$plist_path" 2>/dev/null; then
        colored_message "$GREEN" "✓ LaunchAgent loaded successfully"
    else
        colored_message "$YELLOW" "Service may already be loaded"
    fi
    
    # Enable it to start at login
    if launchctl enable "gui/$(id -u)/com.gdoctor.service" 2>/dev/null; then
        colored_message "$GREEN" "✓ Service enabled for login"
    else
        colored_message "$YELLOW" "Service may already be enabled"
    fi
    
    colored_message "$GREEN" "🎉 GDoctor Service installed as LaunchAgent!"
    colored_message "$BLUE" "It will start automatically at login and run in the background."
    echo
    colored_message "$YELLOW" "Check status: ./macos-service.sh status"
    colored_message "$YELLOW" "View logs: ./macos-service.sh logs"
}

uninstall_service() {
    colored_message "$BLUE" "Uninstalling GDoctor LaunchAgent..."
    
    local plist_path
    plist_path=$(get_plist_path)
    
    # Stop and unload
    launchctl bootout "gui/$(id -u)/com.gdoctor.service" 2>/dev/null || true
    launchctl unload "$plist_path" 2>/dev/null || true
    
    # Remove plist file
    if [[ -f "$plist_path" ]]; then
        rm "$plist_path"
        colored_message "$GREEN" "✓ Removed plist file"
    fi
    
    # Clean up log files
    rm -f "$HOME/.gdoctor.log" "$HOME/.gdoctor.error.log"
    
    colored_message "$GREEN" "✓ GDoctor LaunchAgent uninstalled"
}

start_service() {
    colored_message "$BLUE" "Starting GDoctor Service..."
    
    local plist_path
    plist_path=$(get_plist_path)
    
    if [[ ! -f "$plist_path" ]]; then
        colored_message "$RED" "Service not installed. Run: ./macos-service.sh install"
        exit 1
    fi
    
    if launchctl kickstart "gui/$(id -u)/com.gdoctor.service" 2>/dev/null; then
        colored_message "$GREEN" "✓ Service started"
    else
        colored_message "$YELLOW" "Service may already be running"
    fi
}

stop_service() {
    colored_message "$BLUE" "Stopping GDoctor Service..."
    
    if launchctl kill TERM "gui/$(id -u)/com.gdoctor.service" 2>/dev/null; then
        colored_message "$GREEN" "✓ Service stopped"
    else
        colored_message "$YELLOW" "Service may not be running"
    fi
}

restart_service() {
    stop_service
    sleep 2
    start_service
}

show_status() {
    colored_message "$BLUE" "GDoctor Service Status:"
    echo
    
    local plist_path
    plist_path=$(get_plist_path)
    
    # Check if plist exists
    if [[ -f "$plist_path" ]]; then
        echo "✅ LaunchAgent installed"
    else
        echo "❌ LaunchAgent not installed"
        return 0
    fi
    
    # Check if service is loaded
    if launchctl print "gui/$(id -u)/com.gdoctor.service" &>/dev/null; then
        echo "✅ Service loaded"
        
        # Get service state
        local state
        state=$(launchctl print "gui/$(id -u)/com.gdoctor.service" | grep -o 'state = [a-z]*' | cut -d' ' -f3 || echo "unknown")
        echo "📊 State: $state"
        
        # Check last exit status
        local exit_code
        exit_code=$(launchctl print "gui/$(id -u)/com.gdoctor.service" | grep -o 'last exit code = [0-9]*' | cut -d'=' -f2 | tr -d ' ' || echo "unknown")
        if [[ "$exit_code" == "0" ]]; then
            echo "✅ Last exit: success"
        elif [[ "$exit_code" != "unknown" ]]; then
            echo "⚠️  Last exit code: $exit_code"
        fi
        
    else
        echo "❌ Service not loaded"
    fi
    
    # Check log files
    if [[ -f "$HOME/.gdoctor.log" ]]; then
        local log_size
        log_size=$(wc -l < "$HOME/.gdoctor.log" 2>/dev/null || echo "0")
        echo "📝 Log entries: $log_size"
    fi
    
    if [[ -f "$HOME/.gdoctor.error.log" ]]; then
        local error_size
        error_size=$(wc -l < "$HOME/.gdoctor.error.log" 2>/dev/null || echo "0")
        if [[ "$error_size" -gt 0 ]]; then
            echo "⚠️  Error log entries: $error_size"
        fi
    fi
}

show_logs() {
    colored_message "$BLUE" "Recent GDoctor Service logs:"
    echo
    
    # Show standard output
    if [[ -f "$HOME/.gdoctor.log" ]]; then
        colored_message "$GREEN" "=== Standard Output ==="
        tail -20 "$HOME/.gdoctor.log"
        echo
    fi
    
    # Show errors if any
    if [[ -f "$HOME/.gdoctor.error.log" ]] && [[ -s "$HOME/.gdoctor.error.log" ]]; then
        colored_message "$RED" "=== Error Output ==="
        tail -20 "$HOME/.gdoctor.error.log"
        echo
    fi
    
    # Show system logs
    colored_message "$BLUE" "=== System LaunchAgent Logs ==="
    log show --predicate 'subsystem == "com.apple.launchd"' --info --last 1h | grep -i gdoctor | tail -10 || true
}

# Main execution
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    case $1 in
        install)
            install_service
            ;;
        uninstall)
            uninstall_service
            ;;
        start)
            start_service
            ;;
        stop)
            stop_service
            ;;
        restart)
            restart_service
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        --help|-h)
            show_help
            ;;
        *)
            colored_message "$RED" "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"

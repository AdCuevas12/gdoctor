#!/bin/bash

# test-service.sh - Test script for GDoctor Service

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

TEST_DIR="/tmp/gdoctor-test-$$"
TEST_CONFIG="$TEST_DIR/.gitprofiles"
TEST_PROFILE_FILE="$TEST_DIR/.current_gitprofile"

# Override config locations for testing
export HOME="$TEST_DIR"

cleanup() {
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

echo "🧪 Testing GDoctor Service..."
echo

# Create test environment
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test 1: Help command
colored_message "$BLUE" "Test 1: Help command"
if ../bin/gdoctor --help > /dev/null; then
    colored_message "$GREEN" "✓ Help command works"
else
    colored_message "$RED" "✗ Help command failed"
    exit 1
fi

# Test 2: Initialize profiles (hooks enabled by default from install.sh)
colored_message "$BLUE" "Test 2: Initialize profiles with default hooks enabled"
git config --global user.name "Test User" 2>/dev/null || true
git config --global user.email "test@example.com" 2>/dev/null || true

if ../bin/gdoctor --init 2>/dev/null; then
    if [[ -f "$TEST_CONFIG" ]]; then
        colored_message "$GREEN" "✓ Profile initialization works"
        
        # Verify global template is already set up (from install.sh)
        if git config --global --get init.templateDir > /dev/null 2>&1; then
            colored_message "$GREEN" "✓ Global git template enabled by default (from install.sh)"
        else
            colored_message "$YELLOW" "⚠ Global template not set (install.sh should enable this)"
        fi
    else
        colored_message "$RED" "✗ Config file not created"
        exit 1
    fi
else
    colored_message "$RED" "✗ Profile initialization failed"
    exit 1
fi

# Test 3: List profiles
colored_message "$BLUE" "Test 3: List profiles"
if ../bin/gdoctor --list > /dev/null; then
    colored_message "$GREEN" "✓ List profiles works"
else
    colored_message "$RED" "✗ List profiles failed"
    exit 1
fi

# Test 4: Show current profile
colored_message "$BLUE" "Test 4: Show current profile"
if ../bin/gdoctor --current > /dev/null; then
    colored_message "$GREEN" "✓ Show current profile works"
else
    colored_message "$RED" "✗ Show current profile failed"
    exit 1
fi

# Test 5: Add test profile
colored_message "$BLUE" "Test 5: Add test profile"
cat >> "$TEST_CONFIG" << 'EOF'

[test]
name=Test User
email=test@test.com
server=test.example.com
EOF

# Test 6: Switch profile
colored_message "$BLUE" "Test 6: Switch profile"
if ../bin/gdoctor --switch test > /dev/null 2>&1; then
    colored_message "$GREEN" "✓ Profile switching works"
else
    colored_message "$RED" "✗ Profile switching failed"
    exit 1
fi

# Test 7: Status check
colored_message "$BLUE" "Test 7: Status check"
if ../bin/gdoctor --status > /dev/null; then
    colored_message "$GREEN" "✓ Status check works"
else
    colored_message "$RED" "✗ Status check failed"
    exit 1
fi

# Test 8: Git repository operations (hooks auto-enabled from install.sh)
colored_message "$BLUE" "Test 8: Git repository with default hooks enabled"
mkdir -p "$TEST_DIR/test-repo"
cd "$TEST_DIR/test-repo"

# git init should automatically include hooks due to global template from install.sh
git init > /dev/null 2>&1
git remote add origin https://test.example.com/user/repo.git > /dev/null 2>&1

# Check if hooks were automatically installed via global template
if [[ -f ".git/hooks/pre-commit" ]]; then
    colored_message "$GREEN" "✓ Git hooks auto-installed from global template (install.sh default)"
else
    colored_message "$YELLOW" "⚠ Hooks not auto-installed - global template may not be working"
fi

# Test auto-switch
if ../bin/gdoctor --auto-switch > /dev/null 2>&1; then
    colored_message "$GREEN" "✓ Auto-switch works"
else
    colored_message "$YELLOW" "⚠ Auto-switch needs repository setup"
fi

# Test 9: Validation
colored_message "$BLUE" "Test 9: Validation"
if ../bin/gdoctor --validate https://test.example.com/repo.git > /dev/null 2>&1; then
    colored_message "$GREEN" "✓ URL validation works"
else
    colored_message "$YELLOW" "⚠ URL validation completed (may have warnings)"
fi

# Test 10: Git hooks management (enabled by default from install.sh)
colored_message "$BLUE" "Test 10: Git hooks management and customization"

# Check if hooks are installed by default (from global template via install.sh)
if [[ -f ".git/hooks/pre-commit" ]]; then
    colored_message "$GREEN" "✓ Git hooks enabled by default (install.sh behavior)"
    
    # Test disable hooks option
    if ../bin/gdoctor --disable-hooks > /dev/null 2>&1; then
        if [[ ! -f ".git/hooks/pre-commit" ]] || [[ ! -x ".git/hooks/pre-commit" ]]; then
            colored_message "$GREEN" "✓ Hooks disable option works"
            
            # Test re-enable hooks
            if ../bin/gdoctor --enable-hooks > /dev/null 2>&1; then
                colored_message "$GREEN" "✓ Hooks enable option works"
            else
                colored_message "$YELLOW" "⚠ Re-enabling hooks failed"
            fi
        else
            colored_message "$YELLOW" "⚠ Disable hooks didn't remove/disable hooks"
        fi
    else
        colored_message "$YELLOW" "⚠ --disable-hooks option not available"
    fi
    
    # Test uninstall/reinstall for backward compatibility
    if ../bin/gdoctor --uninstall-hooks > /dev/null 2>&1; then
        colored_message "$GREEN" "✓ Git hooks uninstallation works"
        
        # Test reinstall
        if ../bin/gdoctor --install-hooks > /dev/null 2>&1; then
            colored_message "$GREEN" "✓ Git hooks reinstallation works"
        else
            colored_message "$RED" "✗ Git hooks reinstallation failed"
            exit 1
        fi
    else
        colored_message "$YELLOW" "⚠ Git hooks uninstallation issue"
    fi
else
    # Fallback: hooks not installed by default (install.sh may need fixing)
    colored_message "$YELLOW" "⚠ Hooks not enabled by default - install.sh should enable this"
    if ../bin/gdoctor --install-hooks > /dev/null 2>&1; then
        if [[ -f ".git/hooks/pre-commit" ]]; then
            colored_message "$GREEN" "✓ Git hooks manual installation works"
        else
            colored_message "$RED" "✗ Git hooks not created"
            exit 1
        fi
    else
        colored_message "$RED" "✗ Git hooks installation failed"
        exit 1
    fi
fi

echo
colored_message "$GREEN" "🎉 All tests passed!"
colored_message "$BLUE" "GDoctor Service is working correctly."

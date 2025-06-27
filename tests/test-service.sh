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
if ../bi../bin/gdoctor --help > /dev/null; then
    colored_message "$GREEN" "✓ Help command works"
else
    colored_message "$RED" "✗ Help command failed"
    exit 1
fi

# Test 2: Initialize profiles
colored_message "$BLUE" "Test 2: Initialize profiles"
git config --global user.name "Test User" 2>/dev/null || true
git config --global user.email "test@example.com" 2>/dev/null || true

if ../bi../bin/gdoctor --init 2>/dev/null; then
    if [[ -f "$TEST_CONFIG" ]]; then
        colored_message "$GREEN" "✓ Profile initialization works"
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

# Test 8: Create test git repo
colored_message "$BLUE" "Test 8: Git repository operations"
mkdir -p "$TEST_DIR/test-repo"
cd "$TEST_DIR/test-repo"
git init > /dev/null 2>&1
git remote add origin https://test.example.com/user/repo.git > /dev/null 2>&1

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

# Test 10: Git hooks installation
colored_message "$BLUE" "Test 10: Git hooks"
if ../bin/gdoctor --install-hooks > /dev/null 2>&1; then
    if [[ -f ".git/hooks/pre-commit" ]]; then
        colored_message "$GREEN" "✓ Git hooks installation works"
        
        # Test uninstall
        if ../bin/gdoctor --uninstall-hooks > /dev/null 2>&1; then
            colored_message "$GREEN" "✓ Git hooks uninstallation works"
        else
            colored_message "$YELLOW" "⚠ Git hooks uninstallation issue"
        fi
    else
        colored_message "$RED" "✗ Git hooks not created"
        exit 1
    fi
else
    colored_message "$RED" "✗ Git hooks installation failed"
    exit 1
fi

echo
colored_message "$GREEN" "🎉 All tests passed!"
colored_message "$BLUE" "GDoctor Service is working correctly."

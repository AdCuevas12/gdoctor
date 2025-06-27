# Makefile for GDoctor Service

.PHONY: help install uninstall test clean service-start service-stop status docs

# Default target
help:
	@echo "GDoctor Service - Available Commands"
	@echo "===================================="
	@echo ""
	@echo "Setup Commands:"
	@echo "  make install      - Install GDoctor Service"
	@echo "  make uninstall    - Remove GDoctor Service"
	@echo "  make test         - Run all tests"
	@echo ""
	@echo "Service Commands:"
	@echo "  make service-start - Start macOS service"
	@echo "  make service-stop  - Stop macOS service"
	@echo "  make status        - Show service status"
	@echo ""
	@echo "Development:"
	@echo "  make clean        - Clean temporary files"
	@echo "  make package      - Create deployment package"
	@echo "  make docs         - View documentation"
	@echo "  make version      - Show version information"
	@echo ""
	@echo "Quick Start:"
	@echo "  make install && make status"

# Installation
install:
	@echo "Installing GDoctor Service..."
	@chmod +x bin/gdoctor scripts/*.sh tests/*.sh
	@./scripts/install.sh

# Uninstallation
uninstall:
	@echo "Uninstalling GDoctor Service..."
	@if command -v gdoctor >/dev/null 2>&1; then \
		gdoctor uninstall; \
	else \
		echo "GDoctor not found in PATH. Using local script..."; \
		./bin/gdoctor uninstall; \
	fi

# Testing
test:
	@echo "Running tests..."
	@cd tests && ./test-service.sh

# Service management (macOS)
service-start:
	@echo "Starting macOS service..."
	@./scripts/macos-service.sh install

service-stop:
	@echo "Stopping macOS service..."
	@./scripts/macos-service.sh stop

# Status check
status:
	@echo "Checking service status..."
	@if command -v gdoctor >/dev/null 2>&1; then \
		gdoctor --status; \
	else \
		echo "GDoctor Service not installed. Run 'make install' first."; \
	fi

# Package for distribution
package:
	@echo "Creating deployment package..."
	@./scripts/deploy.sh --team-setup

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@rm -f *.log *.bak *.tmp
	@rm -f tests/*.bak
	@rm -f scripts/*.bak
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete

# Development setup
dev-setup: install
	@echo "Setting up development environment..."
	@./bin/gdoctor --install-shell
	@echo "Development setup complete!"

# Quick setup for new users
quick-start:
	@echo "Quick start setup..."
	@./setup.sh

# View documentation
docs:
	@echo "GDoctor Documentation"
	@echo "===================="
	@echo ""
	@echo "📖 Available Documentation:"
	@echo "  • README.md           - Main project documentation"
	@echo "  • CHANGELOG.md        - Version history and release notes"
	@echo "  • docs/README.md      - Complete feature documentation"
	@echo "  • docs/EXAMPLES.md    - Real-world usage examples"
	@echo ""
	@echo "🔍 Quick access:"
	@echo "  cat README.md         - View main README"
	@echo "  cat CHANGELOG.md      - View changelog"
	@echo "  cat docs/README.md    - View detailed docs"
	@echo "  cat docs/EXAMPLES.md  - View examples"

# Show version information
version:
	@echo "Checking GDoctor version..."
	@if command -v gdoctor >/dev/null 2>&1; then \
		gdoctor version; \
	else \
		echo "Using local script..."; \
		./bin/gdoctor version; \
	fi

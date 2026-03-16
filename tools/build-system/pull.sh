#!/bin/bash

# Exit on failures
set -eo pipefail

# Echo commands
set -x

echo "=========================================="
echo "Verifying source code has been pulled..."
echo "=========================================="

# Define the application code directory
APP_CODE_DIR="src/app/eba"

# Check if the application code directory exists
if [ -d "$APP_CODE_DIR" ]; then
    echo "✓ SUCCESS: Application code directory '$APP_CODE_DIR' exists"
    
    # Check if it's a git repository
    if [ -d ".git" ]; then
        echo "✓ Git repository detected"
    fi
    
    # List key files/directories in the app directory
    echo ""
    echo "Application directory contents:"
    ls -la "$APP_CODE_DIR" | head -10
    
    echo ""
    echo "✓ Source code verification completed successfully"
    exit 0
else
    echo "✗ ERROR: Application code directory '$APP_CODE_DIR' not found"
    echo "  Please ensure the repository has been checked out correctly"
    exit 1
fi

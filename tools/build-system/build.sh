#!/bin/bash

# Exit on failures
set -eo pipefail

APP_DIR="src/app/eba"
REQUIRED_NODE_VERSION="22"

# Function to load Node.js environment
load_nodejs() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm use "$REQUIRED_NODE_VERSION" > /dev/null 2>&1
}

# Function to verify application directory
verify_app_directory() {
    if [ ! -d "$APP_DIR" ]; then
        echo "ERROR: Application directory '$APP_DIR' not found"
        exit 1
    fi
}

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    npm install --silent
}

# Function to build the application
build_application() {
    echo "Building Angular application..."
    npm run build -- --configuration=production
}

# Function to verify build output
verify_build_output() {
    if [ ! -d "dist" ]; then
        echo "WARNING: dist/ directory not found after build"
        return 1
    fi
    echo "Build artifacts created successfully"
}

# Main execution
main() {
    load_nodejs
    verify_app_directory
    
    cd "$APP_DIR"
    
    install_dependencies
    build_application
    verify_build_output
    
    echo "Build completed"
}

main

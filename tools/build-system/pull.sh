#!/bin/bash

# Exit on failures
set -eo pipefail

APP_CODE_DIR="src/app/eba"
REQUIRED_NODE_VERSION="22"

# Function to verify source code directory exists
verify_source_code() {
    if [ ! -d "$APP_CODE_DIR" ]; then
        echo "ERROR: Application code directory '$APP_CODE_DIR' not found"
        exit 1
    fi
}

# Function to setup nvm
setup_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash > /dev/null 2>&1
    fi
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Function to setup Node.js environment
setup_nodejs() {
    setup_nvm
    nvm install "$REQUIRED_NODE_VERSION" > /dev/null 2>&1
    nvm use "$REQUIRED_NODE_VERSION" > /dev/null 2>&1
}

# Main execution
main() {
    echo "Verifying source code..."
    verify_source_code
    
    echo "Setting up Node.js v${REQUIRED_NODE_VERSION}..."
    setup_nodejs
    
    echo "Environment ready (Node $(node --version), npm $(npm --version))"
}

main

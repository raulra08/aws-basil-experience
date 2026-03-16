#!/bin/bash

# Exit on failures
set -eo pipefail

# Echo commands
set -x

echo "=========================================="
echo "Building Angular Application..."
echo "=========================================="

# Define the application directory
APP_DIR="src/app/eba"

# Check if the application directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "✗ ERROR: Application directory '$APP_DIR' not found"
    exit 1
fi

# Navigate to the application directory
cd "$APP_DIR"

echo ""
echo "Installing dependencies..."
npm install

echo ""
echo "Building Angular application..."
# Build the Angular application for production
npm run build -- --configuration=production

echo ""
echo "Build completed successfully!"

# Check if build output exists
if [ -d "dist" ]; then
    echo "✓ Build artifacts created in dist/"
    ls -lh dist/
else
    echo "✗ WARNING: dist/ directory not found after build"
fi

echo ""
echo "=========================================="
echo "Build process completed"
echo "=========================================="

#!/bin/bash
# Remote install script for GitHub
# Usage: curl -sL https://raw.githubusercontent.com/USER/passgen/main/install.sh | bash

set -e

REPO="VasilyPolyuhovich/Passgen"
APP_NAME="PasswordGen"

echo "Installing $APP_NAME..."

# Create temp directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download latest release
echo "Downloading..."
curl -sL "https://github.com/$REPO/releases/latest/download/$APP_NAME.zip" -o "$APP_NAME.zip"

# Unzip
unzip -q "$APP_NAME.zip"

# Remove quarantine
xattr -cr "$APP_NAME.app" 2>/dev/null || true

# Install
echo "Installing to /Applications..."
rm -rf "/Applications/$APP_NAME.app"
mv "$APP_NAME.app" /Applications/

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo ""
echo "Installed! Starting $APP_NAME..."
open "/Applications/$APP_NAME.app"

echo ""
echo "Note: Grant Accessibility permission in System Preferences for global hotkey to work."

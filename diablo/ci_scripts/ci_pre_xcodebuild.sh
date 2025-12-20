#!/bin/bash
set -e

echo "🔧 Running Flutter pre-build setup for Xcode Cloud..."

# Check if Flutter is installed, if not install it
if ! command -v flutter &> /dev/null; then
    echo "📥 Flutter not found, installing Flutter..."
    
    # Install Flutter using the official installation method
    # Use stable branch - Xcode Cloud will use the version specified in pubspec.yaml
    FLUTTER_HOME="$HOME/flutter"
    
    if [ ! -d "$FLUTTER_HOME" ]; then
        echo "📦 Downloading Flutter SDK (stable branch)..."
        git clone --branch stable https://github.com/flutter/flutter.git "$FLUTTER_HOME"
    else
        echo "📦 Flutter SDK already exists, updating..."
        cd "$FLUTTER_HOME"
        git fetch origin stable
        git checkout stable
        git pull origin stable
    fi
    
    # Add Flutter to PATH for this session
    export PATH="$FLUTTER_HOME/bin:$PATH"
    
    # Verify Flutter is accessible
    if ! command -v flutter &> /dev/null; then
        echo "❌ Error: Flutter installation failed"
        exit 1
    fi
    
    echo "✅ Flutter installed successfully"
else
    echo "✅ Flutter is already installed"
    # Ensure Flutter is in PATH
    FLUTTER_BIN=$(dirname $(which flutter))
    export PATH="$FLUTTER_BIN:$PATH"
fi

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
flutter --version

# Navigate to the Flutter project directory
cd "$CI_WORKSPACE/diablo"

# Install Flutter dependencies
echo "📦 Running flutter pub get..."
flutter pub get

# Generate Flutter files needed for iOS build
echo "🔨 Generating Flutter iOS files..."
flutter precache --ios

# Install CocoaPods dependencies
echo "🍫 Running pod install..."
cd ios
pod install

echo "✅ Pre-build setup complete!"


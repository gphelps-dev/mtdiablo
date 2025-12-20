#!/bin/bash
set -e

echo "🔧 Running Flutter pre-build setup for Xcode Cloud..."

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


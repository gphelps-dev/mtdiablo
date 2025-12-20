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

# Generate Flutter files needed for macOS build
echo "🔨 Generating Flutter macOS files..."
flutter precache --macos

# Ensure Generated.xcconfig exists before running pod install
echo "🔍 Verifying Flutter Generated.xcconfig..."
if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
    echo "⚠️  iOS Generated.xcconfig not found, generating it..."
    flutter build ios --config-only --no-codesign || flutter build ios --config-only
fi

# Ensure macOS ephemeral files exist
echo "🔍 Verifying Flutter macOS ephemeral files..."
if [ ! -f "macos/Flutter/ephemeral/Flutter-Generated.xcconfig" ]; then
    echo "⚠️  macOS Flutter-Generated.xcconfig not found, generating it..."
    flutter build macos --config-only || true
fi

# Ensure macOS xcfilelist files exist
if [ ! -f "macos/Flutter/ephemeral/FlutterInputs.xcfilelist" ] || [ ! -f "macos/Flutter/ephemeral/FlutterOutputs.xcfilelist" ]; then
    echo "⚠️  macOS xcfilelist files not found, generating them..."
    cd macos
    mkdir -p Flutter/ephemeral
    touch Flutter/ephemeral/FlutterInputs.xcfilelist
    touch Flutter/ephemeral/FlutterOutputs.xcfilelist
    cd ..
    # Try to generate them properly
    flutter build macos --config-only || true
fi

# Install CocoaPods dependencies
echo "🍫 Running pod install..."
cd ios

# Ensure CocoaPods is available
if ! command -v pod &> /dev/null; then
    echo "📦 Installing CocoaPods..."
    sudo gem install cocoapods 2>/dev/null || gem install cocoapods --user-install
    export PATH="$HOME/.gem/ruby/*/bin:$PATH"
fi

# Clean and install pods
echo "🧹 Cleaning CocoaPods cache..."
pod cache clean --all 2>/dev/null || true

echo "📦 Installing CocoaPods dependencies..."
pod install --repo-update

# Verify that the required xcfilelist files are created
echo "🔍 Verifying CocoaPods file lists..."
REQUIRED_FILES=(
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Release-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Release-output-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-output-files.xcfilelist"
)

MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file not found: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
    else
        echo "✅ Found: $file"
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo "⚠️  Warning: $MISSING_FILES required file(s) are missing. Retrying pod install..."
    pod install
fi

echo "✅ Pre-build setup complete!"


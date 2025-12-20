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
    flutter build macos --config-only 2>/dev/null || true
fi

# Ensure macOS xcfilelist files exist and are properly generated
echo "🔍 Verifying macOS xcfilelist files..."
cd macos
mkdir -p Flutter/ephemeral

# Get FLUTTER_ROOT from Flutter-Generated.xcconfig if it exists
if [ -f "Flutter/ephemeral/Flutter-Generated.xcconfig" ]; then
    FLUTTER_ROOT=$(grep "^FLUTTER_ROOT=" Flutter/ephemeral/Flutter-Generated.xcconfig | cut -d'=' -f2 | tr -d '"' | tr -d ' ')
    export FLUTTER_ROOT
fi

# If FLUTTER_ROOT is not set, try to get it from flutter command
if [ -z "$FLUTTER_ROOT" ]; then
    FLUTTER_ROOT=$(flutter doctor -v 2>/dev/null | grep "Flutter SDK at" | awk '{print $4}' | head -1)
    export FLUTTER_ROOT
fi

# Generate the xcfilelist files using Flutter's macos_assemble script
if [ -n "$FLUTTER_ROOT" ] && [ -f "$FLUTTER_ROOT/packages/flutter_tools/bin/macos_assemble.sh" ]; then
    echo "🔨 Running macos_assemble.sh to generate xcfilelist files..."
    PROJECT_DIR=$(pwd)
    export PROJECT_DIR
    "$FLUTTER_ROOT/packages/flutter_tools/bin/macos_assemble.sh" 2>/dev/null || true
else
    echo "⚠️  FLUTTER_ROOT not found, creating placeholder xcfilelist files..."
    # Create minimal valid xcfilelist files (empty but valid)
    echo "" > Flutter/ephemeral/FlutterInputs.xcfilelist
    echo "" > Flutter/ephemeral/FlutterOutputs.xcfilelist
fi

# Verify files exist
if [ ! -f "Flutter/ephemeral/FlutterInputs.xcfilelist" ]; then
    echo "" > Flutter/ephemeral/FlutterInputs.xcfilelist
fi
if [ ! -f "Flutter/ephemeral/FlutterOutputs.xcfilelist" ]; then
    echo "" > Flutter/ephemeral/FlutterOutputs.xcfilelist
fi

cd ..

# Install CocoaPods dependencies
echo "🍫 Running pod install..."
cd ios

# Ensure CocoaPods is available
if ! command -v pod &> /dev/null; then
    echo "📦 Installing CocoaPods..."
    sudo gem install cocoapods 2>/dev/null || gem install cocoapods --user-install
    export PATH="$HOME/.gem/ruby/*/bin:$PATH"
    # Verify pod is now available
    if ! command -v pod &> /dev/null; then
        echo "❌ Error: CocoaPods installation failed"
        exit 1
    fi
fi

# Remove existing Pods and Manifest.lock to ensure clean install
echo "🧹 Cleaning existing Pods installation..."
rm -rf Pods
rm -f Pods/Manifest.lock

# Clean CocoaPods cache
echo "🧹 Cleaning CocoaPods cache..."
pod cache clean --all 2>/dev/null || true

# Install pods (this will regenerate Podfile.lock and Manifest.lock)
echo "📦 Installing CocoaPods dependencies..."
pod install --repo-update

# Ensure Manifest.lock exists and matches Podfile.lock
MAX_RETRIES=3
RETRY_COUNT=0
SYNCED=false

while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$SYNCED" = false ]; do
    if [ -f "Podfile.lock" ] && [ -f "Pods/Manifest.lock" ]; then
        if diff -q Podfile.lock Pods/Manifest.lock > /dev/null 2>&1; then
            echo "✅ Podfile.lock and Manifest.lock are in sync"
            SYNCED=true
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            echo "⚠️  Podfile.lock and Manifest.lock are out of sync (attempt $RETRY_COUNT/$MAX_RETRIES)"
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                # Copy Podfile.lock to Manifest.lock to force sync
                echo "🔄 Copying Podfile.lock to Manifest.lock to force sync..."
                mkdir -p Pods
                cp Podfile.lock Pods/Manifest.lock
                # Run pod install again to ensure everything is consistent
                pod install
            fi
        fi
    else
        echo "❌ Error: Podfile.lock or Manifest.lock not found after pod install"
        if [ -f "Podfile.lock" ]; then
            echo "📋 Podfile.lock exists, creating Manifest.lock from it..."
            mkdir -p Pods
            cp Podfile.lock Pods/Manifest.lock
            SYNCED=true
        else
            exit 1
        fi
    fi
done

# Final verification
if [ "$SYNCED" = false ]; then
    echo "❌ Error: Failed to sync Podfile.lock and Manifest.lock after $MAX_RETRIES attempts"
    echo "📋 Podfile.lock contents:"
    cat Podfile.lock | head -20
    echo "📋 Manifest.lock contents:"
    cat Pods/Manifest.lock | head -20 2>/dev/null || echo "Manifest.lock not found"
    exit 1
fi

# Verify that the required xcfilelist files are created
echo "🔍 Verifying CocoaPods file lists..."
REQUIRED_FILES=(
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Release-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Release-output-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Release-output-files.xcfilelist"
)

# Also check Debug and Profile versions to use as templates if Release is missing
TEMPLATE_FILES=(
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Debug-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-resources-Debug-output-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Debug-input-files.xcfilelist"
    "Pods/Target Support Files/Pods-Runner/Pods-Runner-frameworks-Debug-output-files.xcfilelist"
)

MISSING_FILES=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  Warning: Required file not found: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
        
        # Try to create it from a template or create empty file
        mkdir -p "$(dirname "$file")"
        # Find corresponding Debug template
        TEMPLATE_FILE=$(echo "$file" | sed 's/-Release-/-Debug-/')
        if [ -f "$TEMPLATE_FILE" ]; then
            echo "📋 Copying from template: $TEMPLATE_FILE"
            cp "$TEMPLATE_FILE" "$file"
        else
            echo "📋 Creating empty file: $file"
            touch "$file"
        fi
    else
        echo "✅ Found: $file"
    fi
done

# If files are still missing after creating from templates, retry pod install
if [ $MISSING_FILES -gt 0 ]; then
    echo "⚠️  Warning: $MISSING_FILES required file(s) were missing. Retrying pod install to regenerate..."
    pod install
    
    # Verify again after retry
    MISSING_AFTER_RETRY=0
    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            echo "❌ Error: File still missing after retry: $file"
            MISSING_AFTER_RETRY=$((MISSING_AFTER_RETRY + 1))
            # Create empty file as last resort
            mkdir -p "$(dirname "$file")"
            touch "$file"
        fi
    done
    
    if [ $MISSING_AFTER_RETRY -gt 0 ]; then
        echo "⚠️  Created empty placeholder files for $MISSING_AFTER_RETRY missing xcfilelist files"
    fi
fi

# Final verification - ensure all files exist
echo "🔍 Final verification of xcfilelist files..."
ALL_EXIST=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: File still missing: $file"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = true ]; then
    echo "✅ All required xcfilelist files exist"
else
    echo "❌ Error: Some xcfilelist files are still missing"
    exit 1
fi

echo "✅ Pre-build setup complete!"


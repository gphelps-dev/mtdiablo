#!/bin/bash
# Fix invalid symlinks in Flutter.framework before archiving (iOS)
# This prevents ITMS-90332 errors during App Store submission

set -e

echo "🔧 Fixing Flutter framework symlinks for iOS..."

# Find the Flutter.framework in the iOS app bundle
# iOS app structure: AppName.app/Frameworks/Flutter.framework
APP_BUNDLE="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
FLUTTER_FRAMEWORK="${APP_BUNDLE}/Frameworks/Flutter.framework"

if [ ! -d "$FLUTTER_FRAMEWORK" ]; then
    echo "⚠️  Flutter.framework not found in app bundle, skipping symlink fix"
    exit 0
fi

HEADERS_DIR="${FLUTTER_FRAMEWORK}/Headers"
FLUTTER_MACOS_DIR="${HEADERS_DIR}/FlutterMacOS"
FLUTTER_MACOS_SYMLINK="${FLUTTER_MACOS_DIR}/FlutterMacOS.h"

# Check if the symlink exists
if [ -L "$FLUTTER_MACOS_SYMLINK" ]; then
    echo "📋 Found symlink: $FLUTTER_MACOS_SYMLINK"
    
    # Check if the symlink target exists
    SYMLINK_TARGET=$(readlink "$FLUTTER_MACOS_SYMLINK")
    
    # Resolve relative paths
    if [[ "$SYMLINK_TARGET" != /* ]]; then
        SYMLINK_TARGET="${FLUTTER_MACOS_DIR}/${SYMLINK_TARGET}"
    fi
    
    # Check if target exists
    if [ ! -f "$SYMLINK_TARGET" ]; then
        echo "⚠️  Symlink target does not exist: $SYMLINK_TARGET"
        echo "🔧 Removing invalid symlink..."
        rm -f "$FLUTTER_MACOS_SYMLINK"
        
        # Try to find FlutterMacOS.h in the Headers directory
        FLUTTER_MACOS_H="${HEADERS_DIR}/FlutterMacOS.h"
        if [ -f "$FLUTTER_MACOS_H" ]; then
            echo "✅ Found FlutterMacOS.h, creating directory structure..."
            mkdir -p "$FLUTTER_MACOS_DIR"
            # Copy the file instead of creating a symlink
            cp "$FLUTTER_MACOS_H" "$FLUTTER_MACOS_SYMLINK"
            echo "✅ Copied FlutterMacOS.h to FlutterMacOS/FlutterMacOS.h"
        else
            echo "⚠️  FlutterMacOS.h not found in Headers directory"
            # Remove the empty directory
            rmdir "$FLUTTER_MACOS_DIR" 2>/dev/null || true
        fi
    else
        echo "✅ Symlink target exists: $SYMLINK_TARGET"
    fi
elif [ -d "$FLUTTER_MACOS_DIR" ]; then
    # Directory exists but no symlink - check if we need to create it
    if [ ! -f "$FLUTTER_MACOS_SYMLINK" ]; then
        FLUTTER_MACOS_H="${HEADERS_DIR}/FlutterMacOS.h"
        if [ -f "$FLUTTER_MACOS_H" ]; then
            echo "📋 Creating FlutterMacOS/FlutterMacOS.h from FlutterMacOS.h..."
            cp "$FLUTTER_MACOS_H" "$FLUTTER_MACOS_SYMLINK"
            echo "✅ Created FlutterMacOS/FlutterMacOS.h"
        fi
    fi
fi

# Also check for any other invalid symlinks in the framework
echo "🔍 Checking for other invalid symlinks in Flutter.framework..."
find "$FLUTTER_FRAMEWORK" -type l | while read symlink; do
    target=$(readlink "$symlink")
    # Resolve relative paths
    if [[ "$target" != /* ]]; then
        symlink_dir=$(dirname "$symlink")
        target="${symlink_dir}/${target}"
    fi
    # Check if target exists
    if [ ! -e "$target" ]; then
        echo "⚠️  Found broken symlink: $symlink → $target"
        echo "🔧 Removing broken symlink..."
        rm -f "$symlink"
    fi
done

echo "✅ Flutter framework symlink check complete"


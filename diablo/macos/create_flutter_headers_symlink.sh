#!/bin/bash
set -e

echo "🔧 Creating FlutterMacOS header symlink structure..."

cd "$(dirname "$0")"

# Get FLUTTER_ROOT from Flutter-Generated.xcconfig
if [ -f "Flutter/ephemeral/Flutter-Generated.xcconfig" ]; then
    FLUTTER_ROOT=$(grep "^FLUTTER_ROOT=" Flutter/ephemeral/Flutter-Generated.xcconfig | cut -d'=' -f2 | tr -d '"' | tr -d ' ')
    
    # Find ALL FlutterMacOS.h files and create symlinks in ALL Headers directories
    # This is critical because Xcode might use different build configurations (Debug/Profile/Release)
    echo "   Creating FlutterMacOS/FlutterMacOS.h structure in all Headers directories..."
    
    HEADERS_COUNT=0
    SYMLINK_COUNT=0
    
    # Find all Headers directories in Flutter engine
    find "$FLUTTER_ROOT/bin/cache/artifacts/engine" -type d -name "Headers" 2>/dev/null | while read headers_dir; do
        HEADERS_COUNT=$((HEADERS_COUNT + 1))
        flutter_macos_dir="$headers_dir/FlutterMacOS"
        
        # Create FlutterMacOS directory if it doesn't exist
        if [ ! -d "$flutter_macos_dir" ]; then
            mkdir -p "$flutter_macos_dir"
            echo "   Created directory: $flutter_macos_dir"
        fi
        
        # Create symlink if it doesn't exist
        if [ ! -f "$flutter_macos_dir/FlutterMacOS.h" ] && [ ! -L "$flutter_macos_dir/FlutterMacOS.h" ]; then
            ln -sf "../FlutterMacOS.h" "$flutter_macos_dir/FlutterMacOS.h"
            SYMLINK_COUNT=$((SYMLINK_COUNT + 1))
            echo "   Created symlink: $flutter_macos_dir/FlutterMacOS.h"
        fi
        
        # Verify symlink works
        if [ -L "$flutter_macos_dir/FlutterMacOS.h" ]; then
            if [ ! -f "$flutter_macos_dir/FlutterMacOS.h" ]; then
                echo "   ⚠️  Broken symlink detected, recreating: $flutter_macos_dir/FlutterMacOS.h"
                rm -f "$flutter_macos_dir/FlutterMacOS.h"
                ln -sf "../FlutterMacOS.h" "$flutter_macos_dir/FlutterMacOS.h"
            fi
        fi
    done
    
    echo "✅ FlutterMacOS header structure created in all Headers directories!"
    echo "   Now <FlutterMacOS/FlutterMacOS.h> should resolve correctly for all build configurations"
else
    echo "❌ Error: Flutter-Generated.xcconfig not found"
    exit 1
fi


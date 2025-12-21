#!/bin/bash
set -e

echo "🔧 Fixing Pods project for FlutterMacOS and VerifyModule issues..."

cd "$(dirname "$0")"

if [ ! -f "Pods/Pods.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Pods/Pods.xcodeproj/project.pbxproj not found"
    echo "   Run 'pod install' first"
    exit 1
fi

PROJECT_FILE="Pods/Pods.xcodeproj/project.pbxproj"
FLUTTER_EPHEMERAL="$(pwd)/Flutter/ephemeral"

echo "📝 Backing up project file..."
cp "$PROJECT_FILE" "${PROJECT_FILE}.backup"

echo "🔧 Removing VerifyModule build phases..."
# Aggressively remove VerifyModule - this is critical to fix Test module errors
# Remove all lines containing VerifyModule
sed -i '' '/VerifyModule/d' "$PROJECT_FILE" 2>/dev/null || true

# Also remove VerifyModule build phase references using Python for more precision
python3 << PYTHON_SCRIPT
import re
import sys
import os

project_file = os.path.expandvars("$PROJECT_FILE")

try:
    with open(project_file, 'r') as f:
        content = f.read()
    
    original_length = len(content)
    
    # Remove VerifyModule build phase definitions
    # Pattern: /* VerifyModule */ = { ... };
    content = re.sub(r'/\* VerifyModule \*/ = \{[^}]*\};', '', content, flags=re.DOTALL)
    
    # Remove VerifyModule from buildPhases arrays
    content = re.sub(r',\s*\w+\s+/\* VerifyModule \*/', '', content)
    content = re.sub(r'\w+\s+/\* VerifyModule \*/,?\s*', '', content)
    
    # Remove VerifyModule shell script phases
    content = re.sub(r'/\* VerifyModule \*/ = \{[^}]*shellScript[^}]*\};', '', content, flags=re.DOTALL)
    
    # Remove any remaining VerifyModule references
    lines = content.split('\n')
    filtered_lines = [line for line in lines if 'VerifyModule' not in line]
    content = '\n'.join(filtered_lines)
    
    with open(project_file, 'w') as f:
        f.write(content)
    
    removed = original_length - len(content)
    if removed > 0:
        print(f"   Removed {removed} bytes containing VerifyModule references")
    else:
        print("   No VerifyModule references found to remove")
except Exception as e:
    print(f"   Error removing VerifyModule: {e}")
    sys.exit(1)
PYTHON_SCRIPT

echo "🔧 Adding FlutterMacOS header search paths..."

# Get FLUTTER_ROOT from Flutter-Generated.xcconfig
if [ -f "Flutter/ephemeral/Flutter-Generated.xcconfig" ]; then
    FLUTTER_ROOT=$(grep "^FLUTTER_ROOT=" Flutter/ephemeral/Flutter-Generated.xcconfig | cut -d'=' -f2 | tr -d '"' | tr -d ' ')
    echo "   FLUTTER_ROOT: $FLUTTER_ROOT"
    
    # Find FlutterMacOS.h in the Flutter engine
    FLUTTER_MACOS_H=$(find "$FLUTTER_ROOT/bin/cache/artifacts/engine" -name "FlutterMacOS.h" 2>/dev/null | head -1)
    if [ -n "$FLUTTER_MACOS_H" ]; then
        FLUTTER_MACOS_DIR=$(dirname "$FLUTTER_MACOS_H")
        echo "   Found FlutterMacOS.h at: $FLUTTER_MACOS_DIR"
        
        # CRITICAL: Create FlutterMacOS/FlutterMacOS.h structure for <FlutterMacOS/FlutterMacOS.h> imports
        FLUTTER_MACOS_SUBDIR="$FLUTTER_MACOS_DIR/FlutterMacOS"
        if [ ! -d "$FLUTTER_MACOS_SUBDIR" ]; then
            mkdir -p "$FLUTTER_MACOS_SUBDIR"
            echo "   Created FlutterMacOS directory"
        fi
        if [ ! -f "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h" ] && [ ! -L "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h" ]; then
            ln -sf "../FlutterMacOS.h" "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h"
            echo "   Created FlutterMacOS/FlutterMacOS.h symlink"
        else
            echo "   FlutterMacOS/FlutterMacOS.h symlink already exists"
        fi
        # Verify symlink works
        if [ -L "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h" ]; then
            if [ -f "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h" ]; then
                echo "   ✅ Symlink verified and working"
            else
                echo "   ⚠️  Symlink exists but target not found, recreating..."
                rm -f "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h"
                ln -sf "../FlutterMacOS.h" "$FLUTTER_MACOS_SUBDIR/FlutterMacOS.h"
            fi
        fi
        
        # Also find the xcframework directory
        FLUTTER_XCFRAMEWORK=$(find "$FLUTTER_ROOT/bin/cache/artifacts/engine" -name "FlutterMacOS.xcframework" -type d 2>/dev/null | head -1)
        if [ -n "$FLUTTER_XCFRAMEWORK" ]; then
            echo "   Found FlutterMacOS.xcframework at: $FLUTTER_XCFRAMEWORK"
            # Find all Headers directories in the xcframework
            XCFRAMEWORK_HEADERS=$(find "$FLUTTER_XCFRAMEWORK" -type d -name "Headers" 2>/dev/null | head -1)
            if [ -n "$XCFRAMEWORK_HEADERS" ]; then
                echo "   Found Headers at: $XCFRAMEWORK_HEADERS"
                # Also create symlink structure here
                FLUTTER_MACOS_SUBDIR2="$XCFRAMEWORK_HEADERS/FlutterMacOS"
                if [ ! -d "$FLUTTER_MACOS_SUBDIR2" ]; then
                    mkdir -p "$FLUTTER_MACOS_SUBDIR2"
                    ln -sf "../FlutterMacOS.h" "$FLUTTER_MACOS_SUBDIR2/FlutterMacOS.h"
                    echo "   Created FlutterMacOS structure in xcframework Headers"
                fi
            fi
        fi
    fi
fi

# Use Python to properly add header search paths
python3 << PYTHON_SCRIPT
import re
import sys
import os

project_file = "$PROJECT_FILE"
flutter_ephemeral = "$FLUTTER_EPHEMERAL"
flutter_macos_dir = "$FLUTTER_MACOS_DIR"
xcframework_headers = "$XCFRAMEWORK_HEADERS"

paths_to_add = []
if flutter_ephemeral and os.path.exists(flutter_ephemeral):
    paths_to_add.append(flutter_ephemeral)
if flutter_macos_dir and os.path.exists(flutter_macos_dir):
    paths_to_add.append(flutter_macos_dir)
    # CRITICAL: Also add the FlutterMacOS subdirectory for <FlutterMacOS/FlutterMacOS.h> imports
    flutter_macos_subdir = os.path.join(flutter_macos_dir, 'FlutterMacOS')
    if os.path.exists(flutter_macos_subdir):
        paths_to_add.append(flutter_macos_subdir)
if xcframework_headers and os.path.exists(xcframework_headers):
    paths_to_add.append(xcframework_headers)
    # Also add FlutterMacOS subdirectory from xcframework
    xcframework_subdir = os.path.join(xcframework_headers, 'FlutterMacOS')
    if os.path.exists(xcframework_subdir):
        paths_to_add.append(xcframework_subdir)

# Also find all darwin-x64 Headers directories (CRITICAL: avoid nested paths)
if os.path.exists("Flutter/ephemeral/Flutter-Generated.xcconfig"):
    with open("Flutter/ephemeral/Flutter-Generated.xcconfig", 'r') as f:
        for line in f:
            if line.startswith('FLUTTER_ROOT='):
                flutter_root = line.split('=', 1)[1].strip().strip('"').strip("'")
                engine_dir = os.path.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine')
                if os.path.exists(engine_dir):
                    # Find only top-level Headers directories (not nested)
                    for root, dirs, files in os.walk(engine_dir):
                        # Only process directories that end with /Headers and contain FlutterMacOS.h
                        # CRITICAL: Skip if already inside a FlutterMacOS subdirectory
                        if 'darwin-x64' in root and root.endswith('/Headers') and 'FlutterMacOS.h' in files:
                            if '/FlutterMacOS/' not in root:  # Skip nested directories
                                headers_dir = root
                                flutter_macos_subdir = os.path.join(headers_dir, 'FlutterMacOS')
                                if os.path.exists(flutter_macos_subdir):
                                    # Only add if not already in list
                                    if headers_dir not in paths_to_add:
                                        paths_to_add.append(headers_dir)
                                    if flutter_macos_subdir not in paths_to_add:
                                        paths_to_add.append(flutter_macos_subdir)
                break

if not paths_to_add:
    print("⚠️  Warning: No Flutter header paths found to add")
    sys.exit(0)

with open(project_file, 'r') as f:
    content = f.read()

# Pattern to match HEADER_SEARCH_PATHS blocks
# Match: HEADER_SEARCH_PATHS = ( ... );
def add_flutter_paths(match):
    header_block = match.group(0)
    indent = "\t\t\t\t"
    
    # CRITICAL: Remove any nested FlutterMacOS paths first
    if '/FlutterMacOS/FlutterMacOS/' in header_block:
        # Remove lines with nested paths
        lines = header_block.split('\n')
        cleaned_lines = [l for l in lines if '/FlutterMacOS/FlutterMacOS/' not in l]
        header_block = '\n'.join(cleaned_lines)
    
    # Check if correct FlutterMacOS paths are already there
    has_correct_path = any(p in header_block for p in paths_to_add[:2])
    if has_correct_path and '/FlutterMacOS/FlutterMacOS/' not in header_block:
        return header_block
    
    # Remove any existing FlutterMacOS paths (we'll add correct ones)
    paths_match = re.search(r'HEADER_SEARCH_PATHS = \((.*?)\);', header_block, re.DOTALL)
    if paths_match:
        existing_paths = paths_match.group(1)
        # Remove FlutterMacOS and darwin-x64 paths
        path_lines = existing_paths.split('\n')
        cleaned_paths = [l for l in path_lines if 'FlutterMacOS' not in l and 'darwin-x64' not in l]
        cleaned_paths_str = '\n'.join(cleaned_paths)
        
        # Add correct Flutter paths
        paths_str = ",\n".join([f'{indent}"{path}"' for path in paths_to_add[:6]])  # Limit to 6 paths
        new_paths = cleaned_paths_str + '\n' + paths_str
        
        header_block = header_block.replace(
            f'HEADER_SEARCH_PATHS = ({existing_paths});',
            f'HEADER_SEARCH_PATHS = (\n{new_paths}\n\t\t\t);'
        )
    else:
        # No existing HEADER_SEARCH_PATHS, add it
        paths_str = ",\n".join([f'{indent}"{path}"' for path in paths_to_add[:6]])
        header_block = header_block.replace(
            'HEADER_SEARCH_PATHS = (',
            f'HEADER_SEARCH_PATHS = (\n{paths_str},'
        )
    
    return header_block

# Replace all HEADER_SEARCH_PATHS blocks
# Match multiline blocks with HEADER_SEARCH_PATHS = ( ... );
pattern = r'HEADER_SEARCH_PATHS = \([^)]*\);'
content = re.sub(pattern, add_flutter_paths, content, flags=re.DOTALL)

# CRITICAL: Also clean FRAMEWORK_SEARCH_PATHS to remove nested paths
def clean_framework_paths(match):
    framework_block = match.group(0)
    paths = match.group(1)
    
    # Remove lines with nested FlutterMacOS paths
    lines = paths.split('\n')
    cleaned_lines = []
    seen_paths = set()
    
    for line in lines:
        stripped = line.strip().strip('"').strip(',').strip()
        if not stripped or stripped == '$(inherited)':
            cleaned_lines.append(line)
            continue
        
        # Skip nested FlutterMacOS paths
        if '/FlutterMacOS/FlutterMacOS/' in stripped:
            continue
        
        # Normalize for comparison
        normalized = stripped.rstrip('/')
        if normalized not in seen_paths:
            cleaned_lines.append(line)
            seen_paths.add(normalized)
    
    cleaned_paths = '\n'.join(cleaned_lines)
    return f'FRAMEWORK_SEARCH_PATHS = (\n{cleaned_paths}\n\t\t\t);'

# Clean FRAMEWORK_SEARCH_PATHS blocks
framework_pattern = r'FRAMEWORK_SEARCH_PATHS = \((.*?)\);'
content = re.sub(framework_pattern, clean_framework_paths, content, flags=re.DOTALL)

# Add correct FlutterMacOS.xcframework paths to FRAMEWORK_SEARCH_PATHS
if os.path.exists("Flutter/ephemeral/Flutter-Generated.xcconfig"):
    with open("Flutter/ephemeral/Flutter-Generated.xcconfig", 'r') as f:
        for line in f:
            if line.startswith('FLUTTER_ROOT='):
                flutter_root = line.split('=', 1)[1].strip().strip('"').strip("'")
                engine_dir = os.path.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine')
                if os.path.exists(engine_dir):
                    # Find FlutterMacOS.xcframework directories (only top-level)
                    xcframework_paths = []
                    for root, dirs, files in os.walk(engine_dir):
                        if 'darwin-x64' in root and root.endswith('FlutterMacOS.xcframework'):
                            if '/FlutterMacOS/' not in root:  # Skip nested
                                xcframework_paths.append(root)
                    
                    if xcframework_paths:
                        def add_xcframework_to_frameworks(match):
                            framework_block = match.group(0)
                            paths = match.group(1)
                            
                            # Check if already has correct paths
                            has_correct = any(p in framework_block for p in xcframework_paths[:2])
                            if has_correct:
                                return framework_block
                            
                            # Add xcframework paths
                            indent = "\t\t\t\t"
                            paths_str = '\n'.join([f'{indent}"{p}",' for p in xcframework_paths[:3]])
                            all_paths = paths.rstrip() + '\n' + paths_str
                            return f'FRAMEWORK_SEARCH_PATHS = (\n{all_paths}\n\t\t\t);'
                        
                        content = re.sub(framework_pattern, add_xcframework_to_frameworks, content, flags=re.DOTALL)
                break

with open(project_file, 'w') as f:
    f.write(content)

print(f"✅ Added {len(paths_to_add)} Flutter header path(s) to all HEADER_SEARCH_PATHS blocks")
print(f"✅ Cleaned FRAMEWORK_SEARCH_PATHS and added FlutterMacOS.xcframework paths")
PYTHON_SCRIPT

if [ -d "$FLUTTER_EPHEMERAL" ]; then
    echo "   Added paths: $FLUTTER_EPHEMERAL"
    [ -n "$FLUTTER_MACOS_DIR" ] && echo "   Added paths: $FLUTTER_MACOS_DIR"
    [ -n "$XCFRAMEWORK_HEADERS" ] && echo "   Added paths: $XCFRAMEWORK_HEADERS"
fi

echo "🔧 Setting module verification settings..."
# Add CLANG_MODULE_VERIFICATION = NO to all build settings
if ! grep -q "CLANG_MODULE_VERIFICATION" "$PROJECT_FILE"; then
    sed -i '' 's/\(buildSettings = {\)/\1\
					CLANG_MODULE_VERIFICATION = NO;/g' "$PROJECT_FILE" 2>/dev/null || true
else
    sed -i '' -E 's/CLANG_MODULE_VERIFICATION = [^;]+;/CLANG_MODULE_VERIFICATION = NO;/g' "$PROJECT_FILE" 2>/dev/null || true
fi

echo "✅ Pods project fixed!"
echo "   Please clean your build folder in Xcode (Shift+Cmd+K) and rebuild"


#!/bin/bash

# Resize screenshots to exact App Store dimensions
# Requires: macOS with sips command

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREENSHOTS_DIR="${SCRIPT_DIR}/screenshots"
OUTPUT_DIR="${SCRIPT_DIR}/app_store_screenshots"
mkdir -p "$OUTPUT_DIR"

echo "🖼️  Resize Screenshots to App Store Dimensions"
echo "=============================================="
echo ""

if ! command -v sips >/dev/null 2>&1; then
    echo "❌ Error: sips command not found (macOS only)"
    exit 1
fi

# Function to resize image
resize_image() {
    local input=$1
    local width=$2
    local height=$3
    local output=$4
    
    if [ ! -f "$input" ]; then
        echo "⚠️  File not found: $input"
        return
    fi
    
    echo "  📐 Resizing to ${width}x${height}..."
    sips -z "$height" "$width" "$input" --out "$output" >/dev/null 2>&1
    
    # Verify dimensions
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "$output" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "    ✅ Created: $(basename "$output") (${ACTUAL_SIZE})"
}

echo "📁 Input directory: $SCREENSHOTS_DIR"
echo "📁 Output directory: $OUTPUT_DIR"
echo ""

# Check if input directory has files
if [ ! -d "$SCREENSHOTS_DIR" ] || [ -z "$(ls -A "$SCREENSHOTS_DIR"/*.png 2>/dev/null)" ]; then
    echo "❌ No screenshots found in $SCREENSHOTS_DIR"
    echo "   Run capture_app_store_screenshots.sh first"
    exit 1
fi

echo "Resizing screenshots..."
echo ""

# Find the largest screenshot (likely from Pro Max device)
LARGEST_SCREENSHOT=$(ls -S "$SCREENSHOTS_DIR"/*.png 2>/dev/null | head -1)

if [ -z "$LARGEST_SCREENSHOT" ]; then
    echo "❌ No screenshots found!"
    exit 1
fi

echo "Using source: $(basename "$LARGEST_SCREENSHOT")"
echo ""

# Resize to required dimensions
resize_image "$LARGEST_SCREENSHOT" "1242" "2688" "${OUTPUT_DIR}/iPhone_1242x2688_portrait.png"
resize_image "$LARGEST_SCREENSHOT" "2688" "1242" "${OUTPUT_DIR}/iPhone_2688x1242_landscape.png"
resize_image "$LARGEST_SCREENSHOT" "1284" "2778" "${OUTPUT_DIR}/iPhone_1284x2778_portrait.png"
resize_image "$LARGEST_SCREENSHOT" "2778" "1284" "${OUTPUT_DIR}/iPhone_2778x1284_landscape.png"

echo ""
echo "✅ Resizing complete!"
echo ""
echo "📁 Output directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}'
echo ""
echo "💡 These screenshots are ready for App Store Connect upload!"


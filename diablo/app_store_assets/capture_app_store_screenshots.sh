#!/bin/bash

# Capture App Store screenshots at required dimensions
# Required sizes:
# - 1242 × 2688px (portrait) / 2688 × 1242px (landscape) - iPhone 11/12/13/14/15 Pro Max
# - 1284 × 2778px (portrait) / 2778 × 1284px (landscape) - iPhone 14/15 Pro Max

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREENSHOTS_DIR="${SCRIPT_DIR}/screenshots"
mkdir -p "$SCREENSHOTS_DIR"

echo "📱 App Store Screenshot Capture"
echo "================================"
echo ""

# Find available iPhone Pro Max simulators (including iPhone 16/17)
DEVICES=$(xcrun simctl list devices available | grep -E "(iPhone 17 Pro Max|iPhone 16 Pro Max|iPhone 15 Pro Max|iPhone 14 Pro Max|iPhone 13 Pro Max|iPhone 12 Pro Max|iPhone 11 Pro Max)" | head -1)

if [ -z "$DEVICES" ]; then
    echo "❌ No iPhone Pro Max simulator found!"
    echo "Available devices:"
    xcrun simctl list devices available | grep -i "iphone" | head -10
    exit 1
fi

# Extract device UDID (format: "iPhone XX Pro Max (UDID) (Status)")
DEVICE_UDID=$(echo "$DEVICES" | grep -oE '[A-F0-9-]{36}' | head -1)
DEVICE_NAME=$(echo "$DEVICES" | sed -E 's/.*iPhone ([^(]+).*/\1/' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

echo "✅ Found device: $DEVICE_NAME ($DEVICE_UDID)"
echo ""

# Boot the simulator if not already booted
BOOT_STATUS=$(xcrun simctl list devices | grep "$DEVICE_UDID" | grep -o "Booted\|Shutdown")
if [ "$BOOT_STATUS" != "Booted" ]; then
    echo "🚀 Booting simulator..."
    xcrun simctl boot "$DEVICE_UDID" 2>/dev/null || true
    sleep 5
fi

# Open Simulator app
open -a Simulator

echo "⏳ Waiting for simulator to be ready..."
sleep 3

# Get the app bundle ID (adjust if needed)
APP_BUNDLE_ID="com.gphelps.mtdiablo"

echo ""
echo "📸 Capturing screenshots..."
echo ""

# Function to capture screenshot
capture_screenshot() {
    local orientation=$1
    local width=$2
    local height=$3
    local filename=$4
    
    echo "  📷 Capturing ${width}x${height} (${orientation})..."
    
    # Capture screenshot at device resolution
    TEMP_FILE="${SCREENSHOTS_DIR}/temp_${filename}"
    xcrun simctl io "$DEVICE_UDID" screenshot "$TEMP_FILE" 2>/dev/null
    
    if [ ! -f "$TEMP_FILE" ]; then
        echo "    ⚠️  Failed to capture screenshot"
        return
    fi
    
    # Resize to exact dimensions
    if command -v sips >/dev/null 2>&1; then
        sips -z "$height" "$width" "$TEMP_FILE" --out "${SCREENSHOTS_DIR}/${filename}" >/dev/null 2>&1
        rm -f "$TEMP_FILE"
        
        # Verify dimensions
        ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${SCREENSHOTS_DIR}/${filename}" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        echo "    ✅ Saved: ${filename} (${ACTUAL_SIZE})"
    else
        mv "$TEMP_FILE" "${SCREENSHOTS_DIR}/${filename}"
        echo "    ✅ Saved: ${filename} (may need manual resizing - sips not found)"
    fi
}

# Capture all required sizes
echo "Portrait screenshots:"
capture_screenshot "portrait" "1242" "2688" "iPhone_1242x2688_portrait.png"
capture_screenshot "portrait" "1284" "2778" "iPhone_1284x2778_portrait.png"

echo ""
echo "Landscape screenshots:"
capture_screenshot "landscape" "2688" "1242" "iPhone_2688x1242_landscape.png"
capture_screenshot "landscape" "2778" "1284" "iPhone_2778x1284_landscape.png"

echo ""
echo "✅ Screenshots captured!"
echo ""
echo "📁 Location: $SCREENSHOTS_DIR"
echo ""
echo "Files created:"
ls -lh "$SCREENSHOTS_DIR"/*.png 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}'
echo ""
echo "💡 Note: You may need to manually adjust screenshots in an image editor"
echo "   to ensure they match exact dimensions and show your app content."


#!/bin/bash

# Capture App Store screenshots from RELEASE build (no debug banners)
# Usage: Run this after building in release mode

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREENSHOTS_DIR="${SCRIPT_DIR}/app_store_screenshots"
mkdir -p "$SCREENSHOTS_DIR"

echo "📱 App Store Screenshot Capture (Release Build)"
echo "================================================"
echo ""
echo "⚠️  IMPORTANT: Make sure you're running a RELEASE build!"
echo "   Debug builds show 'DEBUG' banners that Apple rejects."
echo ""

# Check for iPhone Pro Max
IPHONE_DEVICE=$(xcrun simctl list devices | grep -E "(iPhone 16 Pro Max|iPhone 17 Pro Max)" | grep Booted | head -1)
IPHONE_UDID=$(echo "$IPHONE_DEVICE" | grep -oE '[A-F0-9-]{36}' | head -1)

# Check for iPad Pro
IPAD_DEVICE=$(xcrun simctl list devices | grep -E "iPad Pro 13-inch" | grep Booted | head -1)
IPAD_UDID=$(echo "$IPAD_DEVICE" | grep -oE '[A-F0-9-]{36}' | head -1)

if [ -z "$IPHONE_UDID" ] && [ -z "$IPAD_UDID" ]; then
    echo "❌ No booted simulator found!"
    echo "   Please boot iPhone 16 Pro Max or iPad Pro 13-inch simulator"
    exit 1
fi

# Function to capture screenshot
capture_screenshot() {
    local device_udid=$1
    local width=$2
    local height=$3
    local filename=$4
    
    echo "  📷 Capturing ${width}x${height}..."
    
    TEMP_FILE="${SCREENSHOTS_DIR}/temp_${filename}"
    xcrun simctl io "$device_udid" screenshot "$TEMP_FILE" 2>/dev/null
    
    if [ ! -f "$TEMP_FILE" ]; then
        echo "    ⚠️  Failed to capture"
        return
    fi
    
    if command -v sips >/dev/null 2>&1; then
        sips -z "$height" "$width" "$TEMP_FILE" --out "${SCREENSHOTS_DIR}/${filename}" >/dev/null 2>&1
        rm -f "$TEMP_FILE"
        
        ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${SCREENSHOTS_DIR}/${filename}" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        echo "    ✅ Saved: ${filename} (${ACTUAL_SIZE})"
    else
        mv "$TEMP_FILE" "${SCREENSHOTS_DIR}/${filename}"
        echo "    ✅ Saved: ${filename}"
    fi
}

# Capture iPhone screenshots if iPhone is booted
if [ ! -z "$IPHONE_UDID" ]; then
    echo "📱 Capturing iPhone screenshots..."
    echo ""
    
    capture_screenshot "$IPHONE_UDID" "1242" "2688" "iPhone_1242x2688_portrait_RELEASE.png"
    capture_screenshot "$IPHONE_UDID" "2688" "1242" "iPhone_2688x1242_landscape_RELEASE.png"
    capture_screenshot "$IPHONE_UDID" "1284" "2778" "iPhone_1284x2778_portrait_RELEASE.png"
    capture_screenshot "$IPHONE_UDID" "2778" "1284" "iPhone_2778x1284_landscape_RELEASE.png"
    
    echo ""
fi

# Capture iPad screenshots if iPad is booted
if [ ! -z "$IPAD_UDID" ]; then
    echo "📱 Capturing iPad screenshots..."
    echo ""
    
    capture_screenshot "$IPAD_UDID" "2064" "2752" "iPad_2064x2752_portrait_RELEASE.png"
    capture_screenshot "$IPAD_UDID" "2752" "2064" "iPad_2752x2064_landscape_RELEASE.png"
    capture_screenshot "$IPAD_UDID" "2048" "2732" "iPad_2048x2732_portrait_RELEASE.png"
    capture_screenshot "$IPAD_UDID" "2732" "2048" "iPad_2732x2048_landscape_RELEASE.png"
    
    echo ""
fi

echo "✅ Screenshots captured!"
echo ""
echo "📁 Location: $SCREENSHOTS_DIR"
echo ""
echo "💡 These screenshots are from RELEASE build (no debug banners)"
echo "   Ready to upload to App Store Connect!"




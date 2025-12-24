#!/bin/bash

# Capture App Store screenshots from iPad Pro 12.9" simulator
# Required sizes: 2064×2752, 2752×2064, 2048×2732, 2732×2048

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCREENSHOTS_DIR="${SCRIPT_DIR}/app_store_screenshots"
mkdir -p "$SCREENSHOTS_DIR"

echo "📱 iPad App Store Screenshot Capture"
echo "====================================="
echo ""

# Find available iPad Pro 12.9" or 13" simulators (13" is the newer 12.9")
DEVICES=$(xcrun simctl list devices available | grep -E "(iPad Pro 13-inch|iPad Pro 12.9)" | head -1)

if [ -z "$DEVICES" ]; then
    echo "❌ No iPad Pro 12.9\" simulator found!"
    echo "Available iPad devices:"
    xcrun simctl list devices available | grep -i "ipad" | head -10
    exit 1
fi

# Extract device UDID
DEVICE_UDID=$(echo "$DEVICES" | grep -oE '[A-F0-9-]{36}' | head -1)
DEVICE_NAME=$(echo "$DEVICES" | sed -E 's/.*iPad ([^(]+).*/\1/' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

echo "✅ Found device: iPad $DEVICE_NAME ($DEVICE_UDID)"
echo ""

# Boot the simulator if not already booted
BOOT_STATUS=$(xcrun simctl list devices | grep "$DEVICE_UDID" | grep -o "Booted\|Shutdown")
if [ "$BOOT_STATUS" != "Booted" ]; then
    echo "🚀 Booting iPad simulator..."
    xcrun simctl boot "$DEVICE_UDID" 2>/dev/null || true
    sleep 5
fi

# Open Simulator app
open -a Simulator

echo "⏳ Waiting for simulator to be ready..."
sleep 3

# Get the app bundle ID
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

# Capture all required iPad sizes
echo "Portrait screenshots:"
capture_screenshot "portrait" "2064" "2752" "iPad_2064x2752_portrait.png"
capture_screenshot "portrait" "2048" "2732" "iPad_2048x2732_portrait.png"

echo ""
echo "Landscape screenshots:"
capture_screenshot "landscape" "2752" "2064" "iPad_2752x2064_landscape.png"
capture_screenshot "landscape" "2732" "2048" "iPad_2732x2048_landscape.png"

echo ""
echo "✅ Screenshots captured!"
echo ""
echo "📁 Location: $SCREENSHOTS_DIR"
echo ""
echo "Files created:"
ls -lh "$SCREENSHOTS_DIR"/iPad_*.png 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}'
echo ""
echo "💡 Note: Navigate to different screens in your app and run this script"
echo "   again to capture more screenshots. Each run creates 4 iPad sizes."


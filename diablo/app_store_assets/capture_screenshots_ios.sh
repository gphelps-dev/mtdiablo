#!/bin/bash
# Capture iOS App Store Screenshots from Simulator
# This script launches the app in the simulator and captures screenshots

set -e

echo "📸 iOS App Store Screenshot Capture"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCREENSHOT_DIR="app_store_assets/screenshots/ios"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

# Create screenshots directory
mkdir -p "$SCREENSHOT_DIR"

# Device sizes for App Store screenshots
# iPhone 16 Pro Max: 6.9" display (required for 6.7" screenshots)
# iPhone 16 Pro: 6.3" display (required for 6.5" screenshots)  
# iPhone SE (3rd gen): 4.7" display (required for 5.5" screenshots)

echo "📱 Available iPhone simulators:"
xcrun simctl list devices available | grep -i "iphone" | grep -v "unavailable" | head -10

echo ""
echo "🚀 Starting screenshot capture process..."
echo ""

# Function to capture screenshot
capture_screenshot() {
    local device_name="$1"
    local device_id="$2"
    local screenshot_name="$3"
    local output_path="$SCREENSHOT_DIR/$screenshot_name"
    
    echo -e "${BLUE}📸 Capturing $screenshot_name on $device_name...${NC}"
    
    # Boot the simulator if not already booted
    xcrun simctl boot "$device_id" 2>/dev/null || true
    
    # Wait for simulator to be ready
    sleep 3
    
    # Take screenshot
    xcrun simctl io "$device_id" screenshot "$output_path" 2>/dev/null
    
    if [ -f "$output_path" ]; then
        echo -e "${GREEN}✅ Saved: $output_path${NC}"
    else
        echo "❌ Failed to capture $screenshot_name"
    fi
}

# Function to launch app and wait
launch_app() {
    local device_id="$1"
    local bundle_id="com.gphelps.mountdiablo"
    
    echo "🚀 Launching app on simulator..."
    
    # Install and launch the app
    flutter run -d "$device_id" --release &
    FLUTTER_PID=$!
    
    # Wait for app to launch
    echo "⏳ Waiting for app to launch..."
    sleep 10
    
    # Give it a bit more time to fully load
    sleep 5
    
    return $FLUTTER_PID
}

# Main screenshot capture
echo "Step 1: Launching app in simulator..."
echo ""

# Use iPhone 16 Pro Max for 6.7" screenshots (most common)
DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone 16 Pro Max" | grep -o '[A-F0-9-]\{36\}' | head -1)

if [ -z "$DEVICE_ID" ]; then
    echo "❌ iPhone 16 Pro Max not found, trying iPhone 16 Pro..."
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone 16 Pro" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -z "$DEVICE_ID" ]; then
    echo "❌ No suitable iPhone simulator found"
    echo "Please boot a simulator manually and run:"
    echo "  flutter run -d <device-id>"
    exit 1
fi

echo "✅ Using device: $DEVICE_ID"
echo ""

# Boot simulator
echo "📱 Booting simulator..."
xcrun simctl boot "$DEVICE_ID" 2>/dev/null || echo "Simulator already booted"
open -a Simulator

# Wait for simulator to be ready
sleep 5

# Launch the app
echo "🚀 Building and launching app..."
flutter run -d "$DEVICE_ID" --release &
FLUTTER_PID=$!

echo "⏳ Waiting for app to launch (this may take 30-60 seconds)..."
sleep 30

echo ""
echo "📸 App should now be running. Navigate to the screens you want to capture."
echo ""
echo "To capture screenshots manually:"
echo "  1. Navigate to the screen you want"
echo "  2. Press Cmd+S in Simulator to save screenshot"
echo "  3. Or use: xcrun simctl io booted screenshot <filename>.png"
echo ""
echo "Or press Enter when ready to capture current screen..."
read -p "Press Enter to capture current screen: "

# Capture current screen
SCREENSHOT_FILE="$SCREENSHOT_DIR/01-home-screen.png"
xcrun simctl io booted screenshot "$SCREENSHOT_FILE" 2>/dev/null

if [ -f "$SCREENSHOT_FILE" ]; then
    echo "✅ Screenshot saved: $SCREENSHOT_FILE"
else
    echo "❌ Failed to capture screenshot"
fi

echo ""
echo "📋 App Store Screenshot Requirements:"
echo "  - iPhone 6.7\" Display: 1290 x 2796 pixels (iPhone 16 Pro Max)"
echo "  - iPhone 6.5\" Display: 1284 x 2778 pixels (iPhone 16 Pro)"
echo "  - iPhone 5.5\" Display: 1242 x 2208 pixels (iPhone 8 Plus)"
echo ""
echo "💡 Tips:"
echo "  - Navigate through your app to capture different screens"
echo "  - Use Cmd+S in Simulator for quick screenshots"
echo "  - Screenshots are saved to: $SCREENSHOT_DIR"
echo "  - You need at least 3-10 screenshots for App Store submission"

# Cleanup
if [ ! -z "$FLUTTER_PID" ]; then
    echo ""
    echo "Press Ctrl+C to stop the app when done..."
fi


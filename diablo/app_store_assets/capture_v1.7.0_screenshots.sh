#!/bin/bash
# Capture App Store screenshots for v1.7.0
# Captures both iPhone (6.7" Pro Max) and iPad Pro screenshots

set -e

echo "📸 Mt Diablo App v1.7.0 - Screenshot Capture"
echo "============================================="
echo ""

# Create directories
SCREENSHOT_BASE="app_store_assets/1.7.0"
mkdir -p "$SCREENSHOT_BASE/iphone" "$SCREENSHOT_BASE/ipad"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${YELLOW}⚠️  IMPORTANT: This script will launch the app in RELEASE mode${NC}"
echo ""

# Function to capture screenshot
capture_screenshot() {
    local device_id="$1"
    local output_path="$2"
    local screen_name="$3"
    
    echo "${BLUE}📸 Capturing: $screen_name${NC}"
    xcrun simctl io "$device_id" screenshot "$output_path"
    
    if [ -f "$output_path" ]; then
        local width=$(sips -g pixelWidth "$output_path" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        local height=$(sips -g pixelHeight "$output_path" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        echo "${GREEN}   ✅ Saved: $screen_name (${width} × ${height})${NC}"
    else
        echo "   ❌ Failed to capture"
    fi
}

# STEP 1: iPhone Screenshots
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📱 STEP 1: iPhone Pro Max Screenshots"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Find iPhone 16 Pro Max
IPHONE_DEVICE=$(xcrun simctl list devices available | grep "iPhone 16 Pro Max" | grep -o '[A-F0-9-]\{36\}' | head -1)

if [ -z "$IPHONE_DEVICE" ]; then
    echo "${YELLOW}⚠️  iPhone 16 Pro Max not found, using iPhone 16 Pro...${NC}"
    IPHONE_DEVICE=$(xcrun simctl list devices available | grep "iPhone 16 Pro" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -z "$IPHONE_DEVICE" ]; then
    echo "❌ No suitable iPhone device found"
    exit 1
fi

echo "✅ Found device: $IPHONE_DEVICE"
echo ""
echo "🚀 Launching app in RELEASE mode..."
echo "   (This will take 45-60 seconds)"
echo ""

# Boot simulator
xcrun simctl boot "$IPHONE_DEVICE" 2>/dev/null || true
open -a Simulator
sleep 3

# Kill any existing Flutter processes
pkill -f "flutter run" 2>/dev/null || true
sleep 2

# Launch app in release mode
cd "$(dirname "$0")/.."
flutter run -d "$IPHONE_DEVICE" --release &
FLUTTER_PID=$!

echo "⏳ Waiting for app to launch..."
sleep 45

echo ""
echo "${GREEN}✨ App should now be running!${NC}"
echo ""
echo "📸 Time to capture screenshots!"
echo "   Navigate to each screen in the app"
echo "   Type the screen name and press Enter to capture"
echo "   Type 'done' when finished"
echo ""
echo "Suggested screens:"
echo "  1. home"
echo "  2. safety"
echo "  3. weather"
echo "  4. cyclists"
echo "  5. traffic"
echo "  6. trails"
echo ""

SCREEN_NUM=1
while true; do
    echo -n "${BLUE}Screen name (or 'done'): ${NC}"
    read screen_name
    
    if [ "$screen_name" = "done" ]; then
        break
    fi
    
    if [ -z "$screen_name" ]; then
        screen_name="screen-$SCREEN_NUM"
    fi
    
    filename="${SCREEN_NUM}-${screen_name// /-}.png"
    output_path="$SCREENSHOT_BASE/iphone/$filename"
    
    capture_screenshot "$IPHONE_DEVICE" "$output_path" "$screen_name"
    SCREEN_NUM=$((SCREEN_NUM + 1))
    echo ""
done

# Kill flutter
kill $FLUTTER_PID 2>/dev/null || true
sleep 2

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📱 STEP 2: iPad Pro Screenshots"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Find iPad Pro 13-inch
IPAD_DEVICE=$(xcrun simctl list devices available | grep "iPad Pro 13-inch" | grep -o '[A-F0-9-]\{36\}' | head -1)

if [ -z "$IPAD_DEVICE" ]; then
    echo "${YELLOW}⚠️  iPad Pro 13-inch not found, trying 12.9-inch...${NC}"
    IPAD_DEVICE=$(xcrun simctl list devices available | grep "iPad Pro (12.9-inch)" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -z "$IPAD_DEVICE" ]; then
    echo "${YELLOW}⚠️  No iPad Pro found, skipping iPad screenshots${NC}"
    echo "   You can capture iPad screenshots manually later"
else
    echo "✅ Found device: $IPAD_DEVICE"
    echo ""
    echo "🚀 Launching app in RELEASE mode on iPad..."
    echo "   (This will take 45-60 seconds)"
    echo ""
    
    # Boot simulator
    xcrun simctl boot "$IPAD_DEVICE" 2>/dev/null || true
    sleep 3
    
    # Launch app in release mode
    flutter run -d "$IPAD_DEVICE" --release &
    FLUTTER_PID=$!
    
    echo "⏳ Waiting for app to launch..."
    sleep 45
    
    echo ""
    echo "${GREEN}✨ App should now be running on iPad!${NC}"
    echo ""
    echo "📸 Time to capture iPad screenshots!"
    echo ""
    
    SCREEN_NUM=1
    while true; do
        echo -n "${BLUE}Screen name (or 'done'): ${NC}"
        read screen_name
        
        if [ "$screen_name" = "done" ]; then
            break
        fi
        
        if [ -z "$screen_name" ]; then
            screen_name="screen-$SCREEN_NUM"
        fi
        
        filename="${SCREEN_NUM}-${screen_name// /-}.png"
        output_path="$SCREENSHOT_BASE/ipad/$filename"
        
        capture_screenshot "$IPAD_DEVICE" "$output_path" "$screen_name"
        SCREEN_NUM=$((SCREEN_NUM + 1))
        echo ""
    done
    
    # Kill flutter
    kill $FLUTTER_PID 2>/dev/null || true
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "${GREEN}✅ Screenshot Capture Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Screenshots saved in:"
echo "  📱 iPhone: $SCREENSHOT_BASE/iphone/"
echo "  📱 iPad:   $SCREENSHOT_BASE/ipad/"
echo ""
echo "Next steps:"
echo "  1. Review screenshots in the folders"
echo "  2. Upload to App Store Connect"
echo "  3. If needed, resize using: ./resize_screenshots.sh"
echo ""

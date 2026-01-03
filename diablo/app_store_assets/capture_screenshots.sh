#!/bin/bash

# Script to capture screenshots from iOS Simulator for App Store submission
# Usage: ./capture_screenshots.sh

echo "📸 App Store Screenshot Capture Script"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCREENSHOT_DIR="./screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Check if simulator is running
SIMULATOR_ID=$(xcrun simctl list devices | grep "Booted" | grep "iPhone" | head -1 | grep -o '[A-F0-9-]\{36\}')

if [ -z "$SIMULATOR_ID" ]; then
    echo "❌ No booted iPhone simulator found."
    echo "Please launch the app in a simulator first:"
    echo "  flutter run -d 'iPhone 16 Pro Max'"
    exit 1
fi

echo "✅ Found booted simulator: $SIMULATOR_ID"
echo ""
echo "📱 Instructions:"
echo "1. Navigate to the screen you want to capture"
echo "2. Press ENTER to capture screenshot"
echo "3. Type 'done' when finished"
echo ""

SCREEN_NUM=1

while true; do
    echo -n "${BLUE}Screen name (or 'done' to finish): ${NC}"
    read screen_name
    
    if [ "$screen_name" = "done" ]; then
        break
    fi
    
    if [ -z "$screen_name" ]; then
        screen_name="screen-$SCREEN_NUM"
    fi
    
    filename="${SCREEN_NUM}-${screen_name// /-}.png"
    filepath="$SCREENSHOT_DIR/$filename"
    
    echo "📸 Capturing screenshot..."
    xcrun simctl io "$SIMULATOR_ID" screenshot "$filepath"
    
    if [ -f "$filepath" ]; then
        # Get image dimensions
        dimensions=$(sips -g pixelWidth -g pixelHeight "$filepath" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        echo "${GREEN}✅ Saved: $filename ($dimensions)${NC}"
        SCREEN_NUM=$((SCREEN_NUM + 1))
    else
        echo "❌ Failed to capture screenshot"
    fi
    
    echo ""
done

echo ""
echo "${GREEN}✨ Screenshot capture complete!${NC}"
echo "Screenshots saved in: $SCREENSHOT_DIR"
echo ""
echo "Next steps:"
echo "1. Review screenshots in the folder"
echo "2. Rename them descriptively if needed"
echo "3. Upload to App Store Connect"




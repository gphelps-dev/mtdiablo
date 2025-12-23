#!/bin/bash
# Capture screenshots at all required App Store sizes
# This script captures screenshots in both 6.5" and 6.1" display sizes

set -e

echo "📸 App Store Screenshot Capture - All Required Sizes"
echo "====================================================="
echo ""

SCREENSHOT_DIR="app_store_assets/screenshots/ios"
mkdir -p "$SCREENSHOT_DIR"

# Function to capture screenshot and verify size
capture_and_verify() {
    local device_id="$1"
    local device_name="$2"
    local expected_width="$3"
    local expected_height="$4"
    local filename="$5"
    
    echo "📸 Capturing on $device_name..."
    
    # Boot simulator
    xcrun simctl boot "$device_id" 2>/dev/null || true
    sleep 2
    
    # Take screenshot
    local output_path="$SCREENSHOT_DIR/$filename"
    xcrun simctl io "$device_id" screenshot "$output_path" 2>/dev/null
    
    if [ -f "$output_path" ]; then
        # Get actual dimensions
        local actual_width=$(sips -g pixelWidth "$output_path" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        local actual_height=$(sips -g pixelHeight "$output_path" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        
        echo "   Size: ${actual_width} × ${actual_height}"
        
        # Check if dimensions match (allow small variance)
        if [ "$actual_width" = "$expected_width" ] && [ "$actual_height" = "$expected_height" ]; then
            echo "   ✅ Perfect match!"
        else
            echo "   ⚠️  Size mismatch - expected ${expected_width} × ${expected_height}"
            echo "   Resizing..."
            sips -z "$expected_height" "$expected_width" "$output_path" --out "$output_path" 2>/dev/null
            echo "   ✅ Resized to ${expected_width} × ${expected_height}"
        fi
    else
        echo "   ❌ Failed to capture"
    fi
}

echo "📱 Step 1: Capturing 6.1\" Display Screenshots (1284 × 2778)"
echo "-----------------------------------------------------------"

# Find iPhone 16 Pro (or similar) for 6.1" display
DEVICE_61=$(xcrun simctl list devices available | grep "iPhone 16 Pro" | grep -o '[A-F0-9-]\{36\}' | head -1)

if [ -z "$DEVICE_61" ]; then
    DEVICE_61=$(xcrun simctl list devices available | grep "iPhone 15 Pro" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -z "$DEVICE_61" ]; then
    DEVICE_61=$(xcrun simctl list devices available | grep "iPhone 14 Pro" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -n "$DEVICE_61" ]; then
    echo "✅ Found device for 6.1\" display"
    echo ""
    echo "🚀 Launching app on iPhone 16 Pro..."
    echo "   (This will take 30-60 seconds)"
    echo ""
    
    # Boot and launch app
    xcrun simctl boot "$DEVICE_61" 2>/dev/null || true
    open -a Simulator
    sleep 3
    
    # Launch app in background
    flutter run -d "$DEVICE_61" --release > /dev/null 2>&1 &
    FLUTTER_PID=$!
    
    echo "⏳ Waiting for app to launch..."
    sleep 30
    
    echo ""
    echo "📸 Ready to capture 6.1\" screenshots!"
    echo "   Navigate to each screen, then press Enter to capture"
    echo ""
    
    SCREEN_NUM=1
    while true; do
        echo -n "Screen name (or 'done' to finish): "
        read screen_name
        
        if [ "$screen_name" = "done" ]; then
            break
        fi
        
        if [ -z "$screen_name" ]; then
            screen_name="screen-$SCREEN_NUM"
        fi
        
        filename="61-${SCREEN_NUM}-${screen_name// /-}-1284x2778.png"
        capture_and_verify "$DEVICE_61" "iPhone 16 Pro" 1284 2778 "$filename"
        SCREEN_NUM=$((SCREEN_NUM + 1))
        echo ""
    done
    
    # Kill flutter process
    kill $FLUTTER_PID 2>/dev/null || true
else
    echo "❌ No suitable device found for 6.1\" display"
fi

echo ""
echo "📱 Step 2: Capturing 6.5\" Display Screenshots (1242 × 2688)"
echo "-----------------------------------------------------------"

# Find iPhone 11 Pro Max or XS Max for 6.5" display
DEVICE_65=$(xcrun simctl list devices available | grep "iPhone 11 Pro Max" | grep -o '[A-F0-9-]\{36\}' | head -1)

if [ -z "$DEVICE_65" ]; then
    DEVICE_65=$(xcrun simctl list devices available | grep "iPhone XS Max" | grep -o '[A-F0-9-]\{36\}' | head -1)
fi

if [ -n "$DEVICE_65" ]; then
    echo "✅ Found device for 6.5\" display"
    echo ""
    echo "🚀 Launching app on iPhone 11 Pro Max..."
    echo "   (This will take 30-60 seconds)"
    echo ""
    
    # Boot and launch app
    xcrun simctl boot "$DEVICE_65" 2>/dev/null || true
    sleep 3
    
    # Launch app in background
    flutter run -d "$DEVICE_65" --release > /dev/null 2>&1 &
    FLUTTER_PID=$!
    
    echo "⏳ Waiting for app to launch..."
    sleep 30
    
    echo ""
    echo "📸 Ready to capture 6.5\" screenshots!"
    echo "   Navigate to each screen, then press Enter to capture"
    echo ""
    
    SCREEN_NUM=1
    while true; do
        echo -n "Screen name (or 'done' to finish): "
        read screen_name
        
        if [ "$screen_name" = "done" ]; then
            break
        fi
        
        if [ -z "$screen_name" ]; then
            screen_name="screen-$SCREEN_NUM"
        fi
        
        filename="65-${SCREEN_NUM}-${screen_name// /-}-1242x2688.png"
        capture_and_verify "$DEVICE_65" "iPhone 11 Pro Max" 1242 2688 "$filename"
        SCREEN_NUM=$((SCREEN_NUM + 1))
        echo ""
    done
    
    # Kill flutter process
    kill $FLUTTER_PID 2>/dev/null || true
else
    echo "⚠️  iPhone 11 Pro Max or XS Max not found"
    echo "   You can resize 6.1\" screenshots to 6.5\" size instead"
fi

echo ""
echo "✅ Screenshot capture complete!"
echo "Screenshots saved in: $SCREENSHOT_DIR"
echo ""
echo "Summary:"
echo "  - 6.1\" Display (1284 × 2778): Files starting with '61-'"
echo "  - 6.5\" Display (1242 × 2688): Files starting with '65-'"
echo ""
echo "For landscape screenshots, rotate your device in simulator"
echo "or use image editing software to rotate the portrait screenshots."


#!/bin/bash

# Resize iPad screenshots to ALL required App Store dimensions
# Creates: 2064×2752, 2752×2064, 2048×2732, 2732×2048

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANUAL_DIR="${SCRIPT_DIR}/manual_screenshots"
OUTPUT_DIR="${SCRIPT_DIR}/app_store_screenshots"

mkdir -p "$OUTPUT_DIR"

if [ ! -d "$MANUAL_DIR" ]; then
    echo "❌ Directory not found: $MANUAL_DIR"
    exit 1
fi

echo "📐 Resizing iPad Screenshots to All App Store Dimensions"
echo "========================================================"
echo ""

cd "$MANUAL_DIR"

PNG_COUNT=$(find . -maxdepth 1 -name "*.png" -o -name "*.PNG" | wc -l | tr -d ' ')

if [ "$PNG_COUNT" -eq 0 ]; then
    echo "❌ No PNG files found"
    exit 1
fi

echo "Found $PNG_COUNT screenshot(s)"
echo ""

COUNTER=1
for file in *.png *.PNG; do
    [ -f "$file" ] || continue
    
    FILENAME=$(basename "$file" .png | sed 's/\.PNG$//')
    
    echo "📷 Processing: $file"
    
    # Get original dimensions
    ORIG_WIDTH=$(sips -g pixelWidth "$file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    ORIG_HEIGHT=$(sips -g pixelHeight "$file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
    
    if [ -z "$ORIG_WIDTH" ] || [ -z "$ORIG_HEIGHT" ]; then
        echo "   ⚠️  Could not read dimensions, skipping..."
        continue
    fi
    
    echo "   Original: ${ORIG_WIDTH}x${ORIG_HEIGHT}"
    echo ""
    
    # Create all 4 required sizes
    echo "   → Creating 2064×2752 (portrait)..."
    sips -z 2752 2064 "$file" --out "${OUTPUT_DIR}/iPad_2064x2752_portrait_${COUNTER}.png" >/dev/null 2>&1
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${OUTPUT_DIR}/iPad_2064x2752_portrait_${COUNTER}.png" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "      ✅ iPad_2064x2752_portrait_${COUNTER}.png (${ACTUAL_SIZE})"
    
    echo "   → Creating 2752×2064 (landscape)..."
    sips -z 2064 2752 "$file" --out "${OUTPUT_DIR}/iPad_2752x2064_landscape_${COUNTER}.png" >/dev/null 2>&1
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${OUTPUT_DIR}/iPad_2752x2064_landscape_${COUNTER}.png" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "      ✅ iPad_2752x2064_landscape_${COUNTER}.png (${ACTUAL_SIZE})"
    
    echo "   → Creating 2048×2732 (portrait)..."
    sips -z 2732 2048 "$file" --out "${OUTPUT_DIR}/iPad_2048x2732_portrait_${COUNTER}.png" >/dev/null 2>&1
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${OUTPUT_DIR}/iPad_2048x2732_portrait_${COUNTER}.png" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "      ✅ iPad_2048x2732_portrait_${COUNTER}.png (${ACTUAL_SIZE})"
    
    echo "   → Creating 2732×2048 (landscape)..."
    sips -z 2048 2732 "$file" --out "${OUTPUT_DIR}/iPad_2732x2048_landscape_${COUNTER}.png" >/dev/null 2>&1
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "${OUTPUT_DIR}/iPad_2732x2048_landscape_${COUNTER}.png" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "      ✅ iPad_2732x2048_landscape_${COUNTER}.png (${ACTUAL_SIZE})"
    
    echo ""
    COUNTER=$((COUNTER + 1))
done

echo "✅ All iPad screenshots resized!"
echo ""
echo "📁 Output location: $OUTPUT_DIR"
echo ""
echo "📋 Created sizes for each screenshot:"
echo "   • 2064 × 2752px (portrait)"
echo "   • 2752 × 2064px (landscape)"
echo "   • 2048 × 2732px (portrait)"
echo "   • 2732 × 2048px (landscape)"
echo ""
echo "💡 Ready to upload to App Store Connect!"




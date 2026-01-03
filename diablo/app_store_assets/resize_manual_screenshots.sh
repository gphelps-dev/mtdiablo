#!/bin/bash

# Resize manually captured screenshots to App Store dimensions
# Usage: Place your screenshots in a folder, then run this script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/app_store_screenshots"
mkdir -p "$OUTPUT_DIR"

echo "📐 Resize Screenshots to App Store Dimensions"
echo "=============================================="
echo ""

# Check if input directory or files provided
INPUT_DIR="${1:-${SCRIPT_DIR}/manual_screenshots}"

if [ ! -d "$INPUT_DIR" ] && [ -z "$1" ]; then
    echo "📁 Creating input directory: $INPUT_DIR"
    mkdir -p "$INPUT_DIR"
    echo ""
    echo "💡 Instructions:"
    echo "   1. Capture screenshots from Simulator (⌘+S or File > Save Screen)"
    echo "   2. Save them to: $INPUT_DIR"
    echo "   3. Run this script again: ./resize_manual_screenshots.sh"
    echo ""
    exit 0
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "❌ Directory not found: $INPUT_DIR"
    exit 1
fi

# App Store required dimensions
declare -a DIMENSIONS=(
    "1242:2688:iPhone_1242x2688_portrait"
    "2688:1242:iPhone_2688x1242_landscape"
    "1284:2778:iPhone_1284x2778_portrait"
    "2778:1284:iPhone_2778x1284_landscape"
    "2064:2752:iPad_2064x2752_portrait"
    "2752:2064:iPad_2752x2064_landscape"
    "2048:2732:iPad_2048x2732_portrait"
    "2732:2048:iPad_2732x2048_landscape"
)

echo "📸 Processing screenshots from: $INPUT_DIR"
echo ""

# Count PNG files
PNG_COUNT=$(find "$INPUT_DIR" -maxdepth 1 -name "*.png" -o -name "*.PNG" | wc -l | tr -d ' ')

if [ "$PNG_COUNT" -eq 0 ]; then
    echo "❌ No PNG files found in $INPUT_DIR"
    echo ""
    echo "💡 To capture screenshots manually:"
    echo "   1. Open Simulator"
    echo "   2. Navigate to the screen you want"
    echo "   3. Press ⌘+S (or File > Save Screen)"
    echo "   4. Save to: $INPUT_DIR"
    exit 1
fi

echo "Found $PNG_COUNT screenshot(s)"
echo ""

# Process each screenshot
COUNTER=1
for file in "$INPUT_DIR"/*.png "$INPUT_DIR"/*.PNG; do
    [ -f "$file" ] || continue
    
    FILENAME=$(basename "$file")
    echo "📷 Processing: $FILENAME"
    
    # Get original dimensions
    ORIG_WIDTH=$(sips -g pixelWidth "$file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    ORIG_HEIGHT=$(sips -g pixelHeight "$file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
    
    if [ -z "$ORIG_WIDTH" ] || [ -z "$ORIG_HEIGHT" ]; then
        echo "   ⚠️  Could not read dimensions, skipping..."
        continue
    fi
    
    echo "   Original: ${ORIG_WIDTH}x${ORIG_HEIGHT}"
    
    # Determine if portrait or landscape
    if [ "$ORIG_HEIGHT" -gt "$ORIG_WIDTH" ]; then
        ORIENTATION="portrait"
    else
        ORIENTATION="landscape"
    fi
    
    # Create all required sizes from this screenshot
    for dim_spec in "${DIMENSIONS[@]}"; do
        IFS=':' read -r WIDTH HEIGHT PREFIX <<< "$dim_spec"
        
        # Determine orientation for this dimension
        if [ "$HEIGHT" -gt "$WIDTH" ]; then
            DIM_ORIENTATION="portrait"
        else
            DIM_ORIENTATION="landscape"
        fi
        
        # Only resize if orientation matches (or create both if user wants)
        OUTPUT_FILE="${OUTPUT_DIR}/${PREFIX}_${COUNTER}.png"
        
        echo "   → Resizing to ${WIDTH}x${HEIGHT}..."
        sips -z "$HEIGHT" "$WIDTH" "$file" --out "$OUTPUT_FILE" >/dev/null 2>&1
        
        # Verify
        ACTUAL_WIDTH=$(sips -g pixelWidth "$OUTPUT_FILE" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        ACTUAL_HEIGHT=$(sips -g pixelHeight "$OUTPUT_FILE" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        
        if [ "$ACTUAL_WIDTH" = "$WIDTH" ] && [ "$ACTUAL_HEIGHT" = "$HEIGHT" ]; then
            echo "      ✅ Saved: $(basename "$OUTPUT_FILE") (${ACTUAL_WIDTH}x${ACTUAL_HEIGHT})"
        else
            echo "      ⚠️  Size mismatch: expected ${WIDTH}x${HEIGHT}, got ${ACTUAL_WIDTH}x${ACTUAL_HEIGHT}"
        fi
    done
    
    echo ""
    COUNTER=$((COUNTER + 1))
done

echo "✅ All screenshots resized!"
echo ""
echo "📁 Output location: $OUTPUT_DIR"
echo ""
echo "📋 App Store Required Dimensions:"
echo "   iPhone:"
echo "     • 1242 × 2688px (portrait)"
echo "     • 2688 × 1242px (landscape)"
echo "     • 1284 × 2778px (portrait)"
echo "     • 2778 × 1284px (landscape)"
echo ""
echo "   iPad:"
echo "     • 2064 × 2752px (portrait)"
echo "     • 2752 × 2064px (landscape)"
echo "     • 2048 × 2732px (portrait)"
echo "     • 2732 × 2048px (landscape)"
echo ""
echo "💡 Tip: Upload the ones that match your app's orientation!"


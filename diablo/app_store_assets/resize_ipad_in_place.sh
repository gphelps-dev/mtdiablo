#!/bin/bash

# Resize iPad screenshots in place (overwrite originals)
# Usage: Run from the manual_screenshots folder or specify path

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANUAL_DIR="${SCRIPT_DIR}/manual_screenshots"

if [ ! -d "$MANUAL_DIR" ]; then
    echo "❌ Directory not found: $MANUAL_DIR"
    exit 1
fi

echo "📐 Resizing iPad Screenshots (in place)"
echo "========================================"
echo ""

cd "$MANUAL_DIR"

PNG_COUNT=$(find . -maxdepth 1 -name "*.png" -o -name "*.PNG" | wc -l | tr -d ' ')

if [ "$PNG_COUNT" -eq 0 ]; then
    echo "❌ No PNG files found"
    exit 1
fi

echo "Found $PNG_COUNT screenshot(s)"
echo ""

for file in *.png *.PNG; do
    [ -f "$file" ] || continue
    
    FILENAME="$file"
    TEMP_FILE="${FILENAME}.tmp"
    
    echo "📷 Processing: $FILENAME"
    
    # Get original dimensions
    ORIG_WIDTH=$(sips -g pixelWidth "$file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    ORIG_HEIGHT=$(sips -g pixelHeight "$file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
    
    if [ -z "$ORIG_WIDTH" ] || [ -z "$ORIG_HEIGHT" ]; then
        echo "   ⚠️  Could not read dimensions, skipping..."
        continue
    fi
    
    echo "   Original: ${ORIG_WIDTH}x${ORIG_HEIGHT}"
    
    # Determine orientation and resize accordingly
    if [ "$ORIG_HEIGHT" -gt "$ORIG_WIDTH" ]; then
        # Portrait - resize to 2064x2752
        echo "   → Resizing to iPad portrait (2064x2752)..."
        sips -z 2752 2064 "$file" --out "$TEMP_FILE" >/dev/null 2>&1
        
        # Verify size
        NEW_WIDTH=$(sips -g pixelWidth "$TEMP_FILE" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        NEW_HEIGHT=$(sips -g pixelHeight "$TEMP_FILE" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        
        if [ "$NEW_WIDTH" = "2064" ] && [ "$NEW_HEIGHT" = "2752" ]; then
            mv "$TEMP_FILE" "$file"
            echo "   ✅ Resized: $FILENAME (${NEW_WIDTH}x${NEW_HEIGHT})"
        else
            rm -f "$TEMP_FILE"
            echo "   ⚠️  Size mismatch, keeping original"
        fi
    else
        # Landscape - resize to 2752x2064
        echo "   → Resizing to iPad landscape (2752x2064)..."
        sips -z 2064 2752 "$file" --out "$TEMP_FILE" >/dev/null 2>&1
        
        # Verify size
        NEW_WIDTH=$(sips -g pixelWidth "$TEMP_FILE" 2>/dev/null | grep pixelWidth | awk '{print $2}')
        NEW_HEIGHT=$(sips -g pixelHeight "$TEMP_FILE" 2>/dev/null | grep pixelHeight | awk '{print $2}')
        
        if [ "$NEW_WIDTH" = "2752" ] && [ "$NEW_HEIGHT" = "2064" ]; then
            mv "$TEMP_FILE" "$file"
            echo "   ✅ Resized: $FILENAME (${NEW_WIDTH}x${NEW_HEIGHT})"
        else
            rm -f "$TEMP_FILE"
            echo "   ⚠️  Size mismatch, keeping original"
        fi
    fi
    
    echo ""
done

echo "✅ All iPad screenshots resized!"
echo ""
echo "📁 Location: $MANUAL_DIR"
echo ""
echo "💡 Screenshots have been resized to App Store iPad dimensions:"
echo "   • Portrait: 2064 × 2752px"
echo "   • Landscape: 2752 × 2064px"




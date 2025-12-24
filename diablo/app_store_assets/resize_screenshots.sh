#!/bin/bash
# Resize screenshots to exact App Store dimensions
# Usage: ./resize_screenshots.sh <input-file> [output-file]

set -e

if [ -z "$1" ]; then
    echo "Usage: ./resize_screenshots.sh <input-file> [output-file]"
    echo ""
    echo "Or resize all screenshots in current directory:"
    echo "  for file in *.png; do ./resize_screenshots.sh \"\$file\"; done"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.*}-resized.png}"

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ File not found: $INPUT_FILE"
    exit 1
fi

echo "📐 Resizing screenshot: $INPUT_FILE"
echo ""

# Get current dimensions
CURRENT_WIDTH=$(sips -g pixelWidth "$INPUT_FILE" 2>/dev/null | grep pixelWidth | awk '{print $2}')
CURRENT_HEIGHT=$(sips -g pixelHeight "$INPUT_FILE" 2>/dev/null | grep pixelHeight | awk '{print $2}')

echo "Current size: ${CURRENT_WIDTH} × ${CURRENT_HEIGHT}"
echo ""

# Determine target size based on current dimensions
if [ "$CURRENT_WIDTH" -lt "$CURRENT_HEIGHT" ]; then
    # Portrait
    echo "Detected: Portrait orientation"
    echo ""
    echo "Choose target size:"
    echo "  1) 1284 × 2778 (6.1\" Display - iPhone 16 Pro)"
    echo "  2) 1242 × 2688 (6.5\" Display - iPhone 11 Pro Max)"
    echo ""
    read -p "Enter choice (1 or 2): " choice
    
    case $choice in
        1)
            TARGET_WIDTH=1284
            TARGET_HEIGHT=2778
            SUFFIX="1284x2778"
            ;;
        2)
            TARGET_WIDTH=1242
            TARGET_HEIGHT=2688
            SUFFIX="1242x2688"
            ;;
        *)
            echo "Invalid choice, using 1284 × 2778"
            TARGET_WIDTH=1284
            TARGET_HEIGHT=2778
            SUFFIX="1284x2778"
            ;;
    esac
else
    # Landscape
    echo "Detected: Landscape orientation"
    echo ""
    echo "Choose target size:"
    echo "  1) 2778 × 1284 (6.1\" Display - iPhone 16 Pro)"
    echo "  2) 2688 × 1242 (6.5\" Display - iPhone 11 Pro Max)"
    echo ""
    read -p "Enter choice (1 or 2): " choice
    
    case $choice in
        1)
            TARGET_WIDTH=2778
            TARGET_HEIGHT=1284
            SUFFIX="2778x1284"
            ;;
        2)
            TARGET_WIDTH=2688
            TARGET_HEIGHT=1242
            SUFFIX="2688x1242"
            ;;
        *)
            echo "Invalid choice, using 2778 × 1284"
            TARGET_WIDTH=2778
            TARGET_HEIGHT=1284
            SUFFIX="2778x1284"
            ;;
    esac
fi

# Create output filename with size suffix
OUTPUT_FILE="${INPUT_FILE%.*}-${SUFFIX}.png"

echo ""
echo "Resizing to: ${TARGET_WIDTH} × ${TARGET_HEIGHT}..."
sips -z "$TARGET_HEIGHT" "$TARGET_WIDTH" "$INPUT_FILE" --out "$OUTPUT_FILE" 2>/dev/null

if [ -f "$OUTPUT_FILE" ]; then
    NEW_WIDTH=$(sips -g pixelWidth "$OUTPUT_FILE" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    NEW_HEIGHT=$(sips -g pixelHeight "$OUTPUT_FILE" 2>/dev/null | grep pixelHeight | awk '{print $2}')
    echo "✅ Resized successfully!"
    echo "   Output: $OUTPUT_FILE"
    echo "   Size: ${NEW_WIDTH} × ${NEW_HEIGHT}"
else
    echo "❌ Failed to resize"
    exit 1
fi


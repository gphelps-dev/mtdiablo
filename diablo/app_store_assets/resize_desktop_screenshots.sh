#!/bin/bash

# Resize screenshots from Desktop to App Store dimensions
# Required sizes: 1242×2688, 2688×1242, 1284×2778, 2778×1284

set -e

DESKTOP_DIR="$HOME/Desktop"
OUTPUT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/app_store_screenshots"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$OUTPUT_DIR"

echo "🖼️  Resize Desktop Screenshots to App Store Dimensions"
echo "======================================================"
echo ""

if ! command -v sips >/dev/null 2>&1; then
    echo "❌ Error: sips command not found (macOS only)"
    exit 1
fi

# Find PNG files on Desktop (handle spaces in filenames)
IFS=$'\n' PNG_FILES=($(find "$DESKTOP_DIR" -maxdepth 1 -name "*.png" -type f 2>/dev/null | sort))

if [ ${#PNG_FILES[@]} -eq 0 ]; then
    echo "❌ No PNG files found on Desktop"
    echo "   Please place your screenshot files on the Desktop first"
    exit 1
fi

echo "📁 Found ${#PNG_FILES[@]} PNG file(s) on Desktop:"
for file in "${PNG_FILES[@]}"; do
    echo "  - $(basename "$file")"
done
echo ""

# Function to resize image
resize_image() {
    local input=$1
    local width=$2
    local height=$3
    local output=$4
    local basename_input=$(basename "$input" .png)
    
    echo "  📐 Resizing $(basename "$input") to ${width}x${height}..."
    
    # Resize using sips
    sips -z "$height" "$width" "$input" --out "$output" >/dev/null 2>&1
    
    if [ ! -f "$output" ]; then
        echo "    ⚠️  Failed to resize"
        return 1
    fi
    
    # Verify dimensions
    ACTUAL_SIZE=$(sips -g pixelWidth -g pixelHeight "$output" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    FILE_SIZE=$(ls -lh "$output" | awk '{print $5}')
    echo "    ✅ Created: $(basename "$output") (${ACTUAL_SIZE}, ${FILE_SIZE})"
}

echo "🔄 Processing screenshots..."
echo ""

# Process each PNG file
for input_file in "${PNG_FILES[@]}"; do
    BASENAME=$(basename "$input_file" .png)
    
    echo "📸 Processing: $(basename "$input_file")"
    
    # Create all 4 required sizes for each input file
    resize_image "$input_file" "1242" "2688" "${OUTPUT_DIR}/${BASENAME}_1242x2688_portrait.png"
    resize_image "$input_file" "2688" "1242" "${OUTPUT_DIR}/${BASENAME}_2688x1242_landscape.png"
    resize_image "$input_file" "1284" "2778" "${OUTPUT_DIR}/${BASENAME}_1284x2778_portrait.png"
    resize_image "$input_file" "2778" "1284" "${OUTPUT_DIR}/${BASENAME}_2778x1284_landscape.png"
    
    echo ""
done

echo "✅ Resizing complete!"
echo ""
echo "📁 Output directory: $OUTPUT_DIR"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null | awk '{printf "  %-50s %6s\n", $9, $5}' || echo "  (no files found)"
echo ""
echo "💡 These screenshots are ready for App Store Connect upload!"
echo ""
echo "📋 Required dimensions created:"
echo "  ✅ 1242 × 2688px (portrait)"
echo "  ✅ 2688 × 1242px (landscape)"
echo "  ✅ 1284 × 2778px (portrait)"
echo "  ✅ 2778 × 1284px (landscape)"


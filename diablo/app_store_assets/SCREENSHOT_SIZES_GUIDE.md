# App Store Screenshot Size Guide

## Required Screenshot Dimensions

Apple requires screenshots in these specific sizes:

### iPhone 6.5" Display
- **Portrait**: 1242 × 2688 pixels
- **Landscape**: 2688 × 1242 pixels

### iPhone 6.1" Display  
- **Portrait**: 1284 × 2778 pixels
- **Landscape**: 2778 × 1284 pixels

## Which Simulators Produce These Sizes?

### For 1242 × 2688 (6.5" Display)
- **iPhone 11 Pro Max** (6.5" display) ✅ Perfect match
- **iPhone XS Max** (6.5" display) ✅ Perfect match
- **iPhone 8 Plus** (5.5" display) - Produces 1242 × 2208 (different size)

### For 1284 × 2778 (6.1" Display)
- **iPhone 16 Pro** (6.3" display) ✅ Produces 1284 × 2778
- **iPhone 15 Pro** (6.1" display) ✅ Produces 1284 × 2778
- **iPhone 14 Pro** (6.1" display) ✅ Produces 1284 × 2778
- **iPhone 13 Pro** (6.1" display) ✅ Produces 1284 × 2778

## How to Capture Screenshots

### Method 1: Use the Correct Simulator

**For 1242 × 2688 (6.5" Display):**
```bash
# Launch iPhone 11 Pro Max or XS Max
flutter run -d "iPhone 11 Pro Max"
# Then press Cmd+S in Simulator
```

**For 1284 × 2778 (6.1" Display):**
```bash
# Launch iPhone 16 Pro (or 15 Pro, 14 Pro, 13 Pro)
flutter run -d "iPhone 16 Pro"
# Then press Cmd+S in Simulator
```

### Method 2: Resize Existing Screenshots

If you already have screenshots, you can resize them:

```bash
# Resize to 1242 × 2688 (6.5" portrait)
sips -z 2688 1242 input.png --out output-1242x2688.png

# Resize to 1284 × 2778 (6.1" portrait)
sips -z 2778 1284 input.png --out output-1284x2778.png

# Resize to 2688 × 1242 (6.5" landscape)
sips -z 1242 2688 input.png --out output-2688x1242.png

# Resize to 2778 × 1284 (6.1" landscape)
sips -z 1284 2778 input.png --out output-2778x1284.png
```

### Method 3: Use ImageMagick (if installed)

```bash
# Install ImageMagick: brew install imagemagick

# Resize to 1242 × 2688
convert input.png -resize 1242x2688! output-1242x2688.png

# Resize to 1284 × 2778
convert input.png -resize 1284x2778! output-1284x2778.png
```

## Quick Capture Script

I'll create a script that captures screenshots at the correct sizes automatically.




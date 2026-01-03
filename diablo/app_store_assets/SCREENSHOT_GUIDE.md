# 📸 How to Capture App Store Screenshots Manually

## Quick Method: Using the Script

1. **Capture screenshots from Simulator:**
   - Open your app in Simulator (make sure it's a **RELEASE build** - no debug banners!)
   - Navigate to the screen you want
   - Press **⌘+S** (or go to **File > Save Screen**)
   - Save to: `diablo/app_store_assets/manual_screenshots/`

2. **Resize to App Store dimensions:**
   ```bash
   ./diablo/app_store_assets/resize_manual_screenshots.sh
   ```

3. **Find your resized screenshots:**
   - Location: `diablo/app_store_assets/app_store_screenshots/`
   - Upload to App Store Connect!

---

## Manual Method: Using Simulator + Preview

### Step 1: Capture Screenshot
1. Open Simulator with your app running (RELEASE build)
2. Navigate to the screen you want
3. Press **⌘+S** or go to **File > Save Screen**
4. Save the screenshot

### Step 2: Resize Using Preview (macOS)
1. Open the screenshot in **Preview**
2. Go to **Tools > Adjust Size...**
3. Uncheck "Scale proportionally" (if you need exact dimensions)
4. Enter the dimensions:
   - **iPhone Portrait:** 1242 × 2688 pixels
   - **iPhone Landscape:** 2688 × 1242 pixels
   - **iPad Portrait:** 2064 × 2752 pixels
   - **iPad Landscape:** 2752 × 2064 pixels
5. Click **OK**
6. Save the resized image

### Step 3: Using Command Line (sips)
```bash
# Resize a screenshot to iPhone portrait (1242x2688)
sips -z 2688 1242 input.png --out iPhone_1242x2688.png

# Resize to iPhone landscape (2688x1242)
sips -z 1242 2688 input.png --out iPhone_2688x1242.png

# Resize to iPad portrait (2064x2752)
sips -z 2752 2064 input.png --out iPad_2064x2752.png

# Resize to iPad landscape (2752x2064)
sips -z 2064 2752 input.png --out iPad_2752x2064.png
```

---

## Required App Store Dimensions

### iPhone Screenshots
- **1242 × 2688px** (portrait) - iPhone 14 Pro Max, 15 Pro Max, 16 Pro Max
- **2688 × 1242px** (landscape)
- **1284 × 2778px** (portrait) - iPhone 14 Pro, 15 Pro, 16 Pro
- **2778 × 1284px** (landscape)

### iPad Screenshots
- **2064 × 2752px** (portrait) - iPad Pro 12.9"
- **2752 × 2064px** (landscape)
- **2048 × 2732px** (portrait) - iPad Pro 12.9" (alternative)
- **2732 × 2048px** (landscape)

---

## Important Notes

⚠️ **Always use RELEASE builds** - Debug builds show "DEBUG" banners that Apple will reject!

✅ **Tips:**
- Capture screenshots at the device's native resolution first
- Then resize to exact App Store dimensions
- Make sure screenshots show your app's best features
- Use consistent screenshots across all sizes

---

## Quick Reference Commands

```bash
# Create manual screenshots folder
mkdir -p diablo/app_store_assets/manual_screenshots

# Resize all screenshots in manual_screenshots folder
./diablo/app_store_assets/resize_manual_screenshots.sh

# View resized screenshots
open diablo/app_store_assets/app_store_screenshots/
```




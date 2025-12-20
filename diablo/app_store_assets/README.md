# App Store Assets

This folder contains screenshots and app previews for App Store submission.

## Required Screenshots

Apple requires screenshots for each device size you support. For iPhone apps, you typically need:

### iPhone 6.7" Display (iPhone 14 Pro Max, 15 Pro Max, etc.)
- **Portrait**: 1290 × 2796 pixels
- **Landscape**: 2796 × 1290 pixels

### iPhone 6.5" Display (iPhone 11 Pro Max, etc.)
- **Portrait**: 1242 × 2688 pixels
- **Landscape**: 2688 × 1242 pixels

### iPhone 6.1" Display (iPhone 14 Pro, 15 Pro, etc.)
- **Portrait**: 1284 × 2778 pixels
- **Landscape**: 2778 × 1284 pixels

## How to Capture Screenshots

### Option 1: Using Simulator (Recommended)

1. **Launch the app in simulator:**
   ```bash
   cd /Users/gphelps/mtdiablo/diablo
   flutter run -d "iPhone 16 Pro Max"  # For 6.7" screenshots
   ```

2. **Navigate to each screen** you want to screenshot:
   - Home screen
   - Trails & Map
   - Practical Tools
   - Emergency Contacts
   - Park Info
   - Events

3. **Take screenshots:**
   - Press `Cmd + S` in Simulator, or
   - File → Save Screen in Simulator menu
   - Screenshots save to Desktop by default

4. **Resize if needed** (simulator screenshots are usually correct size)

### Option 2: Using Command Line

Use the `capture_screenshots.sh` script in this folder.

### Option 3: Using Xcode

1. Run app in simulator
2. In Xcode: Debug → View Debugging → Take Screenshot

## App Previews (Optional but Recommended)

App previews are short videos (15-30 seconds) showing your app in action.

1. Record screen while using the app
2. Edit to highlight key features
3. Export as MP4 or MOV
4. Max 500MB, 15-30 seconds recommended

## Screenshot Checklist

Create screenshots showing:
- [ ] Home screen with all 5 navigation tiles
- [ ] Trails & Map screen
- [ ] Practical Tools screen
- [ ] Emergency Contacts screen
- [ ] Park Info screen
- [ ] Events screen
- [ ] Trail detail view
- [ ] Amenity detail view
- [ ] Directions in Apple Maps (if possible)
- [ ] Any other key features

## File Naming Convention

Name files descriptively:
- `home-screen-portrait.png`
- `trails-map-portrait.png`
- `emergency-contacts-portrait.png`
- etc.

Or use numbers:
- `01-home-screen.png`
- `02-trails-map.png`
- etc.


# How to Upload to Existing App (Fix SKU Error)

## The Problem

Xcode is asking for a SKU because it thinks you're creating a **NEW** app instead of updating your **EXISTING** app (version 1.0.2).

## Solution: Upload to Existing App

### Step 1: Verify Bundle ID Matches

Your Bundle ID **MUST** exactly match what's in App Store Connect:
- **Current:** `com.gphelps.mountdiablo`
- **Verify in App Store Connect:** My Apps → mountdiablo → App Information → Bundle ID

### Step 2: Archive Your App

1. Open Xcode
2. Open `diablo/ios/Runner.xcworkspace`
3. Select **"Any iOS Device"** or **"Generic iOS Device"** (not a simulator)
4. **Product → Archive**

### Step 3: Distribute to App Store Connect

1. In the **Organizer** window (opens automatically after archive)
2. Select your archive
3. Click **"Distribute App"**
4. Select **"App Store Connect"**
5. Click **"Next"**

### Step 4: IMPORTANT - Select Existing App

When prompted:

1. **DO NOT** click "Create New App" or "Add New App"
2. **DO** select your **EXISTING** app: **"mountdiablo"**
3. If you don't see it, make sure:
   - You're signed in with the correct Apple ID
   - The Bundle ID matches exactly (`com.gphelps.mountdiablo`)

### Step 5: Choose Version

You have two options:

#### Option A: Upload to Existing Version 1.0.2 (Recommended)

1. **Change your version to match:**
   ```yaml
   # In pubspec.yaml
   version: 1.0.2+2  # or +3, +4, etc. (must be higher than existing builds)
   ```

2. **In Xcode Organizer:**
   - Select **"Upload"** (not "Submit for Review")
   - Choose your existing app
   - It will upload as a new build for version 1.0.2

#### Option B: Create New Version 1.0.4

1. **Keep your current version:**
   ```yaml
   version: 1.0.4+1
   ```

2. **In App Store Connect:**
   - Go to your app
   - Click **"+"** next to "iOS App" to create version 1.0.4
   - Fill in version information

3. **Then upload** - Xcode will see version 1.0.4 exists and upload to it

## Why You're Getting SKU Error

The SKU error appears when:
- Xcode can't find your existing app (Bundle ID mismatch)
- You accidentally clicked "Create New App"
- You're not signed in with the correct Apple ID
- The app doesn't exist in App Store Connect yet

## Quick Fix Checklist

- [ ] Bundle ID matches exactly: `com.gphelps.mountdiablo`
- [ ] Signed in with correct Apple ID in Xcode
- [ ] App exists in App Store Connect (version 1.0.2)
- [ ] Selecting "Upload" not "Create New App"
- [ ] Version/build number is higher than existing builds

## If Still Having Issues

1. **Check App Store Connect:**
   - Go to https://appstoreconnect.apple.com
   - Verify app exists: My Apps → mountdiablo
   - Check Bundle ID matches

2. **Re-authenticate in Xcode:**
   - Xcode → Settings → Accounts
   - Remove and re-add your Apple ID
   - Sign in again

3. **Verify Team:**
   - In Xcode project settings
   - Signing & Capabilities → Team
   - Should match your App Store Connect team


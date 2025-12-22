# Xcode Cloud CocoaPods Setup Guide

## The Problem

The error `Unable to load contents of file list: '/Target Support Files/Pods-Runner/...'` occurs because:

1. **Xcode Cloud is building `.xcodeproj` instead of `.xcworkspace`**
   - CocoaPods requires the workspace to properly integrate Pods
   - Building the project directly breaks Pods integration

2. **`pod install` isn't running before the build**
   - The `Pods/` directory isn't committed (normal)
   - Without `pod install`, the xcfilelist files don't exist

3. **Flutter steps aren't running**
   - Need `flutter pub get` before `pod install`
   - Flutter generates required `.xcconfig` files

## Solution: Configure Xcode Cloud Properly

### Step 1: Set Xcode Cloud to Build the Workspace

**CRITICAL:** In your Xcode Cloud workflow settings:

1. Open Xcode → Xcode Cloud tab → Your Workflow → Edit
2. Under **"Build Environment"** or **"Project"**:
   - ✅ **Select:** `diablo/ios/Runner.xcworkspace` (for iOS builds)
   - ✅ **Select:** `diablo/macos/Runner.xcworkspace` (for macOS builds)
   - ❌ **DO NOT** select `Runner.xcodeproj`

**Why:** The workspace includes both your app and Pods projects. Building the project directly skips Pods integration.

### Step 2: Verify Pre-Build Script Location

The script `ci_scripts/ci_pre_xcodebuild.sh` is already in the correct location:

```
ci_scripts/ci_pre_xcodebuild.sh  ← Must be at repository root
```

Xcode Cloud automatically runs scripts in `ci_scripts/` before building.

### Step 3: What the Script Does

Our `ci_pre_xcodebuild.sh` script already handles:

1. ✅ Installs Flutter (if not present)
2. ✅ Runs `flutter pub get`
3. ✅ Runs `flutter precache --ios` and `flutter precache --macos`
4. ✅ Generates Flutter `.xcconfig` files
5. ✅ Installs CocoaPods (if not present)
6. ✅ Runs `pod install --repo-update` for both iOS and macOS
7. ✅ Creates Release xcfilelist files proactively
8. ✅ Syncs `Podfile.lock` and `Manifest.lock`

### Step 4: Verify Script is Executable

The script should be executable:

```bash
chmod +x ci_scripts/ci_pre_xcodebuild.sh
```

(Already done in the repository)

## Troubleshooting

### If errors persist:

1. **Check Xcode Cloud build logs:**
   - Look for "🔧 Running Flutter pre-build setup..."
   - Verify `pod install` runs successfully
   - Check if workspace is being used

2. **Verify workspace selection:**
   - In Xcode Cloud workflow settings
   - Must be `Runner.xcworkspace`, not `Runner.xcodeproj`

3. **Check script execution:**
   - Script should run before build starts
   - Look for Flutter and CocoaPods output in logs

4. **Verify Podfile.lock is committed:**
   - `diablo/ios/Podfile.lock` should be in git
   - `diablo/macos/Podfile.lock` should be in git
   - This ensures consistent pod versions

## Current Setup Status

✅ Pre-build script exists: `ci_scripts/ci_pre_xcodebuild.sh`  
✅ Script runs Flutter setup  
✅ Script runs `pod install` for iOS and macOS  
✅ Script creates Release xcfilelist files  
✅ Workspace files exist: `diablo/ios/Runner.xcworkspace` and `diablo/macos/Runner.xcworkspace`  

⚠️ **ACTION REQUIRED:** Verify in Xcode Cloud UI that workflows are configured to build `.xcworkspace` files, not `.xcodeproj` files.

## Quick Checklist

- [ ] Xcode Cloud workflow builds `diablo/ios/Runner.xcworkspace` (not `.xcodeproj`)
- [ ] Xcode Cloud workflow builds `diablo/macos/Runner.xcworkspace` (not `.xcodeproj`)
- [ ] `ci_scripts/ci_pre_xcodebuild.sh` exists and is executable
- [ ] `Podfile.lock` files are committed for both iOS and macOS
- [ ] Build logs show Flutter and CocoaPods setup running


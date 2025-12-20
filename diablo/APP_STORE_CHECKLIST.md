# App Store Submission Checklist - Complete Review

## 🔴 CRITICAL - Must Fix Before Submission

### 1. Privacy Policy URL (REQUIRED)
- **Status**: ❌ MISSING
- **Why**: Your app collects location data (geolocator), so Apple REQUIRES a privacy policy URL
- **Action**: Create a privacy policy page and host it online (GitHub Pages, your website, etc.)
- **Where to add**: App Store Connect → App Privacy section

### 2. Support URL (REQUIRED)
- **Status**: ❌ MISSING  
- **Why**: Apple requires a support URL for all apps
- **Action**: Create a support page or use a contact email page
- **Where to add**: App Store Connect → App Information

### 3. App Description (REQUIRED)
- **Status**: ⚠️ NEEDS REVIEW
- **Current**: "Mount Diablo Contra Costa County - Official visitor guide and outdoor recreation app."
- **Action**: Write a detailed description (up to 4000 characters) explaining:
  - What the app does
  - Key features
  - Who it's for
  - How to use it

### 4. Screenshots (REQUIRED)
- **Status**: ⚠️ IN PROGRESS
- **Action**: Need 10 screenshots showing:
  - Home screen
  - All major features
  - Key functionality
- **Folder**: `app_store_assets/screenshots/`

## ✅ Already Fixed

- ✅ Bundle Identifier: `com.gphelps.mtdiablo` (was `com.example.diablo`)
- ✅ Location Privacy Permissions: Added to Info.plist
- ✅ App Icon: Configured
- ✅ Apple Maps: Migrated from Google Maps (no API key needed)
- ✅ iOS Deployment Target: Set to 14.0

## 📋 App Store Connect Requirements

### Required Information
- [ ] **App Name**: "Mount Diablo Contra Costa County" (or shorter if needed)
- [ ] **Subtitle**: 30 characters max (e.g., "Trails, Maps & Park Info")
- [ ] **Description**: Detailed description (up to 4000 characters)
- [ ] **Keywords**: Up to 100 characters (e.g., "hiking, trails, mount diablo, california, parks")
- [ ] **Category**: Travel, Navigation, or Lifestyle
- [ ] **Age Rating**: Complete questionnaire
- [ ] **Pricing**: Free or Paid

### Required URLs
- [ ] **Privacy Policy URL**: ⚠️ CRITICAL - Must have this!
- [ ] **Support URL**: Required
- [ ] **Marketing URL**: Optional

### Required Assets
- [ ] **App Icon**: 1024×1024 PNG (no transparency) ✅ Done
- [ ] **Screenshots**: 10 screenshots for iPhone 6.7" display
- [ ] **App Previews**: Optional but recommended (up to 3 videos)

## 🔍 Common Rejection Reasons

### 1. Missing Privacy Policy (Most Common)
**Why rejected**: App collects location data but no privacy policy URL provided
**Fix**: Create and host a privacy policy page

### 2. Incomplete App Functionality
**Why rejected**: App appears incomplete or crashes
**Fix**: Test all features thoroughly before submission

### 3. Missing Required Metadata
**Why rejected**: Missing description, screenshots, or support URL
**Fix**: Fill in all required fields in App Store Connect

### 4. Privacy Permission Descriptions
**Why rejected**: Description doesn't clearly explain why location is needed
**Fix**: Make sure Info.plist descriptions are clear (✅ Already done)

### 5. App Crashes or Bugs
**Why rejected**: App crashes during review
**Fix**: Test on multiple devices and iOS versions

## 🚀 Step-by-Step Submission Process

### Step 1: Create Privacy Policy (CRITICAL)
1. Write a privacy policy explaining:
   - What data you collect (location)
   - How you use it (navigation, emergency sharing)
   - Whether you share it (no)
   - How users can control it
2. Host it online (GitHub Pages is free and easy)
3. Get the URL

### Step 2: Create Support Page
1. Create a simple support/contact page
2. Host it online
3. Get the URL

### Step 3: Prepare Screenshots
1. Use the `app_store_assets/capture_screenshots.sh` script
2. Capture 10 screenshots showing key features
3. Save to `app_store_assets/screenshots/`

### Step 4: Write App Description
Write a compelling description covering:
- What the app does
- Key features (trails, maps, emergency contacts, etc.)
- Who it's for (hikers, visitors, outdoor enthusiasts)
- How to use it

### Step 5: Configure in App Store Connect
1. Log into https://appstoreconnect.apple.com
2. Create app entry (if not already created)
3. Fill in ALL required fields
4. Upload screenshots
5. Add privacy policy URL
6. Add support URL

### Step 6: Archive and Upload
1. In Xcode: Product → Archive
2. Distribute → App Store Connect
3. Upload build

### Step 7: Submit for Review
1. In App Store Connect, select your build
2. Fill in "What's New" section
3. Answer Export Compliance questions
4. Submit for Review

## 📝 Quick Privacy Policy Template

You can use this template and host it on GitHub Pages:

```markdown
# Privacy Policy for Mount Diablo App

Last updated: [Date]

## Data Collection
This app collects location data to provide the following features:
- Trail navigation and directions
- Emergency location sharing
- Finding nearby amenities

## How We Use Your Data
- Location data is used only on your device
- We do not store or transmit your location to any servers
- Location is shared only when you explicitly request directions or emergency sharing

## Data Sharing
We do not share your location data with any third parties.

## Your Rights
You can revoke location permissions at any time through iOS Settings.

## Contact
For questions about this privacy policy, contact: [your email]
```

## ⚡ Next Steps

1. **Create Privacy Policy** (highest priority)
2. **Create Support Page**
3. **Capture Screenshots**
4. **Write App Description**
5. **Test App Thoroughly**
6. **Submit to App Store Connect**


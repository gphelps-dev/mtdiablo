# How to Change Main Branch in Xcode Cloud

## Method 1: App Store Connect (Recommended)

1. **Go to App Store Connect**
   - Visit: https://appstoreconnect.apple.com
   - Sign in with your Apple ID

2. **Navigate to Xcode Cloud**
   - Click **"My Apps"**
   - Select your app (**mountdiablo**)
   - Click **"TestFlight"** tab
   - Click **"Xcode Cloud"** in the left sidebar

3. **Edit Workflow**
   - Find your workflow (e.g., "CI" or "Production")
   - Click on the workflow name
   - Click **"Edit Workflow"** button

4. **Change Branch**
   - Scroll to **"Source Control"** section
   - Under **"Branch"**, click the dropdown
   - Select your new branch (e.g., `fix/flutter-symlink-app-store-validation`)
   - Click **"Save"** or **"Done"**

## Method 2: Xcode App

1. **Open Xcode**
   - Open your project: `diablo/ios/Runner.xcworkspace` or `diablo/macos/Runner.xcworkspace`

2. **Open Organizer**
   - Menu: **Window → Organizer** (or press `Cmd+Shift+O`)
   - Click **"Cloud"** tab at the top

3. **Select Workflow**
   - Find your workflow in the list
   - Click on it to select

4. **Edit Workflow**
   - Click **"Edit Workflow"** button (or right-click → Edit)
   - In the workflow editor, find **"Source Control"** section
   - Change the **"Branch"** dropdown to your desired branch
   - Click **"Done"** or **"Save"**

## Method 3: Xcode Cloud API (Advanced)

If you need to automate this or change multiple workflows:

```bash
# Get your API key from App Store Connect
# Then use the Xcode Cloud API to update workflow configuration
```

## Current Branch Setup

**Current branch:** `fix/flutter-symlink-app-store-validation`  
**Contains:** Fix for ITMS-90332 symlink validation error

**To use this branch:**
- Change Xcode Cloud workflow to build from `fix/flutter-symlink-app-store-validation`
- Or merge this branch to `main`/`master` first

## Notes

- **Branch must exist** on your remote repository (GitHub/GitLab/etc.)
- **Push your branch** before changing Xcode Cloud:
  ```bash
  git push -u origin fix/flutter-symlink-app-store-validation
  ```
- **Next build** will use the new branch automatically
- You can have **multiple workflows** building from different branches

## Troubleshooting

**Can't see the branch?**
- Make sure you've pushed it: `git push origin <branch-name>`
- Refresh the branch list in Xcode Cloud UI
- Check that the branch exists on your remote repository

**Build still using old branch?**
- Wait for the current build to finish
- Or cancel the current build and start a new one
- The next build will use the new branch


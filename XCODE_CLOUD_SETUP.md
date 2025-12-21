# Xcode Cloud Configuration

## Setting Xcode Version in Xcode Cloud

Xcode Cloud workflow settings are configured in the Xcode Cloud UI, not in project files. To ensure your builds use Xcode 16.0 or later:

### Steps to Configure:

1. **Open your project in Xcode**
2. **Go to Xcode Cloud tab** (or Product → Xcode Cloud → View Workflows)
3. **Select your workflow** (or create a new one)
4. **Click "Edit Workflow"** or the workflow settings
5. **Under "Build Environment" or "Xcode Version"**, select:
   - **Recommended: Xcode 16.0** or **16.2** (for compatibility with Flutter 3.24.5)
   - **Minimum: Xcode 15.4** (if 16.x is not available)

### Why Upgrade?

- Xcode 12.0 (2020) is too old and incompatible with:
  - Flutter 3.24.5
  - macOS 11.0+ deployment target
  - Modern Swift/CocoaPods
  - Required SDKs for App Store submissions

### Current Project Settings

- **macOS Deployment Target:** 11.0
- **Flutter Version:** 3.24.5
- **Recommended Xcode:** 16.0 or later

### Note

The `LastUpgradeVersion` in scheme files reflects the Xcode version used to edit the project locally, but **does not control** which Xcode version Xcode Cloud uses. You must configure this in the Xcode Cloud workflow settings.


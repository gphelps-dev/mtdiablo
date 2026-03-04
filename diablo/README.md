# Mount Diablo App

Official visitor guide and outdoor recreation app for Mount Diablo State Park in Contra Costa County, California.

## Features

- **Safety** - Emergency contacts, park rangers, report unsafe drivers
- **Weather & Air Quality** - Real-time conditions from 4 locations with webcams
- **Mt Diablo Cyclists** - 67 bike turnouts, easement info, traffic monitor
- **Trails & Map** - Browse trails, find amenities, get directions
- **Practical Tools** - Find parking, restrooms, water fountains
- **Park Info** - Hours, fees, contact information

## Prerequisites

- Flutter SDK (3.5.4 or higher)
- Xcode (for iOS, Mac only)
- Android Studio or Android SDK (for Android)
- CocoaPods (for iOS, `brew install cocoapods`)

## Installation

```bash
cd diablo
flutter pub get
```

## Running the App

### iOS (Mac only)

```bash
# List available devices
flutter devices

# Run on iOS Simulator (e.g., iPhone 16 Pro Max)
flutter run -d "iPhone 16 Pro Max"

# Or use device ID
flutter run -d <ios-device-id>
```

### Android

```bash
# Start an Android emulator from Android Studio, or connect a device

# Run on Android
flutter run -d <android-device-id>

# List devices to find ID
flutter devices
```

### Environment Switch (dev / stage / prod)

```bash
# Default is prod
flutter run

# Development
flutter run --dart-define=APP_ENV=dev

# Staging
flutter run --dart-define=APP_ENV=stage
```

## Building for Release

### iOS

```bash
flutter build ios --release
```

Then open **`ios/Runner.xcworkspace`** in Xcode (use workspace, not .xcodeproj):

1. Select "Any iOS Device (arm64)" as destination
2. Product → Archive
3. Distribute App → App Store Connect → Upload

### Android

```bash
# Debug APK (for local testing)
flutter build apk --debug

# Release APK
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release
```

For Play Store release signing, copy `android/key.properties.example` to `android/key.properties` and add your keystore details. See [Flutter Android signing](https://docs.flutter.dev/deployment/android#signing-the-app).

## Adding New Screens

1. Create a new file in `lib/features/<feature_name>/`
2. Add your screen widget
3. In `lib/main.dart`, add a tile in the `GridView` and `Navigator.push` to your screen
4. Both iOS and Android use the same Dart code—no platform-specific changes needed for basic screens

## Project Structure

```
diablo/
├── lib/
│   ├── config/           # Shared app config (app name, env, endpoints)
│   │   ├── app_config.dart
│   │   └── env.dart
│   ├── features/         # Feature screens
│   ├── models/
│   └── main.dart
├── android/             # Android native config
├── ios/                  # iOS native config
└── assets/
```

## CI (Optional)

Placeholder for future CI: build both platforms:

```bash
# iOS
flutter build ios --release --no-codesign

# Android
flutter build apk --release
```

## App Store / Play Store

- **Bundle ID**: `com.gphelps.mountdiablo`
- **iOS**: See `APP_STORE_CHECKLIST.md`
- **Android**: See `android/key.properties.example` for signing

## Version

Current: 1.7.2+1

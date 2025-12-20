# Mount Diablo App

Official visitor guide and outdoor recreation app for Mount Diablo State Park in Contra Costa County, California.

## Features

- **Trails & Map** - Browse trails, find amenities, get directions
- **Practical Tools** - Find parking, restrooms, water fountains, and other amenities
- **Emergency Contacts** - Quick access to park rangers and emergency services with location sharing
- **Park Info** - Hours, fees, contact information, and conservation details
- **Events** - Upcoming hikes, outings, and conservation events

## Getting Started

### Prerequisites

- Flutter SDK (3.5.4 or higher)
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

```bash
cd diablo
flutter pub get
```

### Running the App

```bash
# iOS Simulator
flutter run -d "iPhone 16 Pro Max"

# Android Emulator
flutter run -d <device-id>

# macOS
flutter run -d macos
```

## Building for Release

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and upload to App Store Connect.

### Android

```bash
flutter build appbundle --release
```

## App Store Submission

See `APP_STORE_CHECKLIST.md` for detailed submission requirements.

Key requirements:
- Bundle identifier: `com.gphelps.mtdiablo`
- Privacy policy URL (required - app collects location data)
- Support URL
- Screenshots (see `app_store_assets/` folder)

## Version

Current version: 1.0.3

## License

This project is for Mount Diablo State Park visitor use.

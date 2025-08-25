# PastaPortionPro

iOS app for measuring pasta portions, tracking calories, and managing cooking times.

## Features

- **Accurate Portion Measurement**: Precisely measure pasta portions for your recipes on all iPhone models
- **Calorie Calculation**: Automatically calculate calories for your pasta dishes
- **Cooking Timer**: Set optimal cooking times and receive notifications
- **History Management**: Track and analyze your past cooking records
- **Premium Features**: Unlimited history management and family sharing

## Requirements

- iOS 16.4 or later
- Xcode 15.0 or later
- Swift 5.9

## Installation

1. Clone the repository:
```bash
git clone https://github.com/HelloWorldSagwa/PastaPortionPro.git
cd PastaPortionPro
```

2. Open the project in Xcode:
```bash
open PastaPortionPro.xcodeproj
```

3. Install Swift Package Dependencies in Xcode:
   - Open the project in Xcode
   - Go to **File → Add Package Dependencies**
   - Add the following packages:

### Required Swift Packages

#### Google Mobile Ads
- **URL**: `https://github.com/googleads/swift-package-manager-google-mobile-ads.git`
- **Version**: 11.5.0
- **Product**: GoogleMobileAds

#### Realm Swift
- **URL**: `https://github.com/realm/realm-swift.git`
- **Branch**: master
- **Products**: RealmSwift

#### Firebase
- **URL**: `https://github.com/firebase/firebase-ios-sdk`
- **Version**: 10.28.1
- **Products**: 
  - FirebaseAnalyticsSwift
  - FirebaseAppCheck

4. Configure Firebase:
   - The `GoogleService-Info.plist` file is already included in the project
   - Make sure Firebase is properly configured for your bundle identifier

5. Build and run the project on your device or simulator

## Project Structure

```
PastaPortionPro/
├── PastaPortionPro(SwiftUI)/
│   ├── APP_INFO/           # App configuration files
│   ├── Asset/              # Images and resources
│   ├── Model/              # Data models and business logic
│   ├── View/               # SwiftUI views
│   │   ├── Intro/          # Login and onboarding screens
│   │   └── Main/           # Main app screens
│   │       ├── Home/       # Home tab
│   │       ├── History/    # History tracking
│   │       ├── Portion/    # Portion calculation
│   │       ├── Timer/      # Cooking timer
│   │       └── Settings/   # Settings and preferences
│   └── Purchase/           # In-app purchase management
├── Assets.xcassets/        # App icons and images
└── LanguageSupport/        # Localization files
```

## Version History

### v1.3.0 (Latest)
- Removed ads - converted to premium-only
- Added iPhone 16 support
- Added app rating recommendation feature

## Developer

**SungHyun Kim** (Studio5)

## App Store

Available on the [Apple App Store](https://apps.apple.com/in/app/pasta-portion-pro/id6503697331)

## License

This project is proprietary software. All rights reserved.

## Support

For support, please contact through the App Store or create an issue in this repository.
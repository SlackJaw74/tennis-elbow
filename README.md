# Tennis Elbow Treatment App

An iOS application to help manage and track tennis elbow (lateral epicondylitis) recovery with structured treatment plans, scheduling, pain tracking, and progress monitoring.

## Features

- 📋 **Progressive Treatment Plans** - Three 2-week treatment phases
- 📅 **Smart Scheduling** - Automatic activity scheduling with customizable times
- 🔔 **Push Notifications** - Reminders for scheduled activities
- 📊 **Pain Tracking** - Record and visualize pain levels over time
- 📈 **Progress Analytics** - Track completion rates and treatment effectiveness
- 💡 **Educational Content** - Learn about tennis elbow and treatment best practices

## Quick Start

### Build & Run

```bash
# Build and run on iPhone simulator
make sim-run

# Build and run on iPad simulator
make ipad-run

# Run on specific device
make sim-run DEVICE="iPhone 17 Pro"
make ipad-run IPAD_DEVICE="iPad Air 11-inch (M2)"
```

### Screenshot Generation

```bash
# Capture all screenshots (iPhone + iPad)
make screenshots

# Capture iPhone screenshots only
make screenshots-iphone

# Capture iPad screenshots only
make screenshots-ipad

# Process screenshots for App Store submission
make process-screenshots
```

For detailed snapshot testing documentation, see [SNAPSHOT_TESTING.md](SNAPSHOT_TESTING.md).

## Project Structure

```txt
tennis-elbow/
├── TennisElbow/
│   ├── TennisElbow/
│   │   ├── Models/                    # Data models
│   │   ├── ViewModels/                # Business logic
│   │   └── Views/                     # SwiftUI views
│   └── TennisElbowUITests/            # UI tests and snapshot testing
├── fastlane/                          # Fastlane automation & screenshot lanes
├── scripts/                           # Build and version management scripts
├── Makefile                           # Build automation
├── SCREENSHOT_GUIDE.md                # App Store screenshot guide
└── SNAPSHOT_TESTING.md                # Comprehensive testing guide
```

## Documentation

- **[SCREENSHOT_GUIDE.md](SCREENSHOT_GUIDE.md)** - Manual and automated screenshot capture for App Store
- **[SNAPSHOT_TESTING.md](SNAPSHOT_TESTING.md)** - Comprehensive UI snapshot testing guide
- **[VERSION_MANAGEMENT.md](VERSION_MANAGEMENT.md)** - Automatic version incrementing guide
- **[PRIVACY_POLICY.md](TennisElbow/PRIVACY_POLICY.md)** - Privacy policy for App Store

- Versioning: Update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in the project.
- Minimum iOS: Set deployment target to 16.0 to match Charts (done).
- App Icon: Confirm 1024×1024 marketing icon and that build produces all sizes.
- Privacy Policy: Host [PRIVACY_POLICY.md](TennisElbow/PRIVACY_POLICY.md) on a public URL and add it in App Store Connect.
- App Privacy: Declare data collection as local-only (no collection) in App Store Connect.
- Screenshots: Prepare iPhone (6.5") and iPad (if supported) screenshots for key flows.
- Signing: Configure Release signing (Distribution certificate + provisioning) in Xcode.
- Archive & Upload: In Xcode, select Any iOS Device (arm64) → Product → Archive → Distribute → App Store Connect.
- Review Notes: Include the in-app medical disclaimer and explain local-only data storage.

Optional (recommended): Add a `PrivacyInfo.xcprivacy` manifest declaring no required reason APIs; add a `Makefile` or `fastlane` lane to automate build/archive.

## Automation

- Makefile: quick simulator run
   - Build + install + launch (iPhone):
      ```bash
      make sim-run
      ```
   - Build + install + launch (iPad):
      ```bash
      make ipad-run
      ```
   - Choose a different simulator:
      ```bash
      make sim-run DEVICE="iPhone 17"
      make ipad-run IPAD_DEVICE="iPad Pro 13-inch (M5)"
      ```
   - List devices:
      ```bash
      make device-list
      ```
   - Format code with SwiftFormat:
      ```bash
      make format
      ```
   - Archive (requires signing):
      ```bash
      make archive
      ```
   - Version management:
      ```bash
      # Show current version and build number
      make version

      # Bump patch version (1.0.0 -> 1.0.1)
      make bump-patch

      # Bump minor version (1.0.0 -> 1.1.0)
      make bump-minor

      # Bump major version (1.0.0 -> 2.0.0)
      make bump-major

      # Bump build number only
      make bump-build

      # Or use the script directly
      ./scripts/version_bump.sh patch
      ```

- fastlane: CI-friendly automation lanes
   - Install fastlane:
      ```bash
      sudo gem install fastlane -NV
      # Or with bundler:
      cd fastlane && bundle install
      ```
   - Run simulator lane:
      ```bash
      cd fastlane && bundle exec fastlane simulator
      ```
   - Create archive (Release):
      ```bash
      cd fastlane && bundle exec fastlane archive
      ```
   - Upload to App Store (set credentials first):
      ```bash
      cd fastlane && bundle exec fastlane upload
      ```
   - Generate screenshots (all devices):
      ```bash
      cd fastlane && bundle exec fastlane screenshots_all
      ```
   - Generate screenshots (iPhone only):
      ```bash
      cd fastlane && bundle exec fastlane screenshots_iphone
      ```
   - Generate screenshots (iPad only):
      ```bash
      cd fastlane && bundle exec fastlane screenshots_ipad
      ```
   - Process screenshots for App Store:
      ```bash
      cd fastlane && bundle exec fastlane process_screenshots
      ```
   - Version management:
      ```bash
      # Show current version and build number
      cd fastlane && bundle exec fastlane version

      # Bump patch version (1.0.0 -> 1.0.1)
      cd fastlane && bundle exec fastlane bump_patch

      # Bump minor version (1.0.0 -> 1.1.0)
      cd fastlane && bundle exec fastlane bump_minor

      # Bump major version (1.0.0 -> 2.0.0)
      cd fastlane && bundle exec fastlane bump_major

      # Bump build number only
      cd fastlane && bundle exec fastlane bump_build

      # Or specify type directly
      cd fastlane && bundle exec fastlane bump type:patch
      ```

## Snapshot Testing

The app includes comprehensive UI snapshot testing for both iPhone and iPad devices using fastlane.

### Quick Commands

```bash
# Capture all screenshots (iPhone + iPad)
make screenshots

# Capture iPhone screenshots only
make screenshots-iphone

# Capture iPad screenshots only
make screenshots-ipad

# Process for App Store submission
make process-screenshots
```

### Supported Devices

**iPhone:**
- iPhone 17 Pro Max
- iPhone 17 Pro
- iPhone 17
- iPhone 16e

**iPad:**
- iPad Pro 13-inch (M5)
- iPad Pro 12.9-inch (6th generation)
- iPad Air 11-inch (M2)
- iPad (10th generation)

### UI Coverage

All 9 major app screens are covered:
1. Disclaimer View (initial launch)
2. Treatment Plan View
3. Schedule View
4. Progress View
5. Settings View
6. Medical Sources View
7. Disclaimer View (from Settings)
8. Medical Sources (from Disclaimer)
9. Activity Detail View

### Documentation

- **[SNAPSHOT_TESTING.md](SNAPSHOT_TESTING.md)** - Comprehensive guide with troubleshooting, best practices, and CI/CD integration
- **[SCREENSHOT_GUIDE.md](SCREENSHOT_GUIDE.md)** - Manual screenshot capture and App Store requirements

## App Store Submission Checklist

- [ ] **Versioning**: Update version numbers using automatic version management:
  - Run `make bump-patch` for bug fixes (1.0.0 → 1.0.1)
  - Run `make bump-minor` for new features (1.0.0 → 1.1.0)
  - Run `make bump-major` for breaking changes (1.0.0 → 2.0.0)
  - Or manually update `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in the project
  - Check current version: `make version`
- [ ] **Minimum iOS**: Set deployment target to 16.0 (required for Charts framework)
- [ ] **App Icon**: Confirm 1024×1024 marketing icon and that build produces all sizes
- [ ] **Privacy Policy**: Host [PRIVACY_POLICY.md](TennisElbow/PRIVACY_POLICY.md) on a public URL and add it in App Store Connect
- [ ] **App Privacy**: Declare data collection as local-only (no collection) in App Store Connect
- [ ] **Screenshots**: 
  - Run `make screenshots` to generate screenshots for all devices
  - Process for App Store: `make process-screenshots`
  - Minimum 3, maximum 10 screenshots per device type
  - iPhone: 6.7" display (1290 x 2796) required
  - iPad: 12.9" display (2048 x 2732) if supporting iPad
- [ ] **Signing**: Configure Release signing (Distribution certificate + provisioning) in Xcode
- [ ] **Archive & Upload**: 
  - In Xcode, select Any iOS Device (arm64) → Product → Archive → Distribute → App Store Connect
  - Or use: `make archive` → Upload via Xcode
- [ ] **Review Notes**: 
  - Include the in-app medical disclaimer
  - Explain local-only data storage
  - Mention no third-party analytics or tracking

**Optional Enhancements:**
- Add `PrivacyInfo.xcprivacy` manifest declaring no required reason APIs (already included)
- Use fastlane for automated build/archive: `fastlane archive`
- Generate localized screenshots for multiple languages

## Running PR Checks Locally

Before opening a PR, you can run the same checks that will run in CI to catch issues early:

### Install Tools

First, install the required tools (one-time setup):

```bash
# Install SwiftLint
brew install swiftlint

# Install SwiftFormat
brew install swiftformat
```

### Run Individual Checks

**SwiftLint** (code style and best practices):
```bash
cd TennisElbow
swiftlint lint
```

**SwiftFormat** (code formatting check):
```bash
cd TennisElbow
swiftformat --lint .
```

To automatically fix formatting issues:
```bash
cd TennisElbow
swiftformat .
```

**Build the app**:
```bash
xcodebuild \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 14" \
  clean build
```

**Run tests**:
```bash
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 14" \
  -enableCodeCoverage YES
```

### Run All Checks

To run all checks at once:

```bash
# From project root
cd TennisElbow

# Run SwiftLint
echo "Running SwiftLint..."
swiftlint lint

# Run SwiftFormat check
echo "Running SwiftFormat..."
swiftformat --lint .

# Build
echo "Building..."
cd ..
xcodebuild \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 14" \
  clean build

# Run tests
echo "Running tests..."
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 14" \
  -enableCodeCoverage YES

echo "All checks complete!"
```

Note: If "iPhone 14" simulator is not available on your system, you can list available simulators with:
```bash
xcrun simctl list devices
```

Then use any available device name in the `-destination` parameter.

# Tennis Elbow Treatment App

An iOS application to help manage and track tennis elbow (lateral epicondylitis) recovery with structured treatment plans, scheduling, pain tracking, and progress monitoring.

## Features

- 📋 **Progressive Treatment Plans** - Three 2-week treatment phases
- 📅 **Smart Scheduling** - Automatic activity scheduling with customizable times
- 🔔 **Push Notifications** - Reminders for scheduled activities
- 📊 **Pain Tracking** - Record and visualize pain levels over time
- 📈 **Progress Analytics** - Track completion rates and treatment effectiveness
- 💡 **Educational Content** - Learn about tennis elbow and treatment best practices

## Build & Launch in iOS Simulator

These steps use the included Xcode project and the iOS Simulator.

### Command Line (fastest)

Prerequisites: Xcode installed and at least one iOS simulator (e.g., iPhone 16e) available.

```bash
# Navigate to the workspace root
cd /Users/bwils17/code/tennis-elbow

# Open Simulator (boots your last device)
open -a Simulator

# Build for the simulator (Debug)
xcodebuild \
   -project "TennisElbow/TennisElbow.xcodeproj" \
   -scheme "TennisElbow" \
   -configuration Debug \
   -sdk iphonesimulator \
   -destination "platform=iOS Simulator,name=iPhone 16e" \
   -derivedDataPath build \
   clean build

# Install the built app to the booted simulator
xcrun simctl install booted "build/Build/Products/Debug-iphonesimulator/TennisElbow.app"

# Launch the app by bundle identifier
xcrun simctl launch booted com.madhouse.TennisElbow
```

Notes:

- If `iPhone 16e` isn’t available, pick another installed device name from:
   `xcrun simctl list devices` and update the `-destination`.
- The build output lives in `build/Build/Products/Debug-iphonesimulator/`.

### Xcode (GUI)

1. Open the project: [TennisElbow/TennisElbow.xcodeproj](TennisElbow/TennisElbow.xcodeproj)
2. In the toolbar, select a simulator device (e.g., iPhone 16e).
3. Ensure the scheme is `TennisElbow` and configuration is `Debug`.
4. Press Run (▶) or `Cmd+R` to build and launch.

### Troubleshooting

- No simulators available: open Xcode → Settings → Platforms → install iOS simulators.
- Pick a valid device name: run `xcrun simctl list devices` and use one marked `(Shutdown)` or `(Booted)`.
- Clean derived data: remove the local `build` folder or use Xcode’s Product → Clean Build Folder.
- App doesn’t appear: re-run the install and launch steps; ensure the Simulator is booted.

## How to Test the App

### Option 1: Using Xcode (Recommended)

1. **Install Xcode** from the Mac App Store (if not already installed)

2. **Create a new Xcode project:**
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "iOS" → "App"
   - Click "Next"
   - Fill in:
     - Product Name: `TennisElbow`
     - Team: Select your team (or leave as None for simulator only)
     - Organization Identifier: `com.yourname` (or any identifier)
     - Interface: **SwiftUI**
     - Language: **Swift**
     - Storage: **None**
   - Click "Next" and save to a temporary location

3. **Replace the project files:**
   - Delete the default `ContentView.swift` and `TennisElbowApp.swift` from Xcode
   - Drag and drop all files from this directory into your Xcode project:
     - `TennisElbowApp.swift`
     - `ContentView.swift`
     - `Models/` folder (all 3 files)
     - `ViewModels/` folder (TreatmentManager.swift)
     - `Views/` folder (all 5 files)
   - Make sure "Copy items if needed" is checked
   - Select "Create groups" for folders

4. **Configure capabilities:**
   - Select your project in the navigator
   - Go to "Signing & Capabilities" tab
   - If testing notifications, you may need to enable "Push Notifications"

5. **Run the app:**
   - Select a simulator (e.g., "iPhone 15 Pro")
   - Click the Play button (▶️) or press Cmd+R
   - The app will build and launch in the simulator

### Option 2: Using Swift Playgrounds (iPad/Mac)

If you have an iPad with Swift Playgrounds:

1. Create a new App project
2. Copy the code files one by one
3. Run directly on your iPad

### Option 3: Quick Test with Command Line

```bash
# Navigate to the project directory
cd /Users/bwils17/code/tennis-elbow

# Use xcodebuild to create and test (requires setting up project first)
# This is more advanced - use Option 1 for easier testing
```

## Testing Tips

### Initial Setup

1. **First Launch**: The app will generate a default schedule for the current week
2. **Enable Notifications**: Go to Settings tab → Enable Reminders (simulator will show permission dialog)
3. **Explore Treatment Plan**: View all activities in the Treatment tab

### Testing Activities

1. **Schedule Tab**:
   - Use the calendar to select different dates
   - Tap activities to view details
   - Mark activities as complete and select pain level

2. **Pain Tracking**:
   - Complete several activities with different pain levels
   - Go to Progress tab to see the pain chart and trends
   - Chart needs at least 2 data points to show trends

3. **Progress Tracking**:
   - Complete activities to see progress bars fill up
   - Check the completion percentages
   - View recent completions history

4. **Change Treatment Plans**:
   - Go to Settings → Current Plan
   - Switch between Week 1-2, 3-4, and 5-6 plans
   - Notice how activities change based on recovery phase

### Simulator Tips

- **Notifications**: Won't appear as prominently in simulator as on real device
- **Time Travel**: Change simulator time (Debug → Custom Time) to test scheduling
- **Reset**: Delete app from simulator to start fresh

## Project Structure

```txt
tennis-elbow/
├── Models/
│   ├── TreatmentActivity.swift    # Activity definitions and types
│   ├── ScheduledActivity.swift    # Scheduled activities with pain tracking
│   └── TreatmentPlan.swift        # Treatment plan phases
├── ViewModels/
│   └── TreatmentManager.swift     # Main business logic and state management
├── Views/
│   ├── TreatmentPlanView.swift    # Treatment plan overview
│   ├── ActivityDetailView.swift   # Individual activity details
│   ├── ScheduleView.swift         # Calendar and scheduling
│   ├── ProgressView.swift         # Charts and analytics
│   └── SettingsView.swift         # Settings and info
├── ContentView.swift              # Main tab navigation
└── TennisElbowApp.swift          # App entry point
```

## Requirements

- **iOS 16.0+** (for Charts framework)
- **Xcode 14.0+**
- **Swift 5.7+**

## Medical Disclaimer

This app is for informational purposes only and is not a substitute for professional medical advice. Always consult with a healthcare provider before starting any treatment program.

## Treatment Phases

### Week 1-2: Gentle Recovery

Focus on reducing inflammation with ice therapy and gentle stretching exercises.

### Week 3-4: Progressive Strengthening

Add eccentric strengthening exercises while continuing stretches.

### Week 5-6: Active Rehabilitation

Increase strength and endurance with more intensive exercises.

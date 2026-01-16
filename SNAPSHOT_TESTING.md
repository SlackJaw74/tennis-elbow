# Snapshot Testing Guide

This document provides comprehensive information about snapshot testing in the Tennis Elbow iOS app, including setup, execution, and troubleshooting for both iPhone and iPad devices.

## Overview

Snapshot testing captures screenshots of the app's UI across different devices and screen sizes. These snapshots are used for:
- App Store submission requirements
- Visual regression testing
- Design validation across device types
- Documentation and marketing materials

## Quick Start

### Capture All Screenshots (iPhone + iPad)
```bash
make screenshots
# Or directly with fastlane:
cd fastlane && bundle exec fastlane screenshots_all
```

### Capture iPhone Screenshots Only
```bash
make screenshots-iphone
# Or directly with fastlane:
cd fastlane && bundle exec fastlane screenshots_iphone
```

### Capture iPad Screenshots Only
```bash
make screenshots-ipad
# Or directly with fastlane:
cd fastlane && bundle exec fastlane screenshots_ipad
```

### Process Screenshots for App Store
```bash
make process-screenshots
# Or directly with fastlane:
cd fastlane && bundle exec fastlane process_screenshots
```

## Test Coverage

The UI tests capture snapshots of all major app screens:

| Screen | Snapshot Name | Description |
|--------|---------------|-------------|
| Disclaimer | `00-Disclaimer` | Initial medical disclaimer shown on first launch |
| Treatment Plan | `01-TreatmentPlan` | Main treatment plan with exercise list |
| Schedule | `02-Schedule` | Daily/weekly schedule view |
| Progress | `03-Progress` | Progress tracking with charts |
| Settings | `04-Settings` | App settings and preferences |
| Medical Sources | `05-MedicalSources` | Medical research citations (from Settings) |
| Disclaimer (Settings) | `06-DisclaimerFromSettings` | Disclaimer accessed from settings |
| Medical Sources (Disclaimer) | `07-MedicalSourcesFromDisclaimer` | Citations accessed from disclaimer |
| Activity Detail | `08-ActivityDetail` | Detailed view of a treatment activity |

## Supported Devices

### iPhone Devices
- **iPhone 17 Pro Max** - 6.9" display (1320 x 2868 px)
- **iPhone 17 Pro** - 6.3" display
- **iPhone 17** - 6.1" display
- **iPhone 16e** - Standard iPhone

### iPad Devices
- **iPad Pro 13-inch (M5)** - Large Pro model (2064 x 2752 px)
- **iPad Pro 12.9-inch (6th gen)** - Previous large Pro (2048 x 2732 px)
- **iPad Air 11-inch (M2)** - Mid-size iPad (1640 x 2360 px)
- **iPad (10th generation)** - Standard iPad (1620 x 2160 px)

## Configuration Files

### fastlane/Fastfile
Main fastlane configuration with screenshot capture lanes.

**Key Lanes:**
- `screenshots_all` - Capture screenshots for all devices (iPhone + iPad)
- `screenshots_iphone` - Capture screenshots for iPhone devices only
- `screenshots_ipad` - Capture screenshots for iPad devices only
- `process_screenshots` - Process screenshots for App Store submission

**Customizing Device Lists:**
```ruby
# Edit the device arrays in Fastfile
lane :screenshots_ipad do
  ipad_devices = [
    "iPad Pro 13-inch (M5)",
    "Your Custom iPad Device"
  ]
  
  capture_screenshots_for_devices(devices: ipad_devices, device_type: "iPad")
end
```

### fastlane/Snapfile
Fastlane configuration for automated snapshot generation.

**Key settings:**
```ruby
devices([
  "iPhone 11 Pro Max",              # iPhone devices
  "iPad Pro 13-inch (M5)"           # iPad devices
])

languages([
  "en-US"                           # Add more languages as needed
])

output_directory("./fastlane/screenshots")
clear_previous_screenshots(true)
override_status_bar(true)
```

### Makefile
Build and test automation with convenient targets.

**iPad-specific targets:**
```bash
make ipad-run IPAD_DEVICE="iPad Air 11-inch (M2)"
make ipad-build
make ipad-install
make ipad-launch
```

**Screenshot targets:**
```bash
make screenshots
make screenshots-iphone
make screenshots-ipad
```

## UI Test Implementation

### Test Structure (TennisElbowUITests.swift)

The main snapshot test is `testScreenshots()`:

```swift
func testScreenshots() throws {
    // Force portrait orientation
    XCUIDevice.shared.orientation = .portrait
    
    app.launch()
    
    // Capture disclaimer on first launch
    if acceptButton.waitForExistence(timeout: 5) {
        snapshot("00-Disclaimer")
        acceptButton.tap()
    }
    
    // Navigate through all screens...
    snapshot("01-TreatmentPlan")
    // ... more snapshots
}
```

### Adding New Snapshots

To add a new screen to snapshot testing:

1. **Navigate to the screen in the test:**
   ```swift
   let newScreenButton = app.buttons["New Screen"]
   newScreenButton.tap()
   sleep(2)
   ```

2. **Capture the snapshot:**
   ```swift
   snapshot("08-NewScreen")
   ```

3. **Update this documentation** with the new screen info

### Snapshot Helper

The `SnapshotHelper.swift` file provides:
- Device name detection
- Screenshot organization by device
- Language/locale configuration
- Fastlane integration

## Screenshot Organization

### Directory Structure
```
fastlane/screenshots/
├── en-US/                          # Language-specific directory
│   ├── iPhone 17 Pro Max-00-Disclaimer.png
│   ├── iPhone 17 Pro Max-01-TreatmentPlan.png
│   ├── iPad Pro 13-inch (M5)-00-Disclaimer.png
│   └── ...
└── app-store-ready/                # Processed screenshots
    ├── iPhone-00-Disclaimer.png
    ├── iPad Pro 13-inch (M5)-00-Disclaimer.png
    └── ...
```

### Naming Convention
```
[Device Name]-[Screenshot Number]-[Screen Name].png

Examples:
- iPhone 17 Pro Max-01-TreatmentPlan.png
- iPad Pro 13-inch (M5)-03-Progress.png
```

## Processing Screenshots

### Process for App Store via Fastlane
```bash
make process-screenshots
# Or directly:
cd fastlane && bundle exec fastlane process_screenshots
```

This lane:
- Resizes iPhone screenshots to 1284 x 2778 (6.7" display requirement)
- Copies iPad screenshots at original resolution
- Outputs to `fastlane/screenshots/app-store-ready/`

### Using fastlane snapshot (traditional method)
```bash
cd fastlane
bundle exec fastlane screenshots
```

Fastlane snapshot provides:
- Multi-device automation
- Multi-language support
- Status bar override
- Organized output by language

## Running Tests Locally

### Build and Test on iPhone
```bash
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro Max" \
  -enableCodeCoverage YES
```

### Build and Test on iPad
```bash
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -destination "platform=iOS Simulator,name=iPad Pro 13-inch (M5)" \
  -enableCodeCoverage YES
```

### Using Makefile
```bash
# Test on default iPad device
make ipad-run

# Test on specific iPad
make ipad-run IPAD_DEVICE="iPad Air 11-inch (M2)"
```

## CI/CD Integration

### GitHub Actions Workflow

The PR checks workflow runs UI tests on iPhone:

```yaml
- name: Run UI Tests
  run: |
    xcodebuild test \
      -project "TennisElbow/TennisElbow.xcodeproj" \
      -scheme "TennisElbow" \
      -destination "platform=iOS Simulator,name=iPhone SE (3rd generation)" \
      -enableCodeCoverage YES
```

### Adding iPad to CI

To add iPad testing to CI, update `.github/workflows/pr-checks.yml`:

```yaml
- name: Run iPad UI Tests
  run: |
    xcodebuild test \
      -project "TennisElbow/TennisElbow.xcodeproj" \
      -scheme "TennisElbow" \
      -destination "platform=iOS Simulator,name=iPad Pro 13-inch (M5)" \
      -enableCodeCoverage YES
```

## Troubleshooting

### Simulator Not Found

**Problem:** Device not available
```bash
make device-list  # List all simulators
xcrun simctl list devices available
```

**Solution:** Use an available device name exactly as shown in the list.

### Screenshots Not Captured

**Problem:** Screenshots directory empty

**Check:**
1. UI tests are passing: Look for test failures in output
2. Snapshot helper is initialized: `setupSnapshot(app)` in `setUpWithError()`
3. Directory exists: `mkdir -p fastlane/screenshots`
4. Permissions: Ensure write access to output directory

### UI Element Not Found

**Problem:** Test fails with "element does not exist"

**Solutions:**
1. Increase wait timeout: `element.waitForExistence(timeout: 10)`
2. Add sleep before interaction: `sleep(2)`
3. Check accessibility identifier matches the UI
4. Use correct element type (button, link, tab, etc.)

### iPad Layout Differences

**Problem:** UI looks different on iPad

**Solutions:**
1. Test on actual iPad simulator to verify layout
2. Use size classes for adaptive layouts
3. Add iPad-specific UI adjustments in SwiftUI
4. Consider landscape orientation for iPad

### Screenshot Size Issues

**Problem:** Screenshots wrong size

**Check:**
1. Device pixel dimensions: Each device has specific resolution
2. Scale factor: Retina displays use @2x or @3x
3. Status bar override: Should be enabled in Snapfile

### Fastlane Issues

**Problem:** Fastlane snapshot fails

**Solutions:**
1. Update fastlane: `bundle update fastlane`
2. Check Ruby version: `ruby --version` (need 2.5+)
3. Verify Gemfile exists: `cd fastlane && bundle install`
4. Check Snapfile syntax: Look for typos in device names

## Best Practices

### 1. Consistent Test Data
- Use predictable test data for reproducible screenshots
- Clear app state between test runs
- Set fixed dates/times if relevant

### 2. Portrait Orientation
- Most App Store screenshots work best in portrait
- Force orientation in tests: `XCUIDevice.shared.orientation = .portrait`

### 3. Wait for Animations
- Add `sleep(1)` or `sleep(2)` after navigation
- Let transitions complete before capturing
- SnapshotHelper includes automatic animation wait

### 4. Status Bar
- Use `override_status_bar(true)` in Snapfile
- Shows clean status without carrier/time variations

### 5. Accessibility
- Use accessibility identifiers for UI elements
- Makes tests more robust and maintainable
- Better for VoiceOver support too

### 6. Device Selection
- Test on largest iPhone for best quality
- Include iPad Pro for large display screenshots
- Consider iPad Air for mid-size representation

### 7. Version Control
- Don't commit generated screenshots to git
- Use `.gitignore` for screenshot directories
- Document which screenshots are current in PR descriptions

## App Store Requirements

### iPhone Screenshot Sizes
- **6.9" display:** 1320 x 2868 (required)
- **6.7" display:** 1290 x 2796 (alternative)
- **6.5" display:** 1242 x 2688 (older devices)
- **5.5" display:** 1242 x 2208 (optional)

### iPad Screenshot Sizes
- **13" iPad Pro:** 2064 x 2752 (portrait) or 2752 x 2064 (landscape)
- **12.9" iPad Pro:** 2048 x 2732 (portrait) or 2732 x 2048 (landscape)
- **11" iPad:** 1640 x 2360 (portrait) or 2360 x 1640 (landscape)

### Submission Checklist
- [ ] Minimum 3 screenshots per device type
- [ ] Maximum 10 screenshots per device type
- [ ] PNG or JPEG format
- [ ] sRGB or P3 color space
- [ ] No transparency (for screenshots)
- [ ] High quality, no blurriness
- [ ] Show actual app content

## Additional Resources

- [Apple Screenshot Specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications)
- [fastlane snapshot documentation](https://docs.fastlane.tools/actions/snapshot/)
- [XCTest UI Testing Guide](https://developer.apple.com/documentation/xctest/user_interface_tests)
- [App Store Connect Help](https://developer.apple.com/app-store-connect/)

## Contributing

When adding new screens or features:

1. Update `TennisElbowUITests.swift` with new snapshots
2. Add screen to coverage table in this document
3. Test on both iPhone and iPad
4. Update example screenshots in PR
5. Verify CI passes with new tests

## Support

For issues or questions:
- Check this guide's troubleshooting section
- Review test output for specific errors
- Check CI logs in GitHub Actions
- Contact: @slackjaw74

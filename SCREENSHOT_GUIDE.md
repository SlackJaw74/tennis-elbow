# App Store Screenshot Guide

## Quick Method: Manual Screenshots

### Required Sizes for App Store
Apple requires screenshots for these display sizes:

**iPhone:**
- **6.9" Display** (iPhone 17 Pro Max) - 1320 x 2868 pixels
- **6.7" Display** (iPhone 15 Pro Max, 14 Pro Max) - 1290 x 2796 pixels  
- **5.5" Display** (iPhone 8 Plus) - 1242 x 2208 pixels (optional but good for older devices)

**iPad:**
- **13" iPad Pro** - 2064 x 2752 pixels (portrait) or 2752 x 2064 pixels (landscape)
- **12.9" iPad Pro** - 2048 x 2732 pixels (portrait) or 2732 x 2048 pixels (landscape)
- **11" iPad Air/Pro** - 1640 x 2360 pixels (portrait) or 2360 x 1640 pixels (landscape)

### Steps to Capture Screenshots

1. **Open your app in Xcode**
   ```bash
   open TennisElbow/TennisElbow.xcodeproj
   ```

2. **Select a simulator device**
   - **For iPhone:** iPhone 17 Pro Max (required for 6.9"), iPhone 15 Pro Max (alternative for 6.7")
   - **For iPad:** iPad Pro 13-inch (M5), iPad Pro 12.9-inch (6th generation), iPad Air 11-inch (M2)

3. **Run your app** (Cmd + R)

4. **Navigate to each screen you want to capture**:
   - Disclaimer screen (initial launch)
   - Treatment Plan screen
   - Schedule screen  
   - Progress screen
   - Settings screen
   - Medical Sources screen
   - Activity Detail screen

5. **Take screenshots** in Simulator:
   - Press `Cmd + S` while simulator is active
   - Screenshots automatically save to your Desktop
   - They're saved at the correct resolution for App Store

### Recommended Screenshots
Capture 5-10 screenshots showing:
1. Disclaimer (with medical information)
2. Main treatment plan view
3. Schedule with activities
4. Progress tracking with chart
5. Activity detail/instructions
6. Medical sources view
7. Settings screen

### After Capturing
Screenshots will be on your Desktop. You can:
- Rename them sequentially (01-Disclaimer.png, 02-TreatmentPlan.png, etc.)
- Add them directly to App Store Connect

## Automated Method: Using Fastlane

### Using Fastlane Lanes

The recommended approach is to use fastlane lanes for automated screenshot capture.

**Capture all devices (iPhone and iPad):**
```bash
cd fastlane
bundle exec fastlane screenshots_all
# Or via Makefile:
make screenshots
```

**Capture iPhone devices only:**
```bash
cd fastlane
bundle exec fastlane screenshots_iphone
# Or via Makefile:
make screenshots-iphone
```

**Capture iPad devices only:**
```bash
cd fastlane
bundle exec fastlane screenshots_ipad
# Or via Makefile:
make screenshots-ipad
```

**Process screenshots for App Store submission:**
```bash
cd fastlane
bundle exec fastlane process_screenshots
# Or via Makefile:
make process-screenshots
```

Screenshots will be saved to `fastlane/screenshots/` with device-specific naming.

### Using Makefile Targets

**Capture all screenshots:**
```bash
make screenshots
```

**Capture iPhone screenshots only:**
```bash
make screenshots-iphone
```

**Capture iPad screenshots only:**
```bash
make screenshots-ipad
```

**Process for App Store:**
```bash
make process-screenshots
```

**Test on specific iPad device:**
```bash
make ipad-run IPAD_DEVICE="iPad Air 11-inch (M2)"
```

### Using fastlane snapshot (original method)

You can also use the original fastlane snapshot tool:

```bash
cd fastlane
bundle exec fastlane screenshots
```

This will:
- Run UI tests on all configured devices (iPhone and iPad)
- Capture screenshots for all languages specified in Snapfile
- Save organized screenshots to `fastlane/screenshots/`

## Device Configuration

### Supported Devices

**iPhone Devices:**
- iPhone 17 Pro Max
- iPhone 17 Pro
- iPhone 17
- iPhone 16e

**iPad Devices:**
- iPad Pro 13-inch (M5)
- iPad Pro 12.9-inch (6th generation)
- iPad Air 11-inch (M2)
- iPad (10th generation)

### Customizing Devices

Edit `fastlane/Fastfile` or `fastlane/Snapfile` to add or remove devices:

**In fastlane/Fastfile (for custom lanes):**
```ruby
lane :screenshots_ipad do
  ipad_devices = [
    "iPad Pro 13-inch (M5)",
    "Your Custom iPad Device"
  ]
  
  capture_screenshots_for_devices(devices: ipad_devices, device_type: "iPad")
end
```

**In fastlane/Snapfile (for snapshot tool):**
```ruby
devices([
  "iPhone 17 Pro Max",
  "iPad Pro 13-inch (M5)"
])
```

## Screenshot Organization

Screenshots are automatically organized by:
- **Device name** - Each screenshot includes the device name as prefix
- **Screen name** - Numbered and named by screen (00-Disclaimer, 01-TreatmentPlan, etc.)
- **Language** - When using fastlane with multiple languages

Example: `iPad Pro 13-inch (M5)-01-TreatmentPlan.png`

## Tips for Best Screenshots

1. **Clear the simulator status bar** - The scripts use `override_status_bar(true)` to show clean status
2. **Use portrait orientation** - Most app store screenshots work best in portrait
3. **Capture meaningful content** - Make sure treatment plans and progress data are visible
4. **Test on both iPhone and iPad** - App layouts may differ significantly
5. **Verify all UI elements** - Check that all buttons, tabs, and text are visible

## Troubleshooting

**Simulator not found:**
```bash
make device-list  # Lists all available simulators
```

**Screenshots not appearing:**
- Check `fastlane/screenshots/` directory
- Verify UI tests are passing: `xcodebuild test ...`
- Check console output for errors

**iPad screenshots too large:**
- iPad Pro screenshots are high resolution (2048x2732+)
- App Store Connect handles resizing automatically
- Use original resolution for best quality

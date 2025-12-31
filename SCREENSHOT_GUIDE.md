# App Store Screenshot Guide

## Quick Method: Manual Screenshots

### Required Sizes for App Store
Apple requires screenshots for these display sizes:
- **6.9" Display** (iPhone 17 Pro Max) - 1320 x 2868 pixels
- **6.7" Display** (iPhone 15 Pro Max, 14 Pro Max) - 1290 x 2796 pixels  
- **5.5" Display** (iPhone 8 Plus) - 1242 x 2208 pixels (optional but good for older devices)

### Steps to Capture Screenshots

1. **Open your app in Xcode**
   ```bash
   open TennisElbow/TennisElbow.xcodeproj
   ```

2. **Select a simulator device**
   - iPhone 17 Pro Max (required for 6.9")
   - iPhone 15 Pro Max (alternative for 6.7")

3. **Run your app** (Cmd + R)

4. **Navigate to each screen you want to capture**:
   - Treatment Plan screen
   - Schedule screen  
   - Progress screen
   - Settings screen
   - Activity Detail screen

5. **Take screenshots** in Simulator:
   - Press `Cmd + S` while simulator is active
   - Screenshots automatically save to your Desktop
   - They're saved at the correct resolution for App Store

### Recommended Screenshots
Capture 5-10 screenshots showing:
1. Main treatment plan view
2. Schedule with activities
3. Progress tracking
4. Activity detail/instructions
5. Any key features

### After Capturing
Screenshots will be on your Desktop. You can:
- Rename them sequentially (01-TreatmentPlan.png, 02-Schedule.png, etc.)
- Add them directly to App Store Connect

## Alternative: Using fastlane snapshot

If you want automated screenshots across multiple devices, the fastlane setup is configured but requires manual testing. You may need to adjust the UI test code in TennisElbowUITests.swift to match your app's UI elements.

The automated approach works best once the app is more stable and UI elements have consistent accessibility identifiers.

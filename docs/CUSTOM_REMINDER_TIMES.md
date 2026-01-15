# Custom Reminder Times

This document describes the custom reminder times feature added to the Tennis Elbow app.

## Overview

The app now allows users to customize when they receive morning and evening reminders for their treatment activities.

## Features

### Default Times
- **Morning:** 8:00 AM
- **Evening:** 7:00 PM (19:00)

### Customization
Users can customize morning and evening reminder times through the Settings page:

1. Navigate to the **Settings** tab
2. Enable **Reminders** (if not already enabled)
3. Use the **Morning Time** picker to set your preferred morning reminder time
4. Use the **Evening Time** picker to set your preferred evening reminder time

### Behavior

- **When reminders are disabled:** Time picker fields are hidden
- **When reminders are enabled:** Time picker fields appear below the reminder toggle
- **Time validation:** The time pickers only accept valid time values (built-in iOS validation)
- **Automatic rescheduling:** When you change reminder times, the app automatically:
  - Updates all scheduled activities with the new times
  - Reschedules push notifications
  - Saves your preferences for future use

### Data Persistence

Custom reminder times are saved to `UserDefaults` and persist across app launches:
- `morningReminderTime`: Stored as Date object
- `eveningReminderTime`: Stored as Date object

When you clear all data through Settings > Clear All Data, the reminder times reset to the defaults.

## Implementation Details

### Modified Files

1. **TreatmentManager.swift**
   - Added `morningReminderTime` and `eveningReminderTime` properties
   - Added `saveCustomReminderTimes()` and `loadCustomReminderTimes()` methods
   - Updated `generateSchedule()` to use custom times instead of hardcoded defaults
   - Added helper methods `getCustomHour()` and `getCustomMinute()`

2. **SettingsView.swift**
   - Added two `DatePicker` components for morning and evening times
   - Pickers only visible when reminders are enabled
   - Updated help text to reflect custom times

### Testing

UI tests have been added to verify:
- Time pickers appear when reminders are enabled
- Time pickers are hidden when reminders are disabled
- Reminder toggle functionality works correctly

To run tests:
```bash
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 16"
```

## User Impact

This feature improves user experience by:
- Providing flexibility to match treatment schedules with personal routines
- Allowing users to choose reminder times that work best for them
- Maintaining consistency with the app's notification system

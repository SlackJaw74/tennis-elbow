# Manual Testing Guide for Custom Reminder Times

This guide provides step-by-step instructions for manually testing the custom reminder times feature.

## Prerequisites

- iOS Simulator or physical iOS device
- Xcode installed
- Tennis Elbow app built and installed

## Test Scenarios

### Test 1: Default Values Are Shown Correctly

**Steps:**
1. Launch the app for the first time (or after clearing all data)
2. Accept the disclaimer if shown
3. Navigate to Settings tab
4. Enable Reminders toggle
5. Observe the time picker values

**Expected Results:**
- Morning Time should show 8:00 AM
- Evening Time should show 7:00 PM (19:00)

### Test 2: Time Pickers Are Hidden When Reminders Are Disabled

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. If reminders are enabled, observe that time pickers are visible
4. Tap the "Enable Reminders" toggle to disable reminders
5. Observe the UI

**Expected Results:**
- When reminders are enabled: Morning Time and Evening Time pickers are visible
- When reminders are disabled: Time pickers are hidden
- Only the toggle and descriptive text remain visible when disabled

### Test 3: Custom Times Are Validated and Saved

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. Enable Reminders if not already enabled
4. Tap on Morning Time picker
5. Set time to 6:30 AM
6. Tap on Evening Time picker
7. Set time to 8:45 PM
8. Navigate away from Settings
9. Force close the app
10. Relaunch the app
11. Navigate to Settings tab

**Expected Results:**
- Time pickers only accept valid time values (no invalid input possible)
- Custom times are immediately saved
- After app relaunch, custom times persist (6:30 AM and 8:45 PM)
- All scheduled activities in the Schedule tab reflect the new times

### Test 4: Schedule Updates When Times Change

**Steps:**
1. Launch the app
2. Navigate to Schedule tab
3. Note the times of morning activities (default should be 8:00 AM)
4. Navigate to Settings tab
5. Change Morning Time to 7:00 AM
6. Navigate back to Schedule tab
7. Check morning activity times

**Expected Results:**
- Morning activities now show 7:00 AM instead of 8:00 AM
- Pain tracking activities show 7:30 AM (30 minutes after session start)
- Evening activities remain at their set time

### Test 5: Notifications Are Rescheduled

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. Enable Reminders (grant notification permissions when prompted)
4. Set Morning Time to 9:00 AM
5. Set Evening Time to 6:00 PM
6. Check iOS notification settings for the app

**Expected Results:**
- Notifications are scheduled for the custom times
- Changing times automatically reschedules all pending notifications
- Old notification times are removed

### Test 6: Clear All Data Resets Times

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. Enable Reminders
4. Set custom times (e.g., Morning: 6:00 AM, Evening: 10:00 PM)
5. Scroll down to Data Management section
6. Tap "Clear All Data"
7. Confirm the action
8. Enable Reminders again
9. Check time pickers

**Expected Results:**
- After clearing data, reminder times reset to defaults
- Morning Time: 8:00 AM
- Evening Time: 7:00 PM
- All other data is also cleared as expected

### Test 7: Edge Cases - Late Evening Times

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. Enable Reminders
4. Set Morning Time to 11:45 AM
5. Set Evening Time to 11:30 PM
6. Navigate to Schedule tab
7. Check pain tracking times (should be 30 minutes after session start)

**Expected Results:**
- Pain tracking for morning session: 12:15 PM (correctly handles hour rollover)
- Pain tracking for evening session: 12:00 AM next day (correctly handles midnight rollover)
- No crashes or invalid times

### Test 8: Afternoon Activities Use Default Time

**Steps:**
1. Launch the app
2. Navigate to Settings tab
3. Change treatment plan to "Week 3-4" or "Week 5-6" (which include afternoon activities)
4. Enable Reminders and set custom morning/evening times
5. Navigate to Schedule tab
6. Check afternoon activity times

**Expected Results:**
- Morning activities use custom morning time
- Afternoon activities use default time (2:00 PM / 14:00) - not customizable
- Evening activities use custom evening time

## Automated Test Verification

To run the automated UI tests:

```bash
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -only-testing:TennisElbowUITests/TennisElbowUITests/testCustomReminderTimes
```

## Known Limitations

1. **Afternoon time is not customizable** - Only morning and evening times can be customized as per requirements
2. **No bulk time update** - Each time picker change triggers immediate schedule regeneration (acceptable for UX)
3. **No time range validation** - Users can set morning time later than evening time (considered acceptable as they represent different parts of the day)

## Success Criteria

All tests should pass with:
- ✅ Time pickers visible only when reminders enabled
- ✅ Default values correctly set
- ✅ Custom times persisted across app restarts
- ✅ Schedule automatically updates with new times
- ✅ Notifications rescheduled on time changes
- ✅ Data clearing resets to defaults
- ✅ No crashes with edge case times

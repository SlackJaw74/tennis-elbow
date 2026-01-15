# Feature Implementation Diagram

## UI Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     Settings Screen                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Notifications                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ○ Enable Reminders                        [OFF]     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘

                          ↓ (User enables reminders)

┌─────────────────────────────────────────────────────────────┐
│                     Settings Screen                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Notifications                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ● Enable Reminders                        [ON]      │  │
│  │                                                       │  │
│  │  Morning Time                              8:00 AM   │  │
│  │  [Time Picker Wheel]                                 │  │
│  │                                                       │  │
│  │  Evening Time                              7:00 PM   │  │
│  │  [Time Picker Wheel]                                 │  │
│  │                                                       │  │
│  │  ℹ You'll receive notifications for scheduled        │  │
│  │    activities at your custom times                   │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Changes Time
       ↓
DatePicker onChange
       ↓
treatmentManager.morningReminderTime = newTime
       ↓
treatmentManager.saveCustomReminderTimes()
       ↓
┌─────────────────────────────────────────────────┐
│ 1. Save to UserDefaults                         │
│    - morningReminderTime                        │
│    - eveningReminderTime                        │
├─────────────────────────────────────────────────┤
│ 2. generateSchedule()                           │
│    - Remove incomplete activities               │
│    - Create new activities with custom times    │
│    - Use getCustomHour() & getCustomMinute()    │
├─────────────────────────────────────────────────┤
│ 3. saveScheduledActivities()                    │
│    - Persist updated schedule                   │
├─────────────────────────────────────────────────┤
│ 4. scheduleNotifications() (if enabled)         │
│    - Cancel old notifications                   │
│    - Schedule new notifications at custom times │
└─────────────────────────────────────────────────┘
```

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        SettingsView                          │
│                         (SwiftUI)                            │
├──────────────────────────────────────────────────────────────┤
│  - Toggle: Enable/Disable Reminders                          │
│  - DatePicker: Morning Time (shown if enabled)               │
│  - DatePicker: Evening Time (shown if enabled)               │
└───────────────────────┬──────────────────────────────────────┘
                        │ @EnvironmentObject
                        ↓
┌──────────────────────────────────────────────────────────────┐
│                    TreatmentManager                          │
│                   (@MainActor class)                         │
├──────────────────────────────────────────────────────────────┤
│  @Published Properties:                                      │
│    - morningReminderTime: Date                               │
│    - eveningReminderTime: Date                               │
│    - notificationsEnabled: Bool                              │
│    - scheduledActivities: [ScheduledActivity]                │
│                                                              │
│  Key Methods:                                                │
│    - saveCustomReminderTimes()                               │
│    - loadCustomReminderTimes()                               │
│    - getCustomHour(for: TimeOfDay) -> Int                    │
│    - getCustomMinute(for: TimeOfDay) -> Int                  │
│    - generateSchedule()                                      │
│    - scheduleNotifications()                                 │
└───────────────────────┬──────────────────────────────────────┘
                        │
                        ↓
┌──────────────────────────────────────────────────────────────┐
│                      UserDefaults                            │
├──────────────────────────────────────────────────────────────┤
│  Keys:                                                       │
│    - "morningReminderTime" : Date                            │
│    - "eveningReminderTime" : Date                            │
│    - "scheduledActivities" : [ScheduledActivity] (JSON)      │
└──────────────────────────────────────────────────────────────┘
```

## Time Mapping

```
TimeOfDay Enum          Custom Time Used
─────────────────────  ────────────────────────────
.morning               → morningReminderTime
                         (default: 8:00 AM)
                         
.afternoon             → Fixed at 2:00 PM
                         (not customizable)
                         
.evening               → eveningReminderTime
                         (default: 7:00 PM)
```

## Schedule Generation Example

```
Input:
- Treatment Plan: Week 1-2
- Daily Schedule: Monday = [.morning, .evening]
- Morning Time: 7:30 AM (custom)
- Evening Time: 8:00 PM (custom)

Output (Monday's Schedule):
┌─────────────────────────────────────────────────────┐
│ 7:30 AM - Wrist Extension Stretch                  │
│ 7:30 AM - Wrist Flexion Stretch                    │
│ 7:30 AM - Forearm Massage                          │
│ 7:30 AM - Wrist Rotations                          │
│ 7:30 AM - Eccentric Wrist Extension                │
│ 7:30 AM - Ice Therapy                              │
│ 8:00 AM - Pain Level Check (30 min after session)  │
│                                                     │
│ 8:00 PM - Wrist Extension Stretch                  │
│ 8:00 PM - Wrist Flexion Stretch                    │
│ 8:00 PM - Forearm Massage                          │
│ 8:00 PM - Wrist Rotations                          │
│ 8:00 PM - Eccentric Wrist Extension                │
│ 8:00 PM - Ice Therapy                              │
│ 8:30 PM - Pain Level Check (30 min after session)  │
└─────────────────────────────────────────────────────┘
```

## Edge Case: Minute Overflow Handling

```
Before Fix (Bug):
─────────────────
Evening Time: 11:45 PM
Pain Check Time: 11:45 + 30 = 11:75 PM ❌ INVALID!

After Fix (Correct):
────────────────────
Evening Time: 11:45 PM
Session Start: Date(hour: 23, minute: 45)
Pain Check Time: sessionStart + 30 minutes
               = Date(hour: 0, minute: 15, nextDay) ✅
               = 12:15 AM
```

## State Persistence Flow

```
App Launch
    ↓
TreatmentManager.init()
    ↓
loadCustomReminderTimes()
    ├─→ Load from UserDefaults
    ├─→ If found: Use saved times
    └─→ If not found: Use defaults (8:00 AM, 7:00 PM)
    ↓
generateSchedule()
    └─→ Create activities with loaded times
    
App Termination
    ↓
(Times already saved on each change)
    ↓
Next Launch
    └─→ Times persist automatically
```

## Testing Coverage

```
┌─────────────────────────────────────────────────────┐
│              UI Tests (Automated)                   │
├─────────────────────────────────────────────────────┤
│  ✓ Time pickers appear when reminders enabled      │
│  ✓ Time pickers hidden when reminders disabled     │
│  ✓ Reminder toggle functionality works             │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│           Manual Test Scenarios                     │
├─────────────────────────────────────────────────────┤
│  ✓ Default values shown correctly                  │
│  ✓ Custom times validated and saved                │
│  ✓ Schedule updates when times change              │
│  ✓ Notifications rescheduled                       │
│  ✓ Clear all data resets times                     │
│  ✓ Edge cases (late evening times)                 │
│  ✓ Afternoon activities use default time           │
└─────────────────────────────────────────────────────┘
```

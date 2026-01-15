# User Interface Mockup

This document provides a text-based representation of what the user interface looks like with the new custom reminder times feature.

## Settings Screen - Reminders Disabled

```
╔════════════════════════════════════════════════════════╗
║  ← Settings                                            ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  NOTIFICATIONS                                         ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │  🔔 Enable Reminders                       ○ OFF │ ║
║  └──────────────────────────────────────────────────┘ ║
║                                                        ║
║  TREATMENT PLAN                                        ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │  Current Plan                                    │ ║
║  │  Week 1-2: Gentle Recovery              ▾       │ ║
║  │                                                  │ ║
║  │  ↻ Regenerate Schedule                          │ ║
║  └──────────────────────────────────────────────────┘ ║
║                                                        ║
║  DATA MANAGEMENT                                       ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │  🗑 Clear All Data                               │ ║
║  └──────────────────────────────────────────────────┘ ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

## Settings Screen - Reminders Enabled (NEW!)

```
╔════════════════════════════════════════════════════════╗
║  ← Settings                                            ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  NOTIFICATIONS                                         ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │  🔔 Enable Reminders                       ● ON  │ ║
║  │                                                  │ ║
║  │  Morning Time                          8:00 AM  │ ║ ← NEW!
║  │  ┌────────────────────────────────────────────┐ │ ║
║  │  │    Hours  │  Minutes                       │ │ ║
║  │  │      8    │    00                          │ │ ║
║  │  │   ───────┼──────────                      │ │ ║
║  │  │      9    │    15                          │ │ ║
║  │  └────────────────────────────────────────────┘ │ ║
║  │                                                  │ ║
║  │  Evening Time                          7:00 PM  │ ║ ← NEW!
║  │  ┌────────────────────────────────────────────┐ │ ║
║  │  │    Hours  │  Minutes                       │ │ ║
║  │  │     18    │    45                          │ │ ║
║  │  │   ───────┼──────────                      │ │ ║
║  │  │     19    │    00                          │ │ ║
║  │  └────────────────────────────────────────────┘ │ ║
║  │                                                  │ ║
║  │  ℹ You'll receive notifications for scheduled   │ ║ ← UPDATED!
║  │    activities at your custom times               │ ║
║  └──────────────────────────────────────────────────┘ ║
║                                                        ║
║  TREATMENT PLAN                                        ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │  Current Plan                                    │ ║
║  │  Week 1-2: Gentle Recovery              ▾       │ ║
║  │                                                  │ ║
║  │  ↻ Regenerate Schedule                          │ ║
║  └──────────────────────────────────────────────────┘ ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

## User Interaction Flow

### Step 1: Enable Reminders
```
User taps toggle → Permissions dialog appears
                 → User grants permission
                 → Time pickers appear with default values
```

### Step 2: Customize Morning Time
```
User taps "Morning Time"
                 ↓
Time picker wheel appears
                 ↓
User scrolls to desired time (e.g., 6:30 AM)
                 ↓
User taps elsewhere or "Done"
                 ↓
Time saved automatically
Schedule regenerated in background
Notifications rescheduled
```

### Step 3: Customize Evening Time
```
User taps "Evening Time"
                 ↓
Time picker wheel appears
                 ↓
User scrolls to desired time (e.g., 8:45 PM)
                 ↓
User taps elsewhere or "Done"
                 ↓
Time saved automatically
Schedule regenerated in background
Notifications rescheduled
```

## Time Picker Interaction

When user taps on a time picker, iOS presents a wheel-style picker:

```
┌──────────────────────────────────────────┐
│            Select Time                   │
├──────────────────────────────────────────┤
│                                          │
│      Hour     │     Minute               │
│      ──       │      ──                  │
│       5       │      15                  │
│       6       │   →  30  ←   Selected    │
│    →  7  ←    │      45                  │
│       8       │      00                  │
│       9       │      15                  │
│      ──       │      ──                  │
│                                          │
│              [Done]                      │
└──────────────────────────────────────────┘
```

## Schedule Impact Example

### Before Customization
```
Monday Morning Activities:
┌──────────────────────────────────────┐
│  8:00 AM - Wrist Extension Stretch  │
│  8:00 AM - Wrist Flexion Stretch    │
│  8:00 AM - Forearm Massage          │
│  8:00 AM - Ice Therapy              │
│  8:30 AM - Pain Level Check         │
└──────────────────────────────────────┘
```

### After Setting Morning to 6:30 AM
```
Monday Morning Activities:
┌──────────────────────────────────────┐
│  6:30 AM - Wrist Extension Stretch  │  ← Changed!
│  6:30 AM - Wrist Flexion Stretch    │  ← Changed!
│  6:30 AM - Forearm Massage          │  ← Changed!
│  6:30 AM - Ice Therapy              │  ← Changed!
│  7:00 AM - Pain Level Check         │  ← Changed!
└──────────────────────────────────────┘
```

## Visual States

### State 1: First Launch (Defaults)
- Reminders: OFF
- Morning Time: Hidden (default: 8:00 AM internally)
- Evening Time: Hidden (default: 7:00 PM internally)

### State 2: Reminders Enabled (No Customization)
- Reminders: ON
- Morning Time: Visible, showing 8:00 AM
- Evening Time: Visible, showing 7:00 PM

### State 3: Fully Customized
- Reminders: ON
- Morning Time: Visible, showing user's choice (e.g., 6:30 AM)
- Evening Time: Visible, showing user's choice (e.g., 8:45 PM)

### State 4: After Data Reset
- Reminders: OFF
- Morning Time: Hidden, reset to 8:00 AM
- Evening Time: Hidden, reset to 7:00 PM

## Notification Examples

### Default Times
```
📱 Tennis Elbow App
   8:00 AM
   Treatment Reminder
   Wrist Extension Stretch - 5 minutes

📱 Tennis Elbow App
   7:00 PM
   Treatment Reminder
   Wrist Extension Stretch - 5 minutes
```

### Custom Times (6:30 AM, 8:45 PM)
```
📱 Tennis Elbow App
   6:30 AM  ← Changed!
   Treatment Reminder
   Wrist Extension Stretch - 5 minutes

📱 Tennis Elbow App
   8:45 PM  ← Changed!
   Treatment Reminder
   Wrist Extension Stretch - 5 minutes
```

## Accessibility

The DatePicker components are fully accessible:
- VoiceOver announces: "Morning Time, 8 hours 0 minutes"
- Users can adjust with swipe gestures
- Large text support built-in
- High contrast support built-in

## Dark Mode Support

All UI elements support both light and dark mode:
- Time pickers use system colors
- Text remains readable
- Icons adapt to theme

## Landscape Orientation

On larger devices in landscape:
```
╔════════════════════════════════════════════════════════════════════════╗
║  ← Settings                                                            ║
╠════════════════════════════════════════════════════════════════════════╣
║  NOTIFICATIONS                      │  TREATMENT PLAN                  ║
║  ┌───────────────────────────────┐  │  ┌─────────────────────────────┐ ║
║  │ 🔔 Enable Reminders     ● ON  │  │  │ Current Plan               │ ║
║  │                               │  │  │ Week 1-2: Gentle Recovery  │ ║
║  │ Morning Time      8:00 AM     │  │  │                     ▾      │ ║
║  │ Evening Time      7:00 PM     │  │  │                            │ ║
║  │                               │  │  │ ↻ Regenerate Schedule      │ ║
║  │ ℹ Custom times active         │  │  └─────────────────────────────┘ ║
║  └───────────────────────────────┘  │                                  ║
╚════════════════════════════════════════════════════════════════════════╝
```

## User Experience Flow Summary

1. **Discovery**: User navigates to Settings, sees reminder toggle
2. **Enable**: User enables reminders, time pickers appear
3. **Customize**: User adjusts times to personal preference
4. **Automatic Save**: Changes save immediately on selection
5. **Visual Feedback**: Schedule updates reflect new times
6. **Persistence**: Times remain on app restart
7. **Reset Option**: Clear All Data returns to defaults

This implementation provides a native iOS experience that feels familiar and intuitive to users.

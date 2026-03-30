# Tennis Elbow App — Improvement Backlog

| # | Task | Status | Blocked By |
|---|------|--------|------------|
| 1 | Extract shared UI components (PainLevelPicker, WeightPicker) | completed | — |
| 2 | Customizable afternoon reminder time | pending | — |
| 3 | Prune old scheduled activities | pending | — |
| 4 | Fix UI test stability (replace sleep() with waitForExistence) | pending | — |
| 5 | Data export (CSV / PDF) | pending | — |
| 6 | Customizable treatment plans (edit existing + create from scratch) | pending | — |
| 7 | iCloud / CloudKit sync | pending | — |
| 8 | Home screen widget (WidgetKit) | pending | #7 |
| 9 | Apple Watch companion app | pending | #7 |

## Details

### 1 — Extract shared UI components
Refactor duplicated `PainLevelSheet` and `WeightPickerSheet` out of `TreatmentPlanView.swift` and `ScheduleView.swift` into shared reusable components in a new `SharedComponents.swift`.

### 2 — Customizable afternoon reminder time
Afternoon reminder time is hardcoded to 2pm in `TreatmentManager.swift`. Add a user-configurable afternoon time alongside the existing morning/evening pickers in `SettingsView`.

### 3 — Prune old scheduled activities
`scheduledActivities` in `UserDefaults` grows unbounded. Add cleanup logic in `TreatmentManager` to remove completed activities older than 90 days.

### 4 — Fix UI test stability
`TennisElbowUITests.swift` uses `sleep()` calls throughout which are fragile. Replace with `XCTWaiter` / `waitForExistence(timeout:)` for reliable test execution.

### 5 — Data export (CSV / PDF)
Add ability to export pain history and activity completion data. CSV is the priority; PDF is a stretch goal. Add export option in `SettingsView` or `ProgressView`.

### 6 — Customizable treatment plans
Allow users to edit the built-in treatment plans (modify activities, durations, schedules) and create entirely new plans from scratch. Requires new data model changes and new UI for plan/activity editing.

### 7 — iCloud / CloudKit sync
Migrate data storage from `UserDefaults` to CloudKit so users can restore data after reinstalling and sync across devices (iPhone + iPad). Requires schema design and conflict resolution strategy.

### 8 — Home screen widget (WidgetKit)
Add a WidgetKit target showing today's next activity and completion progress on the home screen. Requires App Group setup for shared data access between app and widget. **Blocked by #7.**

### 9 — Apple Watch companion app
Add a WatchKit target supporting: viewing today's activities, marking activities complete, and logging pain level and weight from the wrist. Use WatchConnectivity or shared CloudKit. **Blocked by #7.**

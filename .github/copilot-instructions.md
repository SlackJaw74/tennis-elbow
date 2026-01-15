# GitHub Copilot Instructions for Tennis Elbow Treatment App

## Project Overview

This is an iOS health application built with SwiftUI to help users manage and track tennis elbow (lateral epicondylitis) recovery. The app provides structured treatment plans, scheduling, pain tracking, and progress monitoring.

**Technology Stack:**
- Language: Swift 5.7+
- Framework: SwiftUI
- Minimum iOS: 16.0+ (for Charts framework)
- Build Tool: Xcode 14.0+

## Project Structure

```
TennisElbow/
├── Models/              # Data models (TreatmentActivity, ScheduledActivity, TreatmentPlan)
├── ViewModels/          # Business logic (TreatmentManager)
├── Views/               # SwiftUI views (TreatmentPlanView, ScheduleView, ProgressView, etc.)
├── Assets.xcassets/     # App assets (images, colors)
└── PrivacyInfo.xcprivacy
```

## Coding Standards

### Swift Style

- **Indentation:** Use 4 spaces (no tabs)
- **Line Length:** Maximum 120 characters (warning), 150 absolute maximum
- **File Length:** Keep files under 500 lines (warning at 500, error at 1000)
- **Function Length:** Keep functions under 50 lines (warning at 50, error at 100)

### SwiftUI Conventions

- Use SwiftUI declarative syntax for all UI components
- Prefer `@StateObject` for view model initialization, `@ObservedObject` for passed-in objects
- Use `@State` for view-local state, `@Binding` for two-way bindings
- Follow implicit return style for single-expression closures and computed properties
- Use trailing closure syntax when the last parameter is a closure

### Naming Conventions

- **Variables/Functions:** camelCase (e.g., `treatmentManager`, `scheduledActivities`)
- **Types/Protocols:** PascalCase (e.g., `TreatmentActivity`, `TreatmentManager`)
- **Constants:** camelCase (e.g., `defaultScheduleTime`)
- Avoid single-letter variable names except for standard loop counters (i, j) or coordinates (x, y)
- Use meaningful, descriptive names (minimum 2 characters)

### Code Quality Rules

- **NO force unwrapping** (`!`) - Always use safe unwrapping with `if let`, `guard let`, or optional chaining
- **NO implicit `any`** - Always specify types explicitly
- **NO empty strings** - Use `.isEmpty` instead of `== ""`
- Prefer `first(where:)` over `filter().first`
- Use `toggle()` instead of `variable = !variable`
- Avoid Yoda conditions - write `value == constant`, not `constant == value`
- Include error messages with `fatalError()` calls
- Avoid optional booleans and optional collections when possible

### Comments and Documentation

- Add clear comments for complex business logic
- Document public APIs with doc comments (`///`)
- TODOs are acceptable during development
- Keep comments concise and meaningful

## Build and Test Commands

### Linting

```bash
# Run SwiftLint
cd TennisElbow
swiftlint lint

# Auto-format with SwiftFormat
cd TennisElbow
swiftformat .

# Check formatting without changes
cd TennisElbow
swiftformat --lint .
```

### Building

```bash
# Build for simulator
# Note: Replace "iPhone 15" with any available simulator from 'xcrun simctl list devices'
xcodebuild \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 15" \
  clean build

# Using Makefile (default device: iPhone 16e, customizable via DEVICE variable)
make sim-run

# Build with custom device
make sim-run DEVICE="iPhone 15 Pro"

# List available simulators
make device-list
```

### Testing

```bash
# Run UI tests
# Note: Replace "iPhone 15" with any available simulator from 'xcrun simctl list devices'
xcodebuild test \
  -project "TennisElbow/TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 15" \
  -enableCodeCoverage YES

# List available simulators
xcrun simctl list devices
```

## Code Review Requirements

- All code must pass SwiftLint checks (no warnings or errors)
- Code must be formatted with SwiftFormat
- UI tests must pass
- No force unwrapping or unsafe code patterns
- Follow existing architectural patterns (MVVM with SwiftUI)
- **Before creating a PR:** Always run linting, formatting, and build checks to ensure CI will pass:
  ```bash
  cd TennisElbow
  swiftlint lint
  swiftformat --lint .
  # Build to verify no compilation errors
  xcodebuild -project "TennisElbow.xcodeproj" -scheme "TennisElbow" -configuration Debug -sdk iphonesimulator clean build
  ```

## Medical Disclaimer Requirement

This app provides health-related guidance. Always include and maintain the medical disclaimer:
- The app is for informational purposes only
- Not a substitute for professional medical advice
- Users should consult healthcare providers before starting treatment

## Privacy and Security

- All data is stored locally on device (no remote servers)
- No user tracking or analytics
- Respect iOS privacy requirements (PrivacyInfo.xcprivacy)
- No collection of personal health data beyond local device storage

## Git and Pull Request Guidelines

- PRs must pass all CI checks (SwiftLint, Build, Tests, SwiftFormat)
- Keep commits focused and atomic
- Write clear commit messages
- Code owner: @slackjaw74

## Special Considerations

- **iOS 16.0+ Required:** Use Charts framework for pain tracking visualization
- **Notifications:** Handle notification permissions gracefully
- **SwiftUI Lifecycle:** App uses SwiftUI App lifecycle (no UIKit AppDelegate)
- **Data Persistence:** Uses SwiftData/UserDefaults for local storage
- **Accessibility:** Consider VoiceOver and accessibility features when adding UI components

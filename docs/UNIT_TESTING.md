# TennisElbowTests - Unit Test Suite

This directory contains unit tests for the TennisElbow iOS application.

## Overview

The `TennisElbowTests` target is a unit test bundle that tests the core business logic of the application, specifically the `TreatmentManager` class which handles treatment plan management, scheduling, and progress tracking.

## Test Coverage

The test suite includes comprehensive tests for:

### Initialization Tests
- Default values and initial state
- Custom reminder times initialization

### Completion Rate Tests
- Overall completion rate calculation
- Weekly completion rate calculation
- Edge cases (no activities, all completed, partial completion)

### Pain Tracking Tests
- Pain history tracking
- Average pain level calculation
- Pain trend analysis

### Weight Tracking Tests
- Weight progress history
- Average weight calculation for exercises

### Activity Management Tests
- Completing and uncompleting activities
- Getting today's activities
- Getting upcoming activities
- Schedule generation and regeneration
- Preserving completed activities during regeneration

### Plan Management Tests
- Changing treatment plans
- Auto-advancement to next stage
- Handling last stage edge case

### Data Management Tests
- Clearing all data
- Custom reminder time persistence

### Stage Advancement Tests
- User acceptance of advancement
- User decline of advancement
- Advancement prompt logic

## Running the Tests

### From Xcode
1. Open `TennisElbow.xcodeproj`
2. Select the `TennisElbowTests` scheme
3. Press `Cmd+U` to run all tests

### From Command Line
```bash
xcodebuild test \
  -project "TennisElbow.xcodeproj" \
  -scheme "TennisElbow" \
  -destination "platform=iOS Simulator,name=iPhone 15" \
  -only-testing:TennisElbowTests
```

## Test Structure

All tests use `@MainActor` annotation because `TreatmentManager` is a `@MainActor` class. This ensures tests run on the main thread, matching the production environment.

### Setup and Teardown
- `setUp()`: Creates a fresh `TreatmentManager` instance and clears all data
- `tearDown()`: Cleans up the test environment

### Test Naming Convention
Tests follow the pattern: `test<MethodName>With<Condition>()`
- Example: `testGetCompletionRateWithNoActivities()`
- Example: `testGetAveragePainLevelWithData()`

## Technical Details

- **Target Type**: Unit Test Bundle (`com.apple.product-type.bundle.unit-test`)
- **Bundle ID**: `com.madhouse.TennisElbowTests`
- **Test Host**: TennisElbow.app
- **Minimum iOS**: 16.0
- **Swift Version**: 5.0

## Notes

- Tests use `XCTest` framework
- All tests are async-capable with `async throws` methods
- Tests use `@testable import TennisElbow` to access internal members
- UserDefaults are used for persistence testing (tests clean up after themselves)

## Future Enhancements

Consider adding tests for:
- Notification scheduling logic
- Edge cases in date calculations
- Concurrent modification scenarios
- Performance tests for large datasets

//
//  TennisElbowUITests.swift
//  TennisElbowUITests
//
//  Created by Ben Wilson on 12/29/25.
//

import XCTest

final class TennisElbowUITests: XCTestCase {

    var app: XCUIApplication!

    @MainActor
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests
        // before they run. The setUp method is a good place to do this.

        app = XCUIApplication()
        setupSnapshot(app)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testScreenshots() throws {

        // Force portrait orientation
        XCUIDevice.shared.orientation = .portrait

        app.launch()

        // Ensure portrait orientation after launch
        XCUIDevice.shared.orientation = .portrait
        sleep(1)

        // Screenshot 1: Disclaimer View (initial launch)
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            snapshot("01-Disclaimer")
            sleep(1)
            acceptButton.tap()
            sleep(2)
        }

        // Wait for tab bar to be ready
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Tab bar should exist before taking screenshots")
        sleep(1)

        // Screenshot 2: Treatment Plan View (already on this view after disclaimer)
        snapshot("02-Treatment")
        sleep(1)

        // Screenshot 3: Schedule View - tap second tab
        let allTabButtons = tabBar.buttons.allElementsBoundByIndex
        XCTAssertGreaterThanOrEqual(allTabButtons.count, 4, "Expected 4 tabs to be present")
        
        allTabButtons[1].tap()
        sleep(2)
        snapshot("03-Schedule")

        // Screenshot 4: Progress View - tap third tab
        allTabButtons[2].tap()
        sleep(2)
        snapshot("04-Progress")

        // Screenshot 5: Settings View - tap fourth tab
        allTabButtons[3].tap()
        sleep(2)
        snapshot("05-Settings")
    }

    @MainActor
    func testAllViewsExist() throws {
        app.launch()

        // Handle the disclaimer if it appears
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            acceptButton.tap()
            sleep(2) // Wait for transition to complete
        }

        // Wait for tab bar to appear
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Tab bar should exist")

        // Verify all main tabs exist (using index since labels are localized)
        let treatmentTab = app.tabBars.buttons.element(boundBy: 0)
        let scheduleTab = app.tabBars.buttons.element(boundBy: 1)
        let progressTab = app.tabBars.buttons.element(boundBy: 2)
        let settingsTab = app.tabBars.buttons.element(boundBy: 3)

        XCTAssertTrue(treatmentTab.exists, "Treatment tab should exist")
        XCTAssertTrue(scheduleTab.exists, "Schedule tab should exist")
        XCTAssertTrue(progressTab.exists, "Progress tab should exist")
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")

        // Test navigation to all views
        scheduleTab.tap()
        sleep(1)
        progressTab.tap()
        sleep(1)
        settingsTab.tap()
        sleep(1)
        treatmentTab.tap()
        sleep(1)
    }

    @MainActor
    func testExample() throws {

        let app = XCUIApplication()
        app.launch()

        // Handle the disclaimer if it appears
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            acceptButton.tap()
            sleep(1)
        }

        // Tab indices: 0=Treatment, 1=Schedule, 2=Progress, 3=Settings
        let treatmentTab = app.tabBars.buttons.element(boundBy: 0)
        let scheduleTab = app.tabBars.buttons.element(boundBy: 1)
        let progressTab = app.tabBars.buttons.element(boundBy: 2)
        let settingsTab = app.tabBars.buttons.element(boundBy: 3)

        // Verify we're on the Treatment tab
        XCTAssertTrue(treatmentTab.exists, "Treatment tab should exist")

        // Navigate to Schedule tab
        XCTAssertTrue(scheduleTab.exists, "Schedule tab should exist")
        scheduleTab.tap()
        sleep(1)

        // Navigate to Progress tab
        XCTAssertTrue(progressTab.exists, "Progress tab should exist")
        progressTab.tap()
        sleep(1)

        // Navigate to Settings tab
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        settingsTab.tap()
        sleep(1)

        // Navigate back to Treatment to verify full cycle
        treatmentTab.tap()
        sleep(1)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    @MainActor
    func testCustomReminderTimes() throws {
        app.launch()

        // Handle the disclaimer if it appears
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            acceptButton.tap()
            sleep(1)
        }

        // Navigate to Settings tab (index 3)
        let settingsTab = app.tabBars.buttons.element(boundBy: 3)
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        settingsTab.tap()
        sleep(1)

        // Verify reminder toggle exists
        let reminderToggle = app.switches["Enable Reminders"]
        XCTAssertTrue(reminderToggle.exists, "Reminder toggle should exist")

        // If reminders are off, turn them on
        if reminderToggle.value as? String == "0" {
            reminderToggle.tap()
            sleep(2) // Wait for UI to update
        }

        // Verify time pickers appear when reminders are enabled
        // Count date pickers - should be 2 when enabled
        let datePickersEnabled = app.datePickers.count
        XCTAssertEqual(datePickersEnabled, 2, "Should have 2 date pickers when reminders are enabled")

        // Turn off reminders
        reminderToggle.tap()
        sleep(2) // Wait for UI to update

        // Verify time pickers are hidden when reminders are disabled
        let datePickersDisabled = app.datePickers.count
        XCTAssertEqual(datePickersDisabled, 0, "Should have 0 date pickers when reminders are disabled")
    }
}

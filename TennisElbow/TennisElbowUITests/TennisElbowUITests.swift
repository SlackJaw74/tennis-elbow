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

        // Screenshot 0: Disclaimer View (initial launch)
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            snapshot("00-Disclaimer")
            sleep(1)
            acceptButton.tap()
            sleep(2)
        }

        // Screenshot 1: Treatment Plan View
        snapshot("01-TreatmentPlan")
        sleep(1)

        // Screenshot 2: Schedule View
        let scheduleTab = app.tabBars.buttons["Schedule"]
        XCTAssertTrue(scheduleTab.exists, "Schedule tab should exist")
        scheduleTab.tap()
        sleep(2)
        snapshot("02-Schedule")

        // Screenshot 3: Progress View
        let progressTab = app.tabBars.buttons["Progress"]
        XCTAssertTrue(progressTab.exists, "Progress tab should exist")
        progressTab.tap()
        sleep(2)
        snapshot("03-Progress")

        // Screenshot 4: Settings View
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        settingsTab.tap()
        sleep(2)
        snapshot("04-Settings")

        // Screenshot 5: Medical Sources View (from Settings)
        let medicalSourcesLink = app.buttons["Medical Sources & Citations"]
        if medicalSourcesLink.waitForExistence(timeout: 3) {
            medicalSourcesLink.tap()
            sleep(2)
            snapshot("05-MedicalSources")

            // Go back to Settings
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                sleep(1)
            }
        }

        // Screenshot 6: Disclaimer from Settings
        let disclaimerButton = app.buttons["Medical Disclaimer"]
        if disclaimerButton.waitForExistence(timeout: 3) {
            disclaimerButton.tap()
            sleep(2)
            snapshot("06-DisclaimerFromSettings")

            // Check for Medical Sources link in disclaimer
            let medicalSourcesCitation = app.links["View All Medical Sources & Citations"]
            if medicalSourcesCitation.waitForExistence(timeout: 3) {
                medicalSourcesCitation.tap()
                sleep(2)
                snapshot("07-MedicalSourcesFromDisclaimer")

                // Go back
                let backButton = app.navigationBars.buttons.element(boundBy: 0)
                if backButton.exists {
                    backButton.tap()
                    sleep(1)
                }
            }

            // Close disclaimer sheet
            let closeButton = app.buttons["Close"]
            if closeButton.exists {
                closeButton.tap()
                sleep(1)
            }
        }

        // Navigate back to Treatment to show activity details
        let treatmentTab = app.tabBars.buttons["Treatment"]
        treatmentTab.tap()
        sleep(2)

        // Screenshot 8: Activity Detail View
        let cells = app.collectionViews.cells
        // swiftlint:disable:next empty_count
        if cells.count > 0 {
            cells.element(boundBy: 0).tap()
            sleep(2)
            snapshot("08-ActivityDetail")
        }
    }

    @MainActor
    func testAllViewsExist() throws {
        app.launch()

        // Handle the disclaimer if it appears
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
            acceptButton.tap()
            sleep(1)
        }

        // Verify all main tabs exist
        XCTAssertTrue(app.tabBars.buttons["Treatment"].exists, "Treatment tab should exist")
        XCTAssertTrue(app.tabBars.buttons["Schedule"].exists, "Schedule tab should exist")
        XCTAssertTrue(app.tabBars.buttons["Progress"].exists, "Progress tab should exist")
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists, "Settings tab should exist")

        // Test navigation to all views
        app.tabBars.buttons["Schedule"].tap()
        sleep(1)
        app.tabBars.buttons["Progress"].tap()
        sleep(1)
        app.tabBars.buttons["Settings"].tap()
        sleep(1)
        app.tabBars.buttons["Treatment"].tap()
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

        // Verify we're on the Treatment tab
        let treatmentTab = app.tabBars.buttons["Treatment"]
        XCTAssertTrue(treatmentTab.exists, "Treatment tab should exist")

        // Navigate to Schedule tab
        let scheduleTab = app.tabBars.buttons["Schedule"]
        XCTAssertTrue(scheduleTab.exists, "Schedule tab should exist")
        scheduleTab.tap()
        sleep(1)

        // Navigate to Progress tab
        let progressTab = app.tabBars.buttons["Progress"]
        XCTAssertTrue(progressTab.exists, "Progress tab should exist")
        progressTab.tap()
        sleep(1)

        // Navigate to Settings tab
        let settingsTab = app.tabBars.buttons["Settings"]
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

        // Navigate to Settings tab
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        settingsTab.tap()
        sleep(1)

        // Verify reminder toggle exists
        let reminderToggle = app.switches["Enable Reminders"]
        XCTAssertTrue(reminderToggle.exists, "Reminder toggle should exist")

        // If reminders are off, turn them on
        if reminderToggle.value as? String == "0" {
            reminderToggle.tap()
            sleep(1)
        }

        // Verify time pickers appear when reminders are enabled
        let morningTimePicker = app.datePickers.matching(identifier: "Morning Time").element
        let eveningTimePicker = app.datePickers.matching(identifier: "Evening Time").element

        XCTAssertTrue(morningTimePicker.exists, "Morning time picker should exist when reminders are enabled")
        XCTAssertTrue(eveningTimePicker.exists, "Evening time picker should exist when reminders are enabled")

        // Turn off reminders
        reminderToggle.tap()
        sleep(1)

        // Verify time pickers are hidden when reminders are disabled
        XCTAssertFalse(morningTimePicker.exists, "Morning time picker should be hidden when reminders are disabled")
        XCTAssertFalse(eveningTimePicker.exists, "Evening time picker should be hidden when reminders are disabled")
    }
}

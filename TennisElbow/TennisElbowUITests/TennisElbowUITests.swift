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

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
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
        
        // Handle the disclaimer if it appears
        let acceptButton = app.buttons["Accept and Continue"]
        if acceptButton.waitForExistence(timeout: 5) {
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
        
        // Navigate back to Treatment to show activity details
        let treatmentTab = app.tabBars.buttons["Treatment"]
        treatmentTab.tap()
        sleep(2)
        
        // Try to tap on first activity cell if it exists
        let cells = app.collectionViews.cells
        if cells.count > 0 {
            cells.element(boundBy: 0).tap()
            sleep(2)
            snapshot("05-ActivityDetail")
        }
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
}

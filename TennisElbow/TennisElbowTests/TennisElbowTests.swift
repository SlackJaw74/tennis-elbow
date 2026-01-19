import XCTest
@testable import TennisElbow

@MainActor
final class TennisElbowTests: XCTestCase {
    var treatmentManager: TreatmentManager!

    override func setUp() async throws {
        try await super.setUp()
        treatmentManager = TreatmentManager()
        // Clear any existing data before each test
        treatmentManager.clearAllData()
    }

    override func tearDown() async throws {
        treatmentManager = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialization() {
        XCTAssertNotNil(treatmentManager)
        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, 1)
        XCTAssertFalse(treatmentManager.notificationsEnabled)
        XCTAssertFalse(treatmentManager.showAdvancementPrompt)
    }

    func testDefaultReminderTimes() {
        let calendar = Calendar.current
        let morningHour = calendar.component(.hour, from: treatmentManager.morningReminderTime)
        let morningMinute = calendar.component(.minute, from: treatmentManager.morningReminderTime)
        let eveningHour = calendar.component(.hour, from: treatmentManager.eveningReminderTime)
        let eveningMinute = calendar.component(.minute, from: treatmentManager.eveningReminderTime)

        XCTAssertEqual(morningHour, 8)
        XCTAssertEqual(morningMinute, 0)
        XCTAssertEqual(eveningHour, 19)
        XCTAssertEqual(eveningMinute, 0)
    }

    // MARK: - Completion Rate Tests

    func testGetCompletionRateWithNoActivities() {
        treatmentManager.scheduledActivities.removeAll()
        let rate = treatmentManager.getCompletionRate()
        XCTAssertEqual(rate, 0.0)
    }

    func testGetCompletionRateWithAllCompleted() {
        treatmentManager.generateSchedule()
        // Complete all activities
        for scheduledActivity in treatmentManager.scheduledActivities {
            treatmentManager.completeActivity(scheduledActivity)
        }
        let rate = treatmentManager.getCompletionRate()
        XCTAssertEqual(rate, 1.0)
    }

    func testGetCompletionRateWithPartialCompletion() {
        treatmentManager.generateSchedule()
        let totalCount = treatmentManager.scheduledActivities.count
        guard totalCount > 0 else {
            XCTFail("No activities generated")
            return
        }

        // Complete half of the activities
        let halfCount = totalCount / 2
        for index in 0 ..< halfCount {
            treatmentManager.completeActivity(treatmentManager.scheduledActivities[index])
        }

        let rate = treatmentManager.getCompletionRate()
        let expectedRate = Double(halfCount) / Double(totalCount)
        XCTAssertEqual(rate, expectedRate, accuracy: 0.01)
    }

    // MARK: - Weekly Completion Rate Tests

    func testGetWeeklyCompletionRateWithNoActivities() {
        treatmentManager.scheduledActivities.removeAll()
        let rate = treatmentManager.getWeeklyCompletionRate()
        XCTAssertEqual(rate, 0.0)
    }

    func testGetWeeklyCompletionRateWithRecentActivities() {
        treatmentManager.generateSchedule()
        let calendar = Calendar.current
        let today = Date()

        // Complete activities from the past week
        let weekActivities = treatmentManager.scheduledActivities.filter {
            let daysAgo = calendar.dateComponents([.day], from: $0.scheduledTime, to: today).day ?? 0
            return daysAgo >= -7 && daysAgo <= 0
        }

        guard !weekActivities.isEmpty else {
            XCTFail("No activities in the past week")
            return
        }

        // Complete half of the week's activities
        let halfCount = weekActivities.count / 2
        for index in 0 ..< halfCount {
            treatmentManager.completeActivity(weekActivities[index])
        }

        let rate = treatmentManager.getWeeklyCompletionRate()
        XCTAssertGreaterThan(rate, 0.0)
        XCTAssertLessThanOrEqual(rate, 1.0)
    }

    // MARK: - Pain Tracking Tests

    func testGetPainHistoryWithNoData() {
        treatmentManager.scheduledActivities.removeAll()
        let history = treatmentManager.getPainHistory(days: 30)
        XCTAssertTrue(history.isEmpty)
    }

    func testGetPainHistoryWithCompletedActivities() {
        treatmentManager.generateSchedule()
        guard let firstActivity = treatmentManager.scheduledActivities.first else {
            XCTFail("No activities available")
            return
        }

        treatmentManager.completeActivity(firstActivity, painLevel: .mild)

        let history = treatmentManager.getPainHistory(days: 30)
        XCTAssertGreaterThan(history.count, 0)
    }

    func testGetAveragePainLevelWithNoData() {
        treatmentManager.scheduledActivities.removeAll()
        let average = treatmentManager.getAveragePainLevel()
        XCTAssertNil(average)
    }

    func testGetAveragePainLevelWithData() {
        treatmentManager.generateSchedule()
        guard treatmentManager.scheduledActivities.count >= 2 else {
            XCTFail("Not enough activities")
            return
        }

        treatmentManager.completeActivity(treatmentManager.scheduledActivities[0], painLevel: .mild)
        treatmentManager.completeActivity(treatmentManager.scheduledActivities[1], painLevel: .moderate)

        let average = treatmentManager.getAveragePainLevel()
        XCTAssertNotNil(average)
        if let avg = average {
            XCTAssertEqual(avg, 1.5, accuracy: 0.01)
        }
    }

    func testGetPainTrendWithInsufficientData() {
        treatmentManager.scheduledActivities.removeAll()
        let trend = treatmentManager.getPainTrend()
        XCTAssertEqual(trend, "Not enough data")
    }

    // MARK: - Weight Tracking Tests

    func testGetWeightProgressHistoryWithNoData() {
        treatmentManager.scheduledActivities.removeAll()
        let history = treatmentManager.getWeightProgressHistory(days: 30)
        XCTAssertTrue(history.isEmpty)
    }

    func testGetAverageWeightWithNoData() {
        treatmentManager.scheduledActivities.removeAll()
        let average = treatmentManager.getAverageWeight()
        XCTAssertNil(average)
    }

    func testGetAverageWeightWithData() {
        treatmentManager.generateSchedule()
        // Find exercise activities
        let exerciseActivities = treatmentManager.scheduledActivities.filter {
            $0.activity.type == .exercise
        }

        guard exerciseActivities.count >= 2 else {
            XCTFail("Not enough exercise activities")
            return
        }

        treatmentManager.completeActivity(exerciseActivities[0], weightUsedLbs: 5)
        treatmentManager.completeActivity(exerciseActivities[1], weightUsedLbs: 10)

        let average = treatmentManager.getAverageWeight()
        XCTAssertNotNil(average)
        if let avg = average {
            XCTAssertEqual(avg, 7.5, accuracy: 0.01)
        }
    }

    // MARK: - Activity Management Tests

    func testCompleteActivity() {
        treatmentManager.generateSchedule()
        guard let firstActivity = treatmentManager.scheduledActivities.first else {
            XCTFail("No activities available")
            return
        }

        XCTAssertFalse(firstActivity.isCompleted)

        treatmentManager.completeActivity(firstActivity, notes: "Test note", painLevel: .mild)

        if let updated = treatmentManager.scheduledActivities.first(where: { $0.id == firstActivity.id }) {
            XCTAssertTrue(updated.isCompleted)
            XCTAssertNotNil(updated.completedTime)
            XCTAssertEqual(updated.notes, "Test note")
            XCTAssertEqual(updated.painLevel, .mild)
        } else {
            XCTFail("Could not find updated activity")
        }
    }

    func testUncompleteActivity() {
        treatmentManager.generateSchedule()
        guard let firstActivity = treatmentManager.scheduledActivities.first else {
            XCTFail("No activities available")
            return
        }

        treatmentManager.completeActivity(firstActivity)
        treatmentManager.uncompleteActivity(firstActivity)

        if let updated = treatmentManager.scheduledActivities.first(where: { $0.id == firstActivity.id }) {
            XCTAssertFalse(updated.isCompleted)
            XCTAssertNil(updated.completedTime)
        } else {
            XCTFail("Could not find updated activity")
        }
    }

    func testGetTodayActivities() {
        treatmentManager.generateSchedule()
        let todayActivities = treatmentManager.getTodayActivities()

        let calendar = Calendar.current
        for activity in todayActivities {
            XCTAssertTrue(calendar.isDateInToday(activity.scheduledTime))
        }
    }

    func testGetUpcomingActivities() {
        treatmentManager.generateSchedule()
        let upcomingActivities = treatmentManager.getUpcomingActivities(limit: 5)

        XCTAssertLessThanOrEqual(upcomingActivities.count, 5)

        let now = Date()
        for activity in upcomingActivities {
            XCTAssertGreaterThan(activity.scheduledTime, now)
            XCTAssertFalse(activity.isCompleted)
        }
    }

    // MARK: - Plan Management Tests

    func testChangePlan() {
        let initialPlan = treatmentManager.currentPlan
        let nextPlan = TreatmentPlan.defaultPlans[1]

        treatmentManager.changePlan(to: nextPlan)

        XCTAssertNotEqual(treatmentManager.currentPlan.id, initialPlan.id)
        XCTAssertEqual(treatmentManager.currentPlan.id, nextPlan.id)
    }

    func testAdvanceToNextStage() {
        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, 1)

        treatmentManager.advanceToNextStage()

        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, 3)
    }

    func testAdvanceToNextStageAtLastStage() {
        // Set to the last plan
        let lastPlan = TreatmentPlan.defaultPlans.last!
        treatmentManager.changePlan(to: lastPlan)

        let currentWeek = treatmentManager.currentPlan.weekNumber
        treatmentManager.advanceToNextStage()

        // Should remain at the same plan
        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, currentWeek)
    }

    // MARK: - Schedule Generation Tests

    func testGenerateSchedule() {
        treatmentManager.scheduledActivities.removeAll()
        XCTAssertEqual(treatmentManager.scheduledActivities.count, 0)

        treatmentManager.generateSchedule()

        XCTAssertGreaterThan(treatmentManager.scheduledActivities.count, 0)
    }

    func testGenerateSchedulePreservesCompletedActivities() {
        treatmentManager.generateSchedule()
        guard let firstActivity = treatmentManager.scheduledActivities.first else {
            XCTFail("No activities available")
            return
        }

        treatmentManager.completeActivity(firstActivity)
        let completedId = firstActivity.id

        treatmentManager.generateSchedule()

        // The completed activity should still exist
        let completedActivity = treatmentManager.scheduledActivities.first(where: { $0.id == completedId })
        XCTAssertNotNil(completedActivity)
        XCTAssertTrue(completedActivity?.isCompleted ?? false)
    }

    // MARK: - Clear Data Tests

    func testClearAllData() {
        treatmentManager.generateSchedule()
        guard let firstActivity = treatmentManager.scheduledActivities.first else {
            XCTFail("No activities available")
            return
        }

        treatmentManager.completeActivity(firstActivity)
        XCTAssertGreaterThan(treatmentManager.scheduledActivities.count, 0)

        treatmentManager.clearAllData()

        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, 1)
        XCTAssertFalse(treatmentManager.showAdvancementPrompt)

        let calendar = Calendar.current
        let morningHour = calendar.component(.hour, from: treatmentManager.morningReminderTime)
        let eveningHour = calendar.component(.hour, from: treatmentManager.eveningReminderTime)
        XCTAssertEqual(morningHour, 8)
        XCTAssertEqual(eveningHour, 19)
    }

    // MARK: - Custom Reminder Time Tests

    func testSaveCustomReminderTimes() {
        let calendar = Calendar.current
        let customMorning = calendar.date(from: DateComponents(hour: 7, minute: 30)) ?? Date()
        let customEvening = calendar.date(from: DateComponents(hour: 20, minute: 15)) ?? Date()

        treatmentManager.morningReminderTime = customMorning
        treatmentManager.eveningReminderTime = customEvening
        treatmentManager.saveCustomReminderTimes()

        let morningHour = calendar.component(.hour, from: treatmentManager.morningReminderTime)
        let morningMinute = calendar.component(.minute, from: treatmentManager.morningReminderTime)
        let eveningHour = calendar.component(.hour, from: treatmentManager.eveningReminderTime)
        let eveningMinute = calendar.component(.minute, from: treatmentManager.eveningReminderTime)

        XCTAssertEqual(morningHour, 7)
        XCTAssertEqual(morningMinute, 30)
        XCTAssertEqual(eveningHour, 20)
        XCTAssertEqual(eveningMinute, 15)
    }

    // MARK: - Stage Advancement Tests

    func testUserAcceptedAdvancement() {
        treatmentManager.showAdvancementPrompt = true
        let initialWeek = treatmentManager.currentPlan.weekNumber

        treatmentManager.userAcceptedAdvancement()

        XCTAssertFalse(treatmentManager.showAdvancementPrompt)
        XCTAssertNotEqual(treatmentManager.currentPlan.weekNumber, initialWeek)
    }

    func testUserDeclinedAdvancement() {
        treatmentManager.showAdvancementPrompt = true
        let initialPlanStartDate = treatmentManager.currentPlanStartDate
        let currentWeek = treatmentManager.currentPlan.weekNumber

        treatmentManager.userDeclinedAdvancement()

        XCTAssertFalse(treatmentManager.showAdvancementPrompt)
        XCTAssertEqual(treatmentManager.currentPlan.weekNumber, currentWeek)
        XCTAssertGreaterThan(treatmentManager.currentPlanStartDate, initialPlanStartDate)
    }

    func testPromptForAdvancementAtLastStage() {
        let lastPlan = TreatmentPlan.defaultPlans.last!
        treatmentManager.changePlan(to: lastPlan)

        treatmentManager.promptForAdvancement()

        // Should not show prompt at last stage
        XCTAssertFalse(treatmentManager.showAdvancementPrompt)
    }
}

import Foundation
import Combine
import UserNotifications
import SwiftUI

@MainActor
class TreatmentManager: ObservableObject {
    @Published var currentPlan: TreatmentPlan
    @Published var scheduledActivities: [ScheduledActivity] = []
    @Published var allActivities: [TreatmentActivity] = TreatmentActivity.defaultActivities
    @Published var startDate: Date
    @Published var currentPlanStartDate: Date
    @Published var notificationsEnabled: Bool = false
    private var hasAutoAdvanced = false
    
    init() {
        self.currentPlan = TreatmentPlan.defaultPlans[0]
        self.startDate = Date()
        self.currentPlanStartDate = Date()
        loadScheduledActivities()
        loadPlanStartDate()
        checkNotificationPermissions()
    }
    
    func changePlan(to plan: TreatmentPlan) {
        currentPlan = plan
        currentPlanStartDate = Date()
        savePlanStartDate()
        hasAutoAdvanced = false
        generateSchedule()
        saveScheduledActivities()
    }
    
    func generateSchedule(from date: Date = Date()) {
        // Preserve existing completed activities and their data
        // Remove only incomplete activities
        scheduledActivities.removeAll { !$0.isCompleted }
        
        let calendar = Calendar.current
        let startOfWeek = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date)
        
        guard let weekStart = calendar.date(from: startOfWeek) else { return }
        
        for day in 0..<7 {
            guard let currentDate = calendar.date(byAdding: .day, value: day, to: weekStart),
                  let dayOfWeek = DayOfWeek(rawValue: calendar.component(.weekday, from: currentDate)),
                  let timesOfDay = currentPlan.dailySchedule[dayOfWeek] else {
                continue
            }
            
            for timeOfDay in timesOfDay {
                // Schedule regular activities (excluding Pain Level Check)
                for activity in currentPlan.activities where activity.type != .painTracking {
                    var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                    components.hour = timeOfDay.defaultHour
                    components.minute = 0
                    
                    if let scheduledTime = calendar.date(from: components) {
                        let scheduled = ScheduledActivity(
                            activity: activity,
                            scheduledTime: scheduledTime
                        )
                        scheduledActivities.append(scheduled)
                    }
                }
                
                // Add Pain Level Check at the end of each session
                if let painActivity = currentPlan.activities.first(where: { $0.type == .painTracking }) {
                    var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                    components.hour = timeOfDay.defaultHour
                    components.minute = 30 // Schedule 30 minutes after session start
                    
                    if let scheduledTime = calendar.date(from: components) {
                        let scheduled = ScheduledActivity(
                            activity: painActivity,
                            scheduledTime: scheduledTime
                        )
                        scheduledActivities.append(scheduled)
                    }
                }
            }
        }
        
        scheduledActivities.sort { $0.scheduledTime < $1.scheduledTime }
        saveScheduledActivities()
        
        if notificationsEnabled {
            scheduleNotifications()
        }
    }
    
    func completeActivity(_ scheduledActivity: ScheduledActivity, notes: String? = nil, painLevel: PainLevel? = nil, weightUsedLbs: Int? = nil) {
        if let index = scheduledActivities.firstIndex(where: { $0.id == scheduledActivity.id }) {
            scheduledActivities[index].isCompleted = true
            scheduledActivities[index].completedTime = Date()
            scheduledActivities[index].notes = notes
            scheduledActivities[index].painLevel = painLevel
            scheduledActivities[index].weightUsedLbs = weightUsedLbs
            saveScheduledActivities()
            
            // Check if we should advance to the next stage
            checkAndAdvanceStage()
        }
    }
    
    func uncompleteActivity(_ scheduledActivity: ScheduledActivity) {
        if let index = scheduledActivities.firstIndex(where: { $0.id == scheduledActivity.id }) {
            scheduledActivities[index].isCompleted = false
            scheduledActivities[index].completedTime = nil
            saveScheduledActivities()
        }
    }
    
    func getTodayActivities() -> [ScheduledActivity] {
        let calendar = Calendar.current
        return scheduledActivities.filter { calendar.isDateInToday($0.scheduledTime) }
    }
    
    func getUpcomingActivities(limit: Int = 5) -> [ScheduledActivity] {
        let now = Date()
        return scheduledActivities
            .filter { $0.scheduledTime > now && !$0.isCompleted }
            .prefix(limit)
            .map { $0 }
    }
    
    func getCompletionRate() -> Double {
        let total = scheduledActivities.count
        guard total > 0 else { return 0 }
        let completed = scheduledActivities.filter { $0.isCompleted }.count
        return Double(completed) / Double(total)
    }
    
    func getWeeklyCompletionRate() -> Double {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        let weekActivities = scheduledActivities.filter { $0.scheduledTime >= oneWeekAgo }
        guard weekActivities.count > 0 else { return 0 }
        
        let completed = weekActivities.filter { $0.isCompleted }.count
        return Double(completed) / Double(weekActivities.count)
    }
    
    func getPainHistory(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        let completedWithPain = scheduledActivities
            .filter { $0.isCompleted && $0.painLevel != nil && $0.completedTime ?? Date.distantPast >= startDate }
            .sorted { ($0.completedTime ?? Date.distantPast) < ($1.completedTime ?? Date.distantPast) }
        
        return completedWithPain.compactMap { activity in
            if let date = activity.completedTime, let pain = activity.painLevel {
                return (date, Double(pain.rawValue))
            }
            return nil
        }
    }
    
    func getAveragePainLevel() -> Double? {
        let completedWithPain = scheduledActivities.filter { $0.isCompleted && $0.painLevel != nil }
        guard !completedWithPain.isEmpty else { return nil }
        
        let total = completedWithPain.reduce(0) { $0 + ($1.painLevel?.rawValue ?? 0) }
        return Double(total) / Double(completedWithPain.count)
    }
    
    func getPainTrend() -> String {
        let history = getPainHistory(days: 14)
        guard history.count >= 2 else { return "Not enough data" }
        
        let firstHalf = history.prefix(history.count / 2)
        let secondHalf = history.suffix(history.count / 2)
        
        let firstAvg = firstHalf.map { $0.1 }.reduce(0, +) / Double(firstHalf.count)
        let secondAvg = secondHalf.map { $0.1 }.reduce(0, +) / Double(secondHalf.count)
        
        let difference = firstAvg - secondAvg
        
        if difference > 0.5 {
            return "Improving"
        } else if difference < -0.5 {
            return "Worsening"
        } else {
            return "Stable"
        }
    }
    
    func getWeightProgressHistory(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        let completedWithWeight = scheduledActivities
            .filter { 
                $0.isCompleted && 
                $0.weightUsedLbs != nil && 
                $0.activity.type == .exercise &&
                $0.completedTime ?? Date.distantPast >= startDate 
            }
            .sorted { ($0.completedTime ?? Date.distantPast) < ($1.completedTime ?? Date.distantPast) }
        
        return completedWithWeight.compactMap { activity in
            if let date = activity.completedTime, let weight = activity.weightUsedLbs {
                return (date, Double(weight))
            }
            return nil
        }
    }
    
    func getAverageWeight() -> Double? {
        let completedWithWeight = scheduledActivities.filter { 
            $0.isCompleted && $0.weightUsedLbs != nil && $0.activity.type == .exercise
        }
        guard !completedWithWeight.isEmpty else { return nil }
        
        let total = completedWithWeight.reduce(0) { $0 + ($1.weightUsedLbs ?? 0) }
        return Double(total) / Double(completedWithWeight.count)
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                if granted {
                    self.scheduleNotifications()
                }
            }
        }
    }
    
    func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let upcomingActivities = scheduledActivities.filter { $0.scheduledTime > Date() && !$0.isCompleted }
        
        for activity in upcomingActivities.prefix(50) {
            let content = UNMutableNotificationContent()
            content.title = "Treatment Reminder"
            content.body = "\(activity.activity.name) - \(activity.activity.durationMinutes) minutes"
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], 
                                                             from: activity.scheduledTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: activity.id.uuidString, 
                                               content: content, 
                                               trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func checkAndAdvanceStage() {
        // Prevent multiple automatic advancements (flag is reset when plan is changed)
        if hasAutoAdvanced {
            return
        }
        
        // Check if current stage has been running for 2 weeks (14 days)
        let calendar = Calendar.current
        // Note: dateComponents with .day gives the number of full days between dates,
        // which is appropriate for this use case of checking if 14+ days have elapsed
        guard let daysSinceStart = calendar.dateComponents([.day], from: currentPlanStartDate, to: Date()).day else {
            return
        }
        
        // If 14 or more days have passed, advance to next stage
        if daysSinceStart >= 14 {
            advanceToNextStage()
        }
    }
    
    func advanceToNextStage() {
        // Find the next plan in the sequence
        guard let currentIndex = TreatmentPlan.defaultPlans.firstIndex(where: { $0.id == currentPlan.id }),
              currentIndex < TreatmentPlan.defaultPlans.count - 1 else {
            // Already at the last stage
            return
        }
        
        let nextPlan = TreatmentPlan.defaultPlans[currentIndex + 1]
        changePlan(to: nextPlan)
        // Set flag after changePlan to prevent multiple auto-advancements
        // (changePlan resets the flag, so we set it after the call)
        hasAutoAdvanced = true
    }
    
    private func savePlanStartDate() {
        UserDefaults.standard.set(currentPlanStartDate, forKey: "currentPlanStartDate")
    }
    
    private func loadPlanStartDate() {
        if let savedDate = UserDefaults.standard.object(forKey: "currentPlanStartDate") as? Date {
            currentPlanStartDate = savedDate
        }
    }
    
    private func saveScheduledActivities() {
        if let encoded = try? JSONEncoder().encode(scheduledActivities) {
            UserDefaults.standard.set(encoded, forKey: "scheduledActivities")
        }
    }
    
    private func loadScheduledActivities() {
        if let data = UserDefaults.standard.data(forKey: "scheduledActivities"),
           let decoded = try? JSONDecoder().decode([ScheduledActivity].self, from: data) {
            scheduledActivities = decoded
        } else {
            generateSchedule()
        }
    }
    
    func clearAllData() {
        // Clear scheduled activities
        scheduledActivities.removeAll()
        UserDefaults.standard.removeObject(forKey: "scheduledActivities")
        
        // Reset to default plan
        currentPlan = TreatmentPlan.defaultPlans[0]
        startDate = Date()
        currentPlanStartDate = Date()
        hasAutoAdvanced = false
        UserDefaults.standard.removeObject(forKey: "currentPlanStartDate")
        
        // Clear all pending notifications and disable notifications
        // We intentionally set notificationsEnabled to false as part of the data reset,
        // even if the user has granted system permissions. This allows users to start fresh.
        // They can re-enable notifications through the Settings toggle if desired.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notificationsEnabled = false
        
        // Regenerate schedule with default plan (this will also save the new schedule to UserDefaults)
        generateSchedule()
    }
}

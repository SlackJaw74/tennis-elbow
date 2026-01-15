import Foundation

struct TreatmentPlan: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let weekNumber: Int
    let activities: [TreatmentActivity]
    let dailySchedule: [DayOfWeek: [TimeOfDay]]

    init(id: UUID = UUID(), name: String, description: String, weekNumber: Int,
         activities: [TreatmentActivity], dailySchedule: [DayOfWeek: [TimeOfDay]])
    {
        self.id = id
        self.name = name
        self.description = description
        self.weekNumber = weekNumber
        self.activities = activities
        self.dailySchedule = dailySchedule
    }
}

enum DayOfWeek: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var name: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

enum TimeOfDay: String, Codable, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"

    var defaultHour: Int {
        switch self {
        case .morning: return 8
        case .afternoon: return 14
        case .evening: return 19
        }
    }
}

extension TreatmentPlan {
    static let defaultPlans: [TreatmentPlan] = [
        TreatmentPlan(
            name: "Week 1-2: Gentle Recovery",
            description: "Focus on reducing inflammation and gentle stretching",
            weekNumber: 1,
            activities: [
                TreatmentActivity.defaultActivities[0], // Wrist Extension Stretch
                TreatmentActivity.defaultActivities[1], // Wrist Flexion Stretch
                TreatmentActivity.defaultActivities[5], // Forearm Massage
                TreatmentActivity.defaultActivities[6], // Wrist Rotations
                TreatmentActivity.defaultActivities[2], // Eccentric Wrist Extension
                TreatmentActivity.defaultActivities[4], // Ice Therapy
                TreatmentActivity.defaultActivities[7], // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .evening],
                .tuesday: [.morning, .evening],
                .wednesday: [.morning, .evening],
                .thursday: [.morning, .evening],
                .friday: [.morning, .evening],
                .saturday: [.morning],
                .sunday: [.morning],
            ]
        ),
        TreatmentPlan(
            name: "Week 3-4: Progressive Strengthening",
            description: "Add gentle strengthening exercises",
            weekNumber: 3,
            activities: [
                TreatmentActivity.defaultActivities[0], // Wrist Extension Stretch
                TreatmentActivity.defaultActivities[1], // Wrist Flexion Stretch
                TreatmentActivity.defaultActivities[5], // Forearm Massage
                TreatmentActivity.defaultActivities[6], // Wrist Rotations
                TreatmentActivity.defaultActivities[2], // Eccentric Wrist Extension
                TreatmentActivity.defaultActivities[3], // Grip Strengthening
                TreatmentActivity.defaultActivities[4], // Ice Therapy
                TreatmentActivity.defaultActivities[7], // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .afternoon, .evening],
                .tuesday: [.morning, .evening],
                .wednesday: [.morning, .afternoon, .evening],
                .thursday: [.morning, .evening],
                .friday: [.morning, .afternoon, .evening],
                .saturday: [.morning],
                .sunday: [.morning],
            ]
        ),
        TreatmentPlan(
            name: "Week 5-6: Active Rehabilitation",
            description: "Increase strength and endurance",
            weekNumber: 5,
            activities: [
                TreatmentActivity.defaultActivities[0], // Wrist Extension Stretch
                TreatmentActivity.defaultActivities[1], // Wrist Flexion Stretch
                TreatmentActivity.defaultActivities[5], // Forearm Massage
                TreatmentActivity.defaultActivities[6], // Wrist Rotations
                TreatmentActivity.defaultActivities[2], // Eccentric Wrist Extension
                TreatmentActivity.defaultActivities[3], // Grip Strengthening
                TreatmentActivity.defaultActivities[4], // Ice Therapy
                TreatmentActivity.defaultActivities[7], // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .afternoon, .evening],
                .tuesday: [.morning, .afternoon, .evening],
                .wednesday: [.morning, .evening],
                .thursday: [.morning, .afternoon, .evening],
                .friday: [.morning, .afternoon, .evening],
                .saturday: [.morning, .afternoon],
                .sunday: [.morning],
            ]
        ),
    ]
}

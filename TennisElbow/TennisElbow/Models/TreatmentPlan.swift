import Foundation

struct TreatmentPlan: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let weekNumber: Int
    let activities: [TreatmentActivity]
    let dailySchedule: [DayOfWeek: [TimeOfDay]]
    let localizationKey: String?

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        weekNumber: Int,
        activities: [TreatmentActivity],
        dailySchedule: [DayOfWeek: [TimeOfDay]],
        localizationKey: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.weekNumber = weekNumber
        self.activities = activities
        self.dailySchedule = dailySchedule
        self.localizationKey = localizationKey
    }

    var localizedName: String {
        if let key = localizationKey {
            return "plan.\(key)".localized()
        }
        return name
    }

    var localizedDescription: String {
        if let key = localizationKey {
            return "plan.\(key).description".localized()
        }
        return description
    }
}

enum DayOfWeek: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    var name: String {
        switch self {
        case .sunday: return "day.sunday".localized()
        case .monday: return "day.monday".localized()
        case .tuesday: return "day.tuesday".localized()
        case .wednesday: return "day.wednesday".localized()
        case .thursday: return "day.thursday".localized()
        case .friday: return "day.friday".localized()
        case .saturday: return "day.saturday".localized()
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
                TreatmentActivity.defaultActivities[7] // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .evening],
                .tuesday: [.morning, .evening],
                .wednesday: [.morning, .evening],
                .thursday: [.morning, .evening],
                .friday: [.morning, .evening],
                .saturday: [.morning],
                .sunday: [.morning]
            ],
            localizationKey: "week_1_2_gentle_recovery"
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
                TreatmentActivity.defaultActivities[7] // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .afternoon, .evening],
                .tuesday: [.morning, .evening],
                .wednesday: [.morning, .afternoon, .evening],
                .thursday: [.morning, .evening],
                .friday: [.morning, .afternoon, .evening],
                .saturday: [.morning],
                .sunday: [.morning]
            ],
            localizationKey: "week_3_4_progressive_strengthening"
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
                TreatmentActivity.defaultActivities[7] // Pain Level Check
            ],
            dailySchedule: [
                .monday: [.morning, .afternoon, .evening],
                .tuesday: [.morning, .afternoon, .evening],
                .wednesday: [.morning, .evening],
                .thursday: [.morning, .afternoon, .evening],
                .friday: [.morning, .afternoon, .evening],
                .saturday: [.morning, .afternoon],
                .sunday: [.morning]
            ],
            localizationKey: "week_5_6_active_rehabilitation"
        )
    ]
}

import Foundation

enum PainLevel: Int, Codable, CaseIterable {
    case none = 0
    case mild = 1
    case moderate = 2
    case severe = 3
    case extreme = 4

    var description: String {
        switch self {
        case .none: return "No Pain"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        case .extreme: return "Extreme"
        }
    }

    var emoji: String {
        switch self {
        case .none: return "😊"
        case .mild: return "🙂"
        case .moderate: return "😐"
        case .severe: return "😣"
        case .extreme: return "😖"
        }
    }

    var color: String {
        switch self {
        case .none: return "green"
        case .mild: return "yellow"
        case .moderate: return "orange"
        case .severe: return "red"
        case .extreme: return "purple"
        }
    }
}

struct ScheduledActivity: Identifiable, Codable {
    let id: UUID
    let activity: TreatmentActivity
    let scheduledTime: Date
    var isCompleted: Bool
    var completedTime: Date?
    var notes: String?
    var painLevel: PainLevel?
    var weightUsedLbs: Int?

    init(
        id: UUID = UUID(),
        activity: TreatmentActivity,
        scheduledTime: Date,
        isCompleted: Bool = false,
        completedTime: Date? = nil,
        notes: String? = nil,
        painLevel: PainLevel? = nil,
        weightUsedLbs: Int? = nil
    ) {
        self.id = id
        self.activity = activity
        self.scheduledTime = scheduledTime
        self.isCompleted = isCompleted
        self.completedTime = completedTime
        self.notes = notes
        self.painLevel = painLevel
        self.weightUsedLbs = weightUsedLbs
    }
}

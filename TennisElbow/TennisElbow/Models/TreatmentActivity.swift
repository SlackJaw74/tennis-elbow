import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case exercise
    case stretch
    case iceTherapy
    case rest
    case medication
    case painTracking
}

enum DifficultyLevel: String, Codable {
    case beginner
    case intermediate
    case advanced
}

struct TreatmentActivity: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let type: ActivityType
    let durationMinutes: Int
    let repetitions: Int?
    let sets: Int?
    let difficultyLevel: DifficultyLevel
    let instructions: [String]
    let imageSystemName: String

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        type: ActivityType,
        durationMinutes: Int,
        repetitions: Int? = nil,
        sets: Int? = nil,
        difficultyLevel: DifficultyLevel = .beginner,
        instructions: [String],
        imageSystemName: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.durationMinutes = durationMinutes
        self.repetitions = repetitions
        self.sets = sets
        self.difficultyLevel = difficultyLevel
        self.instructions = instructions
        self.imageSystemName = imageSystemName
    }
}

extension TreatmentActivity {
    static let defaultActivities: [TreatmentActivity] = [
        TreatmentActivity(
            name: "Wrist Extension Stretch",
            description: "Gentle stretching to improve flexibility",
            type: .stretch,
            durationMinutes: 5,
            sets: 3,
            instructions: [
                "Extend your arm in front with palm facing down",
                "Use your other hand to gently pull fingers back",
                "Hold for 15-30 seconds",
                "Repeat on both arms"
            ],
            imageSystemName: "hand.raised"
        ),
        TreatmentActivity(
            name: "Wrist Flexion Stretch",
            description: "Stretches the extensors of the forearm",
            type: .stretch,
            durationMinutes: 5,
            sets: 3,
            instructions: [
                "Extend your arm with palm facing up",
                "Gently pull fingers down with other hand",
                "Hold for 15-30 seconds",
                "Feel the stretch in your forearm"
            ],
            imageSystemName: "hand.point.down"
        ),
        TreatmentActivity(
            name: "Eccentric Wrist Extension",
            description: "Strengthening exercise for forearm extensors",
            type: .exercise,
            durationMinutes: 10,
            repetitions: 15,
            sets: 3,
            instructions: [
                "Rest your forearm on a table, palm down",
                "Hold a light weight (1-2 lbs to start)",
                "Slowly lower the weight by bending wrist down",
                "Use other hand to help raise it back up",
                "Focus on the lowering motion"
            ],
            imageSystemName: "dumbbell"
        ),
        TreatmentActivity(
            name: "Grip Strengthening",
            description: "Build grip and forearm strength",
            type: .stretch,
            durationMinutes: 10,
            repetitions: 10,
            sets: 3,
            difficultyLevel: .intermediate,
            instructions: [
                "Use a stress ball or grip strengthener",
                "Squeeze firmly for 5 seconds",
                "Release slowly",
                "Rest between sets"
            ],
            imageSystemName: "hand.thumbsup"
        ),
        TreatmentActivity(
            name: "Ice Therapy",
            description: "Reduce inflammation and pain",
            type: .iceTherapy,
            durationMinutes: 15,
            instructions: [
                "Apply ice pack to outer elbow",
                "Use a towel to protect skin",
                "Apply for 15 minutes",
                "Repeat 3-4 times daily as needed"
            ],
            imageSystemName: "snowflake"
        ),
        TreatmentActivity(
            name: "Forearm Massage",
            description: "Self-massage to reduce tension",
            type: .stretch,
            durationMinutes: 10,
            instructions: [
                "Use your thumb to apply gentle pressure",
                "Massage along the forearm muscles",
                "Focus on tender points",
                "Move slowly and breathe deeply"
            ],
            imageSystemName: "hands.sparkles"
        ),
        TreatmentActivity(
            name: "Wrist Rotations",
            description: "Improve mobility and circulation",
            type: .exercise,
            durationMinutes: 5,
            repetitions: 10,
            sets: 2,
            instructions: [
                "Hold arm out with elbow bent at 90 degrees",
                "Slowly rotate wrist in circles",
                "Do 10 rotations clockwise",
                "Then 10 rotations counter-clockwise"
            ],
            imageSystemName: "arrow.triangle.2.circlepath"
        ),
        TreatmentActivity(
            name: "Pain Level Check",
            description: "Track your pain level after activities",
            type: .painTracking,
            durationMinutes: 1,
            instructions: [
                "Rate your current pain level",
                "Consider pain during activities",
                "Note any changes from previous sessions",
                "This helps track your recovery progress"
            ],
            imageSystemName: "heart.text.square.fill"
        )
    ]
}

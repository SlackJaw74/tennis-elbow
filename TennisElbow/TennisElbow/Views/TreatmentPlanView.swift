import SwiftUI

struct TreatmentPlanView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    @State private var expandedSessions: Set<String> = ["morning"] // Start with morning expanded
    @State private var expandedActivityId: UUID? = nil // Track which activity is expanded

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    planHeaderCard

                    todaysSummaryCard

                    sessionsView
                }
                .padding()
            }
            .navigationTitle("Treatment Plan".localized())
        }
    }

    var planHeaderCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2)
                    .foregroundColor(.red)

                VStack(alignment: .leading) {
                    Text(treatmentManager.currentPlan.name)
                        .font(.headline)
                    Text(treatmentManager.currentPlan.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            HStack {
                Label(String(format: "%d %@", treatmentManager.currentPlan.activities.count, "Activities".localized()),
                      systemImage: "list.bullet")

                Spacer()

                Button {
                    treatmentManager.generateSchedule()
                } label: {
                    Label("Regenerate".localized(), systemImage: "arrow.clockwise")
                        .font(.caption)
                }

                Menu {
                    ForEach(TreatmentPlan.defaultPlans) { plan in
                        Button(plan.name) {
                            treatmentManager.changePlan(to: plan)
                        }
                    }
                } label: {
                    Label("Change Plan".localized(), systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption)
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var todaysSummaryCard: some View {
        let todayActivities = treatmentManager.getTodayActivities()
        let completed = todayActivities.filter(\.isCompleted).count

        return VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress".localized())
                .font(.headline)

            HStack {
                VStack(alignment: .leading) {
                    Text("\(completed) / \(todayActivities.count)")
                        .font(.title2)
                        .bold()
                    Text("Activities Completed".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                CircularProgressView(progress: todayActivities
                    .isEmpty ? 0 : Double(completed) / Double(todayActivities.count))
                    .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var sessionsView: some View {
        let todayActivities = treatmentManager.getTodayActivities()
        let morningActivities = todayActivities.filter { getTimeOfDay(for: $0.scheduledTime) == "morning" }
        let afternoonActivities = todayActivities.filter { getTimeOfDay(for: $0.scheduledTime) == "afternoon" }
        let eveningActivities = todayActivities.filter { getTimeOfDay(for: $0.scheduledTime) == "evening" }

        return VStack(spacing: 12) {
            if !morningActivities.isEmpty {
                SessionSection(
                    title: "Morning".localized(),
                    icon: "sunrise.fill",
                    activities: morningActivities,
                    isExpanded: expandedSessions.contains("morning"),
                    expandedActivityId: $expandedActivityId,
                    onToggle: { toggleSession("morning", activities: morningActivities) }
                )
            }

            if !afternoonActivities.isEmpty {
                SessionSection(
                    title: "Afternoon".localized(),
                    icon: "sun.max.fill",
                    activities: afternoonActivities,
                    isExpanded: expandedSessions.contains("afternoon"),
                    expandedActivityId: $expandedActivityId,
                    onToggle: { toggleSession("afternoon", activities: afternoonActivities) }
                )
            }

            if !eveningActivities.isEmpty {
                SessionSection(
                    title: "Evening".localized(),
                    icon: "moon.fill",
                    activities: eveningActivities,
                    isExpanded: expandedSessions.contains("evening"),
                    expandedActivityId: $expandedActivityId,
                    onToggle: { toggleSession("evening", activities: eveningActivities) }
                )
            }
        }
    }

    func getTimeOfDay(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        if hour < 12 {
            return "morning"
        } else if hour < 17 {
            return "afternoon"
        } else {
            return "evening"
        }
    }

    func toggleSession(_ session: String, activities _: [ScheduledActivity]) {
        if expandedSessions.contains(session) {
            expandedSessions.remove(session)
        } else {
            expandedSessions.insert(session)
        }
    }

    var afternoonActivities: [ScheduledActivity] {
        treatmentManager.getTodayActivities().filter { getTimeOfDay(for: $0.scheduledTime) == "afternoon" }
    }

    var eveningActivities: [ScheduledActivity] {
        treatmentManager.getTodayActivities().filter { getTimeOfDay(for: $0.scheduledTime) == "evening" }
    }

    func allActivitiesCompleted(_ activities: [ScheduledActivity]) -> Bool {
        !activities.isEmpty && activities.allSatisfy(\.isCompleted)
    }
}

struct SessionSection: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    let title: String
    let icon: String
    let activities: [ScheduledActivity]
    let isExpanded: Bool
    @Binding var expandedActivityId: UUID?
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.orange)

                    Text(title)
                        .font(.headline)

                    Spacer()

                    let completed = activities.filter(\.isCompleted).count
                    Text("\(completed)/\(activities.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(activities) { activity in
                        SessionActivityRow(
                            scheduledActivity: activity,
                            isExpanded: expandedActivityId == activity.id,
                            onToggle: {
                                if expandedActivityId == activity.id {
                                    expandedActivityId = nil
                                } else {
                                    expandedActivityId = activity.id
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.tertiarySystemBackground))
            }
        }
        .cornerRadius(12)
    }
}

struct SessionActivityRow: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    let scheduledActivity: ScheduledActivity
    let isExpanded: Bool
    let onToggle: () -> Void
    @State private var showWeightPicker = false
    @State private var showPainPicker = false
    @State private var weightUsed: Int = 1
    @State private var selectedPainLevel: PainLevel = .none

    var body: some View {
        VStack(spacing: 0) {
            // Activity Row
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    // Completion toggle
                    Button {
                        if scheduledActivity.isCompleted {
                            treatmentManager.uncompleteActivity(scheduledActivity)
                        } else {
                            // Only show weight picker for Eccentric Wrist Extension
                            if scheduledActivity.activity.type == .exercise,
                               scheduledActivity.activity.name == "Eccentric Wrist Extension"
                            {
                                showWeightPicker = true
                            } else if scheduledActivity.activity.type == .painTracking {
                                showPainPicker = true
                            } else {
                                treatmentManager.completeActivity(
                                    scheduledActivity,
                                    notes: nil,
                                    painLevel: nil,
                                    weightUsedLbs: nil
                                )
                            }
                        }
                    } label: {
                        Image(systemName: scheduledActivity.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(scheduledActivity.isCompleted ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Image(systemName: scheduledActivity.activity.imageSystemName)
                        .foregroundColor(activityColor)
                        .frame(width: 30)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(scheduledActivity.activity.name)
                            .font(.subheadline)
                            .strikethrough(scheduledActivity.isCompleted)

                        HStack(spacing: 8) {
                            Text("\(scheduledActivity.activity.durationMinutes) min")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            if let reps = scheduledActivity.activity.repetitions,
                               let sets = scheduledActivity.activity.sets
                            {
                                Text("•")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text("\(sets)×\(reps)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }

                            if let weight = scheduledActivity.weightUsedLbs {
                                Text("•")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Text("\(weight) lbs")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .opacity(scheduledActivity.isCompleted ? 0.6 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())

            // Expanded Details
            if isExpanded {
                ActivityDetailContent(activity: scheduledActivity.activity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .padding(.top, 4)
            }
        }
        .sheet(isPresented: $showWeightPicker) {
            WeightPickerSheet(
                weightUsed: $weightUsed,
                activityName: scheduledActivity.activity.name,
                onComplete: {
                    treatmentManager.completeActivity(
                        scheduledActivity,
                        notes: nil,
                        painLevel: nil,
                        weightUsedLbs: weightUsed
                    )
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showPainPicker) {
            PainPickerSheet(
                selectedPainLevel: $selectedPainLevel,
                onComplete: {
                    treatmentManager.completeActivity(
                        scheduledActivity,
                        notes: nil,
                        painLevel: selectedPainLevel,
                        weightUsedLbs: nil
                    )
                }
            )
            .presentationDetents([.medium])
        }
        .onAppear {
            weightUsed = scheduledActivity.weightUsedLbs ?? 1
            selectedPainLevel = scheduledActivity.painLevel ?? .none
        }
    }

    var activityColor: Color {
        switch scheduledActivity.activity.type {
        case .exercise: return .blue
        case .stretch: return .green
        case .iceTherapy: return .cyan
        case .rest: return .purple
        case .medication: return .orange
        case .painTracking: return .red
        }
    }
}

struct ActivityDetailContent: View {
    let activity: TreatmentActivity

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Description
            Text(activity.description)
                .font(.body)
                .foregroundColor(.secondary)

            // Details
            if activity.repetitions != nil || activity.sets != nil || activity.durationMinutes > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Details".localized())
                        .font(.headline)

                    HStack(spacing: 16) {
                        if activity.durationMinutes > 0 {
                            DetailBadge(
                                icon: "clock",
                                label: "Duration".localized(),
                                value: "\(activity.durationMinutes) min"
                            )
                        }

                        if let reps = activity.repetitions {
                            DetailBadge(icon: "repeat", label: "Reps".localized(), value: "\(reps)")
                        }

                        if let sets = activity.sets {
                            DetailBadge(icon: "square.stack.3d.up", label: "Sets".localized(), value: "\(sets)")
                        }
                    }
                }
            }

            // Instructions
            if !activity.instructions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions".localized())
                        .font(.headline)

                    ForEach(Array(activity.instructions.enumerated()), id: \.offset) { index, instruction in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1)")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(activityColor)
                                .clipShape(Circle())

                            Text(instruction)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            // Type and Difficulty
            HStack(spacing: 12) {
                Label(activity.type.rawValue.capitalized, systemImage: typeIcon)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Label(activity.difficultyLevel.rawValue.capitalized, systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    var activityColor: Color {
        switch activity.type {
        case .exercise: return .blue
        case .stretch: return .green
        case .iceTherapy: return .cyan
        case .rest: return .purple
        case .medication: return .orange
        case .painTracking: return .red
        }
    }

    var typeIcon: String {
        switch activity.type {
        case .exercise: return "figure.strengthtraining.traditional"
        case .stretch: return "figure.flexibility"
        case .iceTherapy: return "snowflake"
        case .rest: return "bed.double.fill"
        case .medication: return "pills.fill"
        case .painTracking: return "heart.text.square.fill"
        }
    }
}

struct DetailBadge: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.blue)
            Text(value)
                .font(.caption)
                .bold()
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct WeightPickerSheet: View {
    @Binding var weightUsed: Int
    let activityName: String
    let onComplete: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Weight Used".localized())
                    .font(.title2)
                    .bold()

                Text(activityName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 20) {
                    Button {
                        if weightUsed > 1 {
                            weightUsed -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }

                    VStack {
                        Text("\(weightUsed)")
                            .font(.system(size: 72, weight: .bold))
                        Text("lbs".localized())
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }

                    Button {
                        if weightUsed < 100 {
                            weightUsed += 1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                Button {
                    onComplete()
                    dismiss()
                } label: {
                    Text("Complete".localized())
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel".localized()) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PainPickerSheet: View {
    @Binding var selectedPainLevel: PainLevel
    let onComplete: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Pain Level Check".localized())
                    .font(.title2)
                    .bold()

                Text("treatment.feel_after_session".localized())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    ForEach(PainLevel.allCases, id: \.self) { level in
                        Button {
                            selectedPainLevel = level
                            onComplete()
                            dismiss()
                        } label: {
                            HStack {
                                Text(level.emoji)
                                    .font(.title2)

                                VStack(alignment: .leading) {
                                    Text(level.description)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(getPainDescription(for: level))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel".localized()) {
                        dismiss()
                    }
                }
            }
        }
    }

    func getPainDescription(for level: PainLevel) -> String {
        switch level {
        case .none: return "pain.none".localized()
        case .mild: return "pain.mild".localized()
        case .moderate: return "pain.moderate".localized()
        case .severe: return "pain.severe".localized()
        case .extreme: return "pain.extreme".localized()
        }
    }
}

struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)

            Text("\(Int(progress * 100))%")
                .font(.caption)
                .bold()
        }
    }
}

#Preview {
    NavigationStack {
        TreatmentPlanView()
            .environmentObject(TreatmentManager())
    }
}

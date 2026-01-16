import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    @State private var selectedDate = Date()
    @State private var selectedActivity: ScheduledActivity?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker("Select Date".localized(), selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()

                Divider()

                scheduledActivitiesList
            }
            .navigationTitle("Schedule".localized())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        treatmentManager.generateSchedule(from: Date())
                    } label: {
                        Label("Regenerate".localized(), systemImage: "arrow.clockwise")
                    }
                }
            }
            .sheet(item: $selectedActivity) { scheduled in
                ScheduledActivityDetailView(scheduledActivity: scheduled)
            }
        }
    }

    var scheduledActivitiesList: some View {
        let activities = getActivitiesForSelectedDate()

        return Group {
            if activities.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No activities scheduled".localized())
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("schedule.generate_prompt".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(activities) { scheduled in
                            ScheduledActivityRow(scheduledActivity: scheduled)
                                .onTapGesture {
                                    selectedActivity = scheduled
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    func getActivitiesForSelectedDate() -> [ScheduledActivity] {
        let calendar = Calendar.current
        return treatmentManager.scheduledActivities.filter { scheduled in
            calendar.isDate(scheduled.scheduledTime, inSameDayAs: selectedDate)
        }.sorted { $0.scheduledTime < $1.scheduledTime }
    }
}

struct ScheduledActivityRow: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    let scheduledActivity: ScheduledActivity

    var body: some View {
        HStack(spacing: 12) {
            Button {
                if scheduledActivity.isCompleted {
                    treatmentManager.uncompleteActivity(scheduledActivity)
                } else {
                    treatmentManager.completeActivity(scheduledActivity)
                }
            } label: {
                Image(systemName: scheduledActivity.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(scheduledActivity.isCompleted ? .green : .gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(scheduledActivity.activity.name)
                    .font(.subheadline)
                    .bold()
                    .strikethrough(scheduledActivity.isCompleted)

                HStack {
                    Label(scheduledActivity.scheduledTime.formatted(date: .omitted, time: .shortened),
                          systemImage: "clock")
                    Text("•")
                    Label("\(scheduledActivity.activity.durationMinutes) min",
                          systemImage: "timer")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: scheduledActivity.activity.imageSystemName)
                .foregroundColor(activityColor)
        }
        .padding()
        .background(scheduledActivity.isCompleted ?
            Color.green.opacity(0.1) : Color(.secondarySystemBackground))
        .cornerRadius(10)
        .opacity(scheduledActivity.isCompleted ? 0.7 : 1.0)
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

struct ScheduledActivityDetailView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    @Environment(\.dismiss) var dismiss
    let scheduledActivity: ScheduledActivity
    @State private var notes: String = ""
    @State private var selectedPainLevel: PainLevel = .none
    @State private var weightUsed: Int = 1
    @State private var showCompletionSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    scheduleInfoCard

                    ActivityDetailView(activity: scheduledActivity.activity)
                        .toolbar(.hidden)

                    notesSection

                    if !scheduledActivity.isCompleted {
                        Button {
                            // If pain tracking activity, show pain selector directly
                            if scheduledActivity.activity.type == .painTracking {
                                showCompletionSheet = true
                            } else {
                                // For other activities, just mark as complete
                                treatmentManager.completeActivity(
                                    scheduledActivity,
                                    notes: nil,
                                    painLevel: nil,
                                    weightUsedLbs: scheduledActivity.activity.type == .exercise ? weightUsed : nil
                                )
                                dismiss()
                            }
                        } label: {
                            Label("Mark as Complete".localized(), systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Scheduled Activity".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done".localized()) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCompletionSheet) {
                PainLevelSheet(
                    selectedPainLevel: $selectedPainLevel,
                    notes: $notes,
                    weightUsed: $weightUsed,
                    activity: scheduledActivity.activity,
                    onComplete: {
                        treatmentManager.completeActivity(
                            scheduledActivity,
                            notes: notes.isEmpty ? nil : notes,
                            painLevel: scheduledActivity.activity.type == .painTracking ? selectedPainLevel : nil,
                            weightUsedLbs: scheduledActivity.activity.type == .exercise ? weightUsed : nil
                        )
                        dismiss()
                    }
                )
            }
        }
        .onAppear {
            notes = scheduledActivity.notes ?? ""
            selectedPainLevel = scheduledActivity.painLevel ?? .none
            weightUsed = scheduledActivity.weightUsedLbs ?? 1
        }
    }

    var scheduleInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(scheduledActivity.scheduledTime.formatted(date: .abbreviated, time: .shortened),
                      systemImage: "calendar.clock")
                Spacer()
                if scheduledActivity.isCompleted {
                    Label("Completed".localized(), systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .font(.caption)

            if let completedTime = scheduledActivity.completedTime {
                Text(String(
                    format: "%@ %@",
                    "Completed at".localized(),
                    completedTime.formatted(date: .omitted, time: .shortened)
                ))
                .font(.caption2)
                .foregroundColor(.secondary)
            }

            if let painLevel = scheduledActivity.painLevel {
                HStack {
                    Text("Pain Level:".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(painLevel.emoji) \(painLevel.description)")
                        .font(.caption)
                        .bold()
                }
            }

            if let weight = scheduledActivity.weightUsedLbs, scheduledActivity.activity.type == .exercise {
                HStack {
                    Text("Weight Used:".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%d %@", weight, "lbs".localized()))
                        .font(.caption)
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes".localized())
                .font(.headline)

            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct PainLevelSheet: View {
    @Binding var selectedPainLevel: PainLevel
    @Binding var notes: String
    @Binding var weightUsed: Int
    let activity: TreatmentActivity
    let onComplete: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text(activity.type == .painTracking ? "How do you feel?".localized() : "schedule.feel_after_activity"
                        .localized())
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    // Weight selector for exercises only
                    if activity.type == .exercise {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weight Used".localized())
                                .font(.headline)

                            HStack {
                                Button {
                                    if weightUsed > 1 {
                                        weightUsed -= 1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }

                                Spacer()

                                VStack {
                                    Text("\(weightUsed)")
                                        .font(.system(size: 48, weight: .bold))
                                    Text("lbs".localized())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button {
                                    if weightUsed < 100 {
                                        weightUsed += 1
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Pain Level - only for pain tracking activity
                    if activity.type == .painTracking {
                        VStack(spacing: 12) {
                            ForEach(PainLevel.allCases, id: \.self) { level in
                                Button {
                                    selectedPainLevel = level
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

                                        if selectedPainLevel == level {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding()
                                    .background(selectedPainLevel == level ?
                                        Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button {
                        onComplete()
                        dismiss()
                    } label: {
                        Text("Complete Activity".localized())
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Complete Activity".localized())
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

#Preview {
    ScheduleView()
        .environmentObject(TreatmentManager())
}

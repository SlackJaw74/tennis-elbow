import SwiftUI

// MARK: - PainLevel Extension

private extension PainLevel {
    var localizedDetail: String {
        switch self {
        case .none: return "pain.none".localized()
        case .mild: return "pain.mild".localized()
        case .moderate: return "pain.moderate".localized()
        case .severe: return "pain.severe".localized()
        case .extreme: return "pain.extreme".localized()
        }
    }
}

// MARK: - WeightStepperView

struct WeightStepperView: View {
    @Binding var weight: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 0 : 20) {
            Button {
                if weight > 1 { weight -= 1 }
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(compact ? .title2 : .system(size: 40))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("Decrease weight")
            .accessibilityHint("Decreases weight by 1 pound")

            if compact { Spacer() }

            VStack {
                Text("\(weight)")
                    .font(.system(size: compact ? 48 : 72, weight: .bold))
                Text("lbs".localized())
                    .font(compact ? .caption : .title3)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(weight) pounds")
            .accessibilityValue("\(weight)")

            if compact { Spacer() }

            Button {
                if weight < 100 { weight += 1 }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(compact ? .title2 : .system(size: 40))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("Increase weight")
            .accessibilityHint("Increases weight by 1 pound")
        }
        .padding()
    }
}

// MARK: - WeightPickerSheet

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

                WeightStepperView(weight: $weightUsed)

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
                .accessibilityLabel("Complete activity with weight \(weightUsed) pounds")
                .accessibilityHint("Marks the activity as complete and records the weight used")

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

// MARK: - PainPickerSheet

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
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading) {
                                    Text(level.description)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(level.localizedDetail)
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
                        .accessibilityLabel("Pain level: \(level.description)")
                        .accessibilityHint(level.localizedDetail)
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
}

// MARK: - PainLevelSheet

struct PainLevelSheet: View {
    @Binding var selectedPainLevel: PainLevel
    @Binding var weightUsed: Int
    let activity: TreatmentActivity
    let onComplete: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text(activity.type == .painTracking
                        ? "How do you feel?".localized()
                        : "schedule.feel_after_activity".localized())
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    // Weight selector for exercises only
                    if activity.type == .exercise {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weight Used".localized())
                                .font(.headline)
                                .padding(.horizontal)

                            WeightStepperView(weight: $weightUsed, compact: true)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }

                    // Pain level selector for pain tracking activities only
                    if activity.type == .painTracking {
                        VStack(spacing: 12) {
                            ForEach(PainLevel.allCases, id: \.self) { level in
                                Button {
                                    selectedPainLevel = level
                                } label: {
                                    HStack {
                                        Text(level.emoji)
                                            .font(.title2)
                                            .accessibilityHidden(true)

                                        VStack(alignment: .leading) {
                                            Text(level.description)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(level.localizedDetail)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        if selectedPainLevel == level {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .accessibilityHidden(true)
                                        }
                                    }
                                    .padding()
                                    .background(selectedPainLevel == level
                                        ? Color.blue.opacity(0.1)
                                        : Color(.secondarySystemBackground))
                                        .cornerRadius(12)
                                }
                                .accessibilityLabel("Pain level: \(level.description)")
                                .accessibilityHint(level.localizedDetail)
                                .accessibilityAddTraits(selectedPainLevel == level
                                    ? [.isButton, .isSelected]
                                    : .isButton)
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
}

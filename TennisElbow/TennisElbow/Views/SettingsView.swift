import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @State private var showDisclaimer = false
    @State private var showClearDataConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section("Notifications".localized()) {
                    Toggle(isOn: Binding(
                        get: { treatmentManager.notificationsEnabled },
                        set: { enabled in
                            if enabled {
                                treatmentManager.requestNotificationPermissions()
                            } else {
                                treatmentManager.notificationsEnabled = false
                            }
                        }
                    )) {
                        Label("Enable Reminders".localized(), systemImage: "bell.fill")
                    }
                    .accessibilityLabel("Enable reminders")
                    .accessibilityHint(treatmentManager
                        .notificationsEnabled ? "Reminders are enabled" : "Reminders are disabled")

                    if treatmentManager.notificationsEnabled {
                        DatePicker(
                            "Morning Time".localized(),
                            selection: Binding(
                                get: { treatmentManager.morningReminderTime },
                                set: { newTime in
                                    treatmentManager.morningReminderTime = newTime
                                    treatmentManager.saveCustomReminderTimes()
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .accessibilityIdentifier("Morning Time")
                        .accessibilityLabel("Morning reminder time")

                        DatePicker(
                            "Evening Time".localized(),
                            selection: Binding(
                                get: { treatmentManager.eveningReminderTime },
                                set: { newTime in
                                    treatmentManager.eveningReminderTime = newTime
                                    treatmentManager.saveCustomReminderTimes()
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .accessibilityIdentifier("Evening Time")
                        .accessibilityLabel("Evening reminder time")

                        Text("settings.notification_description".localized())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section("Treatment Plan".localized()) {
                    Picker("Current Plan".localized(), selection: Binding(
                        get: { treatmentManager.currentPlan.id },
                        set: { newId in
                            if let plan = TreatmentPlan.defaultPlans.first(where: { $0.id == newId }) {
                                treatmentManager.changePlan(to: plan)
                            }
                        }
                    )) {
                        ForEach(TreatmentPlan.defaultPlans) { plan in
                            Text(plan.name).tag(plan.id)
                        }
                    }
                    .accessibilityLabel("Current treatment plan")
                    .accessibilityHint("Select which treatment plan phase to follow")

                    Button {
                        treatmentManager.generateSchedule(from: Date())
                    } label: {
                        Label("Regenerate Schedule".localized(), systemImage: "arrow.clockwise")
                    }
                    .accessibilityLabel("Regenerate schedule")
                    .accessibilityHint("Creates a new schedule starting from today")
                }

                Section("Data Management".localized()) {
                    Button(role: .destructive) {
                        showClearDataConfirmation = true
                    } label: {
                        Label("Clear All Data".localized(), systemImage: "trash")
                    }
                    .accessibilityLabel("Clear all data")
                    .accessibilityHint("Permanently deletes all your treatment data and progress")
                }

                Section("Information".localized()) {
                    NavigationLink {
                        AboutTennisElbowView()
                    } label: {
                        Label("About Tennis Elbow".localized(), systemImage: "info.circle")
                    }

                    NavigationLink {
                        TipsView()
                    } label: {
                        Label("Treatment Tips".localized(), systemImage: "lightbulb")
                    }

                    NavigationLink {
                        MedicalSourcesView()
                    } label: {
                        Label("Medical Sources & Citations".localized(), systemImage: "books.vertical")
                    }

                    Button {
                        showDisclaimer = true
                    } label: {
                        Label("Medical Disclaimer".localized(), systemImage: "exclamationmark.triangle")
                    }
                }

                Section("App Information".localized()) {
                    HStack {
                        Text("Version".localized())
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings".localized())
            .sheet(isPresented: $showDisclaimer) {
                DisclaimerView(isInitialLaunch: false)
            }
            .confirmationDialog(
                "Clear All Data".localized(),
                isPresented: $showClearDataConfirmation,
                titleVisibility: .visible
            ) {
                Button("Clear All Data".localized(), role: .destructive) {
                    treatmentManager.clearAllData()
                    hasAcceptedDisclaimer = false
                }
                Button("Cancel".localized(), role: .cancel) {}
            } message: {
                Text("settings.clear_data_warning".localized())
            }
        }
    }
}

struct AboutTennisElbowView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What is Tennis Elbow?".localized())
                    .font(.title2)
                    .bold()

                Text("about.tennis_elbow_description".localized())
                    .font(.body)

                Text("Common Symptoms".localized())
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "symptoms.pain_outer_part".localized())
                    BulletPoint(text: "symptoms.weak_grip".localized())
                    BulletPoint(text: "symptoms.pain_lifting".localized())
                    BulletPoint(text: "symptoms.pain_gripping".localized())
                }

                Text("Treatment Approach".localized())
                    .font(.headline)
                    .padding(.top)

                Text("about.treatment_description".localized())
                    .font(.body)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sources".localized())
                        .font(.headline)
                        .padding(.top)

                    Text("tips.sources_description".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)

                    NavigationLink {
                        MedicalSourcesView()
                    } label: {
                        HStack {
                            Image(systemName: "books.vertical")
                            Text("View All Medical Sources".localized())
                        }
                        .font(.subheadline)
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
        }
        .navigationTitle("About Tennis Elbow".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TipsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Treatment Tips".localized())
                    .font(.title2)
                    .bold()

                TipCard(
                    icon: "snowflake",
                    title: "Ice Regularly".localized(),
                    description: "tips.ice_description".localized()
                )

                TipCard(
                    icon: "figure.walk",
                    title: "Start Slow".localized(),
                    description: "tips.start_slow_description".localized()
                )

                TipCard(
                    icon: "calendar",
                    title: "Be Consistent".localized(),
                    description: "tips.consistency_description".localized()
                )

                TipCard(
                    icon: "hand.raised",
                    title: "Modify Activities".localized(),
                    description: "tips.modify_description".localized()
                )

                TipCard(
                    icon: "wind",
                    title: "Warm Up".localized(),
                    description: "tips.warmup_description".localized()
                )

                TipCard(
                    icon: "stethoscope",
                    title: "Seek Professional Help".localized(),
                    description: "tips.professional_help_description".localized()
                )
            }
            .padding()
        }
        .navigationTitle("Treatment Tips".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.body)
            Text(text)
                .font(.body)
        }
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
}

#Preview {
    SettingsView()
        .environmentObject(TreatmentManager())
}

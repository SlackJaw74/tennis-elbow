import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @State private var showDisclaimer = false
    @State private var showClearDataConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notifications") {
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
                        Label("Enable Reminders", systemImage: "bell.fill")
                    }
                    
                    if treatmentManager.notificationsEnabled {
                        Text("You'll receive notifications for scheduled activities")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Treatment Plan") {
                    Picker("Current Plan", selection: Binding(
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
                    
                    Button {
                        treatmentManager.generateSchedule(from: Date())
                    } label: {
                        Label("Regenerate Schedule", systemImage: "arrow.clockwise")
                    }
                }
                
                Section("Data Management") {
                    Button(role: .destructive) {
                        showClearDataConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash")
                    }
                }

                Section("Information") {
                    NavigationLink {
                        AboutTennisElbowView()
                    } label: {
                        Label("About Tennis Elbow", systemImage: "info.circle")
                    }
                    
                    NavigationLink {
                        TipsView()
                    } label: {
                        Label("Treatment Tips", systemImage: "lightbulb")
                    }
                    
                    NavigationLink {
                        MedicalSourcesView()
                    } label: {
                        Label("Medical Sources & Citations", systemImage: "books.vertical")
                    }
                    
                    Button {
                        showDisclaimer = true
                    } label: {
                        Label("Medical Disclaimer", systemImage: "exclamationmark.triangle")
                    }
                }
                
                Section("App Information") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showDisclaimer) {
                DisclaimerView(isInitialLaunch: false)
            }
            .confirmationDialog(
                "Clear All Data",
                isPresented: $showClearDataConfirmation,
                titleVisibility: .visible
            ) {
                Button("Clear All Data", role: .destructive) {
                    treatmentManager.clearAllData()
                    hasAcceptedDisclaimer = false
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will delete all your scheduled activities, completion history, pain tracking data, and reset the app to its default state. This action cannot be undone.")
            }
        }
    }
}

struct AboutTennisElbowView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What is Tennis Elbow?")
                    .font(.title2)
                    .bold()
                
                Text("""
                Tennis elbow (lateral epicondylitis) is a painful condition that occurs when tendons in your elbow are overloaded, usually by repetitive motions of the wrist and arm.
                
                Despite its name, athletes aren't the only people who develop tennis elbow. People whose jobs feature the types of motions that can lead to tennis elbow include plumbers, painters, carpenters and butchers.
                """)
                .font(.body)
                
                Text("Common Symptoms")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Pain or burning on the outer part of your elbow")
                    BulletPoint(text: "Weak grip strength")
                    BulletPoint(text: "Pain when lifting or bending your arm")
                    BulletPoint(text: "Pain when gripping objects")
                }
                
                Text("Treatment Approach")
                    .font(.headline)
                    .padding(.top)
                
                Text("""
                This app follows evidence-based treatment protocols including:
                
                • Rest and activity modification
                • Stretching exercises
                • Strengthening exercises (especially eccentric)
                • Ice therapy for inflammation
                • Gradual return to activities
                
                Always consult with a healthcare provider before starting any treatment program.
                """)
                .font(.body)                

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sources")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("The information above is based on guidelines from the American Academy of Orthopaedic Surgeons (AAOS), Mayo Clinic, and peer-reviewed research published in the British Journal of Sports Medicine.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    NavigationLink {
                        MedicalSourcesView()
                    } label: {
                        HStack {
                            Image(systemName: "books.vertical")
                            Text("View All Medical Sources")
                        }
                        .font(.subheadline)
                    }
                    .padding(.top, 4)
                }            }
            .padding()
        }
        .navigationTitle("About Tennis Elbow")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TipsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Treatment Tips")
                    .font(.title2)
                    .bold()
                
                TipCard(
                    icon: "snowflake",
                    title: "Ice Regularly",
                    description: "Apply ice for 15 minutes, 3-4 times daily, especially after activities that aggravate your symptoms."
                )
                
                TipCard(
                    icon: "figure.walk",
                    title: "Start Slow",
                    description: "Begin with gentle stretches and gradually progress to strengthening exercises. Don't push through sharp pain."
                )
                
                TipCard(
                    icon: "calendar",
                    title: "Be Consistent",
                    description: "Regular, daily exercises are more effective than occasional intensive sessions. Consistency is key to recovery."
                )
                
                TipCard(
                    icon: "hand.raised",
                    title: "Modify Activities",
                    description: "Avoid or modify activities that aggravate your symptoms. Use proper technique when lifting or gripping."
                )
                
                TipCard(
                    icon: "wind",
                    title: "Warm Up",
                    description: "Always warm up your arm with gentle movements before exercises. Cold muscles are more prone to injury."
                )
                
                TipCard(
                    icon: "stethoscope",
                    title: "Seek Professional Help",
                    description: "If pain persists beyond 6-8 weeks or worsens, consult a healthcare provider or physical therapist."
                )
            }
            .padding()
        }
        .navigationTitle("Treatment Tips")
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
    }
}

#Preview {
    SettingsView()
        .environmentObject(TreatmentManager())
}

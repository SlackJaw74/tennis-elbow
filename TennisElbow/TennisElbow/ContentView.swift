import SwiftUI

struct ContentView: View {
    @StateObject private var treatmentManager = TreatmentManager()
    @State private var selectedTab = 0
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @State private var showDisclaimer = false

    var body: some View {

        TabView(selection: $selectedTab) {
            TreatmentPlanView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("tab.treatment".localized(), systemImage: "heart.text.square")
                }
                .tag(0)
                .accessibilityLabel("Treatment Plan")
                .accessibilityHint("View your daily treatment activities and exercises")

            ScheduleView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("tab.schedule".localized(), systemImage: "calendar")
                }
                .tag(1)
                .accessibilityLabel("Schedule")
                .accessibilityHint("View and manage scheduled activities by date")

            TreatmentProgressView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("tab.progress".localized(), systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
                .accessibilityLabel("Progress")
                .accessibilityHint("View your recovery progress and pain trends")

            SettingsView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("tab.settings".localized(), systemImage: "gear")
                }
                .tag(3)
                .accessibilityLabel("Settings")
                .accessibilityHint("Manage app settings and view information")
        }
        .sheet(isPresented: $showDisclaimer) {
            DisclaimerView(isInitialLaunch: !hasAcceptedDisclaimer)
        }
        .alert("Ready to Advance?", isPresented: $treatmentManager.showAdvancementPrompt) {
            Button("Yes, Advance", role: nil) {
                treatmentManager.userAcceptedAdvancement()
            }
            .accessibilityLabel("Yes, advance to next treatment stage")
            Button("Not Yet", role: .cancel) {
                treatmentManager.userDeclinedAdvancement()
            }
            .accessibilityLabel("Not yet, continue current plan")
        } message: {
            Text(
                """
                You've completed 14 days on your current treatment plan. Would you like to advance to the \
                next stage, or continue with the current plan for 2 more weeks?
                """
            )
        }
        .onAppear {
            if !hasAcceptedDisclaimer {
                showDisclaimer = true
            }
        }
    }
}

#Preview {
    ContentView()
}

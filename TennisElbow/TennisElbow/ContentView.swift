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
                    Label("Treatment", systemImage: "heart.text.square")
                }
                .tag(0)
            
            ScheduleView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(1)
            
            TreatmentProgressView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
            
            SettingsView()
                .environmentObject(treatmentManager)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .sheet(isPresented: $showDisclaimer) {
            DisclaimerView(isInitialLaunch: !hasAcceptedDisclaimer)
        }
        .alert("Ready to Advance?", isPresented: $treatmentManager.showAdvancementPrompt) {
            Button("Yes, Advance", role: nil) {
                treatmentManager.userAcceptedAdvancement()
            }
            Button("Not Yet", role: .cancel) {
                treatmentManager.userDeclinedAdvancement()
            }
        } message: {
            Text("You've completed 14 days on your current treatment plan. Would you like to advance to the next stage, or continue with the current plan for 2 more weeks?")
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

import SwiftUI

@main
struct TennisElbowApp: App {
    init() {
        // Reset disclaimer state for UI tests to ensure deterministic screenshot runs
        if CommandLine.arguments.contains("-resetDisclaimer") {
            UserDefaults.standard.removeObject(forKey: "hasAcceptedDisclaimer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

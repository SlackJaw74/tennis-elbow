import SwiftUI

// Ultra-simple text-based icon - just screenshot this at 1024x1024

struct SimpleTextIcon: View {
    var body: some View {
        ZStack {
            // Medical blue background
            LinearGradient(
                colors: [Color(red: 0.3, green: 0.6, blue: 1.0),
                        Color(red: 0.1, green: 0.4, blue: 0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: -30) {
                // Large emoji or symbol
                Text("💪")
                    .font(.system(size: 280))
                
                // Pain indicator
                Text("⚡️")
                    .font(.system(size: 180))
                    .rotationEffect(.degrees(-15))
                    .offset(x: 50, y: -100)
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

struct MinimalIcon: View {
    var body: some View {
        ZStack {
            // Clean white background
            Color.white
            
            VStack(spacing: 20) {
                // App name initials
                Text("TE")
                    .font(.system(size: 400, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Subtitle
                Text("Recovery")
                    .font(.system(size: 80, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview("Emoji Style") {
    SimpleTextIcon()
}

#Preview("Minimal Text") {
    MinimalIcon()
}

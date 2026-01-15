import SwiftUI

// Run this in Xcode Playground or as a simple SwiftUI app
// Take a screenshot and use it as your icon

struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(red: 0.2, green: 0.6, blue: 0.9),
                         Color(red: 0.1, green: 0.4, blue: 0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: -10) {
                // Arm symbol
                Image(systemName: "figure.arms.open")
                    .font(.system(size: 120, weight: .regular))
                    .foregroundColor(.white)

                // Pain indicators
                HStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow)
                        .offset(x: -20, y: -40)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 35))
                        .foregroundColor(.red)
                        .offset(x: 20, y: -35)
                }
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

struct AppIconPreview_Simplified: View {
    var body: some View {
        ZStack {
            // Blue medical background
            Color(red: 0.2, green: 0.5, blue: 0.8)

            VStack(spacing: 0) {
                // Tennis ball or elbow representation
                Circle()
                    .fill(.white)
                    .frame(width: 200, height: 200)
                    .overlay {
                        // Pain lines radiating out
                        ZStack {
                            ForEach(0 ..< 8) { i in
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: 8, height: 60)
                                    .offset(y: -100)
                                    .rotationEffect(.degrees(Double(i) * 45))
                            }
                        }
                    }

                Text("TE")
                    .font(.system(size: 180, weight: .black))
                    .foregroundColor(.white)
                    .offset(y: -50)
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview("Medical Style") {
    AppIconPreview()
}

#Preview("Simple Style") {
    AppIconPreview_Simplified()
}

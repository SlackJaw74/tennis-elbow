import SwiftUI

struct ActivityDetailView: View {
    let activity: TreatmentActivity
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    
                    detailsSection
                    
                    instructionsSection
                }
                .padding()
            }
            .navigationTitle(activity.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: activity.imageSystemName)
                .font(.system(size: 60))
                .foregroundColor(activityColor)
            
            Text(activity.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
            
            HStack(spacing: 20) {
                DetailItem(icon: "clock", label: "Duration", value: "\(activity.durationMinutes) min")
                
                if let reps = activity.repetitions {
                    DetailItem(icon: "repeat", label: "Reps", value: "\(reps)")
                }
                
                if let sets = activity.sets {
                    DetailItem(icon: "square.stack.3d.up", label: "Sets", value: "\(sets)")
                }
            }
            
            HStack {
                Label(activity.type.rawValue.capitalized, systemImage: typeIcon)
                Spacer()
                Label(activity.difficultyLevel.rawValue.capitalized, systemImage: "star.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
            
            ForEach(Array(activity.instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(activityColor)
                        .clipShape(Circle())
                    
                    Text(instruction)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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

struct DetailItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ActivityDetailView(activity: TreatmentActivity.defaultActivities[0])
}

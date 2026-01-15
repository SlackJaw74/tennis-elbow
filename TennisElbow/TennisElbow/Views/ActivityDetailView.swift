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
                    

                    sourcesSection
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
    

    var sourcesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evidence-Based")
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
            
            Text(sourceDescription)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let url = sourceURL {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                        Text("View Research Source")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
    
    var sourceDescription: String {
        switch activity.type {
        case .exercise:
            return """
                Eccentric strengthening exercises are supported by research published in the British Journal of Sports Medicine \
                and guidelines from the American Academy of Orthopaedic Surgeons.
                """
        case .stretch:
            return """
                Stretching protocols are based on clinical studies published in the British Journal of Sports Medicine \
                demonstrating effectiveness for lateral epicondylitis.
                """
        case .iceTherapy:
            return """
                Cryotherapy recommendations follow evidence-based protocols for musculoskeletal injury management \
                as published in peer-reviewed sports medicine journals.
                """
        case .rest:
            return "Rest and activity modification guidance follows AAOS and Mayo Clinic recommendations for tennis elbow recovery."
        case .medication:
            return "Always consult with a healthcare provider regarding medication. This activity tracks compliance only."
        case .painTracking:
            return "Pain tracking helps monitor recovery progress as recommended in clinical practice guidelines."
        }
    }
    
    var sourceURL: URL? {
        switch activity.type {
        case .exercise:
            return URL(string: "https://pubmed.ncbi.nlm.nih.gov/24124037/")
        case .stretch:
            return URL(string: "https://pubmed.ncbi.nlm.nih.gov/16118297/")
        case .iceTherapy:
            return URL(string: "https://pubmed.ncbi.nlm.nih.gov/15155427/")
        case .rest, .medication, .painTracking:
            return URL(string: "https://orthoinfo.aaos.org/en/diseases--conditions/tennis-elbow-lateral-epicondylitis/")
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

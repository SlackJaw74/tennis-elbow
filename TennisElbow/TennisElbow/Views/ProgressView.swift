import Charts
import SwiftUI

struct TreatmentProgressView: View {
    @EnvironmentObject var treatmentManager: TreatmentManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    overallProgressCard

                    painTrendCard

                    painChartCard

                    weightProgressCard

                    weeklyProgressCard

                    activityBreakdownCard

                    completionHistoryCard
                }
                .padding()
            }
            .navigationTitle("Progress".localized())
        }
    }

    var overallProgressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Completion".localized())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            let completionRate = treatmentManager.getCompletionRate()

            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: completionRate)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    VStack {
                        Text("\(Int(completionRate * 100))%")
                            .font(.title)
                            .bold()
                        Text("Complete".localized())
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Overall completion")
                .accessibilityValue("\(Int(completionRate * 100)) percent complete")

                VStack(alignment: .leading, spacing: 12) {
                    StatRow(
                        label: "Total Activities".localized(),
                        value: "\(treatmentManager.scheduledActivities.count)"
                    )
                    StatRow(
                        label: "Completed".localized(),
                        value: "\(treatmentManager.scheduledActivities.filter(\.isCompleted).count)",
                        color: .green
                    )
                    StatRow(
                        label: "Remaining".localized(),
                        value: "\(treatmentManager.scheduledActivities.filter { !$0.isCompleted }.count)",
                        color: .orange
                    )
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var painTrendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pain Trend".localized())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            if let avgPain = treatmentManager.getAveragePainLevel() {
                let trend = treatmentManager.getPainTrend()
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.1f", avgPain))
                            .font(.title)
                            .bold()
                        Text("Average Pain Level".localized())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Average pain level: \(String(format: "%.1f", avgPain))")

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(trend)
                            .font(.headline)
                            .foregroundColor(trendColor(trend))
                        Image(systemName: trendIcon(trend))
                            .font(.title)
                            .foregroundColor(trendColor(trend))
                            .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Pain trend: \(trend)")
                }
            } else {
                Text("progress.track_pain_prompt".localized())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var painChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("pain_history_30_days".localized())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            let painHistory = treatmentManager.getPainHistory(days: 30)

            if !painHistory.isEmpty {
                Chart {
                    ForEach(Array(painHistory.enumerated()), id: \.offset) { _, data in
                        LineMark(
                            x: .value("Date", data.0),
                            y: .value("Pain", data.1)
                        )
                        .foregroundStyle(Color.red)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", data.0),
                            y: .value("Pain", data.1)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .chartYScale(domain: 0 ... 4)
                .chartYAxis {
                    AxisMarks(values: [0, 1, 2, 3, 4]) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                Text(PainLevel(rawValue: intValue)?.description ?? "")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                .frame(height: 200)
                .accessibilityLabel("Pain history chart for the last 30 days")
                .accessibilityHint(chartAccessibilityHint(painHistory: painHistory))
            } else {
                Text("No pain data recorded yet".localized())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var weightProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("weight_progress_30_days".localized())
                .font(.headline)

            let weightHistory = treatmentManager.getWeightProgressHistory(days: 30)

            if !weightHistory.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if let avgWeight = treatmentManager.getAverageWeight() {
                        HStack {
                            Text("Average:".localized())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f %@", avgWeight, "lbs".localized()))
                                .font(.caption)
                                .bold()
                            Spacer()
                            if let maxWeight = weightHistory.map(\.1).max() {
                                Text("Max:".localized())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%d %@", Int(maxWeight), "lbs".localized()))
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }

                    Chart {
                        ForEach(Array(weightHistory.enumerated()), id: \.offset) { _, data in
                            LineMark(
                                x: .value("Date", data.0),
                                y: .value("Weight", data.1)
                            )
                            .foregroundStyle(Color.blue)
                            .interpolationMethod(.catmullRom)

                            PointMark(
                                x: .value("Date", data.0),
                                y: .value("Weight", data.1)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let intValue = value.as(Int.self) {
                                    Text(String(format: "%d %@", intValue, "lbs".localized()))
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
            } else {
                Text("progress.track_weight_prompt".localized())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var weeklyProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week".localized())
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            let weeklyRate = treatmentManager.getWeeklyCompletionRate()

            ProgressView(value: weeklyRate)
                .tint(.green)
                .accessibilityLabel("Weekly progress")
                .accessibilityValue("\(Int(weeklyRate * 100)) percent complete")

            HStack {
                Text(String(format: "progress.week_completion".localized(), Int(weeklyRate * 100)))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: weeklyRate >= 0.8 ? "trophy.fill" : "flag.fill")
                    .foregroundColor(weeklyRate >= 0.8 ? .yellow : .blue)
                    .accessibilityLabel(weeklyRate >= 0.8 ? "Achievement trophy" : "Goal flag")
                    .accessibilityHidden(true)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var activityBreakdownCard: some View {
        let activityCounts = getActivityTypeCounts()

        return VStack(alignment: .leading, spacing: 12) {
            Text("Activity Breakdown".localized())
                .font(.headline)

            ForEach(Array(activityCounts.keys.sorted { $0.rawValue < $1.rawValue }), id: \.self) { type in
                if let count = activityCounts[type] {
                    HStack {
                        Image(systemName: iconForType(type))
                            .foregroundColor(colorForType(type))
                            .frame(width: 30)

                        Text(type.rawValue.capitalized)
                            .font(.subheadline)

                        Spacer()

                        Text("\(count)")
                            .font(.subheadline)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var completionHistoryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Completions".localized())
                .font(.headline)

            let recentCompletions = treatmentManager.scheduledActivities
                .filter(\.isCompleted)
                .sorted { ($0.completedTime ?? Date.distantPast) > ($1.completedTime ?? Date.distantPast) }
                .prefix(5)

            if recentCompletions.isEmpty {
                Text("No completed activities yet".localized())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(Array(recentCompletions)) { scheduled in
                    HStack {
                        Image(systemName: scheduled.activity.imageSystemName)
                            .foregroundColor(.green)

                        VStack(alignment: .leading) {
                            Text(scheduled.activity.localizedName)
                                .font(.caption)
                            if let completedTime = scheduled.completedTime {
                                Text(completedTime.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    func getActivityTypeCounts() -> [ActivityType: Int] {
        var counts: [ActivityType: Int] = [:]
        for scheduled in treatmentManager.scheduledActivities.filter(\.isCompleted) {
            counts[scheduled.activity.type, default: 0] += 1
        }
        return counts
    }

    func iconForType(_ type: ActivityType) -> String {
        switch type {
        case .exercise: return "dumbbell.fill"
        case .stretch: return "figure.flexibility"
        case .iceTherapy: return "snowflake"
        case .rest: return "bed.double.fill"
        case .medication: return "pills.fill"
        case .painTracking: return "heart.text.square.fill"
        }
    }

    func colorForType(_ type: ActivityType) -> Color {
        switch type {
        case .exercise: return .blue
        case .stretch: return .green
        case .iceTherapy: return .cyan
        case .rest: return .purple
        case .medication: return .orange
        case .painTracking: return .red
        }
    }

    func trendColor(_ trend: String) -> Color {
        switch trend {
        case "Improving": return .green
        case "Worsening": return .red
        case "Stable": return .orange
        default: return .secondary
        }
    }

    func trendIcon(_ trend: String) -> String {
        switch trend {
        case "Improving": return "arrow.down.circle.fill"
        case "Worsening": return "arrow.up.circle.fill"
        case "Stable": return "arrow.left.arrow.right.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }

    func chartAccessibilityHint(painHistory: [(Date, Double)]) -> String {
        guard !painHistory.isEmpty else { return "No data available" }
        let values = painHistory.map(\.1)
        let minPain = values.min() ?? 0
        let maxPain = values.max() ?? 0
        let avgPain = values.reduce(0, +) / Double(values.count)
        let minStr = String(format: "%.1f", minPain)
        let maxStr = String(format: "%.1f", maxPain)
        let avgStr = String(format: "%.1f", avgPain)
        return "Chart shows pain levels ranging from \(minStr) to \(maxStr), with an average of \(avgStr)"
    }
}

struct StatRow: View {
    let label: String
    let value: String
    var color: Color = .primary

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
                .foregroundColor(color)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

#Preview {
    TreatmentProgressView()
        .environmentObject(TreatmentManager())
}

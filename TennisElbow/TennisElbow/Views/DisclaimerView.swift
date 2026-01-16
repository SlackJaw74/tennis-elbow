import SwiftUI

struct DisclaimerView: View {
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    @Environment(\.dismiss) var dismiss
    let isInitialLaunch: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.top)

                    Text("Medical Disclaimer".localized())
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Important Information".localized())
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)

                        Text("disclaimer.description".localized())

                        Text("Please Note:".localized())
                            .font(.headline)
                            .padding(.top, 8)
                            .accessibilityAddTraits(.isHeader)

                        BulletText(
                            text: "disclaimer.consult_provider".localized()
                        )
                        BulletText(
                            text: "disclaimer.seek_attention".localized()
                        )
                        BulletText(text: "disclaimer.individual_results".localized())
                        BulletText(text: "disclaimer.not_replacement".localized())
                        BulletText(text: "disclaimer.stop_pain".localized())

                        Text("Medical Sources".localized())
                            .font(.headline)
                            .padding(.top, 8)
                            .accessibilityAddTraits(.isHeader)

                        Text("disclaimer.sources_description".localized())

                        if !isInitialLaunch {
                            NavigationLink {
                                MedicalSourcesView()
                            } label: {
                                HStack {
                                    Image(systemName: "books.vertical")
                                    Text("View All Medical Sources & Citations".localized())
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            .padding(.top, 4)
                            .accessibilityLabel("View all medical sources and citations")
                            .accessibilityHint(
                                "Opens a list of medical research sources"
                            )
                        }

                        Text("Data & Privacy".localized())
                            .font(.headline)
                            .padding(.top, 8)
                            .accessibilityAddTraits(.isHeader)

                        Text("disclaimer.privacy_description".localized())
                    }
                    .padding(.horizontal)

                    if isInitialLaunch {
                        VStack(spacing: 12) {
                            Button {
                                hasAcceptedDisclaimer = true
                                dismiss()
                            } label: {
                                Text("Accept and Continue".localized())
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .accessibilityLabel("Accept and continue")
                            .accessibilityHint(
                                "Accepts the medical disclaimer and continues to the app"
                            )

                            Button {
                                hasAcceptedDisclaimer = false
                                // Exit app - user rejected terms
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    exit(0)
                                }
                            } label: {
                                Text("Decline".localized())
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.red)
                                    .cornerRadius(12)
                            }
                            .accessibilityLabel("Decline")
                            .accessibilityHint(
                                "Declines the medical disclaimer and exits the app"
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Text("Close".localized())
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .accessibilityLabel("Close")
                        .accessibilityHint("Closes the medical disclaimer")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled(isInitialLaunch)
        }
    }
}

struct BulletText: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.body)
                .bold()
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    DisclaimerView(isInitialLaunch: true)
}

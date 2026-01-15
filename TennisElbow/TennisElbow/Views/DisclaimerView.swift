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
                    
                    Text("Medical Disclaimer")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Important Information")
                            .font(.headline)
                        
                        Text("""
                        This app is designed to provide general information and guidance about tennis elbow (lateral epicondylitis) \
                        exercises and treatment approaches. It is NOT intended to be a substitute for professional medical advice, \
                        diagnosis, or treatment.
                        """)
                        
                        Text("Please Note:")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        BulletText(text: "Always consult with a qualified healthcare provider before starting any treatment program")
                        BulletText(text: "If you experience severe pain, swelling, or symptoms that worsen, seek immediate medical attention")
                        BulletText(text: "Individual results may vary based on the severity of your condition")
                        BulletText(text: "This app does not replace physical therapy or medical treatment")
                        BulletText(text: "Stop any exercise that causes sharp pain")
                        

                        Text("Medical Sources")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("""
                        The exercises and treatment recommendations in this app are based on peer-reviewed medical research \
                        and guidelines from recognized medical organizations including the American Academy of Orthopaedic Surgeons (AAOS), \
                        Mayo Clinic, and published studies in the British Journal of Sports Medicine.
                        """)
                        
                        if !isInitialLaunch {
                            NavigationLink {
                                MedicalSourcesView()
                            } label: {
                                HStack {
                                    Image(systemName: "books.vertical")
                                    Text("View All Medical Sources & Citations")
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            .padding(.top, 4)
                        }
                        
                        Text("Data & Privacy")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("""
                        All your health data (activities, pain levels, progress) is stored locally on your device. \
                        We do not collect, transmit, or share your personal health information with any third parties.
                        """)
                    }
                    .padding(.horizontal)
                    
                    if isInitialLaunch {
                        VStack(spacing: 12) {
                            Button {
                                hasAcceptedDisclaimer = true
                                dismiss()
                            } label: {
                                Text("Accept and Continue")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button {
                                hasAcceptedDisclaimer = false
                                // Exit app - user rejected terms
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    exit(0)
                                }
                            } label: {
                                Text("Decline")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.red)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Text("Close")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
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

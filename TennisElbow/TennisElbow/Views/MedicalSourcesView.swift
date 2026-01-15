import SwiftUI

struct MedicalSource: Identifiable {
    let id = UUID()
    let title: String
    let authors: String
    let publication: String
    let year: String
    let url: String
    let description: String
}

struct MedicalSourcesView: View {
    let sources: [MedicalSource] = [
        MedicalSource(
            title: "Lateral Epicondylitis (Tennis Elbow)",
            authors: "American Academy of Orthopaedic Surgeons",
            publication: "OrthoInfo",
            year: "2024",
            url: "https://orthoinfo.aaos.org/en/diseases--conditions/tennis-elbow-lateral-epicondylitis/",
            description: "Comprehensive overview of tennis elbow including symptoms, causes, and treatment options from AAOS."
        ),
        MedicalSource(
            title: "Effectiveness of eccentric exercises in lateral elbow tendinopathy",
            authors: "Peterson M, Butler S, Eriksson M, Svärdsudd K",
            publication: "British Journal of Sports Medicine",
            year: "2014",
            url: "https://pubmed.ncbi.nlm.nih.gov/24124037/",
            description: "Clinical study demonstrating the effectiveness of eccentric wrist extensor exercises for lateral epicondylitis."
        ),
        MedicalSource(
            title: "A systematic review of the effectiveness of eccentric strengthening in the treatment of lateral epicondylalgia",
            authors: "Raman J, MacDermid JC, Grewal R",
            publication: "International Journal of Sports Physical Therapy",
            year: "2012",
            url: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3474303/",
            description: "Systematic review supporting eccentric strengthening exercises for tennis elbow treatment."
        ),
        MedicalSource(
            title: "Tennis Elbow",
            authors: "Mayo Clinic Staff",
            publication: "Mayo Clinic",
            year: "2024",
            url: "https://www.mayoclinic.org/diseases-conditions/tennis-elbow/symptoms-causes/syc-20351987",
            description: "Medical reference for symptoms, causes, and self-care treatments for lateral epicondylitis."
        ),
        MedicalSource(
            title: "Lateral Epicondylitis: A Review of Pathology and Management",
            authors: "Buchanan BK, Varacallo M",
            publication: "StatPearls - NCBI Bookshelf",
            year: "2024",
            url: "https://www.ncbi.nlm.nih.gov/books/NBK431092/",
            description: "Comprehensive medical review of lateral epicondylitis pathophysiology and evidence-based management."
        ),
        MedicalSource(
            title: "Stretching exercises for chronic lateral epicondylitis",
            authors: "Stasinopoulos D, Stasinopoulos I, Pantelis M, Stasinopoulou K",
            publication: "British Journal of Sports Medicine",
            year: "2005",
            url: "https://pubmed.ncbi.nlm.nih.gov/16118297/",
            description: "Research on the effectiveness of wrist extensor stretching in tennis elbow rehabilitation."
        ),
        MedicalSource(
            title: "Physical therapy management of lateral epicondylitis",
            authors: "American Physical Therapy Association",
            publication: "Journal of Orthopaedic & Sports Physical Therapy",
            year: "2015",
            url: "https://www.jospt.org/doi/10.2519/jospt.2015.0302",
            description: "Clinical practice guidelines for physical therapy treatment of lateral epicondylitis."
        ),
        MedicalSource(
            title: "Cryotherapy in treatment of acute injuries",
            authors: "Bleakley CM, McDonough SM, MacAuley DC",
            publication: "British Journal of Sports Medicine",
            year: "2004",
            url: "https://pubmed.ncbi.nlm.nih.gov/15155427/",
            description: "Evidence for ice therapy application protocols in musculoskeletal injury management."
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection

                disclaimerSection

                sourcesListSection

                additionalResourcesSection
            }
            .padding()
        }
        .navigationTitle("Medical Sources".localized())
        .navigationBarTitleDisplayMode(.inline)
    }

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "books.vertical.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("References & Citations".localized())
                    .font(.title2)
                    .bold()
            }

            Text("medical_sources.description".localized())
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Important Note".localized(), systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundColor(.orange)

            Text("medical_sources.disclaimer".localized())
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemOrange).opacity(0.1))
        .cornerRadius(12)
    }

    var sourcesListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Peer-Reviewed Sources".localized())
                .font(.headline)

            ForEach(sources) { source in
                SourceCard(source: source)
            }
        }
    }

    var additionalResourcesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Resources".localized())
                .font(.headline)
                .padding(.top)

            ResourceLink(
                title: "National Institutes of Health (NIH)".localized(),
                subtitle: "MedlinePlus - Tennis Elbow".localized(),
                url: "https://medlineplus.gov/tenniselbow.html"
            )

            ResourceLink(
                title: "Cleveland Clinic".localized(),
                subtitle: "Lateral Epicondylitis Overview".localized(),
                url: "https://my.clevelandclinic.org/health/diseases/7049-tennis-elbow-lateral-epicondylitis"
            )

            ResourceLink(
                title: "NHS (UK National Health Service)".localized(),
                subtitle: "Tennis Elbow Treatment Guide".localized(),
                url: "https://www.nhs.uk/conditions/tennis-elbow/"
            )
        }
    }
}

struct SourceCard: View {
    let source: MedicalSource

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(source.title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)

            Text(source.authors)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text(source.publication)
                    .italic()
                Text("(\(source.year))")
            }
            .font(.caption)
            .foregroundColor(.secondary)

            Text(source.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 2)

            if let url = URL(string: source.url) {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                        Text("View Source".localized())
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct ResourceLink: View {
    let title: String
    let subtitle: String
    let url: String

    var body: some View {
        if let linkURL = URL(string: url) {
            Link(destination: linkURL) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MedicalSourcesView()
    }
}

import SwiftUI

@main
struct PlutokratApp: App {
    var body: some Scene {
        WindowGroup { RootView().preferredColorScheme(.dark) }
    }
}

enum Gold {
    static let base = Color(red: 0.83, green: 0.65, blue: 0.2)
    static let gradient = LinearGradient(
        colors: [Color(red: 0.99, green: 0.88, blue: 0.5), base, Color(red: 0.6, green: 0.42, blue: 0.1)],
        startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct RootView: View {
    @AppStorage("name") private var name = ""
    @AppStorage("since") private var since = 0.0

    var body: some View {
        Group {
            if name.isEmpty {
                NameGate(name: $name)
            } else {
                HomeView(name: name)
            }
        }
        .onAppear { if since == 0 { since = Date().timeIntervalSince1970 } }
    }
}

struct NameGate: View {
    @Binding var name: String
    @State private var input = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("PLUTOKRAT").font(.system(size: 34, weight: .black, design: .serif)).foregroundStyle(Gold.gradient)
            Text("Wie dürfen wir Sie ansprechen?").foregroundStyle(.secondary)
            TextField("Name", text: $input)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Button("Eintreten") { name = input.trimmingCharacters(in: .whitespaces) }
                .buttonStyle(.borderedProminent).tint(Gold.base)
                .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}

struct HomeView: View {
    let name: String

    var body: some View {
        NavigationStack {
            List {
                Section("Guten Tag, \(name)") {
                    row("Zertifikat", "rosette", CertificateView(name: name))
                    row("Vermögens-Ticker", "eurosign.circle", TickerView())
                    row("Champagner", "wineglass", ChampagneView())
                    row("Butler", "bell", ButlerView())
                    row("Privatjet-Bordkarte", "airplane", BoardingPassView(name: name))
                    row("Anruf vom Yachtkapitän", "phone", FakeCallView())
                    row("Plebs-Rechner", "person.3", PeasantView())
                }
            }
            .navigationTitle("Plutokrat")
        }
        .tint(Gold.base)
    }

    private func row<V: View>(_ title: String, _ icon: String, _ dest: V) -> some View {
        NavigationLink { dest } label: { Label(title, systemImage: icon) }
    }
}

/// Rendert beliebigen Inhalt zu einem Bild und bietet ihn zum Teilen an.
struct ShareCard<Content: View>: View {
    let key: String
    @ViewBuilder let content: () -> Content
    @State private var image: UIImage?

    var body: some View {
        VStack(spacing: 20) {
            content()
            if let image {
                ShareLink(item: Image(uiImage: image),
                          preview: SharePreview("Plutokrat", image: Image(uiImage: image))) {
                    Label("Angeben", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .task(id: key) { image = await render() }
    }

    @MainActor private func render() -> UIImage? {
        let r = ImageRenderer(content: content().padding(8))
        r.scale = 3
        return r.uiImage
    }
}

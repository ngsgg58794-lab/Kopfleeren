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
            Text("CROESUS").font(.system(size: 34, weight: .black, design: .serif)).foregroundStyle(Gold.gradient)
            Text("How may we address you?").foregroundStyle(.secondary)
            TextField("Name", text: $input)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Button("Enter") { name = input.trimmingCharacters(in: .whitespaces) }
                .buttonStyle(.borderedProminent).tint(Gold.base)
                .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}

enum Screen: String, Hashable, CaseIterable {
    case certificate, ticker, champagne, butler, boarding, calls, peasant

    var title: LocalizedStringKey {
        switch self {
        case .certificate: "Certificate"
        case .ticker: "Wealth Ticker"
        case .champagne: "Champagne"
        case .butler: "Butler"
        case .boarding: "Private Jet Boarding Pass"
        case .calls: "Calls"
        case .peasant: "Peasant Calculator"
        }
    }

    var icon: String {
        switch self {
        case .certificate: "rosette"
        case .ticker: "eurosign.circle"
        case .champagne: "wineglass"
        case .butler: "bell"
        case .boarding: "airplane"
        case .calls: "phone"
        case .peasant: "person.3"
        }
    }
}

struct HomeView: View {
    let name: String
    @ObservedObject private var calls = CallCenter.shared
    // Launch-Argument `-startScreen <name>` öffnet direkt einen Screen (für automatische Screenshots).
    @State private var path: [Screen] = UserDefaults.standard.string(forKey: "startScreen")
        .flatMap(Screen.init(rawValue:)).map { [$0] } ?? []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Good day, \(name)") {
                    ForEach(Screen.allCases, id: \.self) { s in
                        NavigationLink(value: s) { Label(s.title, systemImage: s.icon) }
                    }
                }
            }
            .navigationTitle("Croesus")
            .navigationDestination(for: Screen.self) { destination($0) }
        }
        .tint(Gold.base)
        .fullScreenCover(item: $calls.incoming) { c in CallScreen(caller: c) { calls.incoming = nil } }
    }

    @ViewBuilder private func destination(_ s: Screen) -> some View {
        switch s {
        case .certificate: CertificateView(name: name)
        case .ticker: TickerView()
        case .champagne: ChampagneView()
        case .butler: ButlerView()
        case .boarding: BoardingPassView(name: name)
        case .calls: FakeCallView()
        case .peasant: PeasantView()
        }
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
                          preview: SharePreview("Croesus", image: Image(uiImage: image))) {
                    Label("Show off", systemImage: "square.and.arrow.up")
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

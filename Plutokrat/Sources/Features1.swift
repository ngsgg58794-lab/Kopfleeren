import SwiftUI

// MARK: - Zertifikat

struct CertificateView: View {
    let name: String
    @AppStorage("since") private var since = 0.0

    private var date: Date { Date(timeIntervalSince1970: since) }
    private var serial: String { String(format: "%06d", Int(since) % 1_000_000) }

    var body: some View {
        ShareCard(key: name + serial) {
            VStack(spacing: 14) {
                Text("ZERTIFIKAT").font(.caption.weight(.semibold)).tracking(6)
                Text(name).font(.system(size: 30, weight: .bold, design: .serif)).multilineTextAlignment(.center)
                Text("hat 100 € für eine App ausgegeben,\ndie nichts kann.\nAbsichtlich.")
                    .font(.system(.body, design: .serif)).multilineTextAlignment(.center)
                Divider().overlay(.black.opacity(0.4))
                HStack {
                    Text("Seriennr. \(serial)")
                    Spacer()
                    Text(date.formatted(date: .long, time: .omitted))
                }.font(.caption.monospaced())
            }
            .foregroundStyle(.black)
            .padding(28)
            .frame(maxWidth: .infinity)
            .background(Gold.gradient, in: RoundedRectangle(cornerRadius: 18))
        }
        .navigationTitle("Zertifikat")
    }
}

// MARK: - Ticker

struct TickerView: View {
    @AppStorage("income") private var income = 1_000_000.0
    @State private var start = Date()

    var body: some View {
        VStack(spacing: 24) {
            let perSecond = income / (365 * 24 * 3600)
            TimelineView(.animation) { ctx in
                let earned = ctx.date.timeIntervalSince(start) * perSecond
                Text(earned, format: .currency(code: "EUR").precision(.fractionLength(2)))
                    .font(.system(size: 44, weight: .bold, design: .monospaced))
                    .foregroundStyle(Gold.gradient)
                    .minimumScaleFactor(0.5)
            }
            Text("verdient, seit Sie diesen Bildschirm geöffnet haben").foregroundStyle(.secondary)
            Text("\(perSecond, format: .currency(code: "EUR").precision(.fractionLength(2))) pro Sekunde")
            HStack {
                Text("Jahreseinkommen")
                TextField("€", value: $income, format: .number)
                    .keyboardType(.decimalPad).textFieldStyle(.roundedBorder).multilineTextAlignment(.trailing)
            }.padding(.horizontal)
            Button("Zurücksetzen") { start = Date() }
        }
        .padding()
        .navigationTitle("Vermögens-Ticker")
    }
}

// MARK: - Champagner

struct ChampagneView: View {
    private struct Bubble: Identifiable {
        let id = UUID()
        let emoji = ["🍾", "🥂", "✨", "💰", "💎"].randomElement()!
        let x = CGFloat.random(in: -150...150)
        let height = CGFloat.random(in: 250...600)
        let delay = Double.random(in: 0...0.4)
    }

    @State private var bubbles: [Bubble] = []
    @State private var fired = false

    var body: some View {
        ZStack {
            ForEach(bubbles) { b in
                Text(b.emoji).font(.largeTitle)
                    .offset(x: b.x, y: fired ? -b.height : 200)
                    .opacity(fired ? 0 : 1)
                    .animation(.easeOut(duration: 1.6).delay(b.delay), value: fired)
            }
            Button {
                bubbles = (0..<40).map { _ in Bubble() }
                fired = false
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                DispatchQueue.main.async { fired = true }
            } label: {
                Text("🍾").font(.system(size: 90))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Champagner")
    }
}

// MARK: - Butler

struct ButlerView: View {
    private static let lines = [
        "Ihr Wagen ist vorgefahren. Der andere auch.",
        "Den Preis habe ich nicht nachgesehen, Sir.",
        "Ihr Kontostand wurde nicht geprüft. Aus Prinzip.",
        "Der Helikopter steht bereit. Das Ziel ist noch unbekannt.",
        "Ich habe Ihren Kalender geleert. Vorsichtshalber auch den von morgen.",
        "Die Yacht war zu klein. Eine größere ist bestellt.",
        "Ich habe Ihre Anrufe gefiltert. Alle.",
        "Ihnen war langweilig. Es wurde eine Insel gekauft.",
        "Ihr Frühstück ist serviert. Es kostet mehr als Ihr Gast verdient.",
        "Sir, das Wort „Budget“ wurde aus dem Haushalt entfernt."
    ]
    @State private var line = "Sie haben geläutet, Sir?"

    var body: some View {
        VStack(spacing: 32) {
            Text("🤵").font(.system(size: 90))
            Text(line).font(.system(.title3, design: .serif)).multilineTextAlignment(.center).padding(.horizontal)
            Button("Butler rufen") {
                line = Self.lines.filter { $0 != line }.randomElement()!
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }.buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Butler")
    }
}

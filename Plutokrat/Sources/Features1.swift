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
    @AppStorage("name") private var name = "Sir"

    private static let general = [
        "Ihr Wagen ist vorgefahren. Der andere auch.",
        "Den Preis habe ich nicht nachgesehen, %@.",
        "Ihr Kontostand wurde nicht geprüft. Aus Prinzip.",
        "Der Helikopter steht bereit. Das Ziel ist noch unbekannt.",
        "Ich habe Ihren Kalender geleert. Vorsichtshalber auch den von morgen.",
        "Die Yacht war zu klein. Eine größere ist bestellt.",
        "Ich habe Ihre Anrufe gefiltert. Alle.",
        "Ihnen war langweilig. Es wurde eine Insel gekauft.",
        "Das Wort „Budget“ wurde aus dem Haushalt entfernt.",
        "%@, Ihr Nachbar hat eine neue Villa. Ihr Nachbar hat jetzt keinen Nachbarn mehr.",
        "Ich habe die Rechnung nicht gelesen. Der Steuerberater hat geweint.",
        "Der Preis war ein Tippfehler. Ich habe den Hersteller gekauft, damit er nicht korrigiert.",
        "Die Warteschlange wurde aufgelöst. Der Laden gehört jetzt Ihnen.",
        "Ihr Hund hat einen eigenen Jet. Er hat sich bedankt.",
        "Das Restaurant war ausgebucht. Es ist jetzt umgebaut, nur für Sie.",
        "Ich habe Ihre Schwäche für Schnäppchen behandeln lassen. Es war teuer.",
        "Die Zeitung hat Ihren Namen falsch geschrieben. Die Zeitung gehört jetzt Ihnen.",
        "Wetter? Wird nach Ihren Wünschen eingekauft.",
        "Der Pool war zu kalt. Das Meer wird angerufen.",
        "Sie wollten Ruhe. Das Dorf wurde evakuiert.",
        "%@, das Geld arbeitet. Sie müssen es nicht auch.",
        "Ihre Kreditkarte ist verwirrt. Sie hat noch nie ein Limit gesehen.",
        "Der Lieferant bittet um Zahlung. Ich habe ihn gekauft.",
        "Ich habe den Stau abgesagt.",
    ]
    private static let morning = [
        "Guten Morgen, %@. Ihr Frühstück ist serviert. Es kostet mehr als das Tablett.",
        "Der Kaffee ist 40 Jahre gereift. Genau wie Ihr Vermögen.",
        "Die Sonne ist pünktlich aufgegangen. Ich habe nachgefragt.",
        "Ihr Terminkalender: nichts. Das ist teurer als es klingt.",
        "Die Zeitung wurde gebügelt. Die Börsenseite wurde entfernt, aus Respekt vor den Verlierern.",
    ]
    private static let day = [
        "Mittagszeit. Der Koch fliegt gerade ein. Der Käse braucht noch zwei Stunden.",
        "Ein Termin wurde abgesagt, weil er nicht in Ihr Gefühl passte.",
        "Ihr Anwalt bittet um Rückruf. Ich habe ihn gefeuert und neu eingestellt. Dasselbe Büro.",
        "Die Aktienkurse? Ich habe sie freundlich gebeten, zu steigen.",
    ]
    private static let evening = [
        "Guten Abend, %@. Der Champagner atmet. Der Sommelier auch.",
        "Das Abendessen wartet. Der Küchenchef wartet auch. Beide gegen Bezahlung.",
        "Ihr Smoking ist gebügelt. Der andere auch. Für spontane Anlässe.",
        "Die Oper wurde auf Ihre Ankunft verschoben. Das Publikum wurde informiert.",
        "Der Kamin brennt. Das Holz stammt aus einem Wald, den Sie nicht kennen.",
        "Ein Konzert wurde verlegt, weil Sie nicht rechtzeitig kommen konnten.",
    ]
    private static let night = [
        "%@, es ist spät. Ich habe die Nacht um eine Stunde verlängert.",
        "Ihr Schlaf wurde kostenpflichtig optimiert.",
        "Das Hauspersonal schläft nicht. Es hat keine Genehmigung dazu.",
        "Der Mond wurde nicht bezahlt. Ich kümmere mich morgen darum.",
        "Gute Nacht. Der Wecker klingelt, wenn Sie es sagen. Nicht früher.",
    ]
    private static let extras = [
        "ein Team von zwölf Personen beauftragt",
        "der Hersteller gekauft",
        "ein Gutachter entlassen, weil er nach dem Preis fragte",
        "eine zweite Version bestellt, falls die erste Ihnen nicht gefällt",
        "ein Hubschrauber vorsorglich losgeschickt",
        "der Zeitplan abgeschafft",
        "ein Experte aus Zürich eingeflogen, der niemandem etwas sagen darf",
        "das Wetter vorsichtshalber informiert",
    ]

    @State private var shown = "Sie haben geläutet?"
    @State private var last = ""
    @State private var typing: Task<Void, Never>?
    @State private var wish = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("🤵").font(.system(size: 90)).padding(.top, 24)
                Text(shown).font(.system(.title3, design: .serif)).multilineTextAlignment(.center)
                    .frame(minHeight: 110, alignment: .top).padding(.horizontal)
                Button("Butler rufen") { say(pick()) }.buttonStyle(.borderedProminent)
                Divider().padding(.horizontal)
                VStack(spacing: 12) {
                    Text("Auftrag erteilen").font(.headline)
                    TextField("Was wünschen Sie?", text: $wish).textFieldStyle(.roundedBorder)
                    Button("Erteilen") { order() }.buttonStyle(.bordered)
                        .disabled(wish.trimmingCharacters(in: .whitespaces).isEmpty)
                }.padding(.horizontal)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Butler")
        .onAppear { shown = "Sie haben geläutet, \(name)?" }
    }

    private func pick() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timed: [String]
        switch hour {
        case 5..<11: timed = Self.morning
        case 11..<17: timed = Self.day
        case 17..<22: timed = Self.evening
        default: timed = Self.night
        }
        let pool = (Self.general + timed).filter { $0 != last }
        let raw = pool.randomElement() ?? Self.general[0]
        last = raw
        return raw.replacingOccurrences(of: "%@", with: name)
    }

    private func order() {
        let w = wish.trimmingCharacters(in: .whitespaces)
        wish = ""
        let extra = Self.extras.randomElement()!
        say("Selbstverständlich, \(name). „\(w)“ wird erledigt. Dafür wurde bereits \(extra).")
    }

    @MainActor private func say(_ text: String) {
        typing?.cancel()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        shown = ""
        typing = Task {
            for ch in text {
                if Task.isCancelled { return }
                shown.append(ch)
                try? await Task.sleep(for: .milliseconds(25))
            }
        }
    }
}

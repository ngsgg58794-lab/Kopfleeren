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
                Text("CERTIFICATE").font(.caption.weight(.semibold)).tracking(6)
                Text(name).font(.system(size: 30, weight: .bold, design: .serif)).multilineTextAlignment(.center)
                Text("has paid €100 for an app\nthat does nothing.\nOn purpose.")
                    .font(.system(.body, design: .serif)).multilineTextAlignment(.center)
                Divider().overlay(.black.opacity(0.4))
                HStack {
                    Text("Serial no. \(serial)")
                    Spacer()
                    Text(date.formatted(date: .long, time: .omitted))
                }.font(.caption.monospaced())
            }
            .foregroundStyle(.black)
            .padding(28)
            .frame(maxWidth: .infinity)
            .background(Gold.gradient, in: RoundedRectangle(cornerRadius: 18))
        }
        .navigationTitle("Certificate")
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
            Text("earned since you opened this screen").foregroundStyle(.secondary)
            Text("\(perSecond, format: .currency(code: "EUR").precision(.fractionLength(2))) per second")
            HStack {
                Text("Annual income")
                TextField("€", value: $income, format: .number)
                    .keyboardType(.decimalPad).textFieldStyle(.roundedBorder).multilineTextAlignment(.trailing)
            }.padding(.horizontal)
            Button("Reset") { start = Date() }
        }
        .padding()
        .navigationTitle("Wealth Ticker")
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
        .navigationTitle("Champagne")
    }
}

// MARK: - Butler

struct ButlerView: View {
    @AppStorage("name") private var name = "Sir"

    private static let general = [
        "Your car has arrived. So has the other one.",
        "I did not look at the price, %@.",
        "Your balance has not been checked. On principle.",
        "The helicopter is ready. The destination is still unknown.",
        "I have cleared your calendar. Tomorrow's too, just in case.",
        "The yacht was too small. A bigger one has been ordered.",
        "I have screened your calls. All of them.",
        "You were bored. An island has been purchased.",
        "The word “budget” has been removed from the household.",
        "%@, your neighbor has a new villa. Your neighbor no longer has a neighbor.",
        "I did not read the invoice. The accountant wept.",
        "The price was a typo. I bought the manufacturer so it cannot be corrected.",
        "The queue has been dissolved. The shop is now yours.",
        "Your dog has its own jet. It sends its thanks.",
        "The restaurant was fully booked. It has been rebuilt, just for you.",
        "I had your weakness for bargains treated. It was expensive.",
        "The newspaper misspelled your name. The newspaper is now yours.",
        "Weather? It is being purchased to your specifications.",
        "The pool was too cold. The ocean is being called.",
        "You wanted peace and quiet. The village has been evacuated.",
        "%@, the money is working. You need not.",
        "Your credit card is confused. It has never seen a limit.",
        "The supplier requests payment. I bought the supplier.",
        "I have cancelled the traffic jam.",
    ]
    private static let morning = [
        "Good morning, %@. Breakfast is served. It costs more than the tray.",
        "The coffee has aged 40 years. Just like your fortune.",
        "The sun rose on time. I checked.",
        "Your schedule: nothing. That is more expensive than it sounds.",
        "The newspaper has been ironed. The stock page was removed, out of respect for the losers.",
    ]
    private static let day = [
        "Lunchtime. The chef is being flown in. The cheese needs two more hours.",
        "An appointment was cancelled because it did not suit your mood.",
        "Your lawyer requests a call back. I fired and rehired him. Same office.",
        "The stock prices? I kindly asked them to rise.",
    ]
    private static let evening = [
        "Good evening, %@. The champagne is breathing. So is the sommelier.",
        "Dinner is waiting. The chef is waiting too. Both on the clock.",
        "Your tuxedo is pressed. So is the other one. For spontaneous occasions.",
        "The opera has been postponed until you arrive. The audience has been informed.",
        "The fireplace is lit. The wood comes from a forest you have never heard of.",
        "A concert was rescheduled because you could not make it in time.",
    ]
    private static let night = [
        "%@, it is late. I have extended the night by an hour.",
        "Your sleep has been optimized, for a fee.",
        "The staff do not sleep. They have no permit for it.",
        "The moon has not been paid. I will see to it tomorrow.",
        "Good night. The alarm rings when you say so. Not earlier.",
    ]
    private static let extras = [
        "a team of twelve was hired",
        "the manufacturer was bought",
        "an appraiser was fired for asking about the price",
        "a second version was ordered in case you dislike the first",
        "a helicopter was dispatched as a precaution",
        "the schedule was abolished",
        "an expert was flown in from Zurich who may not tell anyone anything",
        "the weather was informed as a precaution",
    ]

    @State private var shown = NSLocalizedString("You rang?", comment: "")
    @State private var last = ""
    @State private var typing: Task<Void, Never>?
    @State private var wish = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("🤵").font(.system(size: 90)).padding(.top, 24)
                Text(shown).font(.system(.title3, design: .serif)).multilineTextAlignment(.center)
                    .frame(minHeight: 110, alignment: .top).padding(.horizontal)
                Button("Call butler") { say(pick()) }.buttonStyle(.borderedProminent)
                Divider().padding(.horizontal)
                VStack(spacing: 12) {
                    Text("Give an order").font(.headline)
                    TextField("What is your wish?", text: $wish).textFieldStyle(.roundedBorder)
                    Button("Place order") { order() }.buttonStyle(.bordered)
                        .disabled(wish.trimmingCharacters(in: .whitespaces).isEmpty)
                }.padding(.horizontal)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Butler")
        .onAppear { shown = String(format: NSLocalizedString("You rang, %@?", comment: ""), name) }
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
        return String(format: NSLocalizedString(raw, comment: ""), name)
    }

    private func order() {
        let w = wish.trimmingCharacters(in: .whitespaces)
        wish = ""
        let extra = Self.extras.randomElement()!
        say(String(format: NSLocalizedString("Certainly, %@. “%@” is being taken care of. To that end, %@.", comment: ""), name, w, NSLocalizedString(extra, comment: "")))
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

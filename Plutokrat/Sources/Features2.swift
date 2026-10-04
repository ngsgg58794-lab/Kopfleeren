import SwiftUI
import UserNotifications

// MARK: - Bordkarte

struct BoardingPassView: View {
    let name: String
    @State private var from = "Sylt"
    @State private var to = "Monaco"
    @State private var aircraft = "Gulfstream G700"
    private let aircrafts = ["Gulfstream G700", "Bombardier Global 8000", "Airbus ACJ320", "Boeing BBJ 747-8", "Mein Helikopter"]

    var body: some View {
        ScrollView {
            ShareCard(key: name + from + to + aircraft) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("PRIVATE AVIATION").font(.caption.weight(.bold)).tracking(3)
                        Spacer()
                        Image(systemName: "airplane")
                    }
                    Text(name.uppercased()).font(.title2.weight(.bold))
                    HStack {
                        VStack(alignment: .leading) { Text("VON").font(.caption2); Text(from).font(.title.weight(.heavy)) }
                        Spacer()
                        VStack(alignment: .trailing) { Text("NACH").font(.caption2); Text(to).font(.title.weight(.heavy)) }
                    }
                    HStack(spacing: 24) {
                        info("FLUGZEUG", aircraft)
                        info("SITZ", "1A")
                        info("GATE", "Privat")
                        info("ABFLUG", "Wann Sie wollen")
                    }
                    Text("Fiktive Bordkarte – nicht zum Fliegen geeignet.").font(.caption2).opacity(0.7)
                }
                .foregroundStyle(.black)
                .padding(24)
                .background(Gold.gradient, in: RoundedRectangle(cornerRadius: 18))
            }
            VStack(spacing: 12) {
                TextField("Von", text: $from).textFieldStyle(.roundedBorder)
                TextField("Nach", text: $to).textFieldStyle(.roundedBorder)
                Picker("Flugzeug", selection: $aircraft) { ForEach(aircrafts, id: \.self) { Text($0) } }
            }.padding(.horizontal)
        }
        .navigationTitle("Privatjet-Bordkarte")
    }

    private func info(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading) { Text(title).font(.caption2); Text(value).font(.footnote.weight(.semibold)) }
    }
}

// MARK: - Anrufe (reiner Text, kein Audio, kein echter Anruf)

struct Caller: Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let emoji: String
    let script: [String]

    static let all = [
        Caller(id: "kapitaen", name: "Kapitän Hansen", subtitle: "Yacht Serenity", emoji: "⚓️", script: [
            "Sir, wir liegen vor Capri. Der Hafen ist zu klein für die Yacht.",
            "Ich habe den Hafen gekauft.",
            "Wann dürfen wir mit Ihnen rechnen?",
            "Verstanden. Die Yacht wartet."]),
        Caller(id: "pilot", name: "Pilot Weber", subtitle: "Gulfstream G700", emoji: "✈️", script: [
            "Guten Tag. Wir haben Starterlaubnis. Wir hatten sie schon vor einer Stunde.",
            "Der Flughafen wurde für Sie gesperrt. Er wusste es noch nicht.",
            "Sagen Sie einfach, wohin. Wir fliegen dann dorthin.",
            "Wir warten. Das Flugzeug wartet gern."]),
        Caller(id: "banker", name: "Herr von Thurn", subtitle: "Privatbank", emoji: "🏦", script: [
            "Ihr Vermögen ist so groß, dass wir einen Anbau brauchen.",
            "Es gibt keine Bonitätsprüfung. Wir hätten Angst vor dem Ergebnis.",
            "Ihre Bank bietet Ihnen an, Ihnen Geld zu schulden.",
            "Wir verstehen. Ein schönes Wochenende."]),
        Caller(id: "koch", name: "Küchenchef Philippe", subtitle: "Hausküche", emoji: "👨‍🍳", script: [
            "Monsieur, der Trüffel ist da. Er kostet mehr als der Hubschrauber.",
            "Ich habe das Menü auf sieben Gänge gekürzt. Es sind nur noch zwölf.",
            "Wann essen wir? Ich frage nur für das Soufflé.",
            "Sehr wohl. Das Soufflé fällt nicht in sich zusammen. Es wagt es nicht."]),
        Caller(id: "makler", name: "Khalid", subtitle: "Immobilien Dubai", emoji: "🏙️", script: [
            "Sir, ein Wolkenkratzer wird frei. Er heißt jetzt wie Sie.",
            "Der 87. Stock ist noch frei. Die Stockwerke darüber gehören dem Wind.",
            "Eine Unterschrift genügt. Auch ein Handzeichen.",
            "Sehr gut. Ich lasse die Skyline kürzen, damit Sie die Aussicht haben."]),
        Caller(id: "chauffeur", name: "Chauffeur Reinhard", subtitle: "Fuhrpark", emoji: "🚘", script: [
            "Sir, der Wagen steht vor der Tür. Der zweite auch. Falls der erste zu langweilig ist.",
            "Die Straße wurde gesperrt. Wir haben nur vergessen, es der Stadt zu sagen.",
            "Ich hupe nicht. Ich warte lieber.",
            "Zu Befehl. Der Motor läuft seit heute Morgen."]),
    ]
}

@MainActor
final class CallCenter: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = CallCenter()
    @Published var incoming: Caller?
    @Published var pendingAt: Date?
    private var task: Task<Void, Never>?
    private let center = UNUserNotificationCenter.current()

    override init() {
        super.init()
        center.delegate = self
    }

    func schedule(_ caller: Caller, after seconds: TimeInterval) async {
        cancel()
        let ok = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
        if ok {
            let content = UNMutableNotificationContent()
            content.title = caller.name
            content.body = "Eingehender Anruf – \(caller.subtitle)"
            content.sound = .default
            content.userInfo = ["caller": caller.id]
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(seconds, 1), repeats: false)
            try? await center.add(UNNotificationRequest(identifier: "call", content: content, trigger: trigger))
        }
        pendingAt = Date().addingTimeInterval(seconds)
        task = Task {
            try? await Task.sleep(for: .seconds(seconds))
            if !Task.isCancelled { present(caller) }
        }
    }

    func cancel() {
        task?.cancel()
        pendingAt = nil
        center.removePendingNotificationRequests(withIdentifiers: ["call"])
    }

    func present(_ caller: Caller) {
        center.removePendingNotificationRequests(withIdentifiers: ["call"])
        center.removeDeliveredNotifications(withIdentifiers: ["call"])
        pendingAt = nil
        incoming = caller
    }

    // Im Vordergrund zeigt der Timer den Anrufbildschirm; die Mitteilung wird unterdrückt.
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            willPresent notification: UNNotification) async -> UNNotificationPresentationOptions { [] }

    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse) async {
        let id = response.notification.request.content.userInfo["caller"] as? String
        await MainActor.run {
            if let c = Caller.all.first(where: { $0.id == id }) { present(c) }
        }
    }
}

struct FakeCallView: View {
    @ObservedObject private var center = CallCenter.shared
    @State private var caller = Caller.all[0]
    @State private var preset = 1
    @State private var useClock = false
    @State private var clock = Date().addingTimeInterval(600)

    private let presets: [(String, TimeInterval)] = [
        ("5 Sek.", 5), ("30 Sek.", 30), ("1 Min.", 60), ("5 Min.", 300), ("15 Min.", 900), ("1 Std.", 3600)]

    var body: some View {
        Form {
            Section("Wer ruft an?") {
                Picker("Anrufer", selection: $caller) {
                    ForEach(Caller.all) { Text("\($0.emoji) \($0.name)").tag($0) }
                }
                Text(caller.subtitle).font(.footnote).foregroundStyle(.secondary)
            }
            Section("Wann?") {
                Toggle("Zu einer Uhrzeit", isOn: $useClock)
                if useClock {
                    DatePicker("Uhrzeit", selection: $clock, displayedComponents: .hourAndMinute)
                } else {
                    Picker("In", selection: $preset) {
                        ForEach(presets.indices, id: \.self) { Text(presets[$0].0).tag($0) }
                    }
                }
            }
            Section {
                if let at = center.pendingAt {
                    Text("Anruf um \(at.formatted(date: .omitted, time: .standard))")
                    Button("Abbrechen", role: .destructive) { center.cancel() }
                } else {
                    Button("Anruf planen") { Task { await center.schedule(caller, after: delay()) } }
                }
            } footer: {
                Text("Bei geschlossener App kommt eine Mitteilung; Tippen öffnet den Anruf. Reiner Text, kein echter Anruf.")
            }
        }
        .navigationTitle("Anrufe")
    }

    private func delay() -> TimeInterval {
        if useClock {
            // nächstes Auftreten der gewählten Uhrzeit (heute oder morgen)
            let comps = Calendar.current.dateComponents([.hour, .minute], from: clock)
            let next = Calendar.current.nextDate(after: Date(), matching: comps, matchingPolicy: .nextTime) ?? Date().addingTimeInterval(60)
            return next.timeIntervalSinceNow
        }
        return presets[preset].1
    }
}

struct CallScreen: View {
    let caller: Caller
    let close: () -> Void
    @State private var answered = false
    @State private var step = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(caller.emoji).font(.system(size: 70))
            Text(caller.name).font(.largeTitle)
            Text(answered ? caller.script[min(step, caller.script.count - 1)] : caller.subtitle)
                .multilineTextAlignment(.center).padding(.horizontal)
            Spacer()
            HStack(spacing: 60) {
                circle("phone.down.fill", .red) { close() }
                if !answered { circle("phone.fill", .green) { answered = true } }
            }
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onReceive(timer) { _ in
            guard answered else { return }
            if step < caller.script.count - 1 { step += 1 } else { close() }
        }
        .onAppear { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
    }

    private func circle(_ icon: String, _ color: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon).font(.title).foregroundStyle(.white)
                .frame(width: 72, height: 72).background(color, in: Circle())
        }
    }
}

// MARK: - Plebs-Rechner

struct PeasantView: View {
    @State private var amount = 100.0
    private let minWage = 13.90 // gesetzlicher Mindestlohn DE 2026

    var body: some View {
        Form {
            Section("Was kostet es?") {
                TextField("Betrag in €", value: $amount, format: .number).keyboardType(.decimalPad)
            }
            Section("Ein Mindestlohn-Empfänger arbeitet dafür") {
                let hours = amount / minWage
                Text(hours, format: .number.precision(.fractionLength(1))).font(.largeTitle.bold()) + Text(" Stunden")
                Text("≈ \((hours / 8), format: .number.precision(.fractionLength(1))) Arbeitstage (brutto, ohne Miete)")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section { Text("Mindestlohn: 13,90 € pro Stunde (Deutschland, 2026).").font(.footnote) }
        }
        .navigationTitle("Plebs-Rechner")
    }
}

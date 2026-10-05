import SwiftUI
import UserNotifications

// MARK: - Bordkarte

struct BoardingPassView: View {
    let name: String
    @State private var from = "Sylt"
    @State private var to = "Monaco"
    @State private var aircraft = "Gulfstream G700"
    private let aircrafts = ["Gulfstream G700", "Bombardier Global 8000", "Airbus ACJ320", "Boeing BBJ 747-8", "My helicopter"]

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
                        VStack(alignment: .leading) { Text("FROM").font(.caption2); Text(from).font(.title.weight(.heavy)) }
                        Spacer()
                        VStack(alignment: .trailing) { Text("TO").font(.caption2); Text(to).font(.title.weight(.heavy)) }
                    }
                    HStack(spacing: 24) {
                        info("AIRCRAFT", LocalizedStringKey(aircraft))
                        info("SEAT", "1A")
                        info("GATE", "Private")
                        info("DEPARTURE", "Whenever you like")
                    }
                    Text("Fictional boarding pass – not valid for travel.").font(.caption2).opacity(0.7)
                }
                .foregroundStyle(.black)
                .padding(24)
                .background(Gold.gradient, in: RoundedRectangle(cornerRadius: 18))
            }
            VStack(spacing: 12) {
                TextField("From", text: $from).textFieldStyle(.roundedBorder)
                TextField("To", text: $to).textFieldStyle(.roundedBorder)
                Picker("Aircraft", selection: $aircraft) { ForEach(aircrafts, id: \.self) { Text(LocalizedStringKey($0)).tag($0) } }
            }.padding(.horizontal)
        }
        .navigationTitle("Private Jet Boarding Pass")
    }

    private func info(_ title: LocalizedStringKey, _ value: LocalizedStringKey) -> some View {
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
        Caller(id: "kapitaen", name: "Captain Hansen", subtitle: "Yacht Serenity", emoji: "⚓️", script: [
            "Sir, we are anchored off Capri. The harbor is too small for the yacht.",
            "I bought the harbor.",
            "When may we expect you?",
            "Understood. The yacht will wait."]),
        Caller(id: "pilot", name: "Pilot Weber", subtitle: "Gulfstream G700", emoji: "✈️", script: [
            "Good day. We have clearance for takeoff. We had it an hour ago.",
            "The airport has been closed for you. It does not know yet.",
            "Just tell us where. We will fly there.",
            "We will wait. The plane does not mind."]),
        Caller(id: "banker", name: "Mr. von Thurn", subtitle: "Private bank", emoji: "🏦", script: [
            "Your fortune is so large that we need an extension.",
            "There is no credit check. We would be afraid of the result.",
            "Your bank offers to owe you money.",
            "We understand. Have a lovely weekend."]),
        Caller(id: "koch", name: "Chef Philippe", subtitle: "Household kitchen", emoji: "👨‍🍳", script: [
            "Monsieur, the truffle has arrived. It costs more than the helicopter.",
            "I shortened the menu to seven courses. Only twelve are left.",
            "When do we eat? I only ask for the soufflé.",
            "Very well. The soufflé will not collapse. It would not dare."]),
        Caller(id: "makler", name: "Khalid", subtitle: "Dubai Real Estate", emoji: "🏙️", script: [
            "Sir, a skyscraper is becoming available. It is now named after you.",
            "The 87th floor is still free. The floors above belong to the wind.",
            "One signature will do. A nod will do too.",
            "Excellent. I will have the skyline shortened so that you have the view."]),
        Caller(id: "chauffeur", name: "Chauffeur Reinhard", subtitle: "Motor pool", emoji: "🚘", script: [
            "Sir, the car is at the door. So is the second one, in case the first is too boring.",
            "The street has been closed. We just forgot to tell the city.",
            "I do not honk. I would rather wait.",
            "At your command. The engine has been running since this morning."]),
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
            content.title = NSLocalizedString(caller.name, comment: "")
            content.body = String(format: NSLocalizedString("Incoming call – %@", comment: ""), NSLocalizedString(caller.subtitle, comment: ""))
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

    private let presets: [(LocalizedStringKey, TimeInterval)] = [
        ("5 sec", 5), ("30 sec", 30), ("1 min", 60), ("5 min", 300), ("15 min", 900), ("1 hr", 3600)]

    var body: some View {
        Form {
            Section("Who is calling?") {
                Picker("Caller", selection: $caller) {
                    ForEach(Caller.all) { c in (Text("\(c.emoji) ") + Text(LocalizedStringKey(c.name))).tag(c) }
                }
                Text(LocalizedStringKey(caller.subtitle)).font(.footnote).foregroundStyle(.secondary)
            }
            Section("When?") {
                Toggle("At a specific time", isOn: $useClock)
                if useClock {
                    DatePicker("Time", selection: $clock, displayedComponents: .hourAndMinute)
                } else {
                    Picker("In", selection: $preset) {
                        ForEach(presets.indices, id: \.self) { Text(presets[$0].0).tag($0) }
                    }
                }
            }
            Section {
                if let at = center.pendingAt {
                    Text("Call at \(at.formatted(date: .omitted, time: .standard))")
                    Button("Cancel", role: .destructive) { center.cancel() }
                } else {
                    Button("Schedule call") { Task { await center.schedule(caller, after: delay()) } }
                }
            } footer: {
                Text("If the app is closed, you get a notification; tap it to open the call. Text only, not a real call.")
            }
        }
        .navigationTitle("Calls")
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
            Text(LocalizedStringKey(caller.name)).font(.largeTitle)
            Text(LocalizedStringKey(answered ? caller.script[min(step, caller.script.count - 1)] : caller.subtitle))
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
            Section("What does it cost?") {
                TextField("Amount in €", value: $amount, format: .number).keyboardType(.decimalPad)
            }
            Section("A minimum-wage worker works for") {
                let hours = amount / minWage
                Text("\(hours, format: .number.precision(.fractionLength(1))) hours").font(.largeTitle.bold())
                Text("≈ \((hours / 8), format: .number.precision(.fractionLength(1))) working days (gross, before rent)")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section { Text("Minimum wage: €13.90 per hour (Germany, 2026).").font(.footnote) }
        }
        .navigationTitle("Peasant Calculator")
    }
}

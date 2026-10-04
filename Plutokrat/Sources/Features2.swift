import SwiftUI

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

// MARK: - Anruf vom Yachtkapitän (reiner Text, kein Audio, kein echter Anruf)

struct FakeCallView: View {
    @State private var waiting = false
    @State private var showCall = false

    var body: some View {
        VStack(spacing: 24) {
            Text("⚓️").font(.system(size: 90))
            Text("Ihr Kapitän ruft in 5 Sekunden an.\nPraktisch, um langweilige Gespräche zu verlassen.")
                .multilineTextAlignment(.center).foregroundStyle(.secondary)
            Button(waiting ? "Warten …" : "Anruf starten") {
                waiting = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { waiting = false; showCall = true }
            }.buttonStyle(.borderedProminent).disabled(waiting)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Yachtkapitän")
        .fullScreenCover(isPresented: $showCall) { CallScreen { showCall = false } }
    }
}

private struct CallScreen: View {
    let close: () -> Void
    @State private var answered = false
    @State private var step = 0
    private let script = [
        "Sir, wir liegen vor Capri. Der Hafen ist zu klein für die Yacht.",
        "Ich habe den Hafen gekauft.",
        "Wann dürfen wir mit Ihnen rechnen?",
        "Verstanden. Die Yacht wartet."
    ]
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Kapitän Hansen").font(.largeTitle)
            Text(answered ? script[min(step, script.count - 1)] : "Yacht Serenity …")
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
            if step < script.count - 1 { step += 1 } else { close() }
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

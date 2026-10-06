import SwiftUI

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

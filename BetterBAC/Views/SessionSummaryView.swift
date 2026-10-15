import SwiftUI

struct SessionSummaryView: View {
    let session: DrinkingSession
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            summaryRow("US standard drinks", value: session.metrics.standardDrinks.formatted(.number.precision(.fractionLength(1))))
            summaryRow("Average pace", value: "\(session.metrics.averagePace.formatted(.number.precision(.fractionLength(1)))) US std drinks/hr")
            summaryRow("Estimated calories", value: "\(session.metrics.estimatedCalories) kcal")
            summaryRow("Log duration", value: "\(Int(session.duration) / 3600)h \((Int(session.duration) % 3600) / 60)m")
            Text("Calories are a rough estimate from alcohol and typical beverage carbohydrates; mixers vary.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius))
    }

    private func summaryRow(_ label: String, value: String) -> some View {
        ViewThatFits(in: .horizontal) {
            if !typeSize.isAccessibilitySize {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(label).fixedSize(horizontal: true, vertical: true)
                    Spacer(minLength: 0)
                    Text(value).foregroundStyle(AppTheme.accent).monospacedDigit()
                        .fixedSize(horizontal: true, vertical: true)
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                Text(value).foregroundStyle(AppTheme.accent).monospacedDigit()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}

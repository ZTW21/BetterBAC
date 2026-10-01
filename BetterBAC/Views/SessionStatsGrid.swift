import SwiftUI

struct SessionStatsGrid: View {
    let metrics: SessionMetrics
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: typeSize.isAccessibilitySize ? 1 : 2), spacing: 10) {
            card(icon: "gauge.medium", title: "Average pace", value: metrics.averagePace, unit: "US std drinks/hr", hero: true)
            card(icon: "clock", title: "Logged in past hour", value: metrics.pastHourStandardDrinks, unit: "US standard drinks")
            card(icon: "wineglass", title: "Total standard drinks", value: metrics.standardDrinks, unit: "US standard drinks")
            VStack(spacing: 4) {
                Label("Session elapsed time", systemImage: "timer").font(.caption).foregroundStyle(.secondary)
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    Text(elapsed(at: context.date)).font(.title2.bold()).fontDesign(.rounded).monospacedDigit()
                }
                .foregroundStyle(AppTheme.accent)
                Text("Since first drink").font(.caption2).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        }
        .padding(.horizontal)
    }

    private func card(icon: String, title: String, value: Double, unit: String, hero: Bool = false) -> some View {
        VStack(spacing: 4) {
            Label(title, systemImage: icon).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Text(value, format: .number.precision(.fractionLength(1)))
                .font(hero ? .largeTitle.bold() : .title2.bold()).fontDesign(.rounded)
                .foregroundStyle(AppTheme.accent).monospacedDigit()
            Text(unit).font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(12)
        .background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue("\(value.formatted(.number.precision(.fractionLength(1)))) \(unit)")
    }

    private func elapsed(at time: Date) -> String {
        guard let first = metrics.firstDrinkTime else { return "—" }
        let seconds = max(0, Int(time.timeIntervalSince(first)))
        return seconds >= 3600 ? "\(seconds / 3600)h \((seconds % 3600) / 60)m" : "\(seconds / 60)m \(seconds % 60)s"
    }
}

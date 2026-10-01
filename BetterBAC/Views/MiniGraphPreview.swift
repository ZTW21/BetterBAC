import SwiftUI
import Charts

struct MiniGraphPreview: View {
    let session: DrinkingSession
    var body: some View {
        let points = SessionMetricsCalculator.timeline(drinks: session.drinks, through: session.endTime)
        Chart(points) { point in
            LineMark(x: .value("Time", point.time), y: .value("US standard drinks/hour", point.pace))
                .foregroundStyle(AppTheme.accent.opacity(0.6)).interpolationMethod(.linear)
            if point.drinkCount > 0 {
                PointMark(x: .value("Time consumed", point.time), y: .value("US standard drinks/hour", point.pace))
                    .foregroundStyle(AppTheme.accent)
            }
        }
        .chartXAxis(.hidden).chartYAxis(.hidden)
        .chartYScale(domain: 0...max(points.map(\.pace).max() ?? 1, 1))
        .chartXScale(domain: session.startTime...max(session.endTime, session.startTime.addingTimeInterval(60)))
        .accessibilityHidden(true)
    }
}

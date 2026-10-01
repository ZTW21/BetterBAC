import SwiftUI
import Charts

struct SessionGraphView: View {
    let dataPoints: [PacePoint]
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Drinking pace over time").font(.headline).padding(.horizontal)
            Text("US standard drinks/hour · dots mark logged drinks")
                .font(.caption).foregroundStyle(.secondary).padding(.horizontal)
            if dataPoints.isEmpty {
                ContentUnavailableView("No data to display", systemImage: "chart.xyaxis.line")
            } else {
                Chart(dataPoints) { point in
                    LineMark(x: .value("Time", point.time), y: .value("US standard drinks/hour", point.pace))
                        .foregroundStyle(AppTheme.accent).interpolationMethod(.linear)
                    AreaMark(x: .value("Time", point.time), y: .value("US standard drinks/hour", point.pace))
                        .foregroundStyle(AppTheme.accent.opacity(0.12)).interpolationMethod(.linear)
                    if point.drinkCount > 0 {
                        PointMark(x: .value("Time consumed", point.time), y: .value("US standard drinks/hour", point.pace))
                            .foregroundStyle(AppTheme.accent)
                            .accessibilityLabel("\(point.drinkCount) drinks logged at \(point.time.formatted(date: .omitted, time: .shortened))")
                    }
                }
                .chartYScale(domain: 0...max(dataPoints.map(\.pace).max() ?? 1, 1))
                .chartXScale(domain: timeDomain)
                .chartYAxis { AxisMarks(position: .leading) }
                .chartXAxis { AxisMarks { _ in AxisValueLabel(format: .dateTime.hour().minute()) } }
                .chartXAxis(typeSize.isAccessibilitySize ? .hidden : .visible)
                .frame(height: 160).padding(.horizontal)
                .accessibilityLabel("Drinking pace over time, in US standard drinks per hour")
                if typeSize.isAccessibilitySize {
                    Text("From \(timeDomain.lowerBound.formatted(date: .abbreviated, time: .shortened)) to \(timeDomain.upperBound.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption).foregroundStyle(.secondary).padding(.horizontal)
                }
            }
        }
        .padding(.vertical).background(.fill.quaternary)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
    }

    private var timeDomain: ClosedRange<Date> {
        let first = dataPoints.first?.time ?? Date()
        let last = dataPoints.last?.time ?? first
        return first...max(last, first.addingTimeInterval(60))
    }
}

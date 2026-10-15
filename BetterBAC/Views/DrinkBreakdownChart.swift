import SwiftUI
import Charts

struct DrinkBreakdownChart: View {
    let breakdown: [(type: DrinkType, count: Int)]
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Drink Breakdown").font(.headline)
            ViewThatFits(in: .horizontal) {
                if !typeSize.isAccessibilitySize {
                    HStack(spacing: 20) {
                        donutChart
                        legend.fixedSize(horizontal: true, vertical: true)
                    }
                }
                VStack(alignment: .leading, spacing: 20) {
                    donutChart
                    legend
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding().background(.fill.quaternary)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
    }

    private var donutChart: some View {
        Chart(breakdown, id: \.type) { item in
            SectorMark(angle: .value("Count", item.count), innerRadius: .ratio(0.6), angularInset: 1.5)
                .foregroundStyle(AppTheme.color(for: item.type)).cornerRadius(3)
        }
        .chartLegend(.hidden)
        .frame(width: 120, height: 120)
        .accessibilityLabel("Drink breakdown by number of entries")
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(breakdown, id: \.type) { item in
                DrinkLegendRow(type: item.type, count: item.count)
            }
        }
    }
}

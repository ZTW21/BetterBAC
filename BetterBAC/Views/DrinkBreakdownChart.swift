//
//  DrinkBreakdownChart.swift
//  BetterBAC
//
//  Created by Zack Wilson on 4/4/26.
//

import SwiftUI
import Charts

struct DrinkBreakdownChart: View {
    let breakdown: [(type: DrinkType, count: Int)]
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Drink Breakdown")
                .font(.headline)
                .padding(.horizontal)

            let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 20)) : AnyLayout(HStackLayout(spacing: 20))
            layout {
                donutChart
                legend
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.vertical)
        .background(.fill.quaternary)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .padding(.horizontal)
    }

    private var donutChart: some View {
        Chart(breakdown, id: \.type) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.6),
                angularInset: 1.5
            )
            .foregroundStyle(AppTheme.color(for: item.type))
            .cornerRadius(3)
        }
        .chartLegend(.hidden)
        .frame(width: 120, height: 120)
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(breakdown, id: \.type) { item in
                LegendRow(type: item.type, count: item.count)
            }
        }
    }
}

// MARK: - Legend Row

private struct LegendRow: View {
    let type: DrinkType
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(AppTheme.color(for: type))
                .frame(width: 8, height: 8)

            Image(systemName: AppTheme.icon(for: type))
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(type.rawValue)
                .font(.caption)

            Spacer()

            Text("\(count)")
                .font(.caption)
                .bold()
                .foregroundStyle(.secondary)
        }
    }
}

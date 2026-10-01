//
//  SessionInsightsView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 4/4/26.
//

import SwiftUI

struct SessionInsightsView: View {
    let dataPoints: [PacePoint]
    let breakdown: [(type: DrinkType, count: Int)]
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .body) private var pageHeight = 300.0

    var body: some View {
        if typeSize.isAccessibilitySize {
            VStack(spacing: 16) {
                SessionGraphView(dataPoints: dataPoints)
                DrinkBreakdownChart(breakdown: breakdown)
            }
        } else {
            TabView {
                SessionGraphView(dataPoints: dataPoints)
                DrinkBreakdownChart(breakdown: breakdown)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: pageHeight)
        }
    }
}

import SwiftUI

struct SessionInsightsView: View {
    let dataPoints: [PacePoint]
    let breakdown: [(type: DrinkType, count: Int)]
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .body) private var pageHeight = 300.0
    // Owned outside the presentation branches so returning to compact restores the page.
    @State private var selectedPage = 0

    var body: some View {
        if AppLayout(sizeClass: sizeClass, typeSize: typeSize).usesColumns || typeSize.isAccessibilitySize {
            VStack(spacing: AppLayout.sectionSpacing) {
                SessionGraphView(dataPoints: dataPoints)
                DrinkBreakdownChart(breakdown: breakdown)
            }
        } else {
            TabView(selection: $selectedPage) {
                SessionGraphView(dataPoints: dataPoints).tag(0)
                DrinkBreakdownChart(breakdown: breakdown).tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(height: pageHeight)
            .accessibilityLabel("Session insights")
        }
    }
}

//
//  BACGraphView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI
import Charts

struct BACGraphView: View {
    let dataPoints: [(Date, Double)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("BAC Over Time")
                .font(.headline)
                .padding(.horizontal)
            
            if dataPoints.isEmpty {
                Text("No data to display")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                Chart {
                    // Legal limit line at 0.08
                    RuleMark(y: .value("Legal Limit", 0.08))
                        .foregroundStyle(.red.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .annotation(position: .top, alignment: .trailing) {
                            Text("Legal Limit")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    
                    // BAC data
                    ForEach(dataPoints.indices, id: \.self) { index in
                        LineMark(
                            x: .value("Time", dataPoints[index].0),
                            y: .value("BAC", dataPoints[index].1)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Time", dataPoints[index].0),
                            y: .value("BAC", dataPoints[index].1)
                        )
                        .foregroundStyle(.blue.opacity(0.2))
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text(String(format: "%.2f", doubleValue))
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.hour().minute())
                    }
                }
                .chartYScale(domain: 0...(max(dataPoints.map { $0.1 }.max() ?? 0.1, 0.10)))
                .frame(height: 200)
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .padding()
    }
}

#Preview("Screenshot 2: BAC Graph with Nice Curve") {
    let now = Date()
    let sampleData: [(Date, Double)] = [
        (now.addingTimeInterval(-7200), 0.00),  // 2 hours ago - start
        (now.addingTimeInterval(-6600), 0.025), // After first drink
        (now.addingTimeInterval(-5400), 0.048), // After second drink
        (now.addingTimeInterval(-4200), 0.062), // Peak approaching
        (now.addingTimeInterval(-3600), 0.068), // Peak
        (now.addingTimeInterval(-2400), 0.062), // Declining
        (now.addingTimeInterval(-1800), 0.055), // Continuing down
        (now.addingTimeInterval(-1200), 0.048), // Still declining
        (now, 0.041)                             // Current - safe level
    ]
    
    return BACGraphView(dataPoints: sampleData)
}

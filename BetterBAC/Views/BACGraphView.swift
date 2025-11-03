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

#Preview {
    let sampleData: [(Date, Double)] = [
        (Date().addingTimeInterval(-3600), 0.02),
        (Date().addingTimeInterval(-2400), 0.05),
        (Date().addingTimeInterval(-1200), 0.08),
        (Date(), 0.06)
    ]
    
    BACGraphView(dataPoints: sampleData)
}

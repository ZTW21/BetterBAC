//
//  MiniGraphPreview.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI
import Charts

struct MiniGraphPreview: View {
    let session: DrinkingSession
    
    var body: some View {
        let graphData = generateGraphData()
        
        Chart {
            ForEach(Array(graphData.enumerated()), id: \.offset) { index, point in
                LineMark(
                    x: .value("Time", point.0),
                    y: .value("BAC", point.1)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: 0...(max(session.peakBAC, 0.01)))
    }
    
    private func generateGraphData() -> [(Date, Double)] {
        // Simplified data generation for preview
        guard let firstDrink = session.drinks.map({ $0.timestamp }).min() else {
            return []
        }
        
        var dataPoints: [(Date, Double)] = []
        let interval: TimeInterval = session.duration / 20  // 20 points for smooth preview
        var currentTime = firstDrink
        
        while currentTime <= session.endTime {
            let relevantDrinks = session.drinks.filter { $0.timestamp <= currentTime }
            let bac = BACCalculator.calculateBAC(
                drinks: relevantDrinks,
                profile: session.profileSnapshot,
                currentTime: currentTime
            )
            dataPoints.append((currentTime, bac))
            
            if bac <= 0.0 { break }
            currentTime = currentTime.addingTimeInterval(interval)
        }
        
        return dataPoints
    }
}

#Preview {
    let sampleDrink = Drink(
        timestamp: Date().addingTimeInterval(-3600),
        type: .wine,
        amountOz: 5.0,
        abvPercent: 12.0
    )
    
    let sampleSession = DrinkingSession(
        startTime: Date().addingTimeInterval(-7200),
        endTime: Date(),
        drinks: [sampleDrink],
        peakBAC: 0.045,
        profileSnapshot: UserProfile(sex: .male, weight: 170, weightUnit: .pounds)
    )
    
    MiniGraphPreview(session: sampleSession)
        .frame(height: 60)
        .padding()
}

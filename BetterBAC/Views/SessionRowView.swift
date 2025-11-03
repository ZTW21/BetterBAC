//
//  SessionRowView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct SessionRowView: View {
    let session: DrinkingSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.startTime, style: .date)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("Peak: \(String(format: "%.3f", session.peakBAC))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(bacColor)
            }
            
            HStack {
                Label("\(session.totalDrinks) drink\(session.totalDrinks == 1 ? "" : "s")", 
                      systemImage: "wineglass.fill")
                    .font(.caption)
                
                Spacer()
                
                Text(formatDuration(session.duration))
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            
            // Mini preview graph
            MiniGraphPreview(session: session)
                .frame(height: 60)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var bacColor: Color {
        if session.peakBAC >= 0.08 {
            return .red
        } else if session.peakBAC >= 0.05 {
            return .orange
        } else {
            return .green
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    let sampleSession = DrinkingSession(
        startTime: Date().addingTimeInterval(-7200),
        endTime: Date(),
        drinks: [],
        peakBAC: 0.065,
        profileSnapshot: UserProfile(sex: .male, weight: 170, weightUnit: .pounds)
    )
    
    SessionRowView(session: sampleSession)
}

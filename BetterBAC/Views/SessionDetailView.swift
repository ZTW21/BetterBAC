//
//  SessionDetailView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct SessionDetailView: View {
    let session: DrinkingSession
    
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Session Stats Card
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Peak BAC")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.3f", session.peakBAC))
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatDuration(session.duration))
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Drinks")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(session.totalDrinks)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(session.startTime, style: .date)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Full BAC Graph
                BACGraphView(dataPoints: generateFullGraphData())
                    .padding(.horizontal)
                
                // Drinks List
                VStack(alignment: .leading, spacing: 12) {
                    Text("Drinks Consumed")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(session.drinks) { drink in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(drink.type.rawValue)
                                    .font(.headline)
                                Text(drink.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(String(format: "%.1f", drink.amountOz)) oz")
                                    .font(.subheadline)
                                Text("\(String(format: "%.1f", drink.abvPercent))% ABV")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .toolbar() {
            ToolbarItem(placement: .principal) {
                HeaderView(title: "Details"){
//                    dismiss()
                }
                    .frame(height: 56)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Session?", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteSession()
            }
        } message: {
            Text("This will permanently delete this drinking session.")
        }
        .onAppear {
            // Show interstitial ad every 3rd time
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                AdManager.shared.showInterstitialIfNeeded(from: rootViewController)
            }
        }
    }
    
    private func deleteSession() {
        PersistenceManager.shared.deleteSession(withId: session.id)
        dismiss()
    }
    
    private func generateFullGraphData() -> [(Date, Double)] {
        guard let firstDrink = session.drinks.map({ $0.timestamp }).min() else {
            return []
        }
        
        var dataPoints: [(Date, Double)] = []
        let interval: TimeInterval = 5 * 60  // 5 minutes
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

#Preview("Screenshot 4: Session Detail with 4 Drinks") {
    let session = MockData.createDetailSession()
    
    return NavigationStack {
        SessionDetailView(session: session)
    }
}

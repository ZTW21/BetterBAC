//
//  HomeView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var bacViewModel: BACViewModel
    
    @State private var showingAddDrink = false
    @State private var showingClearConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        if !profileViewModel.hasProfile {
                            // Warning when profile not set up
                            VStack(spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.orange)
                                
                                Text("Profile Not Set Up")
                                    .font(.headline)
                                
                                Text("Please set up your profile in the Profile tab to calculate your BAC.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                            .padding()
                        } else {
                            // Current BAC Display
                            VStack(spacing: 8) {
                                Text("Current BAC")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(String(format: "%.3f", bacViewModel.currentBAC))
                                    .font(.system(size: 60, weight: .bold, design: .rounded))
                                    .foregroundColor(bacColor)
                                
                                Text(bacStatus)
                                    .font(.subheadline)
                                    .foregroundColor(bacColor)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Add Drink Button
                            Button(action: { showingAddDrink = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Drink")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            
                            // Graph
                            if !bacViewModel.drinks.isEmpty {
                                BACGraphView(dataPoints: bacViewModel.generateGraphData())
                            }
                            
                            // Banner Ad
                            BannerAdView()
                                .frame(height: 50)
                                .background(Color(.systemBackground))
                            
                            // Drinks List
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Drinks Log")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    if !bacViewModel.drinks.isEmpty {
                                        Button(role: .destructive, action: { showingClearConfirmation = true }) {
                                            Text("Clear All")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                if bacViewModel.drinks.isEmpty {
                                    Text("No drinks logged yet")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                } else {
                                    ForEach(bacViewModel.drinks.reversed()) { drink in
                                        DrinkRowView(drink: drink)
                                    }
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
                .navigationTitle("BAC Tracker")
                .sheet(isPresented: $showingAddDrink) {
                    AddDrinkView(viewModel: bacViewModel)
                }
                .alert("Clear All Drinks?", isPresented: $showingClearConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Clear All", role: .destructive) {
                        bacViewModel.clearAllDrinks()
                    }
                } message: {
                    Text("This will remove all logged drinks and reset your BAC to 0.00.")
                }
            }
        }
    }
    
    private var bacColor: Color {
        if bacViewModel.currentBAC >= 0.08 {
            return .red
        } else if bacViewModel.currentBAC >= 0.05 {
            return .orange
        } else {
            return .green
        }
    }
    
    private var bacStatus: String {
        if bacViewModel.currentBAC >= 0.08 {
            return "Above Legal Limit"
        } else if bacViewModel.currentBAC >= 0.05 {
            return "Impaired"
        } else if bacViewModel.currentBAC > 0 {
            return "Below Legal Limit"
        } else {
            return "Sober"
        }
    }
}

struct DrinkRowView: View {
    let drink: Drink
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(drink.type.rawValue)
                        .font(.headline)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", drink.amountOz)) oz")
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", drink.abvPercent))%")
                        .foregroundColor(.secondary)
                }
                
                Text(drink.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(String(format: "%.1f", drink.alcoholGrams))g")
                .font(.caption)
                .padding(6)
                .background(Color(.systemGray5))
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    let profileVM = ProfileViewModel()
    let bacVM = BACViewModel(profileViewModel: profileVM)
    
    HomeView(profileViewModel: profileVM, bacViewModel: bacVM)
}

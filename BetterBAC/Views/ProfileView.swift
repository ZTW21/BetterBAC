//
//  ProfileView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.hasProfile, let profile = viewModel.profile {
                    // Profile summary card
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 8) {
                            Text(profile.sex.rawValue)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("\(String(format: "%.1f", profile.weight)) \(profile.weightUnit.rawValue)")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer()
                } else {
                    // No profile message
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                        
                        Text("No Profile Set")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Tap the settings icon above to set up your profile")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .padding(.top, 40)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(viewModel: viewModel)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}

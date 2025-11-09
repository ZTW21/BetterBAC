//
//  ProfileView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI
import PhotosUI
import ContributionChart

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var sessionHistoryVM = SessionHistoryViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showPhotoPicker = false
    private let headerHeight: CGFloat = 56
    
    // Generate chart data for last 98 days (7 rows × 14 columns)
    private var chartData: [Double] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let daysToShow = 98
        
        // Create a dictionary mapping dates to max peakBAC for that day
        var bacByDate: [Date: Double] = [:]
        for session in sessionHistoryVM.sessions {
            let sessionDate = calendar.startOfDay(for: session.startTime)
            let currentMax = bacByDate[sessionDate] ?? 0.0
            bacByDate[sessionDate] = max(currentMax, session.peakBAC)
        }
        
        // Build array from oldest to newest (last element = today)
        var data: [Double] = []
        for dayOffset in (0..<daysToShow).reversed() {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                data.append(bacByDate[date] ?? 0.0)
            }
        }
        
        return data
    }
    
    var body: some View {
        NavigationStack {
                ZStack (alignment: .top) {
                    ScrollView {
                        VStack(spacing: 20) {
                            if viewModel.hasProfile, let profile = viewModel.profile {
                                // Profile summary card
                                VStack(spacing: 16) {
                                    ZStack(alignment: .bottomTrailing) {
                                        // Profile image
                                        if let profileImage = viewModel.profileImage {
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .font(.system(size: 80))
                                                .foregroundColor(.blue)
                                        }
                                        
                                        // Camera badge
                                        Image(systemName: "camera.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.blue)
                                            .background(Circle().fill(Color.white))
                                    }
                                    .onTapGesture {
                                        showPhotoPicker = true
                                    }
                                    .photosPicker(isPresented: $showPhotoPicker,
                                                  selection: $selectedPhoto,
                                                  matching: .images)
                                    .onChange(of: selectedPhoto) { _, newValue in
                                        Task {
                                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                                               let image = UIImage(data: data) {
                                                viewModel.updateProfilePicture(image)
                                            }
                                        }
                                    }
                                    
                                    if let name = profile.name, !name.isEmpty {
                                        Text(name)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("Add your name in settings")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    // Drinking Activity Chart
                                    ContributionChartView(data: chartData,
                                                          rows: 7,
                                                          columns: 14,
                                                          targetValue: 0.25,
                                                          blockColor: .red)
                                    .padding()
                                    .frame(width: 325, height: 180)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                                }
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                                .padding(.horizontal)
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
                            }
                            
                            // Session History Section
                            if !sessionHistoryVM.sessions.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Drinking History")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                    
                                    ForEach(sessionHistoryVM.sessions) { session in
                                        NavigationLink(destination: SessionDetailView(session: session)) {
                                            SessionRowView(session: session)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                        .padding(.top, 40)
                    }
                    .toolbar {
                            ToolbarItem(placement: .principal) {
                                HeaderView(title: "Profile")
                                    .frame(height: 56)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView(viewModel: viewModel)) {
                                    Image(systemName: "gearshape.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                    }
                    .onAppear {
                        sessionHistoryVM.refreshSessions()
                    }
                }
        }
    }
}

#Preview("Screenshot 5: Profile with History") {
    let profileVM = ProfileViewModel()
    let profile = UserProfile(
        name: "Alex",
        sex: .male,
        weight: 170,
        weightUnit: .pounds
    )
    profileVM.profile = profile
    
    // Load preview profile image
    if let image = UIImage(named: "stock-man.jpg") {
        profileVM.profileImage = image
    }
    
    return ProfileView(viewModel: profileVM)
}

//
//  MainTabView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var bacViewModel: BACViewModel
    
    init() {
        let profileVM = ProfileViewModel()
        _profileViewModel = StateObject(wrappedValue: profileVM)
        _bacViewModel = StateObject(wrappedValue: BACViewModel(profileViewModel: profileVM))
    }
    
    var body: some View {
            TabView {
                HomeView(profileViewModel: profileViewModel, bacViewModel: bacViewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                ProfileView(viewModel: profileViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
    }
}

#Preview {
    MainTabView()
}

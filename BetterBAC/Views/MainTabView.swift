import SwiftUI
import Combine

struct MainTabView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var sessionViewModel = SessionViewModel()
    private let refreshTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var selectedTab = 0

    init(initialTab: Int = 0) { _selectedTab = State(initialValue: initialTab) }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(sessionViewModel: sessionViewModel)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            ProfileView(viewModel: profileViewModel, sessionViewModel: sessionViewModel)
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(1)
        }
        .tint(AppTheme.accent)
        .onReceive(refreshTimer) { time in
            if scenePhase == .active { sessionViewModel.refresh(at: time) }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                sessionViewModel.reload()
                profileViewModel.loadProfile()
            }
        }
    }
}

#Preview { MainTabView() }

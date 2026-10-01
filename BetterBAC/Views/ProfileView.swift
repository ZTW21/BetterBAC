import SwiftUI
import PhotosUI
import ContributionChart

@MainActor
struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var sessionViewModel: SessionViewModel
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let error = viewModel.storageError {
                        Text(error).foregroundStyle(AppTheme.destructive).padding(.horizontal)
                        Button("Retry Loading") { viewModel.loadProfile() }
                    }
                    profileCard
                    activityChart
                    sessionHistory
                }.padding(.vertical)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { SettingsView(viewModel: viewModel) } label: { Label("Settings", systemImage: "gearshape") }
                }
            }
            .onAppear { sessionViewModel.reload(); viewModel.loadProfile() }
            .onChange(of: selectedPhoto) { _, photo in
                Task {
                    if let bytes = try? await photo?.loadTransferable(type: Data.self), let image = UIImage(data: bytes) {
                        viewModel.updateProfilePicture(image)
                    }
                }
            }
            .navigationDestination(for: DrinkingSession.self) { session in
                SessionDetailView(session: session, viewModel: sessionViewModel)
            }
        }
    }

    private var profileCard: some View {
        let profileImage = viewModel.profileImage
        return VStack(spacing: 16) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack(alignment: .bottomTrailing) {
                    if let image = profileImage {
                        Image(uiImage: image).resizable().scaledToFill().frame(width: 72, height: 72).clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill").font(.system(size: 72)).foregroundStyle(.quaternary)
                    }
                    Image(systemName: "camera.circle.fill").font(.title3).foregroundStyle(AppTheme.accent)
                        .background(Circle().fill(.background))
                }
            }
            .buttonStyle(.plain).accessibilityLabel("Choose profile photo")
            Text(viewModel.profile?.name ?? "Your drink journal").font(.title3.bold())
            Text("Name and photo are optional.").font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding().background(.fill.quaternary)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
    }

    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Logged intake by day").font(.headline)
            ContributionChartView(data: chartData, rows: 7, columns: 14, targetValue: max(chartData.max() ?? 1, 1), blockColor: AppTheme.accent)
                .frame(height: 140).accessibilityHidden(true)
            Text("Past 14 weeks · shading represents US standard drinks logged, not a goal.")
                .font(.caption).foregroundStyle(.secondary)
            Text("\(chartData.reduce(0, +), specifier: "%.1f") US standard drinks logged in the past 14 weeks.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
    }

    private var sessionHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session History").font(.headline).padding(.horizontal)
            if let error = sessionViewModel.storageError {
                Text(error).foregroundStyle(AppTheme.destructive).padding(.horizontal)
            }
            if sessionViewModel.sessions.isEmpty {
                ContentUnavailableView("No saved sessions", systemImage: "clock.arrow.circlepath", description: Text("End & Save a session to keep it here."))
            }
            ForEach(sessionViewModel.sessions) { session in
                NavigationLink(value: session) { SessionRowView(session: session) }.buttonStyle(.plain)
            }
        }
    }

    private var chartData: [Double] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let allDrinks = sessionViewModel.sessions.flatMap(\.drinks) + sessionViewModel.drinks
        var totals: [Date: Double] = [:]
        for drink in allDrinks where drink.timestamp <= Date() {
            totals[calendar.startOfDay(for: drink.timestamp), default: 0] += drink.alcoholGrams / SessionMetricsCalculator.gramsPerUSStandardDrink
        }
        return (0..<98).reversed().map { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return 0 }
            return totals[date] ?? 0
        }
    }
}

#if DEBUG
import SwiftUI

enum MockData {
    static func drinks(at now: Date) -> [Drink] {
        [Drink(timestamp: now.addingTimeInterval(-7200), type: .beer, amountOz: 12, abvPercent: 5),
         Drink(timestamp: now.addingTimeInterval(-3900), type: .wine, amountOz: 5, abvPercent: 12),
         Drink(timestamp: now.addingTimeInterval(-1200), type: .beer, amountOz: 12, abvPercent: 5)]
    }
}

/// Launch-only visual QA harness. Fixtures are written to a disposable simulator;
/// no demo records or routing flags are compiled into an App Store build.
struct QAScreenHost: View {
    let route: String
    @StateObject private var session = SessionViewModel()
    @StateObject private var profile = ProfileViewModel()
    @State private var showingSheet = true

    static var requestedRoute: String? {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: "--qa-screen"), args.indices.contains(index + 1) else { return nil }
        let route = args[index + 1]
        return ["add", "edit", "metrics", "profile", "details", "insights", "settings"].contains(route) ? route : nil
    }

    var body: some View {
        Group {
            if route == "settings" {
                NavigationStack { SettingsView(viewModel: profile) }
            } else if route == "details", let saved = session.sessions.first {
                NavigationStack { SessionDetailView(session: saved, viewModel: session) }
            } else if route == "insights" {
                NavigationStack {
                    ScrollView {
                        SessionInsightsView(dataPoints: session.graphData, breakdown: session.drinkBreakdown)
                    }
                }
            } else if route == "profile" {
                MainTabView(initialTab: 1)
            } else {
                MainTabView()
                    .sheet(isPresented: $showingSheet) {
                        if route == "add" { AddDrinkView(viewModel: session) }
                        else if route == "edit", let drink = session.drinks.first { AddDrinkView(viewModel: session, drink: drink) }
                        else { MetricHelpView() }
                    }
            }
        }
        .tint(AppTheme.accent)
    }
}
#endif

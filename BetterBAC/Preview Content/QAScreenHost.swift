#if DEBUG
import SwiftUI

struct QAScreenHost: View {
    let route: String
    @StateObject private var data: QADataStore
    @State private var showingSheet = true
    @State private var acceptedWelcome = false

    init(route: String, fixture: String? = QAScreenHost.argument("--qa-fixture")) {
        self.route = route
        _data = StateObject(wrappedValue: QADataStore(fixture: fixture))
    }

    static var requestedRoute: String? {
        guard let route = argument("--qa-screen") else { return nil }
        return ["home", "welcome", "add", "edit", "metrics", "profile", "details", "insights", "settings"].contains(route) ? route : nil
    }

    static func argument(_ key: String) -> String? {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: key), args.indices.contains(index + 1) else { return nil }
        return args[index + 1]
    }

    var body: some View {
        QALayoutHost {
            Group {
                if route == "welcome" && !acceptedWelcome {
                    DisclaimerView(hasAcceptedDisclaimer: $acceptedWelcome)
                } else if route == "settings" {
                    NavigationStack { SettingsView(viewModel: data.profile) }
                } else if route == "details", let saved = data.session.sessions.first {
                    NavigationStack { SessionDetailView(session: saved, viewModel: data.session) }
                } else if route == "insights" {
                    NavigationStack {
                        ScrollView {
                            SessionInsightsView(dataPoints: data.session.graphData, breakdown: data.session.drinkBreakdown)
                                .padding(AppLayout.contentMargin)
                        }
                    }
                } else {
                    MainTabView(initialTab: route == "profile" ? 1 : 0, profileViewModel: data.profile, sessionViewModel: data.session)
                        .sheet(isPresented: sheetPresentation) {
                            if route == "add" { AddDrinkView(viewModel: data.session) }
                            else if route == "edit", let drink = data.session.drinks.first { AddDrinkView(viewModel: data.session, drink: drink) }
                            else { MetricHelpView() }
                        }
                }
            }
            .tint(AppTheme.accent)
        }
        .preferredColorScheme(Self.argument("--qa-appearance") == "dark" ? .dark : nil)
    }

    private var sheetPresentation: Binding<Bool> {
        ["add", "edit", "metrics"].contains(route) ? $showingSheet : .constant(false)
    }
}

#Preview("Home compact", traits: .fixedLayout(width: 390, height: 760)) {
    QAScreenHost(route: "home", fixture: "populated").environment(\.horizontalSizeClass, .compact)
}

#Preview("Home expanded", traits: .fixedLayout(width: 900, height: 650)) {
    QAScreenHost(route: "home", fixture: "populated").environment(\.horizontalSizeClass, .regular)
}

#Preview("Empty expanded", traits: .fixedLayout(width: 900, height: 650)) {
    QAScreenHost(route: "home", fixture: "empty").environment(\.horizontalSizeClass, .regular)
}

#Preview("Long log at largest text", traits: .fixedLayout(width: 900, height: 650)) {
    QAScreenHost(route: "home", fixture: "long")
        .environment(\.horizontalSizeClass, .regular).environment(\.dynamicTypeSize, .accessibility5)
}
#endif

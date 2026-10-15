import SwiftUI

@main
struct BetterBACApp: App {
    // Versioned so upgrading users see the new meaning of the live metrics.
    @AppStorage("hasAcceptedPacingIntroduction") private var hasAcceptedIntroduction = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                #if DEBUG
                if let route = QAScreenHost.requestedRoute { QAScreenHost(route: route) }
                else { introductionOrMain }
                #else
                introductionOrMain
                #endif
            }
            .task(id: scenePhase) {
                if scenePhase == .active && hasAcceptedIntroduction { await AdConsentManager.shared.prepare() }
            }
            .task(id: hasAcceptedIntroduction) {
                if scenePhase == .active && hasAcceptedIntroduction { await AdConsentManager.shared.prepare() }
            }
        }
    }

    @ViewBuilder
    private var introductionOrMain: some View {
        if hasAcceptedIntroduction { MainTabView() }
        else { DisclaimerView(hasAcceptedDisclaimer: $hasAcceptedIntroduction) }
    }
}

import SwiftUI

@main
struct BetterBACApp: App {
    // Versioned so upgrading users see the new meaning of the live metrics.
    @AppStorage("hasAcceptedPacingIntroduction") private var hasAcceptedIntroduction = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if hasAcceptedIntroduction {
                    #if DEBUG
                    if let route = QAScreenHost.requestedRoute { QAScreenHost(route: route) }
                    else { MainTabView() }
                    #else
                    MainTabView()
                    #endif
                }
                else { DisclaimerView(hasAcceptedDisclaimer: $hasAcceptedIntroduction) }
            }
            .task(id: scenePhase) {
                if scenePhase == .active && hasAcceptedIntroduction { await AdConsentManager.shared.prepare() }
            }
            .task(id: hasAcceptedIntroduction) {
                if scenePhase == .active && hasAcceptedIntroduction { await AdConsentManager.shared.prepare() }
            }
        }
    }
}

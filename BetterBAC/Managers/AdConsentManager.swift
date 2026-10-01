import SwiftUI
import AppTrackingTransparency
import UserMessagingPlatform

@MainActor
final class AdConsentManager: ObservableObject {
    static let shared = AdConsentManager()
    @Published private(set) var canShowAds = false
    @Published private(set) var privacyOptionsRequired = false
    @Published private(set) var errorMessage: String?
    private var preparing = false
    private var prepared = false

    func prepare() async {
        #if DEBUG
        // Screen captures exercise the production views without live ad traffic.
        if ProcessInfo.processInfo.arguments.contains("--qa-no-ads") { return }
        #endif
        guard !preparing, !prepared, UIApplication.shared.applicationState == .active else { return }
        preparing = true
        defer { preparing = false }
        await PurchaseManager.shared.checkPurchaseStatus()
        guard !PurchaseManager.shared.hasRemoveAdsPurchase else { prepared = true; return }
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                ConsentInformation.shared.requestConsentInfoUpdate(with: RequestParameters()) { error in
                    if let error { continuation.resume(throwing: error) }
                    else { continuation.resume() }
                }
            }
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
            errorMessage = nil
        } catch { errorMessage = "Advertising is unavailable: \(error.localizedDescription)" }
        privacyOptionsRequired = ConsentInformation.shared.privacyOptionsRequirementStatus == .required
        guard ConsentInformation.shared.canRequestAds else { return }
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            _ = await ATTrackingManager.requestTrackingAuthorization()
        }
        await AdManager.shared.initialize()
        canShowAds = true
        prepared = true
    }

    func showPrivacyOptions() async {
        do {
            try await ConsentForm.presentPrivacyOptionsForm(from: nil)
            canShowAds = ConsentInformation.shared.canRequestAds
            errorMessage = nil
        } catch { errorMessage = error.localizedDescription }
    }
}

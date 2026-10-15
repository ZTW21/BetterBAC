#if DEBUG
import SwiftUI

/// QA fixtures use their own defaults domain and cannot overwrite the user's journal.
@MainActor
final class QADataStore: ObservableObject {
    let session: SessionViewModel
    let profile: ProfileViewModel

    init(fixture: String?) {
        let persistence: PersistenceManager
        let now = Date()
        if let fixture, let defaults = UserDefaults(suiteName: "com.pourtime.AdaptiveLayoutQA") {
            persistence = PersistenceManager(defaults: defaults)
            do {
                let data = try JSONEncoder().encode(MockData.fixture(fixture, at: now))
                defaults.set(data, forKey: PersistenceManager.storageKey)
            } catch { assertionFailure("Unable to create QA fixture: \(error)") }
        } else {
            persistence = .shared
        }
        session = SessionViewModel(persistence: persistence, at: now)
        profile = ProfileViewModel(persistence: persistence)
    }
}
#endif

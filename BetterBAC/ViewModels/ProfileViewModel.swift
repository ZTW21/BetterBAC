import Foundation
import Combine
import UIKit

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfile?
    @Published private(set) var profileImage: UIImage?
    @Published private(set) var storageError: String?
    private let persistence: PersistenceManager

    init(persistence: PersistenceManager = .shared) {
        self.persistence = persistence
        loadProfile()
    }

    func loadProfile() {
        do { apply(try persistence.loadData().profile) }
        catch { storageError = error.localizedDescription }
    }

    @discardableResult
    func saveProfile(name: String?) -> Bool {
        update { profile in
            profile.name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
            if profile.name?.isEmpty == true { profile.name = nil }
        }
    }

    func updateProfilePicture(_ image: UIImage) {
        guard let bytes = image.jpegData(compressionQuality: 0.8) else { return }
        _ = update { $0.profilePictureData = bytes }
    }

    func removeProfilePicture() { _ = update { $0.profilePictureData = nil } }

    func deleteProfile() {
        do { apply(try persistence.update { $0.profile = nil }.profile) }
        catch { storageError = error.localizedDescription }
    }

    private func update(_ mutation: (inout UserProfile) -> Void) -> Bool {
        do {
            let data = try persistence.update { data in
                var profile = data.profile ?? UserProfile()
                mutation(&profile)
                data.profile = profile
            }
            apply(data.profile)
            return true
        } catch { storageError = error.localizedDescription; return false }
    }

    private func apply(_ profile: UserProfile?) {
        self.profile = profile
        profileImage = profile?.profilePictureData.flatMap { UIImage(data: $0) }
        storageError = nil
    }
}

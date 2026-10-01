import Foundation

struct UserProfile: Codable, Hashable {
    var name: String?
    var profilePictureData: Data?
}

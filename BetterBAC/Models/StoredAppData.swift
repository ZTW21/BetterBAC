import Foundation

struct StoredAppData: Codable, Equatable {
    var schemaVersion = 2
    var profile: UserProfile?
    var activeSessionID: UUID?
    var drinks: [Drink] = []
    var sessions: [DrinkingSession] = []
}

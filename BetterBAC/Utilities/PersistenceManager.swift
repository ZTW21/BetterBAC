import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    static let storageKey = "clearSipDataV2"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) { self.defaults = defaults }

    func loadData() throws -> StoredAppData {
        if let data = defaults.data(forKey: Self.storageKey) {
            let decoded = try JSONDecoder().decode(StoredAppData.self, from: data)
            try validate(decoded)
            return decoded
        }
        // Decode every legacy key before writing anything. On failure, all
        // original bytes remain intact and the UI blocks destructive mutations.
        var migrated = StoredAppData()
        if let data = defaults.data(forKey: "userProfile") {
            migrated.profile = try JSONDecoder().decode(UserProfile.self, from: data)
        }
        if let data = defaults.data(forKey: "drinks") {
            migrated.drinks = try JSONDecoder().decode([Drink].self, from: data).sorted { $0.timestamp < $1.timestamp }
        }
        if !migrated.drinks.isEmpty { migrated.activeSessionID = UUID() }
        if let data = defaults.data(forKey: "drinkingSessions") {
            migrated.sessions = try JSONDecoder().decode([DrinkingSession].self, from: data).sorted { $0.startTime > $1.startTime }
        }
        try persist(migrated)
        for key in ["userProfile", "drinks", "drinkingSessions"] { defaults.removeObject(forKey: key) }
        return migrated
    }

    @discardableResult
    func update(_ mutation: (inout StoredAppData) throws -> Void) throws -> StoredAppData {
        var data = try loadData()
        try mutation(&data)
        try persist(data)
        return data
    }

    private func persist(_ data: StoredAppData) throws {
        try validate(data)
        let encoded = try JSONEncoder().encode(data)
        guard try JSONDecoder().decode(StoredAppData.self, from: encoded) == data else {
            throw PersistenceError.verificationFailed
        }
        // One envelope makes archive + active-log replacement atomic.
        let previous = defaults.data(forKey: Self.storageKey)
        defaults.set(encoded, forKey: Self.storageKey)
        guard defaults.data(forKey: Self.storageKey) == encoded else {
            defaults.set(previous, forKey: Self.storageKey)
            throw PersistenceError.verificationFailed
        }
    }

    private func validate(_ data: StoredAppData) throws {
        guard data.schemaVersion == 2 else { throw PersistenceError.unsupportedVersion }
        guard data.drinks.allSatisfy(\.isValid),
              Set(data.drinks.map(\.id)).count == data.drinks.count,
              data.drinks.isEmpty == (data.activeSessionID == nil),
              Set(data.sessions.map(\.id)).count == data.sessions.count,
              !data.sessions.contains(where: { $0.id == data.activeSessionID }),
              data.sessions.allSatisfy({ session in
                  session.startTime.timeIntervalSinceReferenceDate.isFinite &&
                  session.endTime.timeIntervalSinceReferenceDate.isFinite &&
                  session.endTime >= session.startTime && session.drinks.allSatisfy(\.isValid) &&
                  session.drinks.allSatisfy { $0.timestamp >= session.startTime && $0.timestamp <= session.endTime }
              }) else { throw PersistenceError.invalidRecords }
    }
}

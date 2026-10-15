#if DEBUG
import Foundation

enum MockData {
    static func drinks(at now: Date) -> [Drink] {
        [Drink(timestamp: now.addingTimeInterval(-7200), type: .beer, amountOz: 12, abvPercent: 5),
         Drink(timestamp: now.addingTimeInterval(-3900), type: .wine, amountOz: 5, abvPercent: 12),
         Drink(timestamp: now.addingTimeInterval(-1200), type: .beer, amountOz: 12, abvPercent: 5)]
    }

    static func fixture(_ name: String, at now: Date) -> StoredAppData {
        guard name != "empty" else { return StoredAppData() }
        let types = DrinkType.allCases
        let entryCount = name == "single" ? 1 : (name == "long" ? 40 : 4)
        let entries = (0..<entryCount).map { index in
            let type = types[index % types.count]
            let offset: TimeInterval
            switch name {
            case "single": offset = 0
            case "simultaneous": offset = index == 0 ? -7200 : -1200
            case "long": offset = Double(index) * -600 - 600
            default: offset = [-7200.0, -5700, -3900, -1200][index]
            }
            return Drink(timestamp: now.addingTimeInterval(offset), type: type,
                         amountOz: type.defaultAmount, abvPercent: name == "zero" ? 0 : type.defaultABV)
        }.sorted { $0.timestamp < $1.timestamp }
        let sessions = (1...(name == "long" ? 20 : 3)).map { day in
            let end = now.addingTimeInterval(Double(day) * -86400)
            let drinks = Self.drinks(at: end)
            return DrinkingSession(startTime: drinks[0].timestamp, endTime: end, drinks: drinks)
        }
        return StoredAppData(profile: UserProfile(name: "Alex"), activeSessionID: UUID(), drinks: entries, sessions: sessions)
    }
}
#endif

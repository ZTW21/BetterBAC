import Foundation

struct DrinkingSession: Identifiable, Codable, Hashable {
    let id: UUID
    let startTime: Date
    let endTime: Date
    let drinks: [Drink]

    var duration: TimeInterval { max(0, endTime.timeIntervalSince(startTime)) }
    var totalDrinks: Int { drinks.count }
    var metrics: SessionMetrics { SessionMetricsCalculator.metrics(drinks: drinks, at: endTime) }

    init(id: UUID = UUID(), startTime: Date, endTime: Date, drinks: [Drink]) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.drinks = drinks.sorted { $0.timestamp < $1.timestamp }
    }

    private enum CodingKeys: String, CodingKey {
        case id, startTime, endTime, drinks
        // Legacy migration marker only; the value is never read or written.
        case peakBAC
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        drinks = try container.decode([Drink].self, forKey: .drinks).sorted { $0.timestamp < $1.timestamp }
        startTime = try container.decode(Date.self, forKey: .startTime)
        let storedEnd = try container.decode(Date.self, forKey: .endTime)
        endTime = container.contains(.peakBAC) ? (drinks.last?.timestamp ?? startTime) : storedEnd
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(drinks, forKey: .drinks)
    }
}

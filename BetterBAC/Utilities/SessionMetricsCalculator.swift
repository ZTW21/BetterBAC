import Foundation

enum SessionMetricsCalculator {
    static let gramsPerUSStandardDrink = 14.0
    static let minimumPaceWindow: TimeInterval = 5 * 60
    static let recentIntakeWindow: TimeInterval = 60 * 60

    static func metrics(drinks: [Drink], at time: Date) -> SessionMetrics {
        let logged = drinks.filter { $0.isValid && $0.timestamp <= time }
        guard let first = logged.map(\.timestamp).min() else { return SessionMetrics() }
        let total = logged.reduce(0) { $0 + standardDrinks(for: $1) }
        let recent = logged.filter { $0.timestamp > time.addingTimeInterval(-recentIntakeWindow) }
            .reduce(0) { $0 + standardDrinks(for: $1) }
        return SessionMetrics(
            standardDrinks: total, pastHourStandardDrinks: recent, averagePace: pace(total: total, first: first, at: time),
            estimatedCalories: logged.reduce(0) { $0 + estimatedCalories(for: $1) }, firstDrinkTime: first
        )
    }

    static func standardDrinks(for drink: Drink) -> Double {
        drink.isValid ? drink.alcoholGrams / gramsPerUSStandardDrink : 0
    }

    private static func pace(total: Double, first: Date, at time: Date) -> Double {
        total / (max(time.timeIntervalSince(first), minimumPaceWindow) / 3600)
    }

    static func estimatedCalories(for drink: Drink) -> Int {
        guard drink.isValid else { return 0 }
        let mixerCaloriesPerOz: Double
        switch drink.type {
        case .beer: mixerCaloriesPerOz = 13
        case .wine: mixerCaloriesPerOz = 4
        case .liquor: mixerCaloriesPerOz = 0
        case .other: mixerCaloriesPerOz = 8
        }
        let calories = drink.alcoholGrams * 7 + drink.amountOz * mixerCaloriesPerOz
        return Int(min(calories, Double(Int.max / 1_000_000)))
    }

    /// Exact events plus bounded periodic samples. Duplicate times show the
    /// vertical jump at a drink, without interpolating intake before it occurred.
    static func timeline(drinks: [Drink], through end: Date) -> [PacePoint] {
        let logged = drinks.filter { $0.isValid && $0.timestamp <= end }.sorted { $0.timestamp < $1.timestamp }
        guard let first = logged.first?.timestamp else { return [] }
        var times = Set(logged.map(\.timestamp))
        times.insert(end)
        let floorEnd = first.addingTimeInterval(minimumPaceWindow)
        if floorEnd <= end { times.insert(floorEnd) }
        let duration = end.timeIntervalSince(first)
        let interval = max(60, duration / 600)
        for index in 0...Int(min(600, floor(duration / interval))) {
            times.insert(first.addingTimeInterval(Double(index) * interval))
        }
        var points: [PacePoint] = []
        var drinkIndex = 0
        var total = 0.0
        for time in times.sorted() {
            let previousTotal = total
            var count = 0
            while drinkIndex < logged.count && logged[drinkIndex].timestamp <= time {
                total += standardDrinks(for: logged[drinkIndex])
                count += 1
                drinkIndex += 1
            }
            if count > 0 && time > first {
                points.append(PacePoint(id: points.count, time: time, pace: pace(total: previousTotal, first: first, at: time), drinkCount: 0))
            }
            points.append(PacePoint(id: points.count, time: time, pace: pace(total: total, first: first, at: time), drinkCount: count))
        }
        return points
    }
}

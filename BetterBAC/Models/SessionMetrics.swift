import Foundation

struct SessionMetrics: Equatable {
    var standardDrinks: Double = 0
    var pastHourStandardDrinks: Double = 0
    var averagePace: Double = 0
    var estimatedCalories: Int = 0
    var firstDrinkTime: Date?
}

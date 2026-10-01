import Foundation

struct PacePoint: Identifiable, Equatable {
    let id: Int
    let time: Date
    let pace: Double
    let drinkCount: Int
}

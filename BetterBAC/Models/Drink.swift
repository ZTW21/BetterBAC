//
//  Drink.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

struct Drink: Identifiable, Codable {
    var id: UUID
    var timestamp: Date
    var type: DrinkType
    var amountOz: Double
    var abvPercent: Double
    
    init(id: UUID = UUID(), timestamp: Date = Date(), type: DrinkType, amountOz: Double, abvPercent: Double) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.amountOz = amountOz
        self.abvPercent = abvPercent
    }
    
    // Calculate alcohol in grams
    // Formula: (amount_oz * 29.5735 ml/oz * ABV% * 0.789 g/ml)
    var alcoholGrams: Double {
        let mlPerOz = 29.5735
        let alcoholDensity = 0.789 // g/ml
        return amountOz * mlPerOz * (abvPercent / 100.0) * alcoholDensity
    }
}

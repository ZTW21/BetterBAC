//
//  WeightUnit.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

enum WeightUnit: String, Codable, CaseIterable {
    case pounds = "lbs"
    case kilograms = "kg"
    
    func toGrams(_ weight: Double) -> Double {
        switch self {
        case .pounds:
            return weight * 453.592 // pounds to grams
        case .kilograms:
            return weight * 1000.0 // kg to grams
        }
    }
}

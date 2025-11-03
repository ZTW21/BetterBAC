//
//  BACCalculator.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

struct BACCalculator {
    
    /// Calculate current BAC using the Widmark equation
    /// BAC = (A / (W × r)) - (0.015 × H)
    /// - Parameters:
    ///   - drinks: Array of drinks consumed
    ///   - profile: User profile with weight and gender
    ///   - currentTime: Current time for calculation (defaults to now)
    /// - Returns: Current BAC as a percentage (0.08 = 0.08%)
    static func calculateBAC(drinks: [Drink], profile: UserProfile, currentTime: Date = Date()) -> Double {
        guard !drinks.isEmpty else { return 0.0 }
        
        // Get the first drink time to calculate hours elapsed
        guard let firstDrinkTime = drinks.map({ $0.timestamp }).min() else { return 0.0 }
        
        // Calculate total alcohol consumed in grams
        let totalAlcoholGrams = drinks.reduce(0.0) { $0 + $1.alcoholGrams }
        
        // Get body weight in grams and gender constant
        let bodyWeightGrams = profile.weightInGrams
        let genderConstant = profile.sex.widmarkConstant
        
        // Calculate hours since first drink
        let hoursElapsed = currentTime.timeIntervalSince(firstDrinkTime) / 3600.0
        
        // Widmark equation: BAC = (A / (W × r)) × 100 - (0.015 × H)
        // Multiply by 100 to convert to percentage (0.08 = 0.08%)
        let bac = ((totalAlcoholGrams / (bodyWeightGrams * genderConstant)) * 100) - (0.015 * hoursElapsed)
        
        // BAC cannot be negative
        return max(0.0, bac)
    }
    
    /// Calculate BAC at a specific time for graphing purposes
    static func calculateBACAtTime(drinks: [Drink], profile: UserProfile, time: Date) -> Double {
        // Only consider drinks that occurred before or at this time
        let relevantDrinks = drinks.filter { $0.timestamp <= time }
        return calculateBAC(drinks: relevantDrinks, profile: profile, currentTime: time)
    }
}

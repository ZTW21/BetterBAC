//
//  DrinkingSession.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

struct DrinkingSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date        // Timestamp of first drink
    let endTime: Date          // When BAC reached 0
    let drinks: [Drink]        // All drinks in this session
    let peakBAC: Double        // Highest BAC reached
    let profileSnapshot: UserProfile  // User's weight/sex at time of session
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var totalDrinks: Int {
        drinks.count
    }
    
    init(id: UUID = UUID(), startTime: Date, endTime: Date, drinks: [Drink], peakBAC: Double, profileSnapshot: UserProfile) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.drinks = drinks
        self.peakBAC = peakBAC
        self.profileSnapshot = profileSnapshot
    }
}

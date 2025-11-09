//
//  MockData.swift
//  BetterBAC
//
//  Created for App Store Screenshots
//

import Foundation
import SwiftUI

struct MockData {
    // MARK: - Profile
    
    static func createMockProfile(withName: Bool = true, withImage: Bool = false) -> (ProfileViewModel, BACViewModel) {
        let profileVM = ProfileViewModel()
        let profile = UserProfile(
            name: withName ? "Alex" : nil,
            sex: .male,
            weight: 170,
            weightUnit: .pounds
        )
        profileVM.profile = profile
        
        // Load profile image if requested
        if withImage, let image = UIImage(named: "stock-man.jpg") {
            profileVM.profileImage = image
        }
        
        let bacVM = BACViewModel(profileViewModel: profileVM)
        return (profileVM, bacVM)
    }
    
    // MARK: - Drinks for Home View (Screenshot 1)
    
    static func createModerateSession() -> [Drink] {
        let now = Date()
        return [
            Drink(
                timestamp: now.addingTimeInterval(-7200), // 2 hours ago
                type: .beer,
                amountOz: 12.0,
                abvPercent: 5.0
            ),
            Drink(
                timestamp: now.addingTimeInterval(-5400), // 1.5 hours ago
                type: .wine,
                amountOz: 5.0,
                abvPercent: 12.0
            ),
            Drink(
                timestamp: now.addingTimeInterval(-3600), // 1 hour ago
                type: .beer,
                amountOz: 12.0,
                abvPercent: 5.0
            ),
            Drink(
                timestamp: now.addingTimeInterval(-1800), // 30 mins ago
                type: .wine,
                amountOz: 5.0,
                abvPercent: 12.0
            )
        ]
    }
    
    // MARK: - Session for Detail View (Screenshot 4)
    
    static func createDetailSession() -> DrinkingSession {
        let now = Date()
        let drinks = [
            Drink(
                timestamp: now.addingTimeInterval(-7200), // 2 hours ago
                type: .beer,
                amountOz: 12.0,
                abvPercent: 5.0
            ),
            Drink(
                timestamp: now.addingTimeInterval(-5400), // 1.5 hours ago
                type: .wine,
                amountOz: 5.0,
                abvPercent: 12.0
            ),
            Drink(
                timestamp: now.addingTimeInterval(-3600), // 1 hour ago
                type: .beer,
                amountOz: 12.0,
                abvPercent: 5.5
            ),
            Drink(
                timestamp: now.addingTimeInterval(-1800), // 30 mins ago
                type: .wine,
                amountOz: 5.0,
                abvPercent: 12.0
            )
        ]
        
        return DrinkingSession(
            startTime: now.addingTimeInterval(-7200),
            endTime: now,
            drinks: drinks,
            peakBAC: 0.068,
            profileSnapshot: UserProfile(sex: .male, weight: 170, weightUnit: .pounds)
        )
    }
    
    // MARK: - Session History (Screenshot 5)
    
    static func createSessionHistory() -> [DrinkingSession] {
        let calendar = Calendar.current
        let today = Date()
        let profile = UserProfile(sex: .male, weight: 170, weightUnit: .pounds)
        
        var sessions: [DrinkingSession] = []
        
        // Helper function to create a session
        func createSession(daysAgo: Int, drinks: [Drink], peakBAC: Double) -> DrinkingSession {
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            return DrinkingSession(
                startTime: drinks.first!.timestamp,
                endTime: date,
                drinks: drinks,
                peakBAC: peakBAC,
                profileSnapshot: profile
            )
        }
        
        // Week 1 - Recent activity
        let day1 = calendar.date(byAdding: .day, value: -1, to: today)!
        sessions.append(createSession(daysAgo: 1, drinks: [
            Drink(timestamp: day1.addingTimeInterval(-7200), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day1.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day1.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.055))
        
        let day3 = calendar.date(byAdding: .day, value: -3, to: today)!
        sessions.append(createSession(daysAgo: 3, drinks: [
            Drink(timestamp: day3.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day3.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.042))
        
        // Week 2
        let day7 = calendar.date(byAdding: .day, value: -7, to: today)!
        sessions.append(createSession(daysAgo: 7, drinks: [
            Drink(timestamp: day7.addingTimeInterval(-7200), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day7.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day7.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day7.addingTimeInterval(-1800), type: .wine, amountOz: 5.0, abvPercent: 12.0)
        ], peakBAC: 0.072))
        
        let day10 = calendar.date(byAdding: .day, value: -10, to: today)!
        sessions.append(createSession(daysAgo: 10, drinks: [
            Drink(timestamp: day10.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day10.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.038))
        
        // Week 3
        let day14 = calendar.date(byAdding: .day, value: -14, to: today)!
        sessions.append(createSession(daysAgo: 14, drinks: [
            Drink(timestamp: day14.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day14.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.045))
        
        let day17 = calendar.date(byAdding: .day, value: -17, to: today)!
        sessions.append(createSession(daysAgo: 17, drinks: [
            Drink(timestamp: day17.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day17.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day17.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.062))
        
        // Week 4 - Heavy night
        let day21 = calendar.date(byAdding: .day, value: -21, to: today)!
        sessions.append(createSession(daysAgo: 21, drinks: [
            Drink(timestamp: day21.addingTimeInterval(-9000), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day21.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day21.addingTimeInterval(-5400), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day21.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day21.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.115))
        
        // Week 5
        let day28 = calendar.date(byAdding: .day, value: -28, to: today)!
        sessions.append(createSession(daysAgo: 28, drinks: [
            Drink(timestamp: day28.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day28.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0)
        ], peakBAC: 0.051))
        
        let day31 = calendar.date(byAdding: .day, value: -31, to: today)!
        sessions.append(createSession(daysAgo: 31, drinks: [
            Drink(timestamp: day31.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day31.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day31.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day31.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.088))
        
        // Week 6 - Another heavy night
        let day35 = calendar.date(byAdding: .day, value: -35, to: today)!
        sessions.append(createSession(daysAgo: 35, drinks: [
            Drink(timestamp: day35.addingTimeInterval(-7200), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day35.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day35.addingTimeInterval(-3600), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day35.addingTimeInterval(-1800), type: .wine, amountOz: 5.0, abvPercent: 12.0)
        ], peakBAC: 0.106))
        
        // Week 7
        let day42 = calendar.date(byAdding: .day, value: -42, to: today)!
        sessions.append(createSession(daysAgo: 42, drinks: [
            Drink(timestamp: day42.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day42.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day42.addingTimeInterval(-1800), type: .wine, amountOz: 5.0, abvPercent: 12.0)
        ], peakBAC: 0.055))
        
        // Week 8
        let day49 = calendar.date(byAdding: .day, value: -49, to: today)!
        sessions.append(createSession(daysAgo: 49, drinks: [
            Drink(timestamp: day49.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day49.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day49.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day49.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.071))
        
        // Week 9
        let day56 = calendar.date(byAdding: .day, value: -56, to: today)!
        sessions.append(createSession(daysAgo: 56, drinks: [
            Drink(timestamp: day56.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day56.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.042))
        
        // Week 10
        let day63 = calendar.date(byAdding: .day, value: -63, to: today)!
        sessions.append(createSession(daysAgo: 63, drinks: [
            Drink(timestamp: day63.addingTimeInterval(-7200), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day63.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day63.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day63.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.5)
        ], peakBAC: 0.081))
        
        // Week 11
        let day70 = calendar.date(byAdding: .day, value: -70, to: today)!
        sessions.append(createSession(daysAgo: 70, drinks: [
            Drink(timestamp: day70.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day70.addingTimeInterval(-5400), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day70.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day70.addingTimeInterval(-1800), type: .wine, amountOz: 5.0, abvPercent: 12.0)
        ], peakBAC: 0.098))
        
        // Week 12
        let day77 = calendar.date(byAdding: .day, value: -77, to: today)!
        sessions.append(createSession(daysAgo: 77, drinks: [
            Drink(timestamp: day77.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day77.addingTimeInterval(-3600), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.048))
        
        // Week 13 - Heavy night
        let day84 = calendar.date(byAdding: .day, value: -84, to: today)!
        sessions.append(createSession(daysAgo: 84, drinks: [
            Drink(timestamp: day84.addingTimeInterval(-9000), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day84.addingTimeInterval(-7200), type: .beer, amountOz: 12.0, abvPercent: 5.5),
            Drink(timestamp: day84.addingTimeInterval(-5400), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day84.addingTimeInterval(-3600), type: .liquor, amountOz: 1.5, abvPercent: 40.0),
            Drink(timestamp: day84.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.112))
        
        // Week 14
        let day91 = calendar.date(byAdding: .day, value: -91, to: today)!
        sessions.append(createSession(daysAgo: 91, drinks: [
            Drink(timestamp: day91.addingTimeInterval(-5400), type: .beer, amountOz: 12.0, abvPercent: 5.0),
            Drink(timestamp: day91.addingTimeInterval(-3600), type: .wine, amountOz: 5.0, abvPercent: 12.0),
            Drink(timestamp: day91.addingTimeInterval(-1800), type: .beer, amountOz: 12.0, abvPercent: 5.0)
        ], peakBAC: 0.058))
        
        return sessions
    }
    
    // MARK: - Chart Data for Profile
    
    static func createChartData() -> [Double] {
        var data: [Double] = Array(repeating: 0.0, count: 98)
        
        // Add some realistic drinking patterns (weekend focused)
        data[97] = 0.055  // Yesterday
        data[94] = 0.042  // 3 days ago
        data[90] = 0.072  // 7 days ago
        data[87] = 0.038  // 10 days ago
        data[84] = 0.065  // 13 days ago
        data[77] = 0.048  // 20 days ago
        data[70] = 0.051  // 27 days ago
        
        return data
    }
}

//
//  PersistenceManager.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userProfileKey = "userProfile"
    private let drinksKey = "drinks"
    private let sessionsKey = "drinkingSessions"
    
    private init() {}
    
    // MARK: - User Profile
    
    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: userProfileKey)
        }
    }
    
    func loadProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userProfileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }
    
    func deleteProfile() {
        UserDefaults.standard.removeObject(forKey: userProfileKey)
    }
    
    // MARK: - Drinks
    
    func saveDrinks(_ drinks: [Drink]) {
        if let encoded = try? JSONEncoder().encode(drinks) {
            UserDefaults.standard.set(encoded, forKey: drinksKey)
        }
    }
    
    func loadDrinks() -> [Drink] {
        guard let data = UserDefaults.standard.data(forKey: drinksKey),
              let drinks = try? JSONDecoder().decode([Drink].self, from: data) else {
            return []
        }
        return drinks
    }
    
    func deleteDrinks() {
        UserDefaults.standard.removeObject(forKey: drinksKey)
    }
    
    // MARK: - Drinking Sessions
    
    func saveSessions(_ sessions: [DrinkingSession]) {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    func loadSessions() -> [DrinkingSession] {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([DrinkingSession].self, from: data) else {
            return []
        }
        return sessions.sorted { $0.startTime > $1.startTime } // Most recent first
    }
    
    func saveSession(_ session: DrinkingSession) {
        var sessions = loadSessions()
        sessions.insert(session, at: 0)  // Add to beginning
        saveSessions(sessions)
    }
    
    func deleteSession(withId id: UUID) {
        var sessions = loadSessions()
        sessions.removeAll { $0.id == id }
        saveSessions(sessions)
    }
}

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
}

//
//  ProfileViewModel.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var hasProfile: Bool = false
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        profile = persistenceManager.loadProfile()
        hasProfile = profile != nil && profile?.isComplete == true
    }
    
    func saveProfile(sex: SexAssignedAtBirth, weight: Double, weightUnit: WeightUnit) {
        let newProfile = UserProfile(sex: sex, weight: weight, weightUnit: weightUnit)
        profile = newProfile
        persistenceManager.saveProfile(newProfile)
        hasProfile = newProfile.isComplete
    }
    
    func updateProfile(_ updatedProfile: UserProfile) {
        profile = updatedProfile
        persistenceManager.saveProfile(updatedProfile)
        hasProfile = updatedProfile.isComplete
    }
    
    func deleteProfile() {
        profile = nil
        hasProfile = false
        persistenceManager.deleteProfile()
    }
}

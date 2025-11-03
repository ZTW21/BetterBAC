//
//  ProfileViewModel.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var hasProfile: Bool = false
    @Published var profileImage: UIImage?
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        profile = persistenceManager.loadProfile()
        hasProfile = profile != nil && profile?.isComplete == true
        loadProfilePicture()
    }
    
    func loadProfilePicture() {
        if let data = profile?.profilePictureData,
           let image = UIImage(data: data) {
            profileImage = image
        } else {
            profileImage = nil
        }
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
        loadProfilePicture()
    }
    
    func updateProfilePicture(_ image: UIImage) {
        guard var currentProfile = profile else { return }
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            currentProfile.profilePictureData = data
            updateProfile(currentProfile)
        }
    }
    
    func removeProfilePicture() {
        guard var currentProfile = profile else { return }
        
        currentProfile.profilePictureData = nil
        updateProfile(currentProfile)
    }
    
    func deleteProfile() {
        profile = nil
        hasProfile = false
        persistenceManager.deleteProfile()
    }
}

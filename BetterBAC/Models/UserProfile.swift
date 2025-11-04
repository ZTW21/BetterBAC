//
//  UserProfile.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

struct UserProfile: Codable {
    var name: String?
    var sex: SexAssignedAtBirth
    var weight: Double
    var weightUnit: WeightUnit
    var profilePictureData: Data?
    
    var weightInGrams: Double {
        weightUnit.toGrams(weight)
    }
    
    var isComplete: Bool {
        weight > 0
    }
}

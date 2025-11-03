//
//  BiologicalGender.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

enum SexAssignedAtBirth: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    
    var widmarkConstant: Double {
        switch self {
        case .male:
            return 0.68
        case .female:
            return 0.55
        }
    }
}

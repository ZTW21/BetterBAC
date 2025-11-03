//
//  DrinkType.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation

enum DrinkType: String, Codable, CaseIterable {
    case beer = "Beer"
    case wine = "Wine"
    case liquor = "Liquor"
    case other = "Other"
    
    var defaultABV: Double {
        switch self {
        case .beer:
            return 5.0
        case .wine:
            return 12.0
        case .liquor:
            return 40.0
        case .other:
            return 5.0
        }
    }
    
    var defaultAmount: Double {
        switch self {
        case .beer:
            return 12.0 // 12 oz
        case .wine:
            return 5.0 // 5 oz
        case .liquor:
            return 1.5 // 1.5 oz
        case .other:
            return 12.0
        }
    }
}

//
//  AppTheme.swift
//  BetterBAC
//
//  Design constants for a consistent, minimal look.
//

import SwiftUI

enum AppTheme {
    // MARK: - Colors

    static let accent = Color.teal
    static let destructive = Color.red

    // MARK: - Corner Radii

    static let cardRadius: CGFloat = 14
    static let buttonRadius: CGFloat = 12
    static let badgeRadius: CGFloat = 8

    // MARK: - Icons per drink type

    /// Monochromatic teal palette for drink type visualization
    static func color(for type: DrinkType) -> Color {
        switch type {
        case .beer:   return .teal
        case .wine:   return .teal.opacity(0.65)
        case .liquor: return .teal.opacity(0.35)
        case .other:  return .gray.opacity(0.4)
        }
    }

    static func icon(for type: DrinkType) -> String {
        switch type {
        case .beer:   return "mug.fill"
        case .wine:   return "wineglass.fill"
        case .liquor: return "waterbottle.fill"
        case .other:  return "cup.and.saucer.fill"
        }
    }
}

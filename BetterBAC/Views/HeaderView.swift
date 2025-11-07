//
//  HeaderView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/6/25.
//

import SwiftUI

/// HeaderView
/// - Shows a title centered.
/// - If `onBack` is non-nil, a back button appears on the left.
/// - Uses a glass effect; on newer OSes it opts into `.glassBackgroundEffect`,
///   falling back to `.ultraThinMaterial` elsewhere.
struct HeaderView: View {
    let title: String
    var onBack: (() -> Void)? = nil
    
    // Tweak this to control how much the glass merges when back button is present
    private let mergeSpacing: CGFloat = 4
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Text(title)
                .font(.system(size: 36, weight: .semibold, design: .monospaced))
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .glassEffect(.clear)
                .lineLimit(1)
        } else {
            Text(title)
                .font(.system(size: 36, weight: .semibold, design: .monospaced))
                .padding()
                .lineLimit(1)
        }
    }
}

#Preview {
    VStack {
        ZStack {
            Image(systemName: "photo")
                .foregroundStyle(Color.red)
                .font(Font.system(size: 500.0))
            HeaderView(title: "BAC Tracker")
        }
        Spacer()
    }
}

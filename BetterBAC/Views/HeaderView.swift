//
//  HeaderView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/6/25.
//

import SwiftUI

/// A simple glass-effect header for screen titles.
struct HeaderView: View {
    let title: String
    var onBack: (() -> Void)? = nil

    var body: some View {
        if #available(iOS 26.0, *) {
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .glassEffect(.clear)
                .lineLimit(1)
        } else {
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding()
                .lineLimit(1)
        }
    }
}

#Preview {
    HeaderView(title: "Pourtime")
}

//
//  HydrationNudge.swift
//  BetterBAC
//
//  Created by Zack Wilson on 4/4/26.
//

import SwiftUI

struct HydrationNudge: View {
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "drop.fill")
                .foregroundStyle(AppTheme.accent)

            Text("Time for some water!")
                .font(.subheadline)

            Spacer()

            Button("Dismiss", systemImage: "xmark", action: onDismiss)
                .labelStyle(.iconOnly)
                .font(.caption)
                .frame(minWidth: 44, minHeight: 44)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.fill.quaternary)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .padding(.horizontal)
    }
}

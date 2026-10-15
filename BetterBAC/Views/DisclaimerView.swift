//
//  DisclaimerView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 4/4/26.
//

import SwiftUI

struct DisclaimerView: View {
    @Binding var hasAcceptedDisclaimer: Bool

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 0)
                    Image(systemName: "info.circle")
                        .font(.system(size: 44))
                        .foregroundStyle(AppTheme.accent)
                        .accessibilityHidden(true)
                    VStack(spacing: 12) {
                        Text("Welcome to Pourtime").font(.title2.bold())
                        Text("Pourtime records drinks and their consumption times. Its live pace and past-hour totals describe your logged intake. They do not estimate BAC, impairment, or when you will be sober.\n\nNever use this app to determine whether it is safe to drive or operate machinery.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 32)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: AppLayout.readableWidth)
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: accept) {
                Text("I Understand")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .frame(minHeight: 44)
                    .foregroundStyle(.white)
                    .background(AppTheme.accent)
                    .clipShape(.rect(cornerRadius: AppTheme.buttonRadius))
                    .contentShape(.rect(cornerRadius: AppTheme.buttonRadius))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: AppLayout.readableWidth)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 24)
            .background(.background)
        }
    }

    private func accept() {
        hasAcceptedDisclaimer = true
    }
}

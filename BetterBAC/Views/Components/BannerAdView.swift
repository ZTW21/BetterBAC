//
//  BannerAdView.swift
//  BetterBAC
//
//  Created by Cline on 11/5/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        // Check if ads should be shown
        guard let banner = AdManager.shared.createBannerView() else {
            // Return empty view if ads are disabled
            return UIView()
        }
        
        // Get the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootViewController
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
}

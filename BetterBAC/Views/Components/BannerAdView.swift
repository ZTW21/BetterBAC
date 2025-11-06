//
//  BannerAdView.swift
//  BetterBAC
//
//  Created by Cline on 11/5/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = AdManager.shared.createBannerView()
        
        // Get the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootViewController
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // No updates needed
    }
}

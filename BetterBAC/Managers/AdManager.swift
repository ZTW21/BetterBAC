//
//  AdManager.swift
//  BetterBAC
//
//  Created by Cline on 11/5/25.
//

import Foundation
import GoogleMobileAds
import SwiftUI

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    // Automatic toggle: Test ads in DEBUG, Production ads in RELEASE
    #if DEBUG
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910" // Google test ID
    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Google test ID
    #else
    private let interstitialAdUnitID = "ca-app-pub-6185838911408177/7120564851" // Your production ID
    private let bannerAdUnitID = "ca-app-pub-6185838911408177/3566949767" // Your production ID
    #endif
    
    // Interstitial ad
    private var interstitial: InterstitialAd?
    @Published var isInterstitialReady = false
    
    // Session detail view counter (every other time)
    @AppStorage("sessionDetailViewCount") private var sessionDetailViewCount = 0
    
    private override init() {
        super.init()
        // Initialize Mobile Ads SDK
        MobileAds.shared.start(completionHandler: nil)
        loadInterstitial()
    }
    
    // MARK: - Interstitial Ad Methods
    
    func loadInterstitial() {
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                self?.isInterstitialReady = false
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            self?.isInterstitialReady = true
            print("Interstitial ad loaded successfully")
        }
    }
    
    func showInterstitialIfNeeded(from viewController: UIViewController) {
        sessionDetailViewCount += 1
        
        // Show ad every 3rd time
        guard sessionDetailViewCount % 3 == 0 else {
            print("Skipping ad - showing every 3rd time (count: \(sessionDetailViewCount))")
            return
        }
        
        if let interstitial = interstitial, isInterstitialReady {
            interstitial.present(from: viewController)
            print("Presenting interstitial ad")
        } else {
            print("Interstitial ad not ready")
            loadInterstitial() // Try to load for next time
        }
    }
    
    // MARK: - Banner Ad Method
    
    func createBannerView() -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = bannerAdUnitID
        banner.load(Request())
        return banner
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Interstitial ad dismissed")
        // Load next ad
        loadInterstitial()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present interstitial ad: \(error.localizedDescription)")
        // Try to load again
        loadInterstitial()
    }
}

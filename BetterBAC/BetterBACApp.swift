//
//  BetterBACApp.swift
//  BetterBAC
//
//  Created by Zack Wilson on 6/4/24.
//  Refactored on 11/2/25.
//

import SwiftUI
import AppTrackingTransparency

@main
struct BetterBACApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                    requestTrackingPermission()
                }
        }
    }
    
    func requestTrackingPermission() {
        // Request tracking permission for personalized ads
        // This is required by Apple when collecting advertising data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized - personalized ads enabled")
                case .denied:
                    print("Tracking denied - using non-personalized ads")
                case .restricted:
                    print("Tracking restricted")
                case .notDetermined:
                    print("Tracking not determined")
                @unknown default:
                    break
                }
            }
        }
    }
}

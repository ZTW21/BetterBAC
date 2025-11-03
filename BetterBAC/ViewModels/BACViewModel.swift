//
//  BACViewModel.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation
import Combine

class BACViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var currentBAC: Double = 0.0
    
    private let persistenceManager = PersistenceManager.shared
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var currentProfile: UserProfile?
    
    init(profileViewModel: ProfileViewModel) {
        loadDrinks()
        
        // Subscribe to profile changes (gets current value immediately, then future changes)
        profileViewModel.$profile
            .sink { [weak self] newProfile in
                self?.currentProfile = newProfile
                self?.updateCurrentBAC()
            }
            .store(in: &cancellables)
        
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Drink Management
    
    func loadDrinks() {
        drinks = persistenceManager.loadDrinks()
        // Don't call updateCurrentBAC() here - let the profile subscription handle it
    }
    
    func addDrink(_ drink: Drink) {
        drinks.append(drink)
        drinks.sort { $0.timestamp < $1.timestamp }
        persistenceManager.saveDrinks(drinks)
        updateCurrentBAC()
    }
    
    func deleteDrink(at indexSet: IndexSet) {
        drinks.remove(atOffsets: indexSet)
        persistenceManager.saveDrinks(drinks)
        updateCurrentBAC()
    }
    
    func clearAllDrinks() {
        drinks.removeAll()
        persistenceManager.deleteDrinks()
        updateCurrentBAC()
    }
    
    // MARK: - BAC Calculation
    
    func updateCurrentBAC() {
        guard let profile = currentProfile, profile.isComplete else {
            currentBAC = 0.0
            return
        }
        
        currentBAC = BACCalculator.calculateBAC(drinks: drinks, profile: profile)
    }
    
    // MARK: - Timer for Real-time Updates
    
    private func startTimer() {
        // Update BAC every 60 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateCurrentBAC()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Graph Data
    
    func generateGraphData() -> [(Date, Double)] {
        guard let profile = currentProfile,
              profile.isComplete,
              !drinks.isEmpty else {
            return []
        }
        
        guard let firstDrink = drinks.map({ $0.timestamp }).min() else {
            return []
        }
        
        let now = Date()
        var dataPoints: [(Date, Double)] = []
        
        // Generate data points every 5 minutes from first drink until BAC reaches 0 or now
        let interval: TimeInterval = 5 * 60 // 5 minutes
        var currentTime = firstDrink
        
        while currentTime <= now {
            let bac = BACCalculator.calculateBACAtTime(drinks: drinks, profile: profile, time: currentTime)
            dataPoints.append((currentTime, bac))
            
            // Stop generating points once BAC reaches 0
            if bac <= 0.0 {
                break
            }
            
            currentTime = currentTime.addingTimeInterval(interval)
        }
        
        // Only add current time point if BAC is still above 0
        if currentBAC > 0.0, let lastPoint = dataPoints.last, lastPoint.0 < now {
            dataPoints.append((now, currentBAC))
        }
        
        return dataPoints
    }
}

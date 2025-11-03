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
    private var sessionInProgress: Bool = false
    private var hasCheckedForCompletedSession = false
    
    init(profileViewModel: ProfileViewModel) {
        loadDrinks()
        
        // Subscribe to profile changes (gets current value immediately, then future changes)
        profileViewModel.$profile
            .sink { [weak self] newProfile in
                self?.currentProfile = newProfile
                self?.updateCurrentBAC()
                
                // Check for zombie session on first update
                self?.checkForCompletedSession()
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
        let oldBAC = currentBAC
        
        guard let profile = currentProfile, profile.isComplete else {
            currentBAC = 0.0
            return
        }
        
        currentBAC = BACCalculator.calculateBAC(drinks: drinks, profile: profile)
        
        // Session start detection
        if !sessionInProgress && currentBAC > 0.0 && !drinks.isEmpty {
            sessionInProgress = true
        }
        
        // Session end detection (BAC dropped to 0 from above 0)
        if sessionInProgress && oldBAC > 0.0 && currentBAC <= 0.0 {
            saveCompletedSession()
        }
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
    
    // MARK: - Session Management
    
    private func checkForCompletedSession() {
        guard !hasCheckedForCompletedSession else { return }
        hasCheckedForCompletedSession = true
        
        if !drinks.isEmpty && currentBAC <= 0.0 {
            // Drinks exist but BAC is 0 = completed session while app was closed
            saveCompletedSession()
        } else if !drinks.isEmpty && currentBAC > 0.0 {
            // Session still in progress
            sessionInProgress = true
        }
    }
    
    private func saveCompletedSession() {
        guard let profile = currentProfile,
              !drinks.isEmpty,
              let firstDrink = drinks.map({ $0.timestamp }).min() else {
            return
        }
        
        let peakBAC = calculatePeakBAC()
        
        let session = DrinkingSession(
            startTime: firstDrink,
            endTime: Date(),
            drinks: drinks,  // Copy drinks array
            peakBAC: peakBAC,
            profileSnapshot: profile
        )
        
        persistenceManager.saveSession(session)
        clearAllDrinks()  // Reset for next session
        sessionInProgress = false
    }
    
    private func calculatePeakBAC() -> Double {
        let graphData = generateGraphData()
        return graphData.map { $0.1 }.max() ?? currentBAC
    }
}

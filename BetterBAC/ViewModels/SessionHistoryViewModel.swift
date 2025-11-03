//
//  SessionHistoryViewModel.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import Foundation
import Combine

class SessionHistoryViewModel: ObservableObject {
    @Published var sessions: [DrinkingSession] = []
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        loadSessions()
    }
    
    func loadSessions() {
        sessions = persistenceManager.loadSessions()
    }
    
    func deleteSession(at indexSet: IndexSet) {
        let sessionsToDelete = indexSet.map { sessions[$0] }
        for session in sessionsToDelete {
            persistenceManager.deleteSession(withId: session.id)
        }
        sessions.remove(atOffsets: indexSet)
    }
    
    func refreshSessions() {
        loadSessions()
    }
}

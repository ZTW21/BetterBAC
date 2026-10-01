import Foundation
import Combine

@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var drinks: [Drink] = []
    @Published private(set) var sessions: [DrinkingSession] = []
    @Published private(set) var metrics = SessionMetrics()
    @Published private(set) var evaluationTime: Date
    @Published private(set) var storageError: String?
    @Published private(set) var hydrationNudgeDismissedAtCount = 0

    private let persistence: PersistenceManager
    private var activeSessionID: UUID?
    static let idleGap: TimeInterval = 8 * 3600

    init(persistence: PersistenceManager = .shared, at time: Date = Date()) {
        self.persistence = persistence
        evaluationTime = time
        reload(at: time)
    }

    var shouldShowHydrationNudge: Bool { drinks.count >= hydrationNudgeDismissedAtCount + 3 }
    var graphData: [PacePoint] { SessionMetricsCalculator.timeline(drinks: drinks, through: evaluationTime) }
    var drinkBreakdown: [(type: DrinkType, count: Int)] {
        DrinkType.allCases.compactMap { type in
            let count = drinks.filter { $0.type == type }.count
            return count == 0 ? nil : (type, count)
        }
    }

    func reload(at time: Date = Date()) {
        do { apply(try persistence.loadData(), at: time) }
        catch { storageError = "Unable to load your saved log. \(error.localizedDescription)" }
    }

    func refresh(at time: Date = Date()) {
        evaluationTime = time
        metrics = SessionMetricsCalculator.metrics(drinks: drinks, at: time)
    }

    func dismissHydrationNudge() { hydrationNudgeDismissedAtCount = drinks.count }

    @discardableResult
    func addDrink(_ drink: Drink, at time: Date = Date()) -> Bool {
        guard drink.isValid, drink.timestamp <= time else { return false }
        return mutate(at: time) { data in
            guard !data.drinks.contains(where: { $0.id == drink.id }) else { return }
            if let last = data.drinks.map(\.timestamp).max(), drink.timestamp > last,
               drink.timestamp.timeIntervalSince(last) >= Self.idleGap {
                Self.archive(&data, at: last)
            }
            if data.activeSessionID == nil { data.activeSessionID = UUID() }
            data.drinks.append(drink)
            data.drinks.sort { $0.timestamp < $1.timestamp }
        }
    }

    @discardableResult
    func updateDrink(_ drink: Drink, at time: Date = Date()) -> Bool {
        guard drink.isValid, drink.timestamp <= time else { return false }
        return mutate(at: time) { data in
            guard let index = data.drinks.firstIndex(where: { $0.id == drink.id }) else { return }
            data.drinks[index] = drink
            data.drinks.sort { $0.timestamp < $1.timestamp }
        }
    }

    func deleteDrink(id: UUID, at time: Date = Date()) {
        _ = mutate(at: time) { data in
            data.drinks.removeAll { $0.id == id }
            if data.drinks.isEmpty { data.activeSessionID = nil }
        }
    }

    func clearAllDrinks(at time: Date = Date()) {
        if mutate(at: time, { $0.drinks = []; $0.activeSessionID = nil }) { hydrationNudgeDismissedAtCount = 0 }
    }

    func endSession(at time: Date = Date()) {
        if mutate(at: time, { Self.archive(&$0, at: time) }) { hydrationNudgeDismissedAtCount = 0 }
    }

    func deleteSession(id: UUID) {
        _ = mutate(at: evaluationTime) { $0.sessions.removeAll { $0.id == id } }
    }

    private static func archive(_ data: inout StoredAppData, at time: Date) {
        guard let id = data.activeSessionID, let first = data.drinks.map(\.timestamp).min(),
              let last = data.drinks.map(\.timestamp).max() else { return }
        let session = DrinkingSession(id: id, startTime: first, endTime: max(time, last), drinks: data.drinks)
        data.sessions.insert(session, at: 0)
        data.drinks = []
        data.activeSessionID = nil
    }

    private func mutate(at time: Date, _ mutation: (inout StoredAppData) throws -> Void) -> Bool {
        do {
            let oldCount = drinks.count
            apply(try persistence.update(mutation), at: time)
            if drinks.count < oldCount { hydrationNudgeDismissedAtCount = min(hydrationNudgeDismissedAtCount, drinks.count) }
            return true
        } catch {
            storageError = "Unable to save your log. \(error.localizedDescription)"
            return false
        }
    }

    private func apply(_ data: StoredAppData, at time: Date) {
        if activeSessionID != data.activeSessionID { hydrationNudgeDismissedAtCount = 0 }
        activeSessionID = data.activeSessionID
        drinks = data.drinks
        sessions = data.sessions.sorted { $0.startTime > $1.startTime }
        storageError = nil
        refresh(at: time)
    }
}

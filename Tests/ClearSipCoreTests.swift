import XCTest
@testable import ClearSipCore

final class ClearSipCoreTests: XCTestCase {
    private let now = Date(timeIntervalSinceReferenceDate: 800_000_000)

    private func drink(_ time: Date, abv: Double = 40, amount: Double = 1.5) -> Drink {
        Drink(timestamp: time, type: .liquor, amountOz: amount, abvPercent: abv)
    }

    private func isolatedStore() -> (PersistenceManager, UserDefaults, String) {
        let suite = "ClearSipTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        return (PersistenceManager(defaults: defaults), defaults, suite)
    }

    func testStandardDrinkUsesVolumeAndABV() {
        let value = drink(now)
        let expected = 1.5 * 29.5735 * 0.40 * 0.789 / 14
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [value], at: now).standardDrinks, expected, accuracy: 0.000001)
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [drink(now, amount: 3)], at: now).standardDrinks, expected * 2, accuracy: 0.000001)
    }

    func testPaceFallsWhileWaitingAndRisesWithAnotherDrink() {
        let first = drink(now.addingTimeInterval(-3600))
        let initial = SessionMetricsCalculator.metrics(drinks: [first], at: now)
        let later = SessionMetricsCalculator.metrics(drinks: [first], at: now.addingTimeInterval(3600))
        XCTAssertEqual(later.averagePace, initial.averagePace / 2, accuracy: 0.000001)
        let added = SessionMetricsCalculator.metrics(drinks: [first, drink(now)], at: now)
        XCTAssertEqual(added.averagePace, initial.averagePace * 2, accuracy: 0.000001)
    }

    func testSpacedDrinksDifferFromTogether() {
        let spaced = [drink(now.addingTimeInterval(-7200)), drink(now.addingTimeInterval(-1200))]
        let together = [drink(now.addingTimeInterval(-1200)), drink(now.addingTimeInterval(-1200))]
        let a = SessionMetricsCalculator.metrics(drinks: spaced, at: now)
        let b = SessionMetricsCalculator.metrics(drinks: together, at: now)
        XCTAssertEqual(a.standardDrinks, b.standardDrinks)
        XCTAssertLessThan(a.averagePace, b.averagePace)
        XCTAssertLessThan(a.pastHourStandardDrinks, b.pastHourStandardDrinks)
    }

    func testFiveMinuteFloorAndPastHourExactBoundary() {
        let entry = drink(now)
        let grams = entry.alcoholGrams / 14
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [entry], at: now).averagePace, grams * 12, accuracy: 0.000001)
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [entry], at: now.addingTimeInterval(299)).averagePace, grams * 12, accuracy: 0.000001)
        XCTAssertGreaterThan(SessionMetricsCalculator.metrics(drinks: [entry], at: now.addingTimeInterval(3599)).pastHourStandardDrinks, 0)
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [entry], at: now.addingTimeInterval(3600)).pastHourStandardDrinks, 0)
    }

    func testEmptyZeroABVAndFutureEntries() {
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [], at: now), SessionMetrics())
        let zero = SessionMetricsCalculator.metrics(drinks: [drink(now, abv: 0)], at: now)
        XCTAssertEqual(zero.averagePace, 0)
        XCTAssertNotNil(zero.firstDrinkTime)
        XCTAssertEqual(SessionMetricsCalculator.metrics(drinks: [drink(now.addingTimeInterval(1))], at: now), SessionMetrics())
        XCTAssertFalse(drink(now, amount: .nan).isValid)
        XCTAssertFalse(drink(now, amount: .infinity).isValid)
        XCTAssertFalse(drink(now, amount: 0).isValid)
        XCTAssertFalse(drink(now, abv: -1).isValid)
        XCTAssertFalse(drink(now, abv: 101).isValid)
    }

    func testNumericEntryRejectsClearedAndMalformedValues() {
        let locale = Locale(identifier: "en_US")
        for text in ["", " ", ".", "12oz", "nan", "inf", "1e999"] {
            XCTAssertNil(DrinkInputParser.number(text, locale: locale), text)
        }
        XCTAssertEqual(DrinkInputParser.number("0", locale: locale), 0)
        XCTAssertEqual(DrinkInputParser.number(" 1.5 ", locale: locale), 1.5)
    }

    func testNumericEntrySupportsLocaleAndRetainsPrecisionWhenEditing() {
        let value = 12.3456789012345
        for identifier in ["en_US", "fr_FR", "de_DE"] {
            let locale = Locale(identifier: identifier)
            XCTAssertEqual(DrinkInputParser.number(DrinkInputParser.text(value, locale: locale), locale: locale), value)
        }
        XCTAssertEqual(DrinkInputParser.number("1,5", locale: Locale(identifier: "fr_FR")), 1.5)
    }

    func testTimelineIncludesLateDrinksAfterZeroAndExactJumps() {
        let first = drink(now.addingTimeInterval(-7200), abv: 0)
        let second = drink(now.addingTimeInterval(-63))
        let points = SessionMetricsCalculator.timeline(drinks: [second, first], through: now)
        XCTAssertEqual(points.first?.time, first.timestamp)
        XCTAssertEqual(points.last?.time, now)
        XCTAssertTrue(points.contains { $0.time == second.timestamp && $0.drinkCount == 1 })
        let jump = points.filter { $0.time == second.timestamp }
        XCTAssertEqual(jump.count, 2)
        XCTAssertEqual(jump.first?.pace, 0)
        XCTAssertGreaterThan(jump.last!.pace, 0)
        XCTAssertEqual(points.last!.pace, SessionMetricsCalculator.metrics(drinks: [first, second], at: now).averagePace, accuracy: 0.000001)
        XCTAssertTrue(points.allSatisfy { $0.pace.isFinite && $0.pace >= 0 })
    }

    func testSingleTimestampAndLongTimelinesAreBounded() {
        XCTAssertEqual(SessionMetricsCalculator.timeline(drinks: [drink(now)], through: now).count, 1)
        let first = drink(now.addingTimeInterval(-365 * 24 * 3600))
        let points = SessionMetricsCalculator.timeline(drinks: [first], through: now)
        XCTAssertLessThanOrEqual(points.count, 603)
        XCTAssertEqual(points.last?.time, now)
    }

    @MainActor func testManualCompletionIsIdempotentAndPersists() async throws {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = SessionViewModel(persistence: store, at: now)
        let entry = drink(now.addingTimeInterval(-3600))
        XCTAssertTrue(model.addDrink(entry, at: now))
        let activeID = try store.loadData().activeSessionID
        model.endSession(at: now)
        model.endSession(at: now)
        XCTAssertNil(model.storageError)
        XCTAssertTrue(model.drinks.isEmpty)
        XCTAssertEqual(model.sessions.count, 1)
        XCTAssertEqual(model.sessions[0].id, activeID)
        XCTAssertEqual(model.sessions[0].drinks, [entry])
        XCTAssertEqual(model.sessions[0].endTime, now)
        XCTAssertEqual(try store.loadData().sessions, model.sessions)
    }

    @MainActor func testIdleSplitAtExactlyEightHours() async throws {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = SessionViewModel(persistence: store, at: now)
        let old = drink(now.addingTimeInterval(-8 * 3600))
        XCTAssertTrue(model.addDrink(old, at: now))
        let oldID = try store.loadData().activeSessionID
        let next = drink(now)
        XCTAssertTrue(model.addDrink(next, at: now))
        XCTAssertEqual(model.drinks, [next])
        XCTAssertEqual(model.sessions.count, 1)
        XCTAssertEqual(model.sessions[0].id, oldID)
        XCTAssertEqual(model.sessions[0].endTime, old.timestamp)
        XCTAssertNotEqual(try store.loadData().activeSessionID, oldID)
        XCTAssertTrue(model.addDrink(next, at: now))
        XCTAssertEqual(model.drinks.count, 1)
        XCTAssertEqual(model.sessions.count, 1)
    }

    @MainActor func testUnderEightHoursAndBackdatingDoNotSplit() async {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = SessionViewModel(persistence: store, at: now)
        XCTAssertTrue(model.addDrink(drink(now.addingTimeInterval(-8 * 3600 + 1)), at: now))
        XCTAssertTrue(model.addDrink(drink(now), at: now))
        XCTAssertTrue(model.addDrink(drink(now.addingTimeInterval(-24 * 3600)), at: now))
        XCTAssertTrue(model.sessions.isEmpty)
        XCTAssertEqual(model.drinks.count, 3)
        XCTAssertEqual(model.metrics.firstDrinkTime, now.addingTimeInterval(-24 * 3600))
    }

    @MainActor func testEditDeleteClearAndInputValidation() async {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = SessionViewModel(persistence: store, at: now)
        var entry = drink(now)
        XCTAssertTrue(model.addDrink(entry, at: now))
        entry.timestamp = now.addingTimeInterval(-3600)
        entry.abvPercent = 0
        XCTAssertTrue(model.updateDrink(entry, at: now))
        XCTAssertEqual(model.drinks, [entry])
        XCTAssertEqual(model.metrics.averagePace, 0)
        XCTAssertFalse(model.addDrink(drink(now.addingTimeInterval(1)), at: now))
        XCTAssertFalse(model.updateDrink(drink(now, amount: -1), at: now))
        model.deleteDrink(id: entry.id, at: now)
        XCTAssertNil(model.metrics.firstDrinkTime)
        XCTAssertTrue(model.drinks.isEmpty)
        XCTAssertTrue(model.addDrink(drink(now), at: now))
        model.clearAllDrinks(at: now)
        XCTAssertTrue(model.drinks.isEmpty)
        XCTAssertTrue(model.sessions.isEmpty)
    }

    @MainActor func testSuspensionAndRelaunchRecomputeWithoutArchiving() async {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = SessionViewModel(persistence: store, at: now)
        XCTAssertTrue(model.addDrink(drink(now.addingTimeInterval(-3600)), at: now))
        let later = now.addingTimeInterval(12 * 3600)
        model.refresh(at: later)
        let reopened = SessionViewModel(persistence: store, at: later)
        XCTAssertEqual(reopened.metrics, model.metrics)
        XCTAssertEqual(reopened.drinks, model.drinks)
        XCTAssertTrue(reopened.sessions.isEmpty)
    }

    func testLegacyMigrationRetainsRecordsAndDropsDerivedFields() throws {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let entry = drink(now.addingTimeInterval(-3600))
        let id = UUID()
        let encoder = JSONEncoder()
        let drinkObject = try JSONSerialization.jsonObject(with: encoder.encode([entry]))
        let legacy: [[String: Any]] = [[
            "id": id.uuidString, "startTime": entry.timestamp.timeIntervalSinceReferenceDate,
            "endTime": now.timeIntervalSinceReferenceDate, "drinks": drinkObject,
            "peakBAC": 0.08, "profileSnapshot": ["weight": 170, "sex": "Male", "weightUnit": "lbs"]
        ]]
        defaults.set(try JSONSerialization.data(withJSONObject: legacy), forKey: "drinkingSessions")
        defaults.set(try encoder.encode([entry]), forKey: "drinks")
        defaults.set(try JSONSerialization.data(withJSONObject: ["name": "Alex", "profilePictureData": Data([1,2,3]).base64EncodedString(), "weight": 170, "sex": "Male", "weightUnit": "lbs"]), forKey: "userProfile")
        let result = try store.loadData()
        XCTAssertEqual(result.drinks, [entry])
        XCTAssertEqual(result.sessions.first?.id, id)
        XCTAssertEqual(result.sessions.first?.endTime, entry.timestamp)
        XCTAssertEqual(result.profile?.name, "Alex")
        XCTAssertEqual(result.profile?.profilePictureData, Data([1,2,3]))
        XCTAssertEqual(try store.loadData(), result)
        let saved = String(data: defaults.data(forKey: PersistenceManager.storageKey)!, encoding: .utf8)!
        for field in ["peakBAC", "profileSnapshot", "weight", "sex", "weightUnit"] { XCTAssertFalse(saved.contains(field)) }
        for key in ["drinks", "drinkingSessions", "userProfile"] { XCTAssertNil(defaults.object(forKey: key)) }
    }

    @MainActor func testCorruptLegacyDataCannotBeOverwritten() async throws {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        let invalid = Data("broken history".utf8)
        let originalDrinks = try JSONEncoder().encode([drink(now)])
        defaults.set(invalid, forKey: "drinkingSessions")
        defaults.set(originalDrinks, forKey: "drinks")
        XCTAssertThrowsError(try store.loadData())
        let model = SessionViewModel(persistence: store, at: now)
        XCTAssertNotNil(model.storageError)
        XCTAssertFalse(model.addDrink(drink(now), at: now))
        model.clearAllDrinks(at: now)
        XCTAssertEqual(defaults.data(forKey: "drinkingSessions"), invalid)
        XCTAssertEqual(defaults.data(forKey: "drinks"), originalDrinks)
        XCTAssertNil(defaults.object(forKey: PersistenceManager.storageKey))
    }

    func testCorruptCurrentDataAndFutureSchemaArePreserved() throws {
        let (store, defaults, suite) = isolatedStore()
        defer { defaults.removePersistentDomain(forName: suite) }
        for bytes in [Data("invalid".utf8), try JSONEncoder().encode(StoredAppData(schemaVersion: 3))] {
            defaults.set(bytes, forKey: PersistenceManager.storageKey)
            XCTAssertThrowsError(try store.update { $0.profile = UserProfile(name: "changed") })
            XCTAssertEqual(defaults.data(forKey: PersistenceManager.storageKey), bytes)
        }
    }
}

import Testing
import Foundation
@testable import WordUnlocked

// The widget's timeline, built against the bundled database with its settings, favorites
// and memorization plan in a throwaway UserDefaults suite instead of the App Group.
@Suite("WidgetTimelineService")
struct WidgetTimelineServiceTests {

    @Test func dailyEntriesStartNowThenChangeAtEachMidnight() {
        timeline { service in
            let entries = service.entries(now: now)

            #expect(entries.count == 7)
            #expect(entries.first?.date == now)
            #expect(entries.dropFirst().allSatisfy { calendar.startOfDay(for: $0.date) == $0.date })
            #expect(entries.allSatisfy { $0.translationCode == "KJV" && $0.verseText != nil && $0.note == nil })
            #expect(service.entries(now: now, maxEntries: 1).count == 1)
        }
    }

    @Test func theWidgetAsksForItsNextTimelineAtMidnight() {
        timeline { service in
            let timeline = service.timeline(now: now)

            #expect(timeline.reloadDate == calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)))
            #expect(timeline.entries.count == 7)
        }
    }

    @Test func favoritesShowFullReferencesInTheTranslationEachWasSavedIn() throws {
        try timeline(mode: .favorites, favorites: [favorite(44, "Ps 23:1", "KJV"), favorite(2_000_001, "Gen 1:1", "WEB")]) { service in
            let entries = firstEntriesByShortReference(service)
            let psalm = try #require(entries["Ps 23:1"])
            let genesis = try #require(entries["Gen 1:1"])

            #expect(psalm.verseRef == "Psalm 23:1")
            #expect(psalm.translationCode == "KJV")
            #expect(genesis.verseRef == "Genesis 1:1")
            #expect(genesis.translationCode == "WEB")
        }
    }

    @Test func referenceOnlyShowsJustTheReferenceForAVerseTooLongForTheLockScreen() throws {
        try timeline(mode: .favorites, strategy: .referenceOnly, favorites: [favorite(212, "John 3:16", "KJV"), favorite(1, "Gen 1:1", "KJV")]) { service in
            let entries = firstEntriesByShortReference(service)
            let john = try #require(entries["John 3:16"])
            let genesis = try #require(entries["Gen 1:1"])

            #expect(john.verseText == nil)
            #expect(john.verseRef == "John 3:16")
            #expect(genesis.verseText == ScriptureDatabase.shared.verse(id: 1)?.text)
        }
    }

    @Test func segmentedPartsTakeTurnsEvery20MinutesFromTheStartOfTheSlot() throws {
        let john316 = try #require(ScriptureDatabase.shared.verse(id: 212)?.text)
        timeline(mode: .favorites, strategy: .segmented, favorites: [favorite(212, "John 3:16", "KJV")]) { service in
            let entries = service.entries(now: now)
            let midnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!

            #expect(entries.first?.date == now)
            #expect(entries.dropFirst().first?.date == at(10, 20))
            #expect(entries.allSatisfy { $0.date < midnight && $0.verseRef == "John 3:16" })
            // 10:07 falls in the 31st turn since midnight, which shows the first part.
            #expect(entries.prefix(3).map(\.note) == ["Part 1 of 2", "Part 2 of 2", "Part 1 of 2"])
            #expect(entries.prefix(2).compactMap(\.verseText).joined(separator: " ") == john316)
            // A timeline rebuilt partway through a turn carries on from the same part.
            #expect(service.entries(now: at(10, 25)).first?.note == "Part 2 of 2")
        }
    }

    @Test func segmentedPartsTakeTurnsUntilMidnightOnTheDayTheClocksChange() {
        // The first day in a year that isn't 24 hours long here; where clocks never change,
        // any day, and the check still holds.
        let days = (0..<366).compactMap { calendar.date(byAdding: .day, value: $0, to: calendar.startOfDay(for: now)) }
        let day = days.first { calendar.dateInterval(of: .day, for: $0)?.duration != 86_400 } ?? calendar.startOfDay(for: now)
        let morning = calendar.date(bySettingHour: 10, minute: 7, second: 0, of: day)!
        let midnight = calendar.date(byAdding: .day, value: 1, to: day)!

        timeline(mode: .favorites, strategy: .segmented, favorites: [favorite(212, "John 3:16", "KJV")]) { service in
            let entries = service.entries(now: morning)

            #expect(entries.allSatisfy { $0.date < midnight })
            #expect(entries.last.map { midnight.timeIntervalSince($0.date) <= WidgetTimelineService.segmentDuration } == true)
        }
    }

    @Test func memorizationShowsEachStepOfThePlanOnItsDay() throws {
        let john316 = try #require(ScriptureDatabase.shared.verse(id: 212)?.text)
        let plan = MemorizationPlan(verseId: 212, durationDays: 7, difficulty: .medium, startDate: calendar.startOfDay(for: now))
        let values: [String: Any] = [
            AppGroupSettings.Keys.memorizationPlanId: 212,
            AppGroupSettings.Keys.memorizationPlan: try JSONEncoder().encode(plan)
        ]

        timeline(values, mode: .memorization) { service in
            let entries = service.entries(now: now)

            #expect(entries.map(\.note) == [
                "Read it through", "Read it through", "Fill in the blanks", "Fill in the blanks",
                "First letters", "Recite it from memory", "Recite it from memory"
            ])
            #expect(entries.first?.verseText == john316)
            #expect(entries[2].verseText?.contains("___") == true)
            #expect(entries[4].verseText?.hasPrefix("F G S L") == true)
            #expect(entries[5].verseText == nil)
            #expect(entries.allSatisfy { $0.verseRef == "John 3:16" })
        }
    }

    @Test func chapterProgressSaysWhereInTheChapterTheVerseIs() {
        let values: [String: Any] = [
            AppGroupSettings.Keys.chapterBookId: 43,
            AppGroupSettings.Keys.chapterNumber: 3,
            AppGroupSettings.Keys.chapterStartDate: calendar.startOfDay(for: now)
        ]

        timeline(values, mode: .chapter) { service in
            #expect(service.entries(now: now).prefix(2).map(\.note) == ["Verse 1 of 36", "Verse 2 of 36"])
        }
        timeline(values.merging([AppGroupSettings.Keys.showProgress: false]) { $1 }, mode: .chapter) { service in
            #expect(service.entries(now: now).allSatisfy { $0.note == nil })
        }
    }

    @Test func downloadedESVTextStandsInOnlyForTheKingJamesVerses() throws {
        let downloaded = [
            LiveCachedVerse(ref: "Psalm 23:1", text: "Stub ESV psalm", fetchedRef: "Ps 23:1"),
            LiveCachedVerse(ref: "Genesis 1:1", text: "Stub ESV genesis", fetchedRef: "Gen 1:1")
        ]
        let values: [String: Any] = [AppGroupSettings.Keys.esvVerseCache: try JSONEncoder().encode(downloaded)]

        try timeline(values, mode: .favorites, translation: "ESV", favorites: [favorite(44, "Ps 23:1", "KJV"), favorite(2_000_001, "Gen 1:1", "WEB")]) { service in
            let entries = firstEntriesByShortReference(service)
            let psalm = try #require(entries["Ps 23:1"])
            let genesis = try #require(entries["Gen 1:1"])

            #expect(psalm.verseText == "Stub ESV psalm")
            #expect(psalm.translationCode == "ESV")
            // A favorite saved in another translation keeps it.
            #expect(genesis.verseText == ScriptureDatabase.shared.verse(id: 2_000_001)?.text)
            #expect(genesis.translationCode == "WEB")
        }
    }
}

private let calendar = Calendar.current

/// 10:07 AM on 12 September 2026, local time.
private let now = at(10, 7)

private func at(_ hour: Int, _ minute: Int) -> Date {
    calendar.date(from: DateComponents(year: 2026, month: 9, day: 12, hour: hour, minute: minute))!
}

private func favorite(_ verseId: Int, _ ref: String, _ translationCode: String) -> Favorite {
    Favorite(verseId: verseId, verseRef: ref, text: "", translationCode: translationCode)
}

/// The first two entries, which for two favorites in saved order are one of each.
private func firstEntriesByShortReference(_ service: WidgetTimelineService) -> [String: VerseEntry] {
    Dictionary(service.entries(now: now).prefix(2).map { ($0.shortRef, $0) }, uniquingKeysWith: { first, _ in first })
}

/// A timeline reading a throwaway suite set up with the mode, strategy, translation and
/// favorites given, plus `values`.
private func timeline(
    _ values: [String: Any] = [:],
    mode: WidgetSettings.VerseMode = .daily,
    strategy: WidgetSettings.LongVerseStrategy = .smartFit,
    translation: String = "KJV",
    favorites: [Favorite] = [],
    _ body: (WidgetTimelineService) throws -> Void
) rethrows {
    var settings = values
    // Favorites in saved order, so two favorites take turns day by day.
    settings[AppGroupSettings.Keys.favoritesShuffle] = settings[AppGroupSettings.Keys.favoritesShuffle] ?? false
    settings[AppGroupSettings.Keys.activeMode] = mode.rawValue
    settings[AppGroupSettings.Keys.longVerseStrategy] = strategy.rawValue
    settings[AppGroupSettings.Keys.selectedTranslation] = translation
    settings[AppGroupSettings.Keys.favorites] = try? JSONEncoder().encode(favorites)
    try withScratchDefaults(settings) { defaults in
        try body(WidgetTimelineService(defaults: defaults))
    }
}

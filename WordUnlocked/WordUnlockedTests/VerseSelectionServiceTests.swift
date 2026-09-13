import Testing
import Foundation
@testable import WordUnlocked

// The pure index functions behind verse selection, then selection itself against the
// bundled database. The suite runs inside the app (TEST_HOST), which provisions that
// database into the App Group container on first use; nothing here writes to it.
@Suite("VerseSelectionService")
struct VerseSelectionServiceTests {

    // MARK: - stableIndex(for:count:)

    @Test func stableIndexIsDeterministicForTheSameInputs() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        let first = VerseSelectionService.stableIndex(for: date, count: 37)
        let second = VerseSelectionService.stableIndex(for: date, count: 37)

        #expect(first == second)
    }

    @Test func stableIndexStaysInBoundsAcrossExtremeDates() {
        let dates = [Date.distantPast, Date.distantFuture, Date()]
        for date in dates {
            for count in 1...20 {
                let index = VerseSelectionService.stableIndex(for: date, count: count)
                #expect(index >= 0)
                #expect(index < count)
            }
        }
    }

    @Test func stableIndexAdvancesByOneEachDay() {
        // Built with Calendar's own .day arithmetic, so a DST change can't interfere.
        let calendar = Calendar.current
        let day1 = calendar.date(from: DateComponents(year: 2024, month: 3, day: 1))!
        let day2 = calendar.date(byAdding: .day, value: 1, to: day1)!
        let count = 30

        let index1 = VerseSelectionService.stableIndex(for: day1, count: count)
        let index2 = VerseSelectionService.stableIndex(for: day2, count: count)

        #expect(index2 == (index1 + 1) % count)
    }

    @Test func stableIndexWithZeroCountReturnsZeroInsteadOfCrashing() {
        #expect(VerseSelectionService.stableIndex(for: Date(), count: 0) == 0)
    }

    // MARK: - weeklyIndex(for:count:)

    @Test func weeklyIndexWalksTheFirstSevenVersesThroughAWeekSpanningNewYear() {
        let calendar = Calendar.current
        let newYear = calendar.date(from: DateComponents(year: 2027, month: 1, day: 1))!
        let week = calendar.dateInterval(of: .weekOfYear, for: newYear)!

        let indices = (0..<7).map { offset in
            VerseSelectionService.weeklyIndex(for: calendar.date(byAdding: .day, value: offset, to: week.start)!, count: 12)
        }

        #expect(indices == Array(0..<7))
    }

    @Test func weeklyIndexWrapsWhenATopicHasFewerThanSevenVerses() {
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfYear, for: Date())!
        for offset in 0..<7 {
            let day = calendar.date(byAdding: .day, value: offset, to: week.start)!
            #expect(VerseSelectionService.weeklyIndex(for: day, count: 3) == offset % 3)
        }
    }

    // MARK: - pick(from:date:)

    @Test func pickReturnsNilForAnEmptyArray() {
        #expect(VerseSelectionService.pick(from: [Int](), date: Date()) == nil)
    }

    @Test func pickReturnsTheElementAtStableIndexAcrossManyDates() {
        let elements = Array(100..<112)
        for offset in 0..<40 {
            let date = Date(timeIntervalSince1970: 1_700_000_000 + Double(offset) * 86_400)
            let expected = elements[VerseSelectionService.stableIndex(for: date, count: elements.count)]
            #expect(VerseSelectionService.pick(from: elements, date: date) == expected)
        }
    }

    // MARK: - record(for:date:favorites:) against the bundled database

    @Test(arguments: ["KJV", "WEB", "BSB", "ASV", "LSV"])
    func everyTopicHasVersesInEveryOfflineTranslation(translationCode: String) {
        let topics = ScriptureDatabase.shared.topics()
        #expect(!topics.isEmpty)
        for topic in topics {
            let verses = ScriptureDatabase.shared.verses(topicSlug: topic.slug, translationCode: translationCode)
            #expect(verses.count >= 7, "\(topic.slug) has \(verses.count) verses in \(translationCode)")
            #expect(verses.allSatisfy { $0.translationCode == translationCode })
        }
    }

    @Test func topicModeReturnsTheSelectedTranslation() {
        let verse = VerseSelectionService.record(
            for: settings(.topic, translation: "BSB", topicSlug: "grief"),
            defaults: emptyDefaults()
        )
        #expect(verse.translationCode == "BSB")
    }

    @Test func excludeLongKeepsEveryDailyVerseShortWhileStillRotating() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2026, month: 9, day: 1))!
        let verses = (0..<14).map { offset in
            VerseSelectionService.record(
                for: settings(.daily, strategy: .excludeLong),
                date: calendar.date(byAdding: .day, value: offset, to: start)!,
                defaults: emptyDefaults()
            )
        }

        #expect(verses.allSatisfy { $0.charCount <= VerseSelectionService.excludeLongMaxCharCount })
        #expect(Set(verses.map(\.id)).count == verses.count)
    }

    @Test(arguments: ["ESV", "RV"])
    func liveTranslationsRotateThroughTheKJVReferenceSet(translationCode: String) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!

        let first = VerseSelectionService.record(for: settings(.daily, translation: translationCode), date: today, defaults: emptyDefaults())
        let second = VerseSelectionService.record(for: settings(.daily, translation: translationCode), date: tomorrow, defaults: emptyDefaults())

        #expect(first.translationCode == "KJV")
        #expect(first.id != second.id)
    }

    @Test func builtInVerseIsJohn316WithItsRealDatabaseId() {
        let verse = VerseSelectionService.builtInVerse(translationCode: "KJV")
        #expect(verse.verseRef == "John 3:16")
        #expect(verse.id == 212)
    }

    @Test func searchMatchesTextAndTreatsWildcardsAndQuotesLiterally() {
        let database = ScriptureDatabase.shared
        #expect(database.searchVerses(containing: "my shepherd", translationCode: "KJV", limit: 10).contains { $0.verseRef == "Ps 23:1" })
        #expect(database.searchVerses(containing: "%", translationCode: "KJV", limit: 10).isEmpty)
        #expect(database.searchVerses(containing: "_", translationCode: "KJV", limit: 10).isEmpty)
        #expect(database.searchVerses(containing: "' OR 1=1 --", translationCode: "KJV", limit: 10).isEmpty)
    }
}

private func settings(
    _ mode: WidgetSettings.VerseMode,
    translation: String = "KJV",
    strategy: WidgetSettings.LongVerseStrategy = .smartFit,
    topicSlug: String? = nil
) -> WidgetSettings {
    var settings = WidgetSettings.defaultSettings
    settings.activeMode = mode
    settings.translationCode = translation
    settings.longVerseStrategy = strategy
    settings.topicSlug = topicSlug
    return settings
}

// A suite nothing writes to, so daily-scope choices saved in the App Group can't leak in.
private func emptyDefaults() -> UserDefaults {
    UserDefaults(suiteName: "VerseSelectionServiceTests.\(UUID().uuidString)")!
}

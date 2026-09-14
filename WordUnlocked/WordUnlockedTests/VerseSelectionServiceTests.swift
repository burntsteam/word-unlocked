import Testing
import Foundation
@testable import WordUnlocked

// The pure index functions behind verse selection, then selection itself against the
// bundled database. The suite runs inside the app (TEST_HOST), which provisions that
// database into the App Group container on first use; nothing here writes to it, and
// mode settings go into throwaway UserDefaults suites.
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

    // MARK: - slot(for:interval:) and slotStartDates(from:interval:dayCount:)

    @Test func slotAdvancesAtEachIntervalBoundaryAndCountsDaysWhenDaily() {
        let calendar = Calendar.current
        let day = calendar.date(from: DateComponents(year: 2026, month: 9, day: 12))!
        func at(_ hour: Int, _ minute: Int) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day)!
        }
        func slot(_ date: Date, _ interval: WidgetSettings.RotationInterval) -> Int {
            VerseSelectionService.slot(for: date, interval: interval)
        }

        #expect(slot(at(5, 59), .everySixHours) + 1 == slot(at(6, 0), .everySixHours))
        #expect(slot(at(7, 59), .everyEightHours) + 1 == slot(at(8, 0), .everyEightHours))
        #expect(slot(at(11, 59), .everyTwelveHours) + 1 == slot(at(12, 0), .everyTwelveHours))
        // A daily slot lasts from local midnight to local midnight.
        let nextDay = calendar.date(byAdding: .day, value: 1, to: day)!
        #expect(slot(at(0, 0), .daily) == slot(at(23, 59), .daily))
        #expect(slot(at(23, 59), .daily) + 1 == VerseSelectionService.slot(for: nextDay, interval: .daily))
    }

    @Test func slotStartDatesBeginNowThenFollowEveryBoundary() {
        let calendar = Calendar.current
        let today = calendar.date(from: DateComponents(year: 2026, month: 9, day: 12))!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let now = calendar.date(bySettingHour: 10, minute: 57, second: 0, of: today)!
        func at(_ hour: Int, on day: Date) -> Date {
            calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day)!
        }

        #expect(VerseSelectionService.slotStartDates(from: now, interval: .everySixHours, dayCount: 2) == [
            now, at(12, on: today), at(18, on: today),
            at(0, on: tomorrow), at(6, on: tomorrow), at(12, on: tomorrow), at(18, on: tomorrow)
        ])

        let daily = VerseSelectionService.slotStartDates(from: now, interval: .daily, dayCount: 7)
        #expect(daily.count == 7)
        #expect(daily.first == now)
        #expect(daily.dropFirst().allSatisfy { calendar.startOfDay(for: $0) == $0 })
    }

    // MARK: - weeklyIndex(for:count:) and shuffledOrder(count:seed:)

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

    @Test func shuffledOrderIsAReproduciblePermutation() {
        let order = VerseSelectionService.shuffledOrder(count: 10, seed: 42)

        #expect(order.sorted() == Array(0..<10))
        #expect(order == VerseSelectionService.shuffledOrder(count: 10, seed: 42))
        #expect((0..<5).contains { VerseSelectionService.shuffledOrder(count: 10, seed: $0) != Array(0..<10) })
        #expect(VerseSelectionService.shuffledOrder(count: 0, seed: 1).isEmpty)
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

    @Test func chapterRepeatStartsTheChapterAgainAfterItsLastVerse() {
        #expect(chapterVerse(.repeatChapter, book: 43, chapter: 3, daysAfterStart: 35)?.verseRef == "John 3:36")
        #expect(chapterVerse(.repeatChapter, book: 43, chapter: 3, daysAfterStart: 36)?.verseRef == "John 3:1")
    }

    @Test func chapterStopStaysOnTheLastVerse() {
        #expect(chapterVerse(.stop, book: 43, chapter: 3, daysAfterStart: 40)?.verseRef == "John 3:36")
    }

    @Test func chapterNextChapterReadsOnAndWrapsFromRevelationToGenesis() {
        #expect(chapterVerse(.nextChapter, book: 43, chapter: 3, daysAfterStart: 36)?.verseRef == "John 4:1")
        #expect(chapterVerse(.nextChapter, book: 66, chapter: 22, daysAfterStart: 21)?.verseRef == "Gen 1:1")
    }

    @Test func chapterRotationSpeedAdvancesWithinADay() {
        // Started at midnight and rotating every six hours, 18:00 is the fourth slot.
        let verse = chapterVerse(.repeatChapter, book: 43, chapter: 3, daysAfterStart: 0, hour: 18, interval: .everySixHours)
        #expect(verse?.verseRef == "John 3:4")
    }

    @Test func weeklyPlanRepeatsItsFirstSevenVersesOrMovesOnSevenAWeek() {
        func verseRef(autoRepeat: Bool, weeks: Int, day: Int) -> String? {
            VerseSelectionService.weeklyRecord(
                WeeklyPlan(source: .chapter, bookId: 43, chapter: 3),
                autoRepeat: autoRepeat,
                startDate: weekStart,
                settings: settings(.weeklyTheme),
                date: weekDay(weeks * 7 + day)
            )?.verseRef
        }

        #expect(verseRef(autoRepeat: true, weeks: 2, day: 0) == "John 3:1")
        #expect(verseRef(autoRepeat: false, weeks: 1, day: 0) == "John 3:8")
        // John 3 has 36 verses, so the sixth week starts the chapter over.
        #expect(verseRef(autoRepeat: false, weeks: 5, day: 2) == "John 3:2")
    }

    @Test func weeklyPlanReadsItsSavedBookOneVerseADay() {
        let ref = withScratchDefaults([
            AppGroupSettings.Keys.weeklySource: WeeklyPlan.Source.book.rawValue,
            AppGroupSettings.Keys.weeklyBookId: 65,
            AppGroupSettings.Keys.weeklyStartDate: weekStart
        ]) { defaults in
            VerseSelectionService.record(for: settings(.weeklyTheme), date: weekDay(3), defaults: defaults).verseRef
        }

        #expect(ref == "Jude 1:4")
    }

    @Test func weeklyPlanShowsYourOwnVersesInTheSelectedTranslation() {
        let plan = WeeklyPlan(source: .custom, customVerseIds: [212, 1])
        let days = (0..<3).map { day in
            VerseSelectionService.weeklyRecord(
                plan, autoRepeat: true, startDate: nil, settings: settings(.weeklyTheme, translation: "WEB"), date: weekDay(day)
            )
        }

        #expect(days.map { $0?.verseRef } == ["John 3:16", "Gen 1:1", "John 3:16"])
        #expect(days.allSatisfy { $0?.translationCode == "WEB" })
    }

    @Test func weeklyPlanThemeWithoutRepeatReachesItsLaterVerses() {
        let hope = ScriptureDatabase.shared.verses(topicSlug: "hope", translationCode: "KJV")
        let verse = VerseSelectionService.weeklyRecord(
            WeeklyPlan(source: .theme, topicSlug: "hope"), autoRepeat: false, startDate: weekStart,
            settings: settings(.weeklyTheme), date: weekDay(7)
        )

        #expect(verse?.id == hope[7 % hope.count].id)
    }

    @Test func upcomingRecordsListEachComingVerseOnceAndStopWhenAModeOnlyRepeats() {
        let now = weekDay(0)
        let daily = VerseSelectionService.upcomingRecords(for: settings(.daily), from: now, limit: 30, defaults: emptyDefaults())

        #expect(daily.count == 30)
        #expect(Set(daily.map(\.id)).count == 30)
        #expect(daily.first?.id == VerseSelectionService.record(for: settings(.daily), date: now, defaults: emptyDefaults()).id)

        var memorization = settings(.memorization)
        memorization.memorizationPlanId = 212
        #expect(VerseSelectionService.upcomingRecords(for: memorization, from: now, limit: 500, defaults: emptyDefaults()).map(\.id) == [212])
    }

    @Test func liveRecordCarriesTheLiveTextMeasuredForTheLockScreen() {
        let kjv = VerseSelectionService.builtInVerse(translationCode: "KJV")
        let text = "“For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life."

        let esv = VerseSelectionService.liveRecord(kjv, ref: "John 3:16", text: text, translationCode: "ESV")

        #expect(esv.id == kjv.id)
        #expect(esv.bookId == 43)
        #expect(esv.translationCode == "ESV")
        #expect(esv.text == text)
        #expect(esv.charCount == text.count)
    }

    @Test func favoritesWithoutShuffleWalkSavedOrderAndCanSkipLongVerses() {
        let calendar = Calendar.current
        let start = calendar.date(from: DateComponents(year: 2026, month: 9, day: 1))!
        let refs = (0..<4).map { offset in
            withScratchDefaults([
                AppGroupSettings.Keys.favoritesShuffle: false,
                AppGroupSettings.Keys.favoritesExcludeLong: true
            ]) { defaults in
                VerseSelectionService.record(
                    for: settings(.favorites),
                    date: calendar.date(byAdding: .day, value: offset, to: start)!,
                    favorites: sampleFavorites,
                    defaults: defaults
                ).verseRef
            }
        }

        #expect(Set(refs) == ["Gen 1:1", "Ps 23:1"])
        #expect(zip(refs, refs.dropFirst()).allSatisfy { $0 != $1 })
    }

    @Test func favoritesShuffleShowsEachFavoriteOncePerPass() {
        let calendar = Calendar.current
        let day = calendar.date(from: DateComponents(year: 2026, month: 9, day: 1))!
        let position = VerseSelectionService.slot(for: day, interval: .daily)
        let passStart = calendar.date(byAdding: .day, value: -(position % sampleFavorites.count), to: day)!
        let refs = (0..<sampleFavorites.count).map { offset in
            withScratchDefaults([AppGroupSettings.Keys.favoritesShuffle: true]) { defaults in
                VerseSelectionService.record(
                    for: settings(.favorites),
                    date: calendar.date(byAdding: .day, value: offset, to: passStart)!,
                    favorites: sampleFavorites,
                    defaults: defaults
                ).verseRef
            }
        }

        #expect(Set(refs).count == sampleFavorites.count)
    }

    @Test func selectionStampChangesWhenAModeSettingChanges() {
        withScratchDefaults([:]) { defaults in
            let before = VerseSelectionService.selectionStamp(for: .topic, defaults: defaults)
            defaults.set(WidgetSettings.RotationInterval.everySixHours.rawValue, forKey: AppGroupSettings.Keys.topicRotationSpeed)
            #expect(VerseSelectionService.selectionStamp(for: .topic, defaults: defaults) != before)
        }
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

// Gen 1:1 and Ps 23:1 are short; John 3:16 is 141 characters.
private let sampleFavorites = [(1, "Gen 1:1"), (212, "John 3:16"), (44, "Ps 23:1")].map { id, ref in
    Favorite(verseId: id, verseRef: ref, text: "", translationCode: "KJV")
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

/// The start of the week holding 1 Sep 2026.
private let weekStart = Calendar.current.dateInterval(
    of: .weekOfYear, for: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 1))!
)!.start

/// 9 AM on the day `offset` days after `weekStart`.
private func weekDay(_ offset: Int) -> Date {
    let calendar = Calendar.current
    return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: offset, to: weekStart)!)!
}

/// Chapter mode's verse `daysAfterStart` days after a plan started at midnight on 1 Sep 2026.
private func chapterVerse(
    _ behavior: WidgetSettings.ChapterEndBehavior,
    book: Int,
    chapter: Int,
    daysAfterStart: Int,
    hour: Int = 9,
    interval: WidgetSettings.RotationInterval = .daily
) -> SharedVerseRecord? {
    let calendar = Calendar.current
    let start = calendar.date(from: DateComponents(year: 2026, month: 9, day: 1))!
    let day = calendar.date(byAdding: .day, value: daysAfterStart, to: start)!
    let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day)!
    var chapterSettings = settings(.chapter)
    chapterSettings.chapterBookId = book
    chapterSettings.chapterNumber = chapter
    return withScratchDefaults([
        AppGroupSettings.Keys.chapterEndBehavior: behavior.rawValue,
        AppGroupSettings.Keys.chapterRotationSpeed: interval.rawValue,
        AppGroupSettings.Keys.chapterStartDate: start
    ]) { defaults in
        VerseSelectionService.record(for: chapterSettings, date: date, defaults: defaults)
    }
}

// A suite nothing writes to, so daily-scope choices saved in the App Group can't leak in.
private func emptyDefaults() -> UserDefaults {
    UserDefaults(suiteName: "VerseSelectionServiceTests.\(UUID().uuidString)")!
}

// A throwaway suite holding `values`, removed once `body` returns.
private func withScratchDefaults<T>(_ values: [String: Any], _ body: (UserDefaults) -> T) -> T {
    let name = "VerseSelectionServiceTests.\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: name)!
    defer { UserDefaults.standard.removePersistentDomain(forName: name) }
    values.forEach { defaults.set($0.value, forKey: $0.key) }
    return body(defaults)
}

import Testing
import Foundation
@testable import WordUnlocked

// VerseSelectionService's only non-private entry point, verse(for:date:favorites:),
// unconditionally touches DatabaseService.shared / ScriptureDatabase.shared (a
// real SQLite-backed singleton) on every branch, so it stays untested here --
// see the project README for why. `pick(from:date:component:)` and
// `stableIndex(for:component:count:)`, however, are pure: no DB, no
// UserDefaults, no singletons, just Foundation.Calendar arithmetic over
// whatever's passed in. They were `private` (unreachable even via
// @testable import) and are now `internal`, so this file covers exactly
// those two functions and nothing else.
@Suite("VerseSelectionService.stableIndex / pick")
struct VerseSelectionServiceTests {

    // MARK: - stableIndex(for:component:count:)

    @Test func stableIndexIsDeterministicForTheSameInputs() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        let first = VerseSelectionService.stableIndex(for: date, component: .day, count: 37)
        let second = VerseSelectionService.stableIndex(for: date, component: .day, count: 37)

        #expect(first == second)
    }

    @Test func stableIndexStaysInBoundsForDayComponentAcrossExtremeDates() {
        // "Far in the past" / "far in the future" per Foundation's own extremes,
        // plus "now" for a realistic middle case.
        let dates = [Date.distantPast, Date.distantFuture, Date()]
        for date in dates {
            for count in 1...20 {
                let index = VerseSelectionService.stableIndex(for: date, component: .day, count: count)
                #expect(index >= 0)
                #expect(index < count)
            }
        }
    }

    @Test func stableIndexStaysInBoundsForWeekOfYearComponentAcrossExtremeDates() {
        // stableIndex has a separate branch for .weekOfYear (used by the
        // weekly-theme mode) with its own arithmetic -- covered independently
        // of the .day branch above.
        let dates = [Date.distantPast, Date.distantFuture, Date()]
        for date in dates {
            for count in 1...20 {
                let index = VerseSelectionService.stableIndex(for: date, component: .weekOfYear, count: count)
                #expect(index >= 0)
                #expect(index < count)
            }
        }
    }

    @Test func stableIndexYieldsDifferentValuesForDifferentDays() {
        // Two dates exactly one calendar day apart (built with Calendar's own
        // `.day` arithmetic, not a raw 86_400-second offset, so this can't be
        // thrown off by a DST transition in whatever time zone the test runs
        // in). The underlying `.era` day-ordinality differs by exactly 1
        // between them, and a difference of exactly 1 mod a count > 1 can
        // never be congruent to 0, so the two indices are guaranteed distinct.
        let calendar = Calendar.current
        let day1 = calendar.date(from: DateComponents(year: 2024, month: 3, day: 1))!
        let day2 = calendar.date(byAdding: .day, value: 1, to: day1)!
        let count = 30

        let index1 = VerseSelectionService.stableIndex(for: day1, component: .day, count: count)
        let index2 = VerseSelectionService.stableIndex(for: day2, component: .day, count: count)

        #expect(index1 != index2)
    }

    @Test func stableIndexWithZeroCountReturnsZeroInsteadOfCrashing() {
        // The implementation guards its modulo with `max(count, 1)`, so this
        // is well-defined rather than a divide-by-zero -- pinned here rather
        // than left as an unstated assumption. Note `pick` never actually
        // triggers this path: it short-circuits to nil for an empty array
        // before computing an index at all (see below).
        let index = VerseSelectionService.stableIndex(for: Date(), component: .day, count: 0)
        #expect(index == 0)
    }

    // MARK: - pick(from:date:component:)

    @Test func pickReturnsNilForAnEmptyArray() {
        #expect(VerseSelectionService.pick(from: [], date: Date(), component: .day) == nil)
    }

    @Test func pickReturnsTheElementAtStableIndex() {
        let verses = (0..<5).map(makeVerse)
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let expectedIndex = VerseSelectionService.stableIndex(for: date, component: .day, count: verses.count)

        let picked = VerseSelectionService.pick(from: verses, date: date, component: .day)

        #expect(picked?.id == verses[expectedIndex].id)
    }

    @Test func pickStaysConsistentWithStableIndexAcrossManyDates() {
        // Broader version of the above: for a range of dates, whatever index
        // stableIndex computes is exactly the element pick returns -- pick
        // adds no logic of its own beyond that lookup.
        let verses = (0..<12).map(makeVerse)
        for offset in 0..<40 {
            let date = Date(timeIntervalSince1970: 1_700_000_000 + Double(offset) * 86_400)
            let expectedIndex = VerseSelectionService.stableIndex(for: date, component: .day, count: verses.count)
            let picked = VerseSelectionService.pick(from: verses, date: date, component: .day)
            #expect(picked?.id == verses[expectedIndex].id)
        }
    }
}

private func makeVerse(id: Int) -> Verse {
    Verse(
        id: id,
        translationId: 1,
        bookId: 43,
        chapter: 3,
        verse: 16,
        verseRef: "Test \(id):1",
        text: "Test verse text \(id)",
        charCount: 20,
        wordCount: 4,
        fitCategory: .short,
        excerpt: "Test verse text \(id)",
        segmentCount: 1
    )
}

import Foundation

/// Builds the widget's timeline: which verse shows when, and how its text fits the space.
/// The app uses it too, so its Lock Screen preview matches the widget.
final class WidgetTimelineService {
    static let shared = WidgetTimelineService()

    /// How long each part of a split verse shows before the next part takes its turn.
    static let segmentDuration: TimeInterval = 20 * 60
    /// How soon to ask again when the database can't be read, as before the first unlock
    /// after a restart, instead of keeping a stand-in verse until midnight.
    static let unavailableRetryInterval: TimeInterval = 15 * 60
    /// Characters per part when Segmented splits a verse.
    static let segmentLength = 96

    private let defaults: UserDefaults
    private let database: ScriptureDatabase

    init(defaults: UserDefaults = AppGroupSettings.defaults, database: ScriptureDatabase = .shared) {
        self.defaults = defaults
        self.database = database
    }

    /// The entries from `now`, and when WidgetKit should ask for the next timeline.
    func timeline(now: Date = Date()) -> (entries: [VerseEntry], reloadDate: Date) {
        guard database.isAvailable else {
            return (entries(now: now, maxEntries: 1), now.addingTimeInterval(Self.unavailableRetryInterval))
        }
        let calendar = Calendar.current
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))
            ?? now.addingTimeInterval(86_400)
        return (entries(now: now), nextMidnight)
    }

    /// One entry for each rotation slot from `now`, and for Segmented one for each part of
    /// a split verse within its slot.
    func entries(now: Date = Date(), maxEntries: Int = .max) -> [VerseEntry] {
        let settings = WidgetSettings(defaults: defaults)
        let favorites = Favorite.saved(in: defaults)
        let plan = settings.activeMode == .memorization ? MemorizationPlan.saved(in: defaults) : nil
        // ESV verses the app downloaded ahead, by the reference verse each stands in for. The
        // extension never fetches, and Recovery Version text can't be stored at all, so any
        // verse without downloaded text shows in its reference translation.
        let esvVerses = settings.translationCode == "ESV"
            ? Dictionary(LiveCachedVerse.storedESVVerses(in: defaults).map { ($0.fetchedRef, $0) }, uniquingKeysWith: { first, _ in first })
            : [:]
        let interval = VerseSelectionService.rotationInterval(for: settings.activeMode, defaults: defaults)
        // A week of daily entries, or two days of shorter slots; the provider rebuilds at
        // midnight. Split verses change every few minutes, so their timeline covers today.
        let dayCount = settings.longVerseStrategy == .segmented ? 1 : (interval == .daily ? 7 : 2)
        let starts = VerseSelectionService.slotStartDates(from: now, interval: interval, dayCount: dayCount)

        var entries: [VerseEntry] = []
        var chapterLengths: [String: Int] = [:]
        for (index, start) in starts.enumerated() where entries.count < maxEntries {
            var record = VerseSelectionService.record(for: settings, date: start, favorites: favorites, database: database, defaults: defaults)
            if record.translationCode == VerseSelectionService.referenceTranslationCode(for: "ESV"),
               let downloaded = esvVerses[record.verseRef] {
                record = VerseSelectionService.record(record, withText: downloaded.text, translationCode: "ESV")
            }

            var text: String? = record.text
            var note: String?
            if let plan, plan.id == settings.memorizationPlanId {
                let phase = MemorizationService.phase(of: plan, on: start)
                text = MemorizationService.text(record.text, in: phase, difficulty: plan.difficulty)
                note = phase.caption
            } else if settings.activeMode == .chapter, settings.showProgress {
                let key = "\(record.bookId):\(record.chapter)"
                let length = chapterLengths[key] ?? chapterLength(of: record, settings: settings)
                chapterLengths[key] = length
                note = "Verse \(record.verse) of \(length)"
            }

            let slotBegin = index == 0 ? VerseSelectionService.slotStart(containing: start, interval: interval) : start
            // The next boundary, counted on the calendar like the slots, so a day that is 23 or
            // 25 hours long still ends at midnight.
            let slotEnd = index + 1 < starts.count
                ? starts[index + 1]
                : VerseSelectionService.slotStartDates(from: start, interval: interval, dayCount: 2).dropFirst().first
                    ?? slotBegin.addingTimeInterval(TimeInterval(interval.hours) * 3_600)
            entries += slotEntries(
                from: start, slotBegin: slotBegin, slotEnd: slotEnd, record: record, text: text, note: note, settings: settings
            )
        }
        return Array(entries.prefix(maxEntries))
    }

    /// The entries for one slot: one, or for a split verse one per turn of each part.
    private func slotEntries(
        from start: Date,
        slotBegin: Date,
        slotEnd: Date,
        record: SharedVerseRecord,
        text: String?,
        note: String?,
        settings: WidgetSettings
    ) -> [VerseEntry] {
        func entry(_ date: Date, _ text: String?, _ note: String?) -> VerseEntry {
            VerseEntry(
                date: date,
                verseText: text,
                verseRef: record.displayReference,
                shortRef: record.verseRef,
                translationCode: settings.showTranslationCode ? record.translationCode : "",
                theme: settings.themeId,
                note: note
            )
        }

        guard let text else { return [entry(start, nil, note)] }
        switch settings.longVerseStrategy {
        case .smartFit:
            return [entry(start, text.count > 150 ? LongVerseService.excerpt(from: text, maxChars: 132) : text, note)]
        case .excerpt:
            return [entry(start, LongVerseService.excerpt(from: text, maxChars: 132), note)]
        case .referenceOnly:
            return [entry(start, text.count > VerseSelectionService.excludeLongMaxCharCount ? nil : text, note)]
        case .excludeLong:
            return [entry(start, text, note)]
        case .segmented:
            let parts = LongVerseService.segments(from: text, maxCharsPerSegment: Self.segmentLength)
            guard parts.count > 1 else { return [entry(start, text, note)] }
            // Parts take turns from the start of the slot, so a rebuilt timeline picks up
            // where the last one was.
            var turn = Int(max(start.timeIntervalSince(slotBegin), 0) / Self.segmentDuration)
            var date = start
            var entries: [VerseEntry] = []
            while date < slotEnd {
                let part = turn % parts.count
                entries.append(entry(date, parts[part], settings.showProgress ? "Part \(part + 1) of \(parts.count)" : note))
                turn += 1
                date = slotBegin.addingTimeInterval(Double(turn) * Self.segmentDuration)
            }
            return entries
        }
    }

    /// How many verses `record`'s chapter has in the translation its verses come from.
    private func chapterLength(of record: SharedVerseRecord, settings: WidgetSettings) -> Int {
        database.verseCount(
            translationCode: VerseSelectionService.referenceTranslationCode(for: settings.translationCode),
            filter: ScriptureDatabase.VerseFilter(books: .chapter(bookId: record.bookId, chapter: record.chapter))
        )
    }
}

import Foundation

/// Chooses the verse for a date. The widget timeline and the app (Today, previews)
/// both call this, so the Lock Screen always matches what the app shows.
enum VerseSelectionService {
    /// Longest verse the Exclude Long strategy lets through.
    static let excludeLongMaxCharCount = 130

    /// Live translations have no local verses: they rotate through the KJV reference
    /// set, and the app fetches the matching live text.
    static let liveTranslationCodes: Set<String> = ["ESV", "RV"]

    private static let builtInReference = "John 3:16"

    static func verse(for settings: WidgetSettings, date: Date = Date(), favorites: [Favorite] = []) -> Verse {
        Verse(record: record(for: settings, date: date, favorites: favorites))
    }

    static func record(
        for settings: WidgetSettings,
        date: Date = Date(),
        favorites: [Favorite] = [],
        database: ScriptureDatabase = .shared,
        defaults: UserDefaults = AppGroupSettings.defaults
    ) -> SharedVerseRecord {
        let code = referenceTranslationCode(for: settings.translationCode)
        let excludeLong = settings.longVerseStrategy == .excludeLong
        let dailyVerse = {
            dailyRecord(translationCode: code, date: date, excludeLong: excludeLong, database: database, defaults: defaults)
        }

        let selected: SharedVerseRecord?
        switch settings.activeMode {
        case .daily:
            selected = dailyVerse()
        case .weeklyTheme:
            let verses = fitting(database.verses(topicSlug: settings.topicSlug ?? "hope", translationCode: code), excludeLong: excludeLong)
            selected = verses.isEmpty ? nil : verses[weeklyIndex(for: date, count: verses.count)]
        case .topic:
            let verses = database.verses(topicSlug: settings.topicSlug ?? "love", translationCode: code)
            selected = pick(from: fitting(verses, excludeLong: excludeLong), date: date)
        case .chapter:
            let verses = database.verses(bookId: settings.chapterBookId ?? 43, chapter: settings.chapterNumber ?? 3, translationCode: code)
            selected = pick(from: fitting(verses, excludeLong: excludeLong), date: date)
        case .memorization:
            selected = settings.memorizationPlanId
                .flatMap { database.verse(id: $0) }
                .map { matching($0, translationCode: code, database: database) }
        case .favorites:
            let records = favorites.map { favoriteRecord($0, database: database) }
            selected = pick(from: fitting(records, excludeLong: excludeLong), date: date)
        }
        return selected ?? dailyVerse() ?? builtInVerse(translationCode: code, database: database)
    }

    static func referenceTranslationCode(for translationCode: String) -> String {
        liveTranslationCodes.contains(translationCode) ? "KJV" : translationCode
    }

    /// John 3:16 from the database, or the bundled KJV text when the database isn't
    /// available yet (the widget can run before the app has provisioned it).
    static func builtInVerse(translationCode: String, database: ScriptureDatabase = .shared) -> SharedVerseRecord {
        if let record = database.verse(verseRef: builtInReference, translationCode: translationCode) {
            return record
        }
        let text = "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
        return SharedVerseRecord(
            id: 212,
            translationId: 1,
            translationCode: "KJV",
            bookId: 43,
            bookName: "John",
            chapter: 3,
            verse: 16,
            verseRef: builtInReference,
            text: text,
            charCount: text.count,
            wordCount: text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: text.count).rawValue,
            excerpt: LongVerseService.excerpt(from: text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: text, maxCharsPerSegment: 110).count
        )
    }

    // internal, not private: pick/stableIndex/weeklyIndex are pure and are the
    // determinism contract the widget timeline depends on, so tests need to reach them.
    static func pick<Element>(from elements: [Element], date: Date) -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements[stableIndex(for: date, count: elements.count)]
    }

    /// Advances by one each calendar day, so consecutive days walk a list in order.
    static func stableIndex(for date: Date, count: Int) -> Int {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return abs(day) % max(count, 1)
    }

    /// Weekly Theme shows a topic's first seven verses in order, one per day of the week.
    static func weeklyIndex(for date: Date, count: Int) -> Int {
        let dayOfWeek = (Calendar.current.ordinality(of: .day, in: .weekOfYear, for: date) ?? 1) - 1
        return dayOfWeek % max(min(count, 7), 1)
    }

    private static func dailyRecord(
        translationCode: String,
        date: Date,
        excludeLong: Bool,
        database: ScriptureDatabase,
        defaults: UserDefaults
    ) -> SharedVerseRecord? {
        var filter = ScriptureDatabase.VerseFilter(
            books: dailyBooks(defaults),
            maxCharCount: excludeLong ? excludeLongMaxCharCount : nil
        )
        var count = database.verseCount(translationCode: translationCode, filter: filter)
        if count == 0 {
            filter = ScriptureDatabase.VerseFilter()
            count = database.verseCount(translationCode: translationCode, filter: filter)
        }
        guard count > 0 else { return nil }
        return database.verse(translationCode: translationCode, filter: filter, offset: stableIndex(for: date, count: count))
    }

    private static func dailyBooks(_ defaults: UserDefaults) -> ScriptureDatabase.VerseFilter.Books {
        if bool(defaults, AppGroupSettings.Keys.dailyPsalmsProverbsOnly, default: false) {
            return .psalmsAndProverbs
        }
        switch (bool(defaults, AppGroupSettings.Keys.dailyIncludeOldTestament, default: true),
                bool(defaults, AppGroupSettings.Keys.dailyIncludeNewTestament, default: true)) {
        case (true, false):
            return .oldTestament
        case (false, true):
            return .newTestament
        default:
            return .all
        }
    }

    /// With Exclude Long, only the verses that fit the Lock Screen — unless none do,
    /// so a mode never comes up empty.
    private static func fitting(_ verses: [SharedVerseRecord], excludeLong: Bool) -> [SharedVerseRecord] {
        guard excludeLong else { return verses }
        let short = verses.filter { $0.charCount <= excludeLongMaxCharCount }
        return short.isEmpty ? verses : short
    }

    private static func matching(_ record: SharedVerseRecord, translationCode: String, database: ScriptureDatabase) -> SharedVerseRecord {
        guard record.translationCode != translationCode else { return record }
        return database.verse(bookId: record.bookId, chapter: record.chapter, verse: record.verse, translationCode: translationCode) ?? record
    }

    /// A favorite's database verse, or — for live translations, whose text isn't
    /// stored locally — the text that was saved with it.
    private static func favoriteRecord(_ favorite: Favorite, database: ScriptureDatabase) -> SharedVerseRecord {
        if let record = database.verse(id: favorite.verseId), record.translationCode == favorite.translationCode {
            return record
        }
        let text = favorite.text
        return SharedVerseRecord(
            id: favorite.verseId,
            translationId: 0,
            translationCode: favorite.translationCode,
            bookId: 0,
            bookName: favorite.verseRef.components(separatedBy: " ").dropLast().joined(separator: " "),
            chapter: 0,
            verse: 0,
            verseRef: favorite.verseRef,
            text: text,
            charCount: text.count,
            wordCount: text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: text.count).rawValue,
            excerpt: LongVerseService.excerpt(from: text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: text, maxCharsPerSegment: 110).count
        )
    }

    private static func bool(_ defaults: UserDefaults, _ key: String, default defaultValue: Bool) -> Bool {
        defaults.object(forKey: key) == nil ? defaultValue : defaults.bool(forKey: key)
    }
}

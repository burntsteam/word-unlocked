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

    // Mode settings the mode screens save straight to the App Group, outside WidgetSettings.
    private static let modeSettingKeys = [
        AppGroupSettings.Keys.dailyIncludeOldTestament,
        AppGroupSettings.Keys.dailyIncludeNewTestament,
        AppGroupSettings.Keys.dailyPsalmsProverbsOnly,
        AppGroupSettings.Keys.dailyUpdateInterval,
        AppGroupSettings.Keys.topicRotationSpeed,
        AppGroupSettings.Keys.weeklyAutoRepeat,
        AppGroupSettings.Keys.weeklyStartDate,
        AppGroupSettings.Keys.chapterRotationSpeed,
        AppGroupSettings.Keys.chapterEndBehavior,
        AppGroupSettings.Keys.chapterStartDate,
        AppGroupSettings.Keys.favoritesRotationSpeed,
        AppGroupSettings.Keys.favoritesShuffle,
        AppGroupSettings.Keys.favoritesExcludeLong
    ]

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
        let interval = rotationInterval(for: settings.activeMode, defaults: defaults)
        let dailyVerse = {
            dailyRecord(translationCode: code, date: date, excludeLong: excludeLong, database: database, defaults: defaults)
        }

        let selected: SharedVerseRecord?
        switch settings.activeMode {
        case .daily:
            selected = dailyVerse()
        case .weeklyTheme:
            let slug = weeklyTopicSlug(settings, date: date, database: database, defaults: defaults)
            selected = weeklyThemeRecord(topicSlug: slug, settings: settings, date: date, database: database)
        case .topic:
            let verses = database.verses(topicSlug: settings.topicSlug ?? "love", translationCode: code)
            selected = pick(from: fitting(verses, excludeLong: excludeLong), date: date, interval: interval)
        case .chapter:
            selected = chapterRecord(
                settings, translationCode: code, date: date, interval: interval,
                excludeLong: excludeLong, database: database, defaults: defaults
            )
        case .memorization:
            selected = settings.memorizationPlanId
                .flatMap { database.verse(id: $0) }
                .map { matching($0, translationCode: code, database: database) }
        case .favorites:
            let excludeLongFavorites = excludeLong || bool(defaults, AppGroupSettings.Keys.favoritesExcludeLong, default: false)
            let records = fitting(favorites.map { favoriteRecord($0, database: database) }, excludeLong: excludeLongFavorites)
            let shuffle = bool(defaults, AppGroupSettings.Keys.favoritesShuffle, default: true)
            selected = favoriteInRotation(records, date: date, interval: interval, shuffle: shuffle)
        }
        return selected ?? dailyVerse() ?? builtInVerse(translationCode: code, database: database)
    }

    /// The verse Weekly Theme shows for `topicSlug` on `date`: the topic's first seven
    /// verses in order, one per day of the week.
    static func weeklyThemeRecord(
        topicSlug: String,
        settings: WidgetSettings,
        date: Date,
        database: ScriptureDatabase = .shared
    ) -> SharedVerseRecord? {
        let code = referenceTranslationCode(for: settings.translationCode)
        let verses = fitting(
            database.verses(topicSlug: topicSlug, translationCode: code),
            excludeLong: settings.longVerseStrategy == .excludeLong
        )
        return verses.isEmpty ? nil : verses[weeklyIndex(for: date, count: verses.count)]
    }

    static func referenceTranslationCode(for translationCode: String) -> String {
        liveTranslationCodes.contains(translationCode) ? "KJV" : translationCode
    }

    static func rotationInterval(
        for mode: WidgetSettings.VerseMode,
        defaults: UserDefaults = AppGroupSettings.defaults
    ) -> WidgetSettings.RotationInterval {
        let key: String
        switch mode {
        case .daily: key = AppGroupSettings.Keys.dailyUpdateInterval
        case .topic: key = AppGroupSettings.Keys.topicRotationSpeed
        case .chapter: key = AppGroupSettings.Keys.chapterRotationSpeed
        case .favorites: key = AppGroupSettings.Keys.favoritesRotationSpeed
        case .weeklyTheme, .memorization: return .daily
        }
        return defaults.string(forKey: key).flatMap(WidgetSettings.RotationInterval.init(rawValue:)) ?? .daily
    }

    /// Changes whenever `record(for:)` could return another verse for a reason outside
    /// WidgetSettings: a new rotation slot, or a mode setting saved straight to `defaults`.
    static func selectionStamp(
        for mode: WidgetSettings.VerseMode,
        date: Date = Date(),
        defaults: UserDefaults = AppGroupSettings.defaults
    ) -> String {
        let slotStamp = String(slot(for: date, interval: rotationInterval(for: mode, defaults: defaults)))
        let settingStamps = modeSettingKeys.map { key in defaults.object(forKey: key).map { "\($0)" } ?? "" }
        return ([slotStamp] + settingStamps).joined(separator: "|")
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

    // internal, not private: the functions below are pure and are the determinism
    // contract the widget timeline depends on, so tests need to reach them.
    static func pick<Element>(
        from elements: [Element],
        date: Date,
        interval: WidgetSettings.RotationInterval = .daily
    ) -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements[stableIndex(for: date, count: elements.count, interval: interval)]
    }

    /// Advances by one each rotation slot, so consecutive slots walk a list in order.
    static func stableIndex(for date: Date, count: Int, interval: WidgetSettings.RotationInterval = .daily) -> Int {
        abs(slot(for: date, interval: interval)) % max(count, 1)
    }

    /// Numbers rotation slots: each local calendar day split into blocks of `interval.hours`,
    /// from midnight.
    static func slot(for date: Date, interval: WidgetSettings.RotationInterval) -> Int {
        let calendar = Calendar.current
        return dayNumber(for: date, calendar: calendar) * (24 / interval.hours)
            + calendar.component(.hour, from: date) / interval.hours
    }

    // Local calendar days since 2001. Calendar.ordinality(of: .day, in: .era) turns over at
    // midnight UTC rather than local midnight, so it can't number local days.
    private static func dayNumber(for date: Date, calendar: Calendar) -> Int {
        let epoch = calendar.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        return calendar.dateComponents([.day], from: epoch, to: calendar.startOfDay(for: date)).day ?? 0
    }

    /// `now`, then the start of every later slot through `dayCount` days: where widget
    /// timeline entries must begin for the Lock Screen to change with the rotation.
    static func slotStartDates(from now: Date, interval: WidgetSettings.RotationInterval, dayCount: Int) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        var dates = [now]
        for day in 0..<max(dayCount, 1) {
            guard let start = calendar.date(byAdding: .day, value: day, to: today) else { continue }
            for hour in stride(from: 0, to: 24, by: interval.hours) {
                if let boundary = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: start), boundary > now {
                    dates.append(boundary)
                }
            }
        }
        return dates
    }

    /// Weekly Theme shows a topic's first seven verses in order, one per day of the week.
    static func weeklyIndex(for date: Date, count: Int) -> Int {
        let dayOfWeek = (Calendar.current.ordinality(of: .day, in: .weekOfYear, for: date) ?? 1) - 1
        return dayOfWeek % max(min(count, 7), 1)
    }

    /// Whole weeks from the week containing `start` to the week containing `date`.
    static func weeksBetween(_ start: Date, _ date: Date) -> Int {
        let calendar = Calendar.current
        guard let startWeek = calendar.dateInterval(of: .weekOfYear, for: start)?.start,
              let week = calendar.dateInterval(of: .weekOfYear, for: date)?.start else {
            return 0
        }
        return calendar.dateComponents([.weekOfYear], from: startWeek, to: week).weekOfYear ?? 0
    }

    /// A reproducible shuffle of `0..<count` for `seed` (Fisher–Yates driven by SplitMix64),
    /// so the app and the widget produce the same order.
    static func shuffledOrder(count: Int, seed: Int) -> [Int] {
        var order = Array(0..<max(count, 0))
        var state = UInt64(bitPattern: Int64(seed))
        for i in order.indices.reversed() where i > 0 {
            state &+= 0x9E37_79B9_7F4A_7C15
            var z = state
            z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
            z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
            z ^= z >> 31
            order.swapAt(i, Int(z % UInt64(i + 1)))
        }
        return order
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
        let interval = rotationInterval(for: .daily, defaults: defaults)
        return database.verse(
            translationCode: translationCode,
            filter: filter,
            offset: stableIndex(for: date, count: count, interval: interval)
        )
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

    /// With auto-repeat off, each week since the plan started moves one topic further
    /// through the topic list.
    private static func weeklyTopicSlug(
        _ settings: WidgetSettings,
        date: Date,
        database: ScriptureDatabase,
        defaults: UserDefaults
    ) -> String {
        let chosen = settings.topicSlug ?? "hope"
        guard !bool(defaults, AppGroupSettings.Keys.weeklyAutoRepeat, default: true),
              let start = defaults.object(forKey: AppGroupSettings.Keys.weeklyStartDate) as? Date else {
            return chosen
        }
        let weeks = weeksBetween(start, date)
        let slugs = database.topics().map(\.slug)
        guard weeks > 0, let index = slugs.firstIndex(of: chosen) else { return chosen }
        return slugs[(index + weeks) % slugs.count]
    }

    /// Chapter mode reads from verse 1, one verse per slot since the passage was set, then
    /// repeats the chapter, carries on into the next one, or stays on the last verse.
    private static func chapterRecord(
        _ settings: WidgetSettings,
        translationCode: String,
        date: Date,
        interval: WidgetSettings.RotationInterval,
        excludeLong: Bool,
        database: ScriptureDatabase,
        defaults: UserDefaults
    ) -> SharedVerseRecord? {
        let bookId = settings.chapterBookId ?? 43
        let chapter = settings.chapterNumber ?? 3
        let behavior = defaults.string(forKey: AppGroupSettings.Keys.chapterEndBehavior)
            .flatMap(WidgetSettings.ChapterEndBehavior.init(rawValue:)) ?? .repeatChapter
        let currentSlot = slot(for: date, interval: interval)
        let elapsed = (defaults.object(forKey: AppGroupSettings.Keys.chapterStartDate) as? Date)
            .map { max(currentSlot - slot(for: $0, interval: interval), 0) } ?? abs(currentSlot)

        guard behavior != .nextChapter else {
            return readingPlanRecord(
                bookId: bookId, chapter: chapter, elapsed: elapsed,
                translationCode: translationCode, excludeLong: excludeLong, database: database
            )
        }
        let verses = fitting(database.verses(bookId: bookId, chapter: chapter, translationCode: translationCode), excludeLong: excludeLong)
        guard !verses.isEmpty else { return nil }
        return verses[behavior == .stop ? min(elapsed, verses.count - 1) : elapsed % verses.count]
    }

    /// The verse `elapsed` steps into reading forward from `bookId` `chapter`, through the
    /// chapters after it and round from Revelation back to Genesis.
    private static func readingPlanRecord(
        bookId: Int,
        chapter: Int,
        elapsed: Int,
        translationCode: String,
        excludeLong: Bool,
        database: ScriptureDatabase
    ) -> SharedVerseRecord? {
        var maxCharCount = excludeLong ? excludeLongMaxCharCount : nil
        var chapters = database.chapterVerseCounts(translationCode: translationCode, maxCharCount: maxCharCount)
        if chapters.isEmpty, maxCharCount != nil {
            maxCharCount = nil
            chapters = database.chapterVerseCounts(translationCode: translationCode)
        }
        let total = chapters.reduce(0) { $0 + $1.verseCount }
        guard total > 0 else { return nil }

        var index = chapters.firstIndex { ($0.bookId, $0.chapter) >= (bookId, chapter) } ?? 0
        var remaining = elapsed % total
        while remaining >= chapters[index].verseCount {
            remaining -= chapters[index].verseCount
            index = (index + 1) % chapters.count
        }
        let target = chapters[index]
        let verses = database.verses(bookId: target.bookId, chapter: target.chapter, translationCode: translationCode)
            .filter { $0.charCount <= (maxCharCount ?? .max) }
        return verses.indices.contains(remaining) ? verses[remaining] : verses.last
    }

    /// Favorites advance one per slot, in saved order or, with Shuffle, in a new order for
    /// each pass so every favorite still appears once per pass.
    private static func favoriteInRotation(
        _ records: [SharedVerseRecord],
        date: Date,
        interval: WidgetSettings.RotationInterval,
        shuffle: Bool
    ) -> SharedVerseRecord? {
        guard !records.isEmpty else { return nil }
        let position = abs(slot(for: date, interval: interval))
        guard shuffle else { return records[position % records.count] }
        let order = shuffledOrder(count: records.count, seed: position / records.count)
        return records[order[position % records.count]]
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

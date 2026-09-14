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
        AppGroupSettings.Keys.weeklySource,
        AppGroupSettings.Keys.weeklyBookId,
        AppGroupSettings.Keys.weeklyChapter,
        AppGroupSettings.Keys.weeklyCustomVerseIds,
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
            selected = weeklyRecord(
                WeeklyPlan(defaults: defaults, topicSlug: settings.topicSlug),
                autoRepeat: bool(defaults, AppGroupSettings.Keys.weeklyAutoRepeat, default: true),
                startDate: defaults.object(forKey: AppGroupSettings.Keys.weeklyStartDate) as? Date,
                settings: settings,
                date: date,
                database: database
            )
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

    /// The verse Weekly Plan shows on `date`: one a day, in order, from the plan's theme,
    /// chapter, book or list. With `autoRepeat` every week shows the same seven; without it
    /// each week since `startDate` moves on seven verses, starting over at the end.
    static func weeklyRecord(
        _ plan: WeeklyPlan,
        autoRepeat: Bool,
        startDate: Date?,
        settings: WidgetSettings,
        date: Date,
        database: ScriptureDatabase = .shared
    ) -> SharedVerseRecord? {
        let code = referenceTranslationCode(for: settings.translationCode)
        let excludeLong = settings.longVerseStrategy == .excludeLong
        let weeks = autoRepeat ? 0 : startDate.map { max(weeksBetween($0, date), 0) } ?? 0
        let index = { (count: Int) in weeklyIndex(for: date, count: count, weeksElapsed: weeks) }

        switch plan.source {
        case .theme:
            let verses = fitting(database.verses(topicSlug: plan.topicSlug, translationCode: code), excludeLong: excludeLong)
            return verses.isEmpty ? nil : verses[index(verses.count)]
        case .chapter:
            return filteredRecord(
                .chapter(bookId: plan.bookId, chapter: plan.chapter),
                translationCode: code, excludeLong: excludeLong, inReadingOrder: true, database: database, index: index
            )
        case .book:
            return filteredRecord(
                .book(plan.bookId),
                translationCode: code, excludeLong: excludeLong, inReadingOrder: true, database: database, index: index
            )
        case .custom:
            let verses = fitting(
                plan.customVerseIds.compactMap { database.verse(id: $0) }.map { matching($0, translationCode: code, database: database) },
                excludeLong: excludeLong
            )
            return verses.isEmpty ? nil : verses[index(verses.count)]
        }
    }

    /// The distinct verses `settings` shows from `now` on that pass `include`, in the order
    /// they come up, up to `limit`: what a live translation keeps ready ahead of time. It
    /// looks as many days ahead as `limit`, which daily rotation needs to reach it, and stops
    /// once four weeks of slots bring no new verse, as in a mode that repeats a few verses.
    static func upcomingRecords(
        for settings: WidgetSettings,
        from now: Date,
        favorites: [Favorite] = [],
        limit: Int,
        database: ScriptureDatabase = .shared,
        defaults: UserDefaults = AppGroupSettings.defaults,
        where include: (SharedVerseRecord) -> Bool = { _ in true }
    ) -> [SharedVerseRecord] {
        let interval = rotationInterval(for: settings.activeMode, defaults: defaults)
        let slotsWithoutNewVerseLimit = 28 * 24 / interval.hours
        var seen = Set<Int>()
        var records: [SharedVerseRecord] = []
        var slotsWithoutNewVerse = 0
        for date in slotStartDates(from: now, interval: interval, dayCount: limit) {
            guard records.count < limit, slotsWithoutNewVerse < slotsWithoutNewVerseLimit else { break }
            let record = self.record(for: settings, date: date, favorites: favorites, database: database, defaults: defaults)
            guard seen.insert(record.id).inserted else {
                slotsWithoutNewVerse += 1
                continue
            }
            slotsWithoutNewVerse = 0
            if include(record) {
                records.append(record)
            }
        }
        return records
    }

    /// `record`'s verse carrying a live translation's reference and text, measured for the
    /// Lock Screen from that text.
    static func liveRecord(_ record: SharedVerseRecord, ref: String, text: String, translationCode: String) -> SharedVerseRecord {
        textRecord(
            id: record.id, translationCode: translationCode, bookId: record.bookId, bookName: record.bookName,
            chapter: record.chapter, verse: record.verse, verseRef: ref, text: text
        )
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
        return textRecord(
            id: 212, translationId: 1, translationCode: "KJV", bookId: 43, bookName: "John", chapter: 3, verse: 16,
            verseRef: builtInReference,
            text: "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
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

    /// Weekly Plan's place in a source of `count` verses on `date`: the day of the week, plus
    /// seven for each week the plan has moved on, wrapping at the end.
    static func weeklyIndex(for date: Date, count: Int, weeksElapsed: Int = 0) -> Int {
        let dayOfWeek = (Calendar.current.ordinality(of: .day, in: .weekOfYear, for: date) ?? 1) - 1
        return (weeksElapsed * 7 + dayOfWeek) % max(count, 1)
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
        let interval = rotationInterval(for: .daily, defaults: defaults)
        return filteredRecord(dailyBooks(defaults), translationCode: translationCode, excludeLong: excludeLong, database: database) {
            stableIndex(for: date, count: $0, interval: interval)
        }
    }

    /// The verse at `index(count)` among the `count` verses of `translationCode` in `books`,
    /// counted in SQL so a whole book never loads: only short verses with Exclude Long,
    /// unless none are short.
    private static func filteredRecord(
        _ books: ScriptureDatabase.VerseFilter.Books,
        translationCode: String,
        excludeLong: Bool,
        inReadingOrder: Bool = false,
        database: ScriptureDatabase,
        index: (Int) -> Int
    ) -> SharedVerseRecord? {
        var filter = ScriptureDatabase.VerseFilter(books: books, maxCharCount: excludeLong ? excludeLongMaxCharCount : nil)
        var count = database.verseCount(translationCode: translationCode, filter: filter)
        if count == 0, filter.maxCharCount != nil {
            filter.maxCharCount = nil
            count = database.verseCount(translationCode: translationCode, filter: filter)
        }
        guard count > 0 else { return nil }
        return database.verse(translationCode: translationCode, filter: filter, offset: index(count), inReadingOrder: inReadingOrder)
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
        return textRecord(
            id: favorite.verseId, translationCode: favorite.translationCode, bookId: 0,
            bookName: favorite.verseRef.components(separatedBy: " ").dropLast().joined(separator: " "),
            chapter: 0, verse: 0, verseRef: favorite.verseRef, text: favorite.text
        )
    }

    /// A verse record for text that isn't a database row, measured for the Lock Screen.
    private static func textRecord(
        id: Int,
        translationId: Int = 0,
        translationCode: String,
        bookId: Int,
        bookName: String,
        chapter: Int,
        verse: Int,
        verseRef: String,
        text: String
    ) -> SharedVerseRecord {
        SharedVerseRecord(
            id: id,
            translationId: translationId,
            translationCode: translationCode,
            bookId: bookId,
            bookName: bookName,
            chapter: chapter,
            verse: verse,
            verseRef: verseRef,
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

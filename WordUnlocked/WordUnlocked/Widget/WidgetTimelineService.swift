import Foundation

final class WidgetTimelineService {
    static let shared = WidgetTimelineService()

    private let defaults: UserDefaults
    private let database: ScriptureDatabase

    private init(defaults: UserDefaults = AppGroupSettings.defaults, database: ScriptureDatabase = .shared) {
        self.defaults = defaults
        self.database = database
    }

    func generateTimeline() -> [VerseEntry] {
        let settings = readSettings()
        let favorites = readFavorites()
        let calendar = Calendar.current
        let startDate = Date()

        // For RV: all entries use the single cached verse (live API, not stored in bulk).
        if settings.translationCode == "RV" {
            return (0..<7).map { offset in
                let date = calendar.date(byAdding: .day, value: offset, to: startDate) ?? startDate
                return makeRVEntry(date: date, settings: settings)
            }
        }

        // For ESV: show the most recently cached verse (live API, ≤500-verse cache),
        // or a built-in KJV verse if nothing is cached yet.
        if settings.translationCode == "ESV" {
            let esv = readESVCache().last
            return (0..<7).map { offset in
                let date = calendar.date(byAdding: .day, value: offset, to: startDate) ?? startDate
                guard let esv else {
                    return makeEntry(date: date, verse: builtInVerse("KJV"), settings: settings, offset: 0)
                }
                let code = settings.showTranslationCode ? "ESV" : ""
                return VerseEntry(date: date, verseText: esv.text, verseRef: esv.ref, translationCode: code,
                                  theme: settings.themeId, segmentInfo: nil, mode: settings.activeMode.title)
            }
        }

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startDate) ?? startDate
            let verse = selectVerse(settings: settings, date: date, favorites: favorites)
            return makeEntry(date: date, verse: verse, settings: settings, offset: offset)
        }
    }

    // Builds a widget entry from the cached RV verse. Shows John 3:16 (KJV) if none is cached.
    private func makeRVEntry(date: Date, settings: WidgetSettings) -> VerseEntry {
        if let data = defaults.data(forKey: AppGroupSettings.Keys.rvCachedVerse) {
            if let cached = try? JSONDecoder().decode(RVCachedVerse.self, from: data) {
                let translationCode = settings.showTranslationCode ? "RV" : ""
                return VerseEntry(
                    date: date,
                    verseText: cached.text,
                    verseRef: cached.ref,
                    translationCode: translationCode,
                    theme: settings.themeId,
                    segmentInfo: nil,
                    mode: settings.activeMode.title
                )
            } else {
                // Corrupt data — remove it so the next successful fetch can repopulate.
                defaults.removeObject(forKey: AppGroupSettings.Keys.rvCachedVerse)
            }
        }
        let fallback = builtInVerse("KJV")
        return makeEntry(date: date, verse: fallback, settings: settings, offset: 0)
    }

    private func readSettings() -> WidgetSettings {
        let base = WidgetSettings.defaultSettings
        let mode = WidgetSettings.VerseMode(rawValue: defaults.string(forKey: AppGroupSettings.Keys.activeMode) ?? base.activeMode.rawValue) ?? base.activeMode
        let strategy = WidgetSettings.LongVerseStrategy(rawValue: defaults.string(forKey: AppGroupSettings.Keys.longVerseStrategy) ?? base.longVerseStrategy.rawValue) ?? base.longVerseStrategy

        let showTranslationCode: Bool
        if defaults.object(forKey: AppGroupSettings.Keys.showTranslationCode) == nil {
            showTranslationCode = base.showTranslationCode
        } else {
            showTranslationCode = defaults.bool(forKey: AppGroupSettings.Keys.showTranslationCode)
        }

        let showProgress: Bool
        if defaults.object(forKey: AppGroupSettings.Keys.showProgress) == nil {
            showProgress = base.showProgress
        } else {
            showProgress = defaults.bool(forKey: AppGroupSettings.Keys.showProgress)
        }

        return WidgetSettings(
            widgetKind: .rectangular,
            activeMode: mode,
            translationCode: defaults.string(forKey: AppGroupSettings.Keys.selectedTranslation) ?? base.translationCode,
            topicSlug: defaults.string(forKey: AppGroupSettings.Keys.topicSlug) ?? base.topicSlug,
            chapterBookId: defaults.object(forKey: AppGroupSettings.Keys.chapterBookId) as? Int ?? base.chapterBookId,
            chapterNumber: defaults.object(forKey: AppGroupSettings.Keys.chapterNumber) as? Int ?? base.chapterNumber,
            memorizationPlanId: defaults.object(forKey: AppGroupSettings.Keys.memorizationPlanId) as? Int ?? base.memorizationPlanId,
            themeId: defaults.string(forKey: AppGroupSettings.Keys.selectedTheme) ?? base.themeId,
            longVerseStrategy: strategy,
            showTranslationCode: showTranslationCode,
            showProgress: showProgress
        )
    }

    private func readFavorites() -> [Favorite] {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.favorites) else { return [] }
        return (try? JSONDecoder().decode([Favorite].self, from: data)) ?? []
    }

    private func readESVCache() -> [LiveCachedVerse] {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.esvVerseCache) else { return [] }
        return (try? JSONDecoder().decode([LiveCachedVerse].self, from: data)) ?? []
    }

    private func selectVerse(settings: WidgetSettings, date: Date, favorites: [Favorite]) -> SharedVerseRecord {
        let verse: SharedVerseRecord?
        switch settings.activeMode {
        case .daily:
            verse = dailyVerse(settings: settings, date: date)
        case .weeklyTheme:
            verse = topicVerse(slug: settings.topicSlug ?? "hope", settings: settings, date: date, weekly: true)
        case .topic:
            verse = topicVerse(slug: settings.topicSlug ?? "love", settings: settings, date: date, weekly: false)
        case .chapter:
            verse = chapterVerse(settings: settings, date: date)
        case .memorization:
            verse = settings.memorizationPlanId.flatMap(database.verse(id:)) ?? dailyVerse(settings: settings, date: date)
        case .favorites:
            verse = favoriteVerse(date: date, favorites: favorites) ?? dailyVerse(settings: settings, date: date)
        }

        if settings.longVerseStrategy == .excludeLong, let verse, verse.charCount > 130 {
            return database
                .allVerses(translationCode: settings.translationCode)
                .first { $0.charCount <= 130 } ?? verse
        }

        return verse ?? builtInVerse(settings.translationCode)
    }

    private func dailyVerse(settings: WidgetSettings, date: Date) -> SharedVerseRecord? {
        let allVerses = database.allVerses(translationCode: settings.translationCode)
        let includeOldTestament = bool(forKey: AppGroupSettings.Keys.dailyIncludeOldTestament, defaultValue: true)
        let includeNewTestament = bool(forKey: AppGroupSettings.Keys.dailyIncludeNewTestament, defaultValue: true)
        let psalmsProverbsOnly = bool(forKey: AppGroupSettings.Keys.dailyPsalmsProverbsOnly, defaultValue: false)

        let filtered: [SharedVerseRecord]
        if psalmsProverbsOnly {
            filtered = allVerses.filter { $0.bookId == 19 || $0.bookId == 20 }
        } else {
            filtered = allVerses.filter { verse in
                (includeOldTestament && verse.bookId < 40) || (includeNewTestament && verse.bookId >= 40)
            }
        }

        return pick(from: filtered.isEmpty ? allVerses : filtered, date: date, weekly: false)
    }

    private func topicVerse(slug: String, settings: WidgetSettings, date: Date, weekly: Bool) -> SharedVerseRecord? {
        pick(from: database.verses(topicSlug: slug, translationCode: settings.translationCode), date: date, weekly: weekly)
    }

    private func chapterVerse(settings: WidgetSettings, date: Date) -> SharedVerseRecord? {
        let bookId = settings.chapterBookId ?? 43
        let chapter = settings.chapterNumber ?? 3
        return pick(from: database.verses(bookId: bookId, chapter: chapter, translationCode: settings.translationCode), date: date, weekly: false)
    }

    private func favoriteVerse(date: Date, favorites: [Favorite]) -> SharedVerseRecord? {
        guard !favorites.isEmpty else { return nil }
        let shuffle = bool(forKey: AppGroupSettings.Keys.favoritesShuffle, defaultValue: true)
        let index = shuffle ? stableIndex(date: date, weekly: false, count: favorites.count) : 0
        let favorite = favorites[index]
        return database.verse(id: favorite.verseId) ?? SharedVerseRecord(
            id: favorite.verseId,
            translationId: 0,
            translationCode: favorite.translationCode,
            bookId: 0,
            bookName: favorite.verseRef.components(separatedBy: " ").dropLast().joined(separator: " "),
            chapter: 0,
            verse: 0,
            verseRef: favorite.verseRef,
            text: favorite.text,
            charCount: favorite.text.count,
            wordCount: favorite.text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: favorite.text.count).rawValue,
            excerpt: LongVerseService.excerpt(from: favorite.text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: favorite.text, maxCharsPerSegment: 110).count
        )
    }

    private func bool(forKey key: String, defaultValue: Bool) -> Bool {
        guard defaults.object(forKey: key) != nil else { return defaultValue }
        return defaults.bool(forKey: key)
    }

    private func pick(from verses: [SharedVerseRecord], date: Date, weekly: Bool) -> SharedVerseRecord? {
        guard !verses.isEmpty else { return nil }
        return verses[stableIndex(date: date, weekly: weekly, count: verses.count)]
    }

    private func stableIndex(date: Date, weekly: Bool, count: Int) -> Int {
        let calendar = Calendar.current
        let value: Int
        if weekly {
            value = calendar.component(.weekOfYear, from: date) + calendar.component(.year, from: date) * 53
        } else {
            value = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        }
        return abs(value) % max(count, 1)
    }

    private func makeEntry(date: Date, verse: SharedVerseRecord, settings: WidgetSettings, offset: Int) -> VerseEntry {
        var text = verse.text
        var segmentInfo: String?

        switch settings.longVerseStrategy {
        case .smartFit:
            if verse.charCount > 150 {
                text = verse.excerpt
            }
        case .excerpt:
            text = verse.excerpt
        case .segmented:
            let segments = LongVerseService.segments(from: verse.text, maxCharsPerSegment: 96)
            let segmentIndex = segments.isEmpty ? 0 : offset % segments.count
            text = segments.isEmpty ? verse.text : segments[segmentIndex]
            if settings.showProgress, segments.count > 1 {
                segmentInfo = "\(segmentIndex + 1)/\(segments.count)"
            }
        case .referenceOnly:
            if verse.charCount > 130 {
                text = settings.showTranslationCode ? verse.translationCode : "Reference"
            }
        case .excludeLong:
            text = verse.text
        }

        let translationCode = settings.showTranslationCode ? verse.translationCode : ""
        return VerseEntry(
            date: date,
            verseText: text,
            verseRef: verse.verseRef,
            translationCode: translationCode,
            theme: settings.themeId,
            segmentInfo: segmentInfo,
            mode: settings.activeMode.title
        )
    }

    private func builtInVerse(_ translationCode: String) -> SharedVerseRecord {
        let isWEB = translationCode == "WEB"
        let text = isWEB
            ? "For God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life."
            : "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."

        return SharedVerseRecord(
            id: isWEB ? 101 : 1,
            translationId: isWEB ? 2 : 1,
            translationCode: translationCode,
            bookId: 43,
            bookName: "John",
            chapter: 3,
            verse: 16,
            verseRef: "John 3:16",
            text: text,
            charCount: text.count,
            wordCount: text.split(separator: " ").count,
            fitCategory: LongVerseService.fitCategory(charCount: text.count).rawValue,
            excerpt: LongVerseService.excerpt(from: text, maxChars: 132),
            segmentCount: LongVerseService.segments(from: text, maxCharsPerSegment: 110).count
        )
    }
}

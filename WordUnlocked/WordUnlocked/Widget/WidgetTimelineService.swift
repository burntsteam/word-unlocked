import Foundation

final class WidgetTimelineService {
    static let shared = WidgetTimelineService()

    private let defaults: UserDefaults
    private let database: ScriptureDatabase

    private init(defaults: UserDefaults = AppGroupSettings.defaults, database: ScriptureDatabase = .shared) {
        self.defaults = defaults
        self.database = database
    }

    func generateTimeline(now: Date = Date(), dayCount: Int = 7) -> [VerseEntry] {
        let settings = readSettings()
        let dates = Self.entryDates(now: now, dayCount: dayCount)

        switch settings.translationCode {
        case "RV", "ESV":
            // Live translations show their most recent cached verse (RV keeps one, ESV
            // up to 500); the extension never fetches, and nothing is stored in bulk.
            let cached = settings.translationCode == "RV" ? readRVCache() : readESVCache().last
            return dates.map { cachedEntry(cached, date: $0, settings: settings) }
        default:
            let favorites = readFavorites()
            return dates.enumerated().map { offset, date in
                let verse = VerseSelectionService.record(
                    for: settings, date: date, favorites: favorites, database: database, defaults: defaults
                )
                return makeEntry(date: date, verse: verse, settings: settings, offset: offset)
            }
        }
    }

    /// The first entry starts now and each later one at a following midnight, so the
    /// Lock Screen changes verse when the day changes.
    static func entryDates(now: Date, dayCount: Int) -> [Date] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        return (0..<max(dayCount, 1)).map { offset in
            offset == 0 ? now : calendar.date(byAdding: .day, value: offset, to: startOfToday) ?? now
        }
    }

    // Shows John 3:16 (KJV) until the app has cached a live verse.
    private func cachedEntry(_ cached: LiveCachedVerse?, date: Date, settings: WidgetSettings) -> VerseEntry {
        guard let cached else {
            let fallback = VerseSelectionService.builtInVerse(translationCode: "KJV", database: database)
            return makeEntry(date: date, verse: fallback, settings: settings, offset: 0)
        }
        return VerseEntry(
            date: date,
            verseText: cached.text,
            verseRef: cached.ref,
            translationCode: settings.showTranslationCode ? settings.translationCode : "",
            theme: settings.themeId,
            segmentInfo: nil,
            mode: settings.activeMode.title
        )
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

    private func readRVCache() -> LiveCachedVerse? {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.rvCachedVerse) else { return nil }
        guard let cached = try? JSONDecoder().decode(RVCachedVerse.self, from: data) else {
            // Corrupt data — remove it so the next successful fetch can repopulate.
            defaults.removeObject(forKey: AppGroupSettings.Keys.rvCachedVerse)
            return nil
        }
        return cached
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
}

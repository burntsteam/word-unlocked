import Foundation

final class WidgetTimelineService {
    static let shared = WidgetTimelineService()

    private let defaults: UserDefaults
    private let database: ScriptureDatabase

    private init(defaults: UserDefaults = AppGroupSettings.defaults, database: ScriptureDatabase = .shared) {
        self.defaults = defaults
        self.database = database
    }

    func generateTimeline(now: Date = Date(), maxEntries: Int = .max) -> [VerseEntry] {
        let settings = readSettings()
        let favorites = readFavorites()
        // ESV verses the app downloaded ahead, by the reference verse each stands in for. The
        // extension never fetches, and Recovery Version text can't be stored at all, so any
        // verse without downloaded text shows in its reference translation.
        let esvVerses = settings.translationCode == "ESV"
            ? Dictionary(LiveCachedVerse.storedESVVerses(in: defaults).map { ($0.fetchedRef, $0) }, uniquingKeysWith: { first, _ in first })
            : [:]
        let interval = VerseSelectionService.rotationInterval(for: settings.activeMode, defaults: defaults)
        // A week of daily entries, or two days of shorter slots; the provider rebuilds at midnight.
        let dayCount = interval == .daily ? 7 : 2
        let dates = VerseSelectionService.slotStartDates(from: now, interval: interval, dayCount: dayCount).prefix(maxEntries)
        return dates.enumerated().map { offset, date in
            let record = VerseSelectionService.record(
                for: settings, date: date, favorites: favorites, database: database, defaults: defaults
            )
            // A favorite saved with ESV text already carries it.
            let downloaded = record.translationCode == "ESV" ? nil : esvVerses[record.verseRef]
            let verse = downloaded.map {
                VerseSelectionService.liveRecord(record, ref: $0.ref, text: $0.text, translationCode: "ESV")
            } ?? record
            return makeEntry(date: date, verse: verse, settings: settings, offset: offset)
        }
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

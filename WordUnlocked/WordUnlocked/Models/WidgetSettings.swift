import Foundation

struct WidgetSettings: Codable {
    var widgetKind: WidgetKind
    var activeMode: VerseMode
    var translationCode: String
    var topicSlug: String?
    var chapterBookId: Int?
    var chapterNumber: Int?
    var memorizationPlanId: Int?
    var themeId: String
    var longVerseStrategy: LongVerseStrategy
    var showTranslationCode: Bool
    var showProgress: Bool

    enum WidgetKind: String, Codable {
        case inline
        case circular
        case rectangular
    }

    enum VerseMode: String, Codable {
        case daily
        case weeklyTheme
        case topic
        case chapter
        case memorization
        case favorites
    }

    enum LongVerseStrategy: String, Codable {
        case smartFit
        case excerpt
        case segmented
        case referenceOnly
        case excludeLong
    }

    static var defaultSettings: WidgetSettings {
        WidgetSettings(widgetKind: .rectangular, activeMode: .daily, translationCode: "KJV",
                       topicSlug: nil, chapterBookId: nil, chapterNumber: nil, memorizationPlanId: nil,
                       themeId: WidgetTheme.automaticId, longVerseStrategy: .smartFit,
                       showTranslationCode: true, showProgress: true)
    }
}

extension WidgetSettings {
    /// The settings saved in `defaults`, with the default for anything not saved. Reading
    /// never writes, so the app, its previews and the widget can all call it.
    init(defaults: UserDefaults) {
        let base = WidgetSettings.defaultSettings
        typealias Keys = AppGroupSettings.Keys
        func bool(_ key: String, _ fallback: Bool) -> Bool {
            defaults.object(forKey: key) == nil ? fallback : defaults.bool(forKey: key)
        }
        self.init(
            widgetKind: .rectangular,
            activeMode: defaults.string(forKey: Keys.activeMode).flatMap(VerseMode.init(rawValue:)) ?? base.activeMode,
            translationCode: defaults.string(forKey: Keys.selectedTranslation) ?? base.translationCode,
            topicSlug: defaults.string(forKey: Keys.topicSlug) ?? base.topicSlug,
            chapterBookId: defaults.object(forKey: Keys.chapterBookId) as? Int ?? base.chapterBookId,
            chapterNumber: defaults.object(forKey: Keys.chapterNumber) as? Int ?? base.chapterNumber,
            memorizationPlanId: defaults.object(forKey: Keys.memorizationPlanId) as? Int ?? base.memorizationPlanId,
            themeId: defaults.string(forKey: Keys.selectedTheme) ?? base.themeId,
            longVerseStrategy: defaults.string(forKey: Keys.longVerseStrategy).flatMap(LongVerseStrategy.init(rawValue:)) ?? base.longVerseStrategy,
            showTranslationCode: bool(Keys.showTranslationCode, base.showTranslationCode),
            showProgress: bool(Keys.showProgress, base.showProgress)
        )
    }
}

extension WidgetSettings.WidgetKind: CaseIterable, Identifiable {
    var id: String { rawValue }

    var title: String {
        switch self {
        case .inline: "Inline"
        case .circular: "Circular"
        case .rectangular: "Rectangular"
        }
    }
}

extension WidgetSettings.VerseMode: CaseIterable, Identifiable {
    var id: String { rawValue }

    static var allCases: [WidgetSettings.VerseMode] {
        [.daily, .weeklyTheme, .topic, .chapter, .memorization, .favorites]
    }

    var title: String {
        switch self {
        case .daily: "Daily Verse"
        case .weeklyTheme: "Weekly Plan"
        case .topic: "Topic"
        case .chapter: "Chapter"
        case .memorization: "Memorization"
        case .favorites: "Favorites"
        }
    }

    var symbolName: String {
        switch self {
        case .daily: "sun.max"
        case .weeklyTheme: "calendar"
        case .topic: "tag"
        case .chapter: "book.pages"
        case .memorization: "brain.head.profile"
        case .favorites: "heart"
        }
    }

    var summary: String {
        switch self {
        case .daily: "A well-known verse, new each day."
        case .weeklyTheme: "Seven verses a week from a theme, book, or your own list."
        case .topic: "Verses on a subject you choose."
        case .chapter: "Read one chapter, verse by verse."
        case .memorization: "Learn one verse, with less of it shown each day."
        case .favorites: "Your saved verses, one at a time."
        }
    }
}

extension WidgetSettings.LongVerseStrategy: CaseIterable, Identifiable {
    var id: String { rawValue }

    var title: String {
        switch self {
        case .smartFit: "Smart Fit"
        case .excerpt: "Excerpt"
        case .segmented: "Segmented"
        case .referenceOnly: "Reference Only"
        case .excludeLong: "Exclude Long"
        }
    }

    var summary: String {
        switch self {
        case .smartFit: "Use the full verse when it fits and shorten only when needed."
        case .excerpt: "Show the strongest readable opening within the widget limit."
        case .segmented: "Split longer verses into parts that take turns on the Lock Screen."
        case .referenceOnly: "Show the reference when a verse is too long."
        case .excludeLong: "Choose a shorter verse for Lock Screen display."
        }
    }
}

extension WidgetSettings {
    /// How often a mode moves on to its next verse, counted from midnight.
    enum RotationInterval: String, CaseIterable, Identifiable {
        case daily
        case everyTwelveHours
        case everyEightHours
        case everySixHours

        var id: String { rawValue }

        var hours: Int {
            switch self {
            case .daily: 24
            case .everyTwelveHours: 12
            case .everyEightHours: 8
            case .everySixHours: 6
            }
        }

        var title: String {
            switch self {
            case .daily: "Daily"
            case .everyTwelveHours: "Every 12 Hours"
            case .everyEightHours: "Every 8 Hours"
            case .everySixHours: "Every 6 Hours"
            }
        }
    }

    /// What Chapter mode does after the last verse of its chapter.
    enum ChapterEndBehavior: String, CaseIterable, Identifiable {
        case repeatChapter
        case nextChapter
        case stop

        var id: String { rawValue }

        var title: String {
            switch self {
            case .repeatChapter: "Repeat"
            case .nextChapter: "Next Chapter"
            case .stop: "Stop"
            }
        }
    }
}


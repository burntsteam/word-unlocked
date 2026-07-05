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
                       themeId: "minimal-light", longVerseStrategy: .smartFit,
                       showTranslationCode: true, showProgress: true)
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
        case .weeklyTheme: "Weekly Theme"
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
        case .chapter: "book"
        case .memorization: "brain.head.profile"
        case .favorites: "heart"
        }
    }

    var summary: String {
        switch self {
        case .daily: "A fresh verse selected each day."
        case .weeklyTheme: "A weekly rhythm around one spiritual theme."
        case .topic: "Verses chosen from a topic you select."
        case .chapter: "Move through one chapter in order."
        case .memorization: "Phase-based prompts for committing a verse to memory."
        case .favorites: "Rotate through verses you have saved."
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
        case .segmented: "Split longer verses across the next scheduled entries."
        case .referenceOnly: "Show the reference when a verse is too long."
        case .excludeLong: "Choose a shorter verse for Lock Screen display."
        }
    }
}


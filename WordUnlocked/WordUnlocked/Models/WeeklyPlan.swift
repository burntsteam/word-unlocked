import Foundation

/// Where Weekly Plan's seven verses a week come from, as its mode screen edits it and the
/// App Group stores it.
struct WeeklyPlan: Equatable {
    enum Source: String, CaseIterable, Identifiable {
        case theme
        case chapter
        case book
        case custom

        var id: String { rawValue }

        var title: String {
            switch self {
            case .theme: "Theme"
            case .chapter: "Chapter"
            case .book: "Book"
            case .custom: "My Verses"
            }
        }
    }

    var source: Source = .theme
    var topicSlug = "hope"
    var bookId = 19
    var chapter = 23
    var customVerseIds: [Int] = []
}

extension WeeklyPlan {
    /// The saved plan. Its theme is the shared topic setting, so that arrives as `topicSlug`.
    init(defaults: UserDefaults, topicSlug: String?) {
        self.init()
        source = defaults.string(forKey: AppGroupSettings.Keys.weeklySource).flatMap(Source.init(rawValue:)) ?? source
        self.topicSlug = topicSlug ?? self.topicSlug
        bookId = defaults.object(forKey: AppGroupSettings.Keys.weeklyBookId) as? Int ?? bookId
        chapter = defaults.object(forKey: AppGroupSettings.Keys.weeklyChapter) as? Int ?? chapter
        customVerseIds = defaults.array(forKey: AppGroupSettings.Keys.weeklyCustomVerseIds) as? [Int] ?? customVerseIds
    }

    /// Saves everything but the theme, which the settings store owns.
    func save(to defaults: UserDefaults) {
        defaults.set(source.rawValue, forKey: AppGroupSettings.Keys.weeklySource)
        defaults.set(bookId, forKey: AppGroupSettings.Keys.weeklyBookId)
        defaults.set(chapter, forKey: AppGroupSettings.Keys.weeklyChapter)
        defaults.set(customVerseIds, forKey: AppGroupSettings.Keys.weeklyCustomVerseIds)
    }
}

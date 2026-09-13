import Foundation

enum AppGroupSettings {
    static let suiteName = "group.com.rippre.wordunlocked"
    static let databaseFileName = "wordunlocked.sqlite3"

    enum Keys {
        static let selectedTranslation = "selectedTranslation"
        static let activeMode = "activeMode"
        static let selectedTheme = "selectedTheme"
        static let longVerseStrategy = "longVerseStrategy"
        static let topicSlug = "topicSlug"
        static let chapterBookId = "chapterBookId"
        static let chapterNumber = "chapterNumber"
        static let memorizationPlanId = "memorizationPlanId"
        static let showTranslationCode = "showTranslationCode"
        static let showProgress = "showProgress"
        static let favorites = "favorites"
        static let memorizationPlan = "memorizationPlan"
        static let dailyIncludeOldTestament = "dailyIncludeOldTestament"
        static let dailyIncludeNewTestament = "dailyIncludeNewTestament"
        static let dailyPsalmsProverbsOnly = "dailyPsalmsProverbsOnly"
        static let dailyUpdateInterval = "dailyUpdateInterval"
        static let topicRotationSpeed = "topicRotationSpeed"
        static let weeklyAutoRepeat = "weeklyAutoRepeat"
        static let weeklyStartDate = "weeklyStartDate"
        static let chapterRotationSpeed = "chapterRotationSpeed"
        static let chapterEndBehavior = "chapterEndBehavior"
        static let chapterStartDate = "chapterStartDate"
        static let favoritesRotationSpeed = "favoritesRotationSpeed"
        static let favoritesShuffle = "favoritesShuffle"
        static let favoritesExcludeLong = "favoritesExcludeLong"
        static let rvCachedVerse = "rvCachedVerse"
        static let esvVerseCache = "esvVerseCache"
    }

    static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    static var containerURL: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: suiteName)
            ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }

    static var databaseURL: URL {
        containerURL.appendingPathComponent(databaseFileName, isDirectory: false)
    }
}

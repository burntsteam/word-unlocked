import Foundation

// An English Standard Version verse downloaded from the ESV API, kept in the App Group so
// the app and its widget can show it offline.
struct LiveCachedVerse: Codable {
    /// The reference as the ESV API writes it, such as "Psalm 23:1".
    let ref: String
    let text: String
    /// The reference translation's verse this one stands in for, such as "Ps 23:1".
    let fetchedRef: String
}

extension LiveCachedVerse {
    /// The downloaded ESV verses, in the order the settings they were planned for show them.
    static func storedESVVerses(in defaults: UserDefaults) -> [LiveCachedVerse] {
        guard let data = defaults.data(forKey: AppGroupSettings.Keys.esvVerseCache) else { return [] }
        return (try? JSONDecoder().decode([LiveCachedVerse].self, from: data)) ?? []
    }
}

struct SharedTranslationRecord: Codable, Equatable {
    let id: Int
    let code: String
    let displayName: String
    let publisher: String
    let copyrightNotice: String
    let licenseStatus: String
    let attribution: String
    let offlineAvailable: Bool
    let enabled: Bool
}

struct SharedBookRecord: Codable, Equatable {
    let id: Int
    let name: String
    let abbreviation: String
    let testament: String
    let chapterCount: Int
}

struct SharedVerseRecord: Codable, Equatable {
    let id: Int
    let translationId: Int
    let translationCode: String
    let bookId: Int
    let bookName: String
    let chapter: Int
    let verse: Int
    let verseRef: String
    let text: String
    let charCount: Int
    let wordCount: Int
    let fitCategory: String
    let excerpt: String
    let segmentCount: Int
}

struct SharedTopicRecord: Codable, Equatable {
    let id: Int
    let slug: String
    let name: String
    let symbolName: String
    let summary: String
}


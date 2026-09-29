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


/// A verse's reference as people write it: the book's full name, so "1 Kings 2:2" rather
/// than the database's "1Kgs 2:2", and "Psalm" for a single psalm.
enum VerseReference {
    static func display(bookName: String, chapter: Int, verse: Int, fallback: String) -> String {
        guard !bookName.isEmpty, chapter > 0, verse > 0 else { return fallback }
        return "\(bookName == "Psalms" ? "Psalm" : bookName) \(chapter):\(verse)"
    }
}

extension SharedVerseRecord {
    /// The reference to show people. `verseRef` stays the database's key, which the ESV
    /// store and Recovery Version requests use.
    var displayReference: String {
        VerseReference.display(bookName: bookName, chapter: chapter, verse: verse, fallback: verseRef)
    }
}

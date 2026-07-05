import Foundation

// Cached verse from a live Bible API (RV / ESV), shared across app and widget targets.
struct LiveCachedVerse: Codable {
    let ref: String
    let text: String
    let fetchedRef: String
}

// Back-compat alias for existing Recovery Version call sites.
typealias RVCachedVerse = LiveCachedVerse

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


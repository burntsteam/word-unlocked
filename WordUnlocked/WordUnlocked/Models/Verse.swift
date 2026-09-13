import Foundation

struct Verse: Identifiable, Codable {
    let id: Int
    let translationId: Int
    let bookId: Int
    let chapter: Int
    let verse: Int
    let verseRef: String
    let text: String
    let charCount: Int
    let wordCount: Int
    let fitCategory: FitCategory
    let excerpt: String
    let segmentCount: Int

    enum FitCategory: String, Codable {
        case short
        case medium
        case long
        case veryLong
    }
}

extension Verse {
    init(record: SharedVerseRecord) {
        self.init(
            id: record.id,
            translationId: record.translationId,
            bookId: record.bookId,
            chapter: record.chapter,
            verse: record.verse,
            verseRef: record.verseRef,
            text: record.text,
            charCount: record.charCount,
            wordCount: record.wordCount,
            fitCategory: FitCategory(rawValue: record.fitCategory) ?? .medium,
            excerpt: record.excerpt,
            segmentCount: record.segmentCount
        )
    }

    var bookName: String {
        verseRef.components(separatedBy: " ").dropLast().joined(separator: " ")
    }
}


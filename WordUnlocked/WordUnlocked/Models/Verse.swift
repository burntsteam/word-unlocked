import Foundation

struct Verse: Identifiable, Codable {
    let id: Int
    let translationId: Int
    /// The translation this text is in, which can differ from the selected one: a live
    /// translation's verses are the KJV reference text, and a favorite keeps its own.
    let translationCode: String
    let bookId: Int
    let bookName: String
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
            translationCode: record.translationCode,
            bookId: record.bookId,
            bookName: record.bookName,
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

    /// The reference to show people, such as "1 Kings 2:2".
    var displayReference: String {
        VerseReference.display(bookName: bookName, chapter: chapter, verse: verse, fallback: verseRef)
    }

    var shareText: String {
        Self.shareText(text, reference: displayReference, translationCode: translationCode)
    }

    /// A verse as shared text: the quotation, then its reference and translation, which
    /// Crossway asks for after any ESV quotation.
    static func shareText(_ text: String, reference: String, translationCode: String) -> String {
        "\u{201C}\(text)\u{201D}\n\(reference) (\(translationCode))"
    }
}

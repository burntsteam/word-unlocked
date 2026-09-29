import Foundation

final class DatabaseService {
    static let shared = DatabaseService()

    private let database = ScriptureDatabase.shared
    private let bookRecords: [SharedBookRecord]

    private init() {
        bookRecords = database.books()
    }

    func translations() -> [Translation] {
        database.translations().map(translation(from:))
    }

    func books() -> [Book] {
        database.books().map(book(from:))
    }

    func topics() -> [Topic] {
        database.topics().map(topic(from:))
    }

    func verse(id: Int) -> Verse? {
        database.verse(id: id).map(Verse.init(record:))
    }

    /// A reference such as "Psalm 23" or "John 3:16" returns those verses in order; anything
    /// else searches references and text for the words.
    func search(query: String, translationCode: String, limit: Int = 50) -> [Verse] {
        if let reference = ReferenceParser.parse(query, books: bookRecords) {
            return database.verses(bookId: reference.bookId, chapter: reference.chapter, translationCode: translationCode)
                .filter { reference.verses?.contains($0.verse) ?? true }
                .map(Verse.init(record:))
        }
        return database.searchVerses(containing: query, translationCode: translationCode, limit: limit).map(Verse.init(record:))
    }

    private func translation(from record: SharedTranslationRecord) -> Translation {
        Translation(
            id: record.id,
            code: record.code,
            displayName: record.displayName,
            publisher: record.publisher,
            copyrightNotice: record.copyrightNotice,
            licenseStatus: Translation.LicenseStatus(rawValue: record.licenseStatus) ?? .publicDomain,
            attribution: record.attribution,
            offlineAvailable: record.offlineAvailable,
            enabled: record.enabled
        )
    }

    private func book(from record: SharedBookRecord) -> Book {
        Book(
            id: record.id,
            name: record.name,
            abbreviation: record.abbreviation,
            testament: record.testament == "old" ? .old : .new,
            chapterCount: record.chapterCount
        )
    }

    private func topic(from record: SharedTopicRecord) -> Topic {
        Topic(
            id: record.id,
            slug: record.slug,
            name: record.name,
            symbolName: record.symbolName,
            summary: record.summary
        )
    }
}

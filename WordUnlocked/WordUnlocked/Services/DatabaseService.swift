import Foundation

final class DatabaseService {
    static let shared = DatabaseService()

    private let database = ScriptureDatabase.shared

    private init() {}

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

    func search(query: String, translationCode: String, limit: Int = 50) -> [Verse] {
        database.searchVerses(containing: query, translationCode: translationCode, limit: limit).map(Verse.init(record:))
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

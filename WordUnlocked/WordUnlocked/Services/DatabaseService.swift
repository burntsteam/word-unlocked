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

    func allVerses(translationCode: String) -> [Verse] {
        ScriptureDatabase.shared.allVerses(translationCode: translationCode).map(verse(from:))
    }

    func verse(id: Int) -> Verse? {
        database.verse(id: id).map(verse(from:))
    }

    func verses(topicSlug: String, translationCode: String) -> [Verse] {
        database.verses(topicSlug: topicSlug, translationCode: translationCode).map(verse(from:))
    }

    func verses(bookId: Int, chapter: Int, translationCode: String) -> [Verse] {
        database.verses(bookId: bookId, chapter: chapter, translationCode: translationCode).map(verse(from:))
    }

    func verseForToday(translationCode: String) -> Verse? {
        let verses = allVerses(translationCode: translationCode)
        guard !verses.isEmpty else { return nil }

        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % verses.count
        return verses[index]
    }

    func weeklyPlanVerses(topicSlug: String, translationCode: String) -> [(dayNumber: Int, verse: Verse)] {
        let topicVerses = verses(topicSlug: topicSlug, translationCode: translationCode)
        return zip(1...7, topicVerses.prefix(7)).map { pair in
            (dayNumber: pair.0, verse: pair.1)
        }
    }

    func search(query: String, translationCode: String) -> [Verse] {
        let matches = allVerses(translationCode: translationCode).filter { verse in
            verse.verseRef.localizedCaseInsensitiveContains(query) ||
                verse.text.localizedCaseInsensitiveContains(query)
        }
        return Array(matches.prefix(50))
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

    private func verse(from record: SharedVerseRecord) -> Verse {
        Verse(
            id: record.id,
            translationId: record.translationId,
            bookId: record.bookId,
            chapter: record.chapter,
            verse: record.verse,
            verseRef: record.verseRef,
            text: record.text,
            charCount: record.charCount,
            wordCount: record.wordCount,
            fitCategory: fitCategory(from: record.fitCategory),
            excerpt: record.excerpt,
            segmentCount: record.segmentCount
        )
    }

    private func fitCategory(from value: String) -> Verse.FitCategory {
        switch value {
        case "short":
            return .short
        case "long":
            return .long
        case "veryLong":
            return .veryLong
        default:
            return .medium
        }
    }
}

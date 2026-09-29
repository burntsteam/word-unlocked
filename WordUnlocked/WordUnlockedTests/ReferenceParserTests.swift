import Testing
import Foundation
@testable import WordUnlocked

// References typed the way people write them, read against the bundled database's books.
@Suite("ReferenceParser")
struct ReferenceParserTests {
    private let books = ScriptureDatabase.shared.books()

    @Test func readsReferencesTheWayPeopleWriteThem() {
        let cases: [(String, VerseQuery)] = [
            ("Psalm 23", VerseQuery(bookId: 19, chapter: 23, verses: nil)),
            ("psalms 23:1", VerseQuery(bookId: 19, chapter: 23, verses: 1...1)),
            ("Ps 23", VerseQuery(bookId: 19, chapter: 23, verses: nil)),
            ("Genesis 1:1", VerseQuery(bookId: 1, chapter: 1, verses: 1...1)),
            ("1 Kings 2", VerseQuery(bookId: 11, chapter: 2, verses: nil)),
            ("1Kgs 2:2", VerseQuery(bookId: 11, chapter: 2, verses: 2...2)),
            ("I Kings 2:3", VerseQuery(bookId: 11, chapter: 2, verses: 3...3)),
            ("First John 4:8", VerseQuery(bookId: 62, chapter: 4, verses: 8...8)),
            ("Romans 8:28-30", VerseQuery(bookId: 45, chapter: 8, verses: 28...30)),
            ("rom 8:28–30", VerseQuery(bookId: 45, chapter: 8, verses: 28...30)),
            ("Song of Solomon 2:4", VerseQuery(bookId: 22, chapter: 2, verses: 4...4)),
            ("Joh 3:16", VerseQuery(bookId: 43, chapter: 3, verses: 16...16)),
            ("Revelation 22:21", VerseQuery(bookId: 66, chapter: 22, verses: 21...21)),
            // A book of one chapter is cited by verse alone.
            ("Jude 3", VerseQuery(bookId: 65, chapter: 1, verses: 3...3)),
            ("Jude 1:3", VerseQuery(bookId: 65, chapter: 1, verses: 3...3))
        ]

        for (text, expected) in cases {
            #expect(ReferenceParser.parse(text, books: books) == expected, "\(text)")
        }
    }

    @Test func leavesWordsAndImpossibleReferencesToWordSearch() {
        // A book alone may be a word being looked for; "Jo" could be John, Job, Joel or Jonah.
        for text in ["John", "fear not", "love 1", "Psalm 151", "Jo 3", "3:16", ""] {
            #expect(ReferenceParser.parse(text, books: books) == nil, "\(text)")
        }
    }

    @Test func searchReturnsTheVersesAReferenceNamesInOrder() {
        let psalm = DatabaseService.shared.search(query: "Psalm 23", translationCode: "KJV")
        #expect(psalm.map(\.verse) == Array(1...6))
        #expect(psalm.first?.displayReference == "Psalm 23:1")

        let romans = DatabaseService.shared.search(query: "Romans 8:28-30", translationCode: "WEB")
        #expect(romans.map(\.verse) == [28, 29, 30])
        #expect(romans.allSatisfy { $0.translationCode == "WEB" && $0.bookName == "Romans" })

        #expect(DatabaseService.shared.search(query: "my shepherd", translationCode: "KJV").contains { $0.verseRef == "Ps 23:1" })
    }
}
